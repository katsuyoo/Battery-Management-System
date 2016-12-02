/** @defgroup Monitor_file Monitor

@brief Management of Allocation of Charger and loads

This task accesses the various measured and estimated parameters of the
batteries, loads and panel to make decisions about switch settings and
load disconnect/reconnect. The decisions made here involve the set of batteries
as a whole rather than individual batteries.

The decisions determine how to connect loads and solar panel to the different
batteries in order to ensure continuous service and long battery life. The
batteries are connected to the charger at a low level of SoC, to the loads at a
high level of SoC, and are isolated for a period of time to obtain a reference
measurement of the SoC from the open circuit voltage. Loads are progressively
disconnected as the batteries pass to the low and critically low charge states.

On external command the interface currents and SoC of the batteries will be
calibrated.

On external command the task will automatically track and manage battery to load
and battery charging. Tracking will always occur but switches will not be set
until auto-tracking is enabled.

@note Non-integer variables are scaled by a factor 256 (8 bit shift) to allow
fixed point arithmetic to be performed rapidly using integer values. This avoids
the use of floating point which will be costly for processors lacking a hardware
FPU.

Initial 29 September 2013
Updated 15 November 2016
*/

/*
 * This file is part of the battery-management-system project.
 *
 * Copyright 2013 K. Sarkies <ksarkies@internode.on.net>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/**@{*/

#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>

/* Scheduler includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "semphr.h"

#include "power-management-board-defs.h"
#include "power-management.h"
#include "power-management-hardware.h"
#include "power-management-objdic.h"
#include "power-management-lib.h"
#include "power-management-time.h"
#include "power-management-file.h"
#include "power-management-comms.h"
#include "power-management-measurement.h"
#include "power-management-charger.h"
#include "power-management-monitor.h"

/*--------------------------------------------------------------------------*/
/* Local Prototypes */
static void initGlobals(void);

/*--------------------------------------------------------------------------*/
/* Global Variables */
/* These configuration variables are part of the Object Dictionary. */
/* This is defined in power-management-objdic and is updated in response to
received messages. */
extern union ConfigGroup configData;

/*--------------------------------------------------------------------------*/
/* Local Persistent Variables */
static uint8_t monitorWatchdogCount;
static bool calibrate;
/* All current, voltage, SoC, charge variables times 256. */
static uint16_t batteryCurrentSteady[NUM_BATS];
static battery_Fl_States batteryFillState[NUM_BATS];
static battery_Op_States batteryOpState[NUM_BATS];
static battery_Hl_States batteryHealthState[NUM_BATS];
static union InterfaceGroup currentOffsets;
static union InterfaceGroup currents;
static union InterfaceGroup voltages;
static int16_t lastbatteryCurrent[NUM_BATS];
static int16_t lastbatteryVoltage[NUM_BATS];
static uint8_t batteryUnderCharge;
static uint8_t batteryUnderLoad;
/* State of Charge is in percentage (times 256) */
static uint16_t batterySoC[NUM_BATS];
/* Battery charge is in Coulombs (times 256) */
static int32_t batteryCharge[NUM_BATS];
/* Time that a battery is in the isolation state */
static uint32_t batteryIsolationTime[NUM_BATS];

/*--------------------------------------------------------------------------*/
/** @brief <b>Monitoring Task</b>

This is a long-running task, monitoring the state of the
batteries, deciding which one to charge and which to place under load, switching
them out at intervals and when critically low, and resetting the state of charge
estimation algorithm during lightly loaded periods.
*/

void prvMonitorTask(void *pvParameters)
{
    pvParameters = pvParameters;
    initGlobals();

    uint16_t decisionStatus = 0;    

/* Short delay to allow measurement task to produce results */
    vTaskDelay(MONITOR_STARTUP_DELAY );

/* Main loop */
    while (1)
    {
/*------------- CALIBRATION -----------------------*/
/**
<b>Calibration:</b> Perform a calibration sequence to zero the currents
(see docs). Also estimate the State of Charge from the Open Circuit Voltages.
For this purpose the system should have been left in a quiescent state for at
least two hours. */

        if (calibrate)
        {
/* Keep aside to restore after calibration. */
            uint8_t switchSettings = getSwitchControlBits();
/* Results for all 7 tests */
            int16_t results[NUM_TESTS][NUM_IFS];
            uint8_t test;
            uint8_t i;

/* Zero the offsets. */
            for (i=0; i<NUM_IFS; i++) currentOffsets.data[i] = 0;

/* Set switches and collect the results */
            for (test=0; test<NUM_TESTS ; test++)
            {
/* First turn off all switches */
                for (i=0; i<NUM_LOADS+NUM_PANELS; i++) setSwitch(0,i);
/* Connect load 2 to each battery in turn. */
                if (test < NUM_BATS) setSwitch(test+1,1);
/* Then connect load 1 to each battery in turn. Last test is all
switches off to allow the panel to be measured. */
                else if (test < NUM_TESTS-1) setSwitch(test-NUM_BATS+1,0);
/* Delay a few seconds to let the measurements settle. Current should settle
quickly but terminal voltage may take some time, which could slightly affect
some currents. */
                vTaskDelay(getCalibrationDelay());
/* Check to see if a battery is missing as a result of setting loads. */
                for (i=0; i<NUM_BATS; i++)
                {
                    if (((getIndicators() >> 2*i) & 0x02) == 0)
                    {
                        batteryHealthState[i] = missingH;
                        setBatterySoC(i,0);
                    }
                }
/* Reset watchdog counter */
                monitorWatchdogCount = 0;
                for (i=0; i<NUM_IFS; i++) results[test][i] = getCurrent(i);
/* Send a progress update */
                dataMessageSendLowPriority("pQ",0,test);
            }

/* Estimate the offsets only when they are less than a threshold. Find the
lowest value for each interface. */
            for (i=0; i<NUM_IFS; i++)
            {
                currentOffsets.data[i] = OFFSET_START_VALUE;
/* Run through each test to find the minimum. This is the offset. */
                for (test=0; test<NUM_TESTS; test++)
                {
                    int16_t current = results[test][i];
/* Get the minimum if within the threshold. */
                    if (current > CALIBRATION_THRESHOLD)
                    {
                        if (current < currentOffsets.data[i])
                            currentOffsets.data[i] = current;
                    }
                }
/* If not changed, then the measurements were invalid, so set to zero. */
                if (currentOffsets.data[i] == OFFSET_START_VALUE)
                    currentOffsets.data[i] = 0;
/* Remove offset from the results */
                for (test=0; test<NUM_TESTS; test++)
                {
                    results[test][i] -= currentOffsets.data[i];
                }        
            }
/* Run through all tests and batteries to find the maximum. This is the
quiescent current */
            int16_t quiescentCurrent = -100;
            for (i=0; i<NUM_BATS; i++)
            {
                if (batteryHealthState[i] != missingH)
                {
                    for (test=0; test<NUM_TESTS; test++)
                    {
                        int16_t current = results[test][i];
/* Get the maximum if within threshold. */
                        if (current > CALIBRATION_THRESHOLD)
                        {
                            if (current > quiescentCurrent)
                                quiescentCurrent = current;
                        }
                    }
                }
            }
            dataMessageSendLowPriority("pQ",quiescentCurrent,7);

/* Restore switches and report back */
            setSwitchControlBits(switchSettings);
            dataMessageSendLowPriority("dS",switchSettings,0);
/* Compute the SoC from the OCV. Note the conditions for which OCV gives an
accurate estimate of SoC. */
/* Zero counters, and reset battery states */
            for (i=0; i<NUM_BATS; i++)
            {
                if (batteryHealthState[i] != missingH)
                {
                    setBatterySoC(i,computeSoC(getBatteryVoltage(i),
                                               getTemperature(),getBatteryType(i)));
                    batteryCurrentSteady[i] = 0;
                    batteryIsolationTime[i] = 0;
                    batteryOpState[i] = isolatedO;
                }
            }
            batteryUnderLoad = 0;
            batteryUnderCharge = 0;
/* Write the offsets to FLASH */
            for (i=0; i<NUM_IFS; i++) setCurrentOffset(i,currentOffsets.data[i]);
            writeConfigBlock();
/* Ensure that calibration doesn't happen on the next cycle */
            calibrate = false;
        }

/*------------- RECORD AND REPORT STATE --------------*/
/**
<b>Record and Report State:</b> The current state variables are recorded
via the File module, and transmitted via the Communications module. */

/* Send off the current set of measurements */
        char id[4];
        id[0] = 'd';
        id[3] = 0;
/* Send out a time string */
        char timeString[20];
        putTimeToString(timeString);
        sendDebugString("pH",timeString);
        recordString("pH",timeString);
        uint8_t i;
        for (i=0; i<NUM_BATS; i++)
        {
            id[2] = '1'+i;
/* Send out battery terminal measurements. */
            id[1] = 'B';
            dataMessageSendLowPriority(id,
                        getBatteryCurrent(i),
                        getBatteryVoltage(i));
            recordDual(id,
                        getBatteryCurrent(i),
                        getBatteryVoltage(i));
/* Send out battery state of charge. */
            id[1] = 'C';
            sendResponseLowPriority(id,batterySoC[i]);
            recordSingle(id,batterySoC[i]);
/* Send out battery operational, fill, charging and health status indication. */
            uint16_t states = (batteryOpState[i] & 0x03) |
                             ((batteryFillState[i] & 0x03) << 2) |
                             ((getBatteryChargingPhase(i) & 0x03) << 4) |
                             ((batteryHealthState[i] & 0x03) << 6);
            id[1] = 'O';
            sendResponseLowPriority(id,states);
            recordSingle(id,states);
        }
/* Send out load terminal measurements. */
        id[1] = 'L';
        for (i=0; i<NUM_LOADS; i++)
        {
            id[2] = '1'+i;
            dataMessageSendLowPriority(id,
                        getLoadCurrent(i)-getLoadCurrentOffset(i),
                        getLoadVoltage(i));
            recordDual(id,
                        getLoadCurrent(i)-getLoadCurrentOffset(i),
                        getLoadVoltage(i));
        }
/* Send out panel terminal measurements. */
        id[1] = 'M';
        for (i=0; i<NUM_PANELS; i++)
        {
            id[2] = '1'+i;
            dataMessageSendLowPriority(id,
                        getPanelCurrent(i)-getPanelCurrentOffset(i),
                        getPanelVoltage(i));
            recordDual(id,
                        getPanelCurrent(i)-getPanelCurrentOffset(i),
                        getPanelVoltage(i));
        }
/* Send out temperature measurement. */
        sendResponseLowPriority("dT",getTemperature());
        recordSingle("dT",getTemperature());
/* Send out control variables - isAutoTrack(), recording, calibrate */
        sendResponseLowPriority("dD",getControls());
        recordSingle("dD",getControls());
        sendResponseLowPriority("ds",(int)getSwitchControlBits());
        recordSingle("ds",(int)getSwitchControlBits());
/* Send switch and decision settings during tracking */
        if (isAutoTrack())
        {
            sendResponseLowPriority("dd",decisionStatus);
            recordSingle("dd",decisionStatus);
        }
/* Read the interface fault indicators and send out */
        sendResponseLowPriority("dI",getIndicators());
        recordSingle("dI",getIndicators());

/*------------- COMPUTE BATTERY STATE -----------------------*/
/**
<b>Compute the Battery State:</b>
<ul>
<li> Check to see if any batteries are missing. This can happen if a battery put
 under load has been removed. Remove any existing loads and charger from that
battery. If a battery has already been marked as missing then perpetuate the
state.
@note Missing batteries not under load will not show as missing due to the
nature of the circuitry, so any existing missing battery status is not
removed here; this must be done externally. */
        for (i=0; i<NUM_BATS; i++)
        {
            if ((batteryHealthState[i] == missingH) || 
                ((getIndicators() >> 2*i) & 0x02) == 0)
            {
                batteryHealthState[i] = missingH;
                setBatterySoC(i,0);
                if (batteryUnderLoad == i+1)
                    batteryUnderLoad = 0;
                if (batteryUnderCharge == i+1)
                    batteryUnderCharge = 0;
            }
        }
/* Find the number of batteries present */
        uint8_t numBats = NUM_BATS;
        for (i=0; i<NUM_BATS; i++)
        {
            if (batteryHealthState[i] == missingH) numBats--;
        }
        for (i=0; i<NUM_BATS; i++)
        {
            if (batteryHealthState[i] != missingH)
            {
/**
<li> Access charge accumulated for each battery since the last time, and update
the SoC. The maximum charge is the battery capacity in ampere seconds
(coulombs). */
                int16_t accumulatedCharge = getBatteryAccumulatedCharge(i);
                batteryCharge[i] += accumulatedCharge;
                uint32_t chargeMax = getBatteryCapacity(i)*3600*256;
                if (batteryCharge[i] < 0) batteryCharge[i] = 0;
                if ((uint32_t)batteryCharge[i] > chargeMax)
                    batteryCharge[i] = chargeMax;
                batterySoC[i] = batteryCharge[i]/(getBatteryCapacity(i)*36);
/* Collect the battery charge fill state estimations. */
                uint16_t batteryAbsVoltage = abs(getBatteryVoltage(i));
                batteryFillState[i] = normalF;
                if ((batteryAbsVoltage < configData.config.lowVoltage) ||
                    (batterySoC[i] < configData.config.lowSoC))
                    batteryFillState[i] = lowF;
                else if ((batteryAbsVoltage < configData.config.criticalVoltage) ||
                         (batterySoC[i] < configData.config.criticalSoC))
                    batteryFillState[i] = criticalF;
            }
        }
/**
<li> Rank the batteries by charge state. Bubble sort to have the highest SoC set
to the start of the list and the lowest at the end. */
        uint8_t k;
        uint16_t temp;
        uint8_t batteryFillStateSort[NUM_BATS];        
        for (i=0; i<NUM_BATS; i++) batteryFillStateSort[i] = i+1;
        for (i=0; i<NUM_BATS-1; i++)
        {
            for (k=0; k<NUM_BATS-i-1; k++)
            {
              if (batterySoC[batteryFillStateSort[k]-1] <
                  batterySoC[batteryFillStateSort[k+1]-1])
              {
                temp = batteryFillStateSort[k];
                batteryFillStateSort[k] = batteryFillStateSort[k+1];
                batteryFillStateSort[k+1] = temp;
              }
            }
        }
/**
<li> Find the batteries with the longest and shortest isolation times. */
        uint8_t longestBattery = 0;
        uint32_t longestTime = 0;
//        uint8_t shortestBattery = 0;
//        uint32_t shortestTime = 0xFFFFFFFF;
        for (i=0; i<NUM_BATS; i++)
        {
            if (batteryHealthState[i] != missingH)
            {
                if (batteryIsolationTime[i] > longestTime)
                {
                    longestTime = batteryIsolationTime[i];
                    longestBattery = i+1;
                }
/*                if (batteryIsolationTime[i] < shortestTime)
                {
                    shortestTime = batteryIsolationTime[i];
                    shortestBattery = i+1;
                } */
            }
        }

/**
/</ul> */

/*------------- BATTERY MANAGEMENT DECISIONS -----------------------*/
/**
<b>Battery Management Decisions:</b> Work through the battery states to allocate
loads to the highest SoC, accounting for batteries set to be isolated which we
wish to keep isolated if possible.
The first priority is to allocate the charger to a weak or critical battery.
The second priority is to allocate all loads to a "normal" charged battery even
if it must be taken out of isolation. Failing that, repeat for low state
batteries in order to hold onto the priority loads.
The charger, once allocated, is maintained until the charge algorithm releases
it or another battery becomes low. Decisions to change the charged battery are
therefore made when the charger is released (unallocated).
@note The code is valid for any number of batteries, but fixed for two loads and
one panel.
<b>TODO</b>: update code for more panels (chargers) and loads. */
        uint8_t highestBattery = batteryFillStateSort[0];
        uint8_t lowestBattery = batteryFillStateSort[numBats-1];
        uint8_t chargingBattery = (getSwitchControlBits() >> 4) & 0x03;
/* decisionStatus is a variable used to record the reason for any decision */
        decisionStatus = 0;

        for (i=0; i<NUM_BATS; i++)
        {
/**
<ul>
<li> Change each battery to bulk phase if it is in float phase and the SoC drops
below a charging restart threshold (nominally 95%). */
            if ((getBatteryChargingPhase(i) == floatC) &&
                (getBatterySoC(i) < configData.config.floatBulkSoC))
                setBatteryChargingPhase(i,bulkC);
        }

/**
<li> If the currently allocated charging battery is in float and higher than
95%, or is in rest phase, deallocate the battery to allow the algorithms to find
another. */
        if (batteryUnderCharge > 0)
        {
            bool floatPhase = ((getBatteryChargingPhase(batteryUnderCharge-1) == floatC)
                     && (batterySoC[batteryUnderCharge-1] > configData.config.floatBulkSoC));
            bool restPhase = (getBatteryChargingPhase(batteryUnderCharge-1) == restC);
            if (floatPhase || restPhase)
            {
                batteryUnderCharge = 0;
            }
        }

/**
<li> One battery: just allocate the loads and charger to it. */
        if (numBats == 1)
        {
            decisionStatus = 0x100;
            batteryUnderCharge = batteryFillStateSort[0];
            batteryUnderLoad = batteryFillStateSort[0];
/**
<ul>
<li> If the battery is in float and higher than 95%, stop charging.
</ul> */
            bool floatPhase = ((getBatteryChargingPhase(batteryUnderCharge-1) == floatC)
                     && (batterySoC[batteryUnderCharge-1] > configData.config.floatBulkSoC));
            if (floatPhase)
            {
                decisionStatus |= 0x02;
                batteryUnderCharge = 0;
            }
        }
/**
<li> Two batteries: just allocate the loads to the highest and the charger to
the lowest. */
        else if (numBats == 2)
        {
            decisionStatus = 0x200;
/**
<ol>
<li> If the charger is unallocated, set to the lowest SoC battery if it is
not in float state with the SoC > 95%, nor in rest phase.*/
            if (batteryUnderCharge == 0)
            {
                decisionStatus |= 0x01;
                for (i=0; i<numBats; i++)
                {
                    uint8_t index = batteryFillStateSort[numBats-i-1]-1;
                    bool floatPhase = ((getBatteryChargingPhase(index) == floatC)
                             && (batterySoC[index] > configData.config.floatBulkSoC));
                    bool restPhase = (getBatteryChargingPhase(index) == restC);
                    if (!(floatPhase || restPhase))
                    {
                        decisionStatus |= 0x02;
                        batteryUnderCharge = index+1;
                        break;
                    }
                }
            }
/**
<li> If the charger has been allocated to the loaded battery, then
deallocate the loaded battery. This will allow the charger to swap back and
forth as the loaded battery droops and the charging battery completes charge. */
                if ((getMonitorStrategy() & SEPARATE_LOAD) &&
                    (batteryUnderLoad == batteryUnderCharge))
                    batteryUnderLoad = 0;

/**
<li> If the loads are unallocated, set them to the highest SoC unallocated
battery. Avoid the battery that has been idle for the longest time, and also
the battery under charge if the strategies require it. */
            if (batteryUnderLoad == 0)
            {
                decisionStatus |= 0x10;
                for (i=0; i<numBats; i++)
                {
                    batteryUnderLoad = batteryFillStateSort[i];
                    if (!(getMonitorStrategy() & SEPARATE_LOAD))
                    {
                        decisionStatus |= 0x20;
                        break;
                    }
                    if (batteryUnderLoad != chargingBattery)
                    {
                        decisionStatus |= 0x40;
                        break;
                    }
                }
            }
/**
<li> If the battery under load is on a low or critical battery, allocate to the
charging battery regardless.
</ol> */
            if (batteryFillState[batteryUnderLoad-1] != normalF)
                batteryUnderLoad = chargingBattery;
        }
/**
<li> More than two batteries: manage isolation and charge states. */
        else if (numBats > 2)
        {
/**
<ol>
<li> All batteries in normal fill state. The isolated battery has already been
allocated. */
            if (batteryFillState[lowestBattery-1] == normalF)
            {
/**
<ul>
<li> If the charger is unallocated, set to the lowest SoC battery, provided this
battery is not in float with SoC > 95%, nor in rest phase. If no suitable
battery is found leave the charger unallocated. */
                decisionStatus = 0x300;
                if (batteryUnderCharge == 0)
                {
                    decisionStatus |= 0x01;
                    for (i=0; i<numBats; i++)
                    {
                        uint8_t battery = batteryFillStateSort[numBats-i-1];
                        bool floatPhase = ((getBatteryChargingPhase(battery-1) == floatC)
                                 && (batterySoC[battery-1] > configData.config.floatBulkSoC));
                        bool restPhase = (getBatteryChargingPhase(battery-1) == restC);
                        if (!(floatPhase || restPhase))
                        {
                            decisionStatus |= 0x02;
                            batteryUnderCharge = battery;
                            break;
                        }
                    }
                }

/**
<li> If the charger has been allocated to the loaded battery, then
deallocate the loaded battery. This will allow the charger to swap back and
forth as the loaded battery droops and the charging battery completes charge.
If the charger has been deallocated, maintain the load on the same battery as
long as it is still in normal state. */
                if ((batteryUnderCharge != 0) &&
                    (getMonitorStrategy() & SEPARATE_LOAD) &&
                    (batteryUnderLoad == batteryUnderCharge))
                    batteryUnderLoad = 0;

/**
<li> If the loads are unallocated, set to the highest SoC unallocated battery.
Avoid the battery that has been idle for the longest time, and also the battery
under charge if the strategies require it. */
                if (batteryUnderLoad == 0)
                {
                    decisionStatus |= 0x10;
                    for (i=0; i<numBats; i++)
                    {
                        batteryUnderLoad = batteryFillStateSort[i];
                        if (!((getMonitorStrategy() & PRESERVE_ISOLATION) &&
                            (batteryUnderLoad == longestBattery)))
                        {
                            if (!(getMonitorStrategy() & SEPARATE_LOAD))
                            {
                                decisionStatus |= 0x20;
                                break;
                            }
                            if (batteryUnderLoad != chargingBattery)
                            {
                                decisionStatus |= 0x40;
                                break;
                            }
                        }
                    }
                }
            }
/**
</ul> */

/**
<li> At least one battery is normal, and some are low or critical. */
            else if (batteryFillState[highestBattery-1] == normalF)
            {
                decisionStatus = 0x400;
/**
<ul>
<li> If the charger is unallocated, set to the lowest SoC battery, provided this
battery is not in float with SoC > 95%, nor in rest phase, regardless if it is
isolated. Also if the weakest battery is critical, reallocate unconditionally to
the charger. Also if the battery under charge is normal, allocate to the weakest
battery. If no suitable battery is found leave the charger unallocated. */
                if ((batteryUnderCharge == 0) || 
                    (batteryFillState[batteryUnderCharge-1] == normalF) ||
                    (batteryFillState[lowestBattery-1] == criticalF))
                {
                    decisionStatus |= 0x01;
/**
Work through the batteries in fill state order to get the weakest one that
is not in float or rest. Make the change only if the battery fill state is
weak or critical and the battery under charge is normal. This avoids rapid
switching in certain unusual cases. */
                    for (i=0; i<numBats; i++)
                    {
                        uint8_t battery = batteryFillStateSort[numBats-i-1];
                        bool floatPhase = ((getBatteryChargingPhase(battery-1) == floatC)
                                 && (batterySoC[battery-1] > configData.config.floatBulkSoC));
                        bool restPhase = (getBatteryChargingPhase(battery-1) == restC);
                        if (!(floatPhase || restPhase))
                        {
                            if ((batteryFillState[battery-1] != normalF) &&
                                (batteryFillState[batteryUnderCharge-1] == normalF))
                            {
                                decisionStatus |= 0x02;
                                batteryUnderCharge = battery;
                                break;
                            }
                        }
                    }
                }

/**
<li> If the battery under load is the same as the battery just selected for
charging, then deallocate the battery under load. */
                if ((getMonitorStrategy() & SEPARATE_LOAD) &&
                    (batteryUnderLoad == batteryUnderCharge))
                    batteryUnderLoad = 0;

/**
<li> If the loads are unallocated or if the battery under load is low or
critical, set to the highest SoC unallocated battery ... */
                if ((batteryUnderLoad == 0) ||
                    (batteryFillState[batteryUnderLoad-1] != normalF))
                {
                    decisionStatus |= 0x10;
                    for (i=0; i<numBats; i++)
                    {
                        batteryUnderLoad = batteryFillStateSort[i];
                        if (batteryUnderLoad != longestBattery)
                        {
                            if (!(getMonitorStrategy() & SEPARATE_LOAD)) break;
                            if (batteryUnderLoad != chargingBattery) break;
                        }
                    }
/**
 ... however if it still ends up on a low battery then there is only one
normal battery which is also isolated, so this must be overridden (this should
not be the battery under charge if our logic is correct so far).
</ul> */
                    if ((batteryUnderLoad == 0) ||
                        (batteryFillState[batteryUnderLoad-1] != normalF))
                    {
                        decisionStatus |= 0x20;
                        batteryUnderLoad = batteryFillStateSort[0];
                    }
                }
            }
/**
<li> Otherwise all batteries are low or critical. */
/**
<ul>
<li> Allocate the charger and loads as best we can. If the battery under load is
critical, turn off the low priority loads (see below). It is expected that at
least one battery will be in bulk phase but check the float and
rest phases regardless in case the algorithm got the charge states wrong.
</ul> */
            else
            {
                decisionStatus = 0x500;
                batteryUnderCharge = 0;
                uint8_t i=0;
                for (i=0; i<numBats; i++)
                {
                    uint8_t battery = batteryFillStateSort[numBats-i-1];
                    bool floatPhase = ((getBatteryChargingPhase(battery-1) == floatC)
                             && (batterySoC[battery-1] > configData.config.floatBulkSoC));
                    bool restPhase = (getBatteryChargingPhase(battery-1) == restC);
                    if (!(floatPhase || restPhase))
                    {
                        decisionStatus |= 0x04;
                        batteryUnderCharge = battery;
                        break;
                    }
                }
                batteryUnderLoad = batteryFillStateSort[0];
            }
        }
/**
</ol> */
/**
</ul> */

/*--------------END BATTERY MANAGEMENT DECISIONS ------------------*/

/**
<b>Global Decisions:</b>
<ul>
<li> If the charging voltage drops below the battery voltage, turn off
charging altogether. This will allow more flexibility in managing isolation
during night periods. Though there may be another battery that could be put on
charge, there is little point seeking it as the panel output would be below
the point at which charging is effective. */
        if ((batteryUnderCharge > 0) &&
            (getBatteryVoltage(batteryUnderCharge-1) > getPanelVoltage(0)+128))
        {
            decisionStatus |= 0x1000;
            batteryUnderCharge = 0;
        }
/**
<li> Compute any changes in battery operational states. */
        for (i=0; i<NUM_BATS; i++)
        {
            uint8_t lastOpState = batteryOpState[i];
            if (batteryHealthState[i] != missingH)
            {
                batteryOpState[i] = isolatedO; /* reset operational state */
                if ((batteryUnderLoad > 0) && (batteryUnderLoad == i+1))
                {
                    batteryOpState[i] = loadedO;
                }
                if ((batteryUnderCharge > 0) && (i == batteryUnderCharge-1))
                {
                    batteryOpState[i] = chargingO;
                }
/**
<ol>
<li> If the operational state of a battery changes from isolated, update the SoC
if it has been isolated for over 2 hours */
                if ((lastOpState == isolatedO) &&
                    (batteryOpState[i] != isolatedO) &&
                    (batteryIsolationTime[i] > (uint32_t)(2*3600*1024)/getMonitorDelay()))
                {
                    setBatterySoC(i,computeSoC(getBatteryVoltage(i),
                                               getTemperature(),getBatteryType(i)));
                    batteryIsolationTime[i] = 0;
                }
/**
<li> Restart the isolation timer for the battery if it is not isolated or if the
charger and loads are on the same battery (isolation is not possible in that
case due to leakage of charging current to other batteries). Set the timer to a
low value rather than down completely to zero, so that the currently allocated
isolation timer can handover later. */
                if ((batteryOpState[i] != isolatedO) ||
                    (batteryUnderLoad == chargingBattery))
                    batteryIsolationTime[i] = 10;
            }
        }
/**
</ol> */
        if (isAutoTrack())
        {
/* Set Load Switches. */
            setSwitch(batteryUnderLoad,LOAD_2);
/**
<li> Turn off all low priority loads if the batteries are all critical */
            if (batteryFillState[batteryUnderLoad-1] == criticalF)
            {
                setSwitch(0,LOAD_1);
            }
            else
            {
                setSwitch(batteryUnderLoad,LOAD_1);
            }
/**
<li> Connect the battery under charge to the charger if the temperature is below
the high temperature limit, otherwise leave it unconnected. */
            if (getTemperature() < TEMPERATURE_LIMIT*256)
                setSwitch(batteryUnderCharge,PANEL);
/**
<li> Set the battery selected for charge as the "preferred" battery so that it
continues to be used if autotrack is turned off. This information is passed to
the charger task. */
            setPanelSwitchSetting(batteryUnderCharge);
        }

/*---------------- RESET SoC AFTER IDLE TIME --------------------*/
/**
<li> Reset the SoC after a programmed isolation time.
<ol>
<li> Compute the state of charge estimates from the open circuit voltage (OCV)
if the currents are low for the selected time period. The steady current
indicator is incremented on each cycle that the current is below a threshold of
about 80mA. */
        uint32_t monitorHour = (uint32_t)(3600*1000)/getMonitorDelay();
        for (i=0; i<NUM_BATS; i++)
        {
            if (batteryHealthState[i] != missingH)
            {
                if (abs(getBatteryCurrent(i)) < 30)
                    batteryCurrentSteady[i]++;
                else
                    batteryCurrentSteady[i] = 0;
                if (batteryCurrentSteady[i] > monitorHour)
                {
                    setBatterySoC(i,computeSoC(getBatteryVoltage(i),
                                               getTemperature(),getBatteryType(i)));
                    batteryCurrentSteady[i] = 0;
                }
/**
<li> Update the isolation time of each battery. If a battery has been isolated
for over 8 hours, compute the SoC and drop the isolation time back to zero to
allow other batteries to pass to the isolation state. */
                batteryIsolationTime[i]++;
                if (batteryIsolationTime[i] > 8*monitorHour)
                {
                    setBatterySoC(i,computeSoC(getBatteryVoltage(i),
                                               getTemperature(),getBatteryType(i)));
                    batteryIsolationTime[i] = 0;
                }
            }
        }

/**
</ol> */
/**
</ul> */

/* Wait until the next tick cycle */
        vTaskDelay(getMonitorDelay());
/* Reset watchdog counter */
        monitorWatchdogCount = 0;
    }
}

/*--------------------------------------------------------------------------*/
/** @brief Initialise Global Variables to Defaults

*/

static void initGlobals(void)
{
    calibrate = false;
    uint8_t i=0;
    for (i=0; i<NUM_BATS; i++)
    {
/* Determine capacity */
        setBatterySoC(i,computeSoC(getBatteryVoltage(i),getTemperature(),
                                   getBatteryType(i)));
        batteryCurrentSteady[i] = 0;
        batteryIsolationTime[i] = 0;
/* Start with all batteries isolated */
        batteryOpState[i] = isolatedO;
        batteryHealthState[i] = goodH;
    }
    batteryUnderLoad = 0;
    batteryUnderCharge = 0;
/* Load the currrent offsets to the local structure. These will be in FLASH,
or will be set to zero if not. */
    for (i=0; i<NUM_IFS; i++) currentOffsets.data[i] = getCurrentOffset(i);
}

/*--------------------------------------------------------------------------*/
/** @brief Compute SoC from OC Battery Terminal Voltage and Temperature

This model covers the Gel and Wet cell batteries.
Voltage is referred to the value at 48.9C so that one table can be used.
Refer to documentation for the model formula derived.

@param voltage: uint32_t Measured open circuit voltage. Volts times 256
@param temperature: uint32_t Temperature degrees C times 256
@param type: battery_Type
@return int16_t Percentage State of Charge times 256.
*/

int16_t computeSoC(uint32_t voltage, uint32_t temperature, battery_Type type)
{
    int32_t soc;
    int32_t v100, v50, v25;
    if (type == wetT) v100 = 3242;
    else v100 = 3280;
/* Difference between top temperature 48.9C and ambient, times 64. */
    uint32_t tDiff = (12518-temperature) >> 2;
/* Correction factor to apply to measured voltages, times 65536. */
    uint32_t vFactor = 65536-((42*tDiff*tDiff) >> 20);
/* Open circuit voltage referred to 48.9C */
    int32_t ocv = (voltage*65536)/vFactor;
/* SoC for Wet cell and part of Gel cell */
    soc = (100*(65536 - 320*(v100-ocv))) >> 8;
    if (type == gelT)
    {
        v50 = 3178;
        if (ocv < v50)
        {
            v25 = 3075;
            if (ocv > v25) soc = (100*(65536 - 640*(v50-ocv))) >> 8;
            else soc = (100*(65536 - 320*(v25-ocv))) >> 8;
        }
    }
    if (soc > 100*256) soc = 100*256;
    if (soc < 0) soc = 0;
    return soc;
}

/*--------------------------------------------------------------------------*/
/** @brief Access the Battery Current Offset

@param[in] battery: int 0..NUM_BATS-1
@return int16_t battery current offset.
*/

int16_t getBatteryCurrentOffset(int battery)
{
    return currentOffsets.dataArray.battery[battery];
}

/*--------------------------------------------------------------------------*/
/** @brief Access the Load Current Offset

@param[in] battery: int 0..NUM_LOADS-1
@return int16_t battery current offset.
*/

int16_t getLoadCurrentOffset(int load)
{
    return currentOffsets.dataArray.load[load];
}

/*--------------------------------------------------------------------------*/
/** @brief Access the Panel Current Offset

@param[in] battery: int 0..NUM_PANELS-1
@return int16_t battery current offset.
*/

int16_t getPanelCurrentOffset(int panel)
{
    return currentOffsets.dataArray.panel[panel];
}

/*--------------------------------------------------------------------------*/
/** @brief Access the Battery State of Charge

@param[in] battery: int 0..NUM_BATS-1
@return int16_t battery SoC.
*/

int16_t getBatterySoC(int battery)
{
    return batterySoC[battery];
}

/*--------------------------------------------------------------------------*/
/** @brief Get the Battery Under Load

@return int16_t battery under load.
*/

int16_t getBatteryUnderLoad(void)
{
    return batteryUnderLoad;
}

/*--------------------------------------------------------------------------*/
/** @brief Set the Battery Under Load

@param[in] battery: int 0..NUM_BATS-1
*/

void setBatteryUnderLoad(int battery)
{
    batteryUnderLoad = battery;
}

/*--------------------------------------------------------------------------*/
/** @brief Reset the Battery State of Charge to 100%

This is done by the charging task when the battery enters float phase.
If the current SoC is less than 100%, report the battery as faulty.

@param[in] battery: int 0..NUM_BATS-1
*/

void resetBatterySoC(int battery)
{
    if (batterySoC[battery] < 25600) batteryFillState[battery] = faultyF;
    setBatterySoC(battery,25600);
}

/*--------------------------------------------------------------------------*/
/** @brief Set the Battery State of Charge

State of charge is percentage times 256. The accumulated charge is also computed
here in ampere seconds.

@param[in] battery: int 0..NUM_BATS-1
@param[in] soc: int16_t 0..25600
*/

void setBatterySoC(int battery,int16_t soc)
{
    if (batterySoC[battery] > 25600) batterySoC[battery] = 25600;
    else batterySoC[battery] = soc;
/* SoC is computed from the charge so this is the quantity changed. */
    batteryCharge[battery] = soc*getBatteryCapacity(battery)*36;
}

/*--------------------------------------------------------------------------*/
/** @brief Request a Calibration Sequence

*/

void startCalibration()
{
    calibrate = true;
}

/*--------------------------------------------------------------------------*/
/** @brief Change Missing Status of batteries

@param[in] battery: int 0..NUM_BATS-1
@param[in] missing: boolean
*/

void setBatteryMissing(int battery, bool missing)
{
    if (missing) batteryHealthState[battery] = missingH;
    else batteryHealthState[battery] = goodH;
}

/*--------------------------------------------------------------------------*/
/** @brief Check the watchdog state

The watchdog counter is decremented. If it reaches zero then the task is
restarted.
*/

void checkMonitorWatchdog(void)
{
    if (monitorWatchdogCount++ > 10*getMonitorDelay()/getWatchdogDelay())
    {
        vTaskDelete(prvMonitorTask);
        xTaskCreate(prvMonitorTask, (portCHAR * ) "Monitor", \
                    configMINIMAL_STACK_SIZE, NULL, MONITOR_TASK_PRIORITY, NULL);
        sendDebugString("D","Monitor Restarted");
        recordString("D","Monitor Restarted");
    }
}

/*--------------------------------------------------------------------------*/

/**@}*/

