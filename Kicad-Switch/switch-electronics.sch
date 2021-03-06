EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:special
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:MIC4127
LIBS:sud50p04-08-ge3
LIBS:sqd45p03-12
LIBS:switch-electronics-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 2
Title "Switch-Electronics"
Date "7 dec 2013"
Rev "0.00"
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L 74LS139 U2
U 1 1 529FB8BF
P 5450 6800
F 0 "U2" H 5450 6900 60  0000 C CNN
F 1 "74LS139" H 5450 6700 60  0000 C CNN
F 2 "BMS:TSSOP-16" H 5450 6800 60  0001 C CNN
F 3 "" H 5450 6800 60  0001 C CNN
	1    5450 6800
	1    0    0    -1  
$EndComp
$Comp
L 74LS139 U3
U 1 1 529FB8D3
P 5500 1500
F 0 "U3" H 5500 1600 60  0000 C CNN
F 1 "74LS139" H 5500 1400 60  0000 C CNN
F 2 "BMS:TSSOP-16" H 5500 1500 60  0001 C CNN
F 3 "" H 5500 1500 60  0001 C CNN
	1    5500 1500
	1    0    0    -1  
$EndComp
$Comp
L 74LS139 U3
U 2 1 529FB8FB
P 5500 3250
F 0 "U3" H 5500 3350 60  0000 C CNN
F 1 "74LS139" H 5500 3150 60  0000 C CNN
F 2 "BMS:TSSOP-16" H 5500 3250 60  0001 C CNN
F 3 "" H 5500 3250 60  0001 C CNN
	2    5500 3250
	1    0    0    -1  
$EndComp
$Comp
L 74LS139 U2
U 2 1 529FB90F
P 5450 5000
F 0 "U2" H 5450 5100 60  0000 C CNN
F 1 "74LS139" H 5450 4900 60  0000 C CNN
F 2 "BMS:TSSOP-16" H 5450 5000 60  0001 C CNN
F 3 "" H 5450 5000 60  0001 C CNN
	2    5450 5000
	1    0    0    -1  
$EndComp
$Comp
L C C1
U 1 1 529FCC53
P 1300 5500
F 0 "C1" H 1300 5600 40  0000 L CNN
F 1 "0.1uF" H 1306 5415 40  0000 L CNN
F 2 "BMS:SM0603_Capa" H 1350 5200 30  0000 C CNN
F 3 "" H 1300 5500 60  0001 C CNN
	1    1300 5500
	1    0    0    -1  
$EndComp
$Comp
L C C2
U 1 1 529FCC67
P 1750 5500
F 0 "C2" H 1750 5600 40  0000 L CNN
F 1 "0.1uF" H 1756 5415 40  0000 L CNN
F 2 "BMS:SM0603_Capa" H 1800 5200 30  0000 C CNN
F 3 "" H 1750 5500 60  0001 C CNN
	1    1750 5500
	1    0    0    -1  
$EndComp
$Comp
L C C3
U 1 1 529FCCA3
P 2300 5500
F 0 "C3" H 2300 5600 40  0000 L CNN
F 1 "0.1uF" H 2306 5415 40  0000 L CNN
F 2 "BMS:SM0603_Capa" H 2350 5200 30  0000 C CNN
F 3 "" H 2300 5500 60  0001 C CNN
	1    2300 5500
	1    0    0    -1  
$EndComp
$Comp
L C C4
U 1 1 529FCCB7
P 2750 5500
F 0 "C4" H 2750 5600 40  0000 L CNN
F 1 "0.1uF" H 2756 5415 40  0000 L CNN
F 2 "BMS:SM0603_Capa" H 2800 5200 30  0000 C CNN
F 3 "" H 2750 5500 60  0001 C CNN
	1    2750 5500
	1    0    0    -1  
$EndComp
NoConn ~ 4400 1100
NoConn ~ 6350 1800
NoConn ~ 6350 3550
NoConn ~ 6300 5300
NoConn ~ 6300 6500
NoConn ~ 6300 6700
NoConn ~ 6300 6900
NoConn ~ 6300 7100
$Comp
L GND #PWR01
U 1 1 529FE53E
P 4650 1750
F 0 "#PWR01" H 4650 1750 30  0001 C CNN
F 1 "GND" H 4650 1680 30  0001 C CNN
F 2 "" H 4650 1750 60  0001 C CNN
F 3 "" H 4650 1750 60  0001 C CNN
	1    4650 1750
	0    1    -1   0   
$EndComp
$Comp
L GND #PWR02
U 1 1 529FE558
P 4650 3500
F 0 "#PWR02" H 4650 3500 30  0001 C CNN
F 1 "GND" H 4650 3430 30  0001 C CNN
F 2 "" H 4650 3500 60  0001 C CNN
F 3 "" H 4650 3500 60  0001 C CNN
	1    4650 3500
	0    1    -1   0   
$EndComp
$Comp
L GND #PWR03
U 1 1 529FE563
P 4600 7050
F 0 "#PWR03" H 4600 7050 30  0001 C CNN
F 1 "GND" H 4600 6980 30  0001 C CNN
F 2 "" H 4600 7050 60  0001 C CNN
F 3 "" H 4600 7050 60  0001 C CNN
	1    4600 7050
	0    1    -1   0   
$EndComp
$Comp
L GND #PWR04
U 1 1 529FE56E
P 4600 6700
F 0 "#PWR04" H 4600 6700 30  0001 C CNN
F 1 "GND" H 4600 6630 30  0001 C CNN
F 2 "" H 4600 6700 60  0001 C CNN
F 3 "" H 4600 6700 60  0001 C CNN
	1    4600 6700
	0    1    -1   0   
$EndComp
$Comp
L GND #PWR05
U 1 1 529FE579
P 4600 6550
F 0 "#PWR05" H 4600 6550 30  0001 C CNN
F 1 "GND" H 4600 6480 30  0001 C CNN
F 2 "" H 4600 6550 60  0001 C CNN
F 3 "" H 4600 6550 60  0001 C CNN
	1    4600 6550
	0    1    -1   0   
$EndComp
$Comp
L GND #PWR06
U 1 1 529FE6FF
P 1800 1650
F 0 "#PWR06" H 1800 1650 30  0001 C CNN
F 1 "GND" H 1800 1580 30  0001 C CNN
F 2 "" H 1800 1650 60  0001 C CNN
F 3 "" H 1800 1650 60  0001 C CNN
	1    1800 1650
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR07
U 1 1 529FE804
P 2750 5650
F 0 "#PWR07" H 2750 5650 30  0001 C CNN
F 1 "GND" H 2750 5580 30  0001 C CNN
F 2 "" H 2750 5650 60  0001 C CNN
F 3 "" H 2750 5650 60  0001 C CNN
	1    2750 5650
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR08
U 1 1 529FE822
P 2750 5350
F 0 "#PWR08" H 2750 5450 30  0001 C CNN
F 1 "VCC" H 2750 5500 30  0000 C CNN
F 2 "" H 2750 5350 60  0001 C CNN
F 3 "" H 2750 5350 60  0001 C CNN
	1    2750 5350
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR09
U 1 1 529FEA1C
P 1300 5350
F 0 "#PWR09" H 1300 5450 30  0001 C CNN
F 1 "VCC" H 1300 5500 30  0000 C CNN
F 2 "" H 1300 5350 60  0001 C CNN
F 3 "" H 1300 5350 60  0001 C CNN
	1    1300 5350
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR010
U 1 1 529FEA27
P 1750 5350
F 0 "#PWR010" H 1750 5450 30  0001 C CNN
F 1 "VCC" H 1750 5500 30  0000 C CNN
F 2 "" H 1750 5350 60  0001 C CNN
F 3 "" H 1750 5350 60  0001 C CNN
	1    1750 5350
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR011
U 1 1 529FEA32
P 2300 5350
F 0 "#PWR011" H 2300 5450 30  0001 C CNN
F 1 "VCC" H 2300 5500 30  0000 C CNN
F 2 "" H 2300 5350 60  0001 C CNN
F 3 "" H 2300 5350 60  0001 C CNN
	1    2300 5350
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR012
U 1 1 529FEA47
P 1300 5650
F 0 "#PWR012" H 1300 5650 30  0001 C CNN
F 1 "GND" H 1300 5580 30  0001 C CNN
F 2 "" H 1300 5650 60  0001 C CNN
F 3 "" H 1300 5650 60  0001 C CNN
	1    1300 5650
	1    0    0    -1  
$EndComp
$Sheet
S 2100 3450 500  150 
U 529FF400
F0 "Switch-MOSFETs" 50
F1 "switch-mosfet.sch" 50
$EndSheet
Text GLabel 1800 2250 3    60   Input ~ 0
9V
$Comp
L GND #PWR013
U 1 1 52A042DE
P 2300 5650
F 0 "#PWR013" H 2300 5650 30  0001 C CNN
F 1 "GND" H 2300 5580 30  0001 C CNN
F 2 "" H 2300 5650 60  0001 C CNN
F 3 "" H 2300 5650 60  0001 C CNN
	1    2300 5650
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR014
U 1 1 52A042EC
P 1750 5650
F 0 "#PWR014" H 1750 5650 30  0001 C CNN
F 1 "GND" H 1750 5580 30  0001 C CNN
F 2 "" H 1750 5650 60  0001 C CNN
F 3 "" H 1750 5650 60  0001 C CNN
	1    1750 5650
	1    0    0    -1  
$EndComp
$Comp
L PWR_FLAG #FLG015
U 1 1 52A04FE2
P 4600 7050
F 0 "#FLG015" H 4600 7145 30  0001 C CNN
F 1 "PWR_FLAG" H 4600 7230 30  0000 C CNN
F 2 "" H 4600 7050 60  0001 C CNN
F 3 "" H 4600 7050 60  0001 C CNN
	1    4600 7050
	-1   0    0    1   
$EndComp
$Comp
L R_Network08 RN1
U 1 1 5A503D5D
P 4100 900
F 0 "RN1" V 3600 900 50  0000 C CNN
F 1 "R_Network08" V 4500 900 50  0000 C CNN
F 2 "BMS:R_Array_SIP9" V 4575 900 50  0001 C CNN
F 3 "" H 4100 900 50  0001 C CNN
	1    4100 900 
	1    0    0    -1  
$EndComp
$Comp
L Conn_02x07_Odd_Even J1
U 1 1 5A5052FC
P 1500 1550
F 0 "J1" H 1550 1950 50  0000 C CNN
F 1 "Conn_02x07_Odd_Even" H 1200 800 50  0000 C CNN
F 2 "BMS:header-14-v" H 1500 1550 50  0001 C CNN
F 3 "" H 1500 1550 50  0001 C CNN
	1    1500 1550
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR016
U 1 1 5A505EE6
P 1300 1650
F 0 "#PWR016" H 1300 1650 30  0001 C CNN
F 1 "GND" H 1300 1580 30  0001 C CNN
F 2 "" H 1300 1650 60  0001 C CNN
F 3 "" H 1300 1650 60  0001 C CNN
	1    1300 1650
	0    1    1    0   
$EndComp
$Comp
L GND #PWR017
U 1 1 5A506068
P 1300 1350
F 0 "#PWR017" H 1300 1350 30  0001 C CNN
F 1 "GND" H 1300 1280 30  0001 C CNN
F 2 "" H 1300 1350 60  0001 C CNN
F 3 "" H 1300 1350 60  0001 C CNN
	1    1300 1350
	0    1    1    0   
$EndComp
$Comp
L Jumper_NO_Small JP1
U 1 1 5A50C3A1
P 2150 1800
F 0 "JP1" H 2150 1880 50  0000 C CNN
F 1 "Jumper_NO_Small" V 2450 1900 50  0000 C CNN
F 2 "BMS:SIL-2" H 2150 1800 50  0001 C CNN
F 3 "" H 2150 1800 50  0001 C CNN
	1    2150 1800
	0    1    1    0   
$EndComp
NoConn ~ 4600 5700
$Comp
L 74HC04 U4
U 1 1 5A5146C8
P 7150 900
F 0 "U4" H 7300 1000 50  0000 C CNN
F 1 "74HC04" H 7350 800 50  0000 C CNN
F 2 "BMS:TSSOP-14" H 7150 900 50  0001 C CNN
F 3 "" H 7150 900 50  0001 C CNN
	1    7150 900 
	1    0    0    -1  
$EndComp
$Comp
L 74HC04 U4
U 2 1 5A5148B3
P 7150 1400
F 0 "U4" H 7300 1500 50  0000 C CNN
F 1 "74HC04" H 7350 1300 50  0000 C CNN
F 2 "BMS:TSSOP-14" H 7150 1400 50  0001 C CNN
F 3 "" H 7150 1400 50  0001 C CNN
	2    7150 1400
	1    0    0    -1  
$EndComp
$Comp
L 74HC04 U1
U 5 1 5A514928
P 4150 5700
F 0 "U1" H 4300 5800 50  0000 C CNN
F 1 "74HC04" H 4350 5600 50  0000 C CNN
F 2 "BMS:TSSOP-14" H 4150 5700 50  0001 C CNN
F 3 "" H 4150 5700 50  0001 C CNN
	5    4150 5700
	1    0    0    -1  
$EndComp
$Comp
L 74HC04 U1
U 4 1 5A514969
P 7100 5400
F 0 "U1" H 7250 5500 50  0000 C CNN
F 1 "74HC04" H 7300 5300 50  0000 C CNN
F 2 "BMS:TSSOP-14" H 7100 5400 50  0001 C CNN
F 3 "" H 7100 5400 50  0001 C CNN
	4    7100 5400
	1    0    0    -1  
$EndComp
$Comp
L 74HC04 U4
U 3 1 5A5149F8
P 7150 1900
F 0 "U4" H 7300 2000 50  0000 C CNN
F 1 "74HC04" H 7350 1800 50  0000 C CNN
F 2 "BMS:TSSOP-14" H 7150 1900 50  0001 C CNN
F 3 "" H 7150 1900 50  0001 C CNN
	3    7150 1900
	1    0    0    -1  
$EndComp
$Comp
L 74HC04 U1
U 6 1 5A514A8F
P 4150 6100
F 0 "U1" H 4300 6200 50  0000 C CNN
F 1 "74HC04" H 4350 6000 50  0000 C CNN
F 2 "BMS:TSSOP-14" H 4150 6100 50  0001 C CNN
F 3 "" H 4150 6100 50  0001 C CNN
	6    4150 6100
	1    0    0    -1  
$EndComp
$Comp
L 74HC04 U4
U 4 1 5A514B46
P 7150 3650
F 0 "U4" H 7300 3750 50  0000 C CNN
F 1 "74HC04" H 7350 3550 50  0000 C CNN
F 2 "BMS:TSSOP-14" H 7150 3650 50  0001 C CNN
F 3 "" H 7150 3650 50  0001 C CNN
	4    7150 3650
	1    0    0    -1  
$EndComp
$Comp
L 74HC04 U1
U 2 1 5A514BC1
P 7100 4400
F 0 "U1" H 7250 4500 50  0000 C CNN
F 1 "74HC04" H 7300 4300 50  0000 C CNN
F 2 "BMS:TSSOP-14" H 7100 4400 50  0001 C CNN
F 3 "" H 7100 4400 50  0001 C CNN
	2    7100 4400
	1    0    0    -1  
$EndComp
$Comp
L 74HC04 U4
U 5 1 5A514C58
P 7150 3150
F 0 "U4" H 7300 3250 50  0000 C CNN
F 1 "74HC04" H 7350 3050 50  0000 C CNN
F 2 "BMS:TSSOP-14" H 7150 3150 50  0001 C CNN
F 3 "" H 7150 3150 50  0001 C CNN
	5    7150 3150
	1    0    0    -1  
$EndComp
$Comp
L 74HC04 U1
U 3 1 5A514CD5
P 7100 4900
F 0 "U1" H 7250 5000 50  0000 C CNN
F 1 "74HC04" H 7300 4800 50  0000 C CNN
F 2 "BMS:TSSOP-14" H 7100 4900 50  0001 C CNN
F 3 "" H 7100 4900 50  0001 C CNN
	3    7100 4900
	1    0    0    -1  
$EndComp
$Comp
L 74HC04 U4
U 6 1 5A514D88
P 7150 2650
F 0 "U4" H 7300 2750 50  0000 C CNN
F 1 "74HC04" H 7350 2550 50  0000 C CNN
F 2 "BMS:TSSOP-14" H 7150 2650 50  0001 C CNN
F 3 "" H 7150 2650 50  0001 C CNN
	6    7150 2650
	1    0    0    -1  
$EndComp
$Comp
L 74HC04 U1
U 1 1 5A514E12
P 4150 5250
F 0 "U1" H 4300 5350 50  0000 C CNN
F 1 "74HC04" H 4350 5150 50  0000 C CNN
F 2 "BMS:TSSOP-14" H 4150 5250 50  0001 C CNN
F 3 "" H 4150 5250 50  0001 C CNN
	1    4150 5250
	1    0    0    -1  
$EndComp
NoConn ~ 4600 6100
$Comp
L BC847BPDW1 Q7
U 1 1 5A520701
P 9700 1100
F 0 "Q7" V 9950 1050 50  0000 L CNN
F 1 "BC847BPDW1" V 9650 500 50  0000 L CNN
F 2 "BMS:SOT-363" H 9900 1200 50  0001 C CNN
F 3 "" H 9700 1100 50  0001 C CNN
	1    9700 1100
	0    1    1    0   
$EndComp
$Comp
L BC847BPDW1 Q7
U 2 1 5A52090A
P 10100 1100
F 0 "Q7" V 10350 1050 50  0000 L CNN
F 1 "BC847BPDW1" H 10400 750 50  0001 L CNN
F 2 "BMS:SOT-363" H 10300 1200 50  0001 C CNN
F 3 "" H 10100 1100 50  0001 C CNN
	2    10100 1100
	0    1    1    0   
$EndComp
$Comp
L GND #PWR018
U 1 1 5A5211C2
P 9500 1200
F 0 "#PWR018" H 9500 1200 30  0001 C CNN
F 1 "GND" H 9500 1130 30  0001 C CNN
F 2 "" H 9500 1200 60  0001 C CNN
F 3 "" H 9500 1200 60  0001 C CNN
	1    9500 1200
	0    1    -1   0   
$EndComp
$Comp
L BC847BPDW1 Q4
U 1 1 5A523876
P 9000 1600
F 0 "Q4" V 9250 1550 50  0000 L CNN
F 1 "BC847BPDW1" V 8950 1000 50  0000 L CNN
F 2 "BMS:SOT-363" H 9200 1700 50  0001 C CNN
F 3 "" H 9000 1600 50  0001 C CNN
	1    9000 1600
	0    1    1    0   
$EndComp
$Comp
L BC847BPDW1 Q4
U 2 1 5A52387C
P 9400 1600
F 0 "Q4" V 9650 1550 50  0000 L CNN
F 1 "BC847BPDW1" H 9700 1250 50  0001 L CNN
F 2 "BMS:SOT-363" H 9600 1700 50  0001 C CNN
F 3 "" H 9400 1600 50  0001 C CNN
	2    9400 1600
	0    1    1    0   
$EndComp
$Comp
L GND #PWR019
U 1 1 5A523885
P 8800 1700
F 0 "#PWR019" H 8800 1700 30  0001 C CNN
F 1 "GND" H 8800 1630 30  0001 C CNN
F 2 "" H 8800 1700 60  0001 C CNN
F 3 "" H 8800 1700 60  0001 C CNN
	1    8800 1700
	0    1    -1   0   
$EndComp
$Comp
L BC847BPDW1 Q1
U 1 1 5A523984
P 8300 2100
F 0 "Q1" V 8550 2050 50  0000 L CNN
F 1 "BC847BPDW1" V 8250 1500 50  0000 L CNN
F 2 "BMS:SOT-363" H 8500 2200 50  0001 C CNN
F 3 "" H 8300 2100 50  0001 C CNN
	1    8300 2100
	0    1    1    0   
$EndComp
$Comp
L BC847BPDW1 Q1
U 2 1 5A52398A
P 8700 2100
F 0 "Q1" V 8950 2050 50  0000 L CNN
F 1 "BC847BPDW1" H 9000 1750 50  0001 L CNN
F 2 "BMS:SOT-363" H 8900 2200 50  0001 C CNN
F 3 "" H 8700 2100 50  0001 C CNN
	2    8700 2100
	0    1    1    0   
$EndComp
$Comp
L GND #PWR020
U 1 1 5A523993
P 8100 2200
F 0 "#PWR020" H 8100 2200 30  0001 C CNN
F 1 "GND" H 8100 2130 30  0001 C CNN
F 2 "" H 8100 2200 60  0001 C CNN
F 3 "" H 8100 2200 60  0001 C CNN
	1    8100 2200
	0    1    -1   0   
$EndComp
$Comp
L BC847BPDW1 Q8
U 1 1 5A524620
P 9700 2850
F 0 "Q8" V 9950 2800 50  0000 L CNN
F 1 "BC847BPDW1" V 9650 2250 50  0000 L CNN
F 2 "BMS:SOT-363" H 9900 2950 50  0001 C CNN
F 3 "" H 9700 2850 50  0001 C CNN
	1    9700 2850
	0    1    1    0   
$EndComp
$Comp
L BC847BPDW1 Q8
U 2 1 5A524626
P 10100 2850
F 0 "Q8" V 10350 2800 50  0000 L CNN
F 1 "BC847BPDW1" H 10400 2500 50  0001 L CNN
F 2 "BMS:SOT-363" H 10300 2950 50  0001 C CNN
F 3 "" H 10100 2850 50  0001 C CNN
	2    10100 2850
	0    1    1    0   
$EndComp
$Comp
L GND #PWR021
U 1 1 5A52462F
P 9500 2950
F 0 "#PWR021" H 9500 2950 30  0001 C CNN
F 1 "GND" H 9500 2880 30  0001 C CNN
F 2 "" H 9500 2950 60  0001 C CNN
F 3 "" H 9500 2950 60  0001 C CNN
	1    9500 2950
	0    1    -1   0   
$EndComp
$Comp
L BC847BPDW1 Q5
U 1 1 5A524636
P 9000 3350
F 0 "Q5" V 9250 3300 50  0000 L CNN
F 1 "BC847BPDW1" V 8950 2750 50  0000 L CNN
F 2 "BMS:SOT-363" H 9200 3450 50  0001 C CNN
F 3 "" H 9000 3350 50  0001 C CNN
	1    9000 3350
	0    1    1    0   
$EndComp
$Comp
L BC847BPDW1 Q5
U 2 1 5A52463C
P 9400 3350
F 0 "Q5" V 9650 3300 50  0000 L CNN
F 1 "BC847BPDW1" H 9700 3000 50  0001 L CNN
F 2 "BMS:SOT-363" H 9600 3450 50  0001 C CNN
F 3 "" H 9400 3350 50  0001 C CNN
	2    9400 3350
	0    1    1    0   
$EndComp
$Comp
L GND #PWR022
U 1 1 5A524645
P 8800 3450
F 0 "#PWR022" H 8800 3450 30  0001 C CNN
F 1 "GND" H 8800 3380 30  0001 C CNN
F 2 "" H 8800 3450 60  0001 C CNN
F 3 "" H 8800 3450 60  0001 C CNN
	1    8800 3450
	0    1    -1   0   
$EndComp
$Comp
L BC847BPDW1 Q2
U 1 1 5A52464C
P 8300 3850
F 0 "Q2" V 8550 3800 50  0000 L CNN
F 1 "BC847BPDW1" V 8250 3250 50  0000 L CNN
F 2 "BMS:SOT-363" H 8500 3950 50  0001 C CNN
F 3 "" H 8300 3850 50  0001 C CNN
	1    8300 3850
	0    1    1    0   
$EndComp
$Comp
L BC847BPDW1 Q2
U 2 1 5A524652
P 8700 3850
F 0 "Q2" V 8950 3800 50  0000 L CNN
F 1 "BC847BPDW1" H 9000 3500 50  0001 L CNN
F 2 "BMS:SOT-363" H 8900 3950 50  0001 C CNN
F 3 "" H 8700 3850 50  0001 C CNN
	2    8700 3850
	0    1    1    0   
$EndComp
$Comp
L GND #PWR023
U 1 1 5A52465B
P 8100 3950
F 0 "#PWR023" H 8100 3950 30  0001 C CNN
F 1 "GND" H 8100 3880 30  0001 C CNN
F 2 "" H 8100 3950 60  0001 C CNN
F 3 "" H 8100 3950 60  0001 C CNN
	1    8100 3950
	0    1    -1   0   
$EndComp
$Comp
L BC847BPDW1 Q9
U 1 1 5A5263B0
P 9700 4600
F 0 "Q9" V 9950 4550 50  0000 L CNN
F 1 "BC847BPDW1" V 9650 4000 50  0000 L CNN
F 2 "BMS:SOT-363" H 9900 4700 50  0001 C CNN
F 3 "" H 9700 4600 50  0001 C CNN
	1    9700 4600
	0    1    1    0   
$EndComp
$Comp
L BC847BPDW1 Q9
U 2 1 5A5263B6
P 10100 4600
F 0 "Q9" V 10350 4550 50  0000 L CNN
F 1 "BC847BPDW1" H 10400 4250 50  0001 L CNN
F 2 "BMS:SOT-363" H 10300 4700 50  0001 C CNN
F 3 "" H 10100 4600 50  0001 C CNN
	2    10100 4600
	0    1    1    0   
$EndComp
$Comp
L GND #PWR024
U 1 1 5A5263BF
P 9500 4700
F 0 "#PWR024" H 9500 4700 30  0001 C CNN
F 1 "GND" H 9500 4630 30  0001 C CNN
F 2 "" H 9500 4700 60  0001 C CNN
F 3 "" H 9500 4700 60  0001 C CNN
	1    9500 4700
	0    1    -1   0   
$EndComp
$Comp
L BC847BPDW1 Q6
U 1 1 5A5263C6
P 9000 5100
F 0 "Q6" V 9250 5050 50  0000 L CNN
F 1 "BC847BPDW1" V 8950 4500 50  0000 L CNN
F 2 "BMS:SOT-363" H 9200 5200 50  0001 C CNN
F 3 "" H 9000 5100 50  0001 C CNN
	1    9000 5100
	0    1    1    0   
$EndComp
$Comp
L BC847BPDW1 Q6
U 2 1 5A5263CC
P 9400 5100
F 0 "Q6" V 9650 5050 50  0000 L CNN
F 1 "BC847BPDW1" H 9700 4750 50  0001 L CNN
F 2 "BMS:SOT-363" H 9600 5200 50  0001 C CNN
F 3 "" H 9400 5100 50  0001 C CNN
	2    9400 5100
	0    1    1    0   
$EndComp
$Comp
L GND #PWR025
U 1 1 5A5263D5
P 8800 5200
F 0 "#PWR025" H 8800 5200 30  0001 C CNN
F 1 "GND" H 8800 5130 30  0001 C CNN
F 2 "" H 8800 5200 60  0001 C CNN
F 3 "" H 8800 5200 60  0001 C CNN
	1    8800 5200
	0    1    -1   0   
$EndComp
$Comp
L BC847BPDW1 Q3
U 1 1 5A5263DC
P 8300 5600
F 0 "Q3" V 8550 5550 50  0000 L CNN
F 1 "BC847BPDW1" V 8250 5000 50  0000 L CNN
F 2 "BMS:SOT-363" H 8500 5700 50  0001 C CNN
F 3 "" H 8300 5600 50  0001 C CNN
	1    8300 5600
	0    1    1    0   
$EndComp
$Comp
L BC847BPDW1 Q3
U 2 1 5A5263E2
P 8700 5600
F 0 "Q3" V 8950 5550 50  0000 L CNN
F 1 "BC847BPDW1" H 9000 5250 50  0001 L CNN
F 2 "BMS:SOT-363" H 8900 5700 50  0001 C CNN
F 3 "" H 8700 5600 50  0001 C CNN
	2    8700 5600
	0    1    1    0   
$EndComp
$Comp
L GND #PWR026
U 1 1 5A5263EB
P 8100 5700
F 0 "#PWR026" H 8100 5700 30  0001 C CNN
F 1 "GND" H 8100 5630 30  0001 C CNN
F 2 "" H 8100 5700 60  0001 C CNN
F 3 "" H 8100 5700 60  0001 C CNN
	1    8100 5700
	0    1    -1   0   
$EndComp
Text GLabel 10750 1450 2    60   Input ~ 0
B3L1
Text GLabel 10750 1950 2    60   Input ~ 0
B2L1
Text GLabel 10750 2450 2    60   Input ~ 0
B1L1
Text GLabel 10750 3200 2    60   Input ~ 0
B3L2
Text GLabel 10750 3700 2    60   Input ~ 0
B2L2
Text GLabel 10750 4200 2    60   Input ~ 0
B1L2
Text GLabel 10750 4950 2    60   Input ~ 0
B3M1
Text GLabel 10750 5450 2    60   Input ~ 0
B2M1
Text GLabel 10750 5950 2    60   Input ~ 0
B1M1
Text GLabel 10750 1700 2    60   Input ~ 0
B3
Text GLabel 10750 2200 2    60   Input ~ 0
B2
Text GLabel 10750 2650 2    60   Input ~ 0
B1
Text GLabel 10750 4700 2    60   Input ~ 0
M1
Connection ~ 3700 1950
Connection ~ 3800 1850
Connection ~ 3900 1750
Connection ~ 4000 1650
Connection ~ 4100 1550
Wire Wire Line
	6350 1200 6700 1200
Wire Wire Line
	6700 1200 6700 900 
Wire Wire Line
	6350 1600 6700 1600
Wire Wire Line
	6700 1600 6700 1900
Wire Wire Line
	6700 2650 6700 2950
Wire Wire Line
	6700 2950 6350 2950
Wire Wire Line
	6350 3150 6700 3150
Wire Wire Line
	6700 3650 6700 3350
Wire Wire Line
	6700 3350 6350 3350
Wire Wire Line
	6300 4700 6650 4700
Wire Wire Line
	6650 4700 6650 4400
Wire Wire Line
	6300 5100 6650 5100
Wire Wire Line
	6650 5100 6650 5400
Wire Wire Line
	1800 1250 4650 1250
Wire Wire Line
	2500 1650 4000 1650
Wire Wire Line
	2400 1750 3900 1750
Wire Wire Line
	2300 1850 3800 1850
Wire Wire Line
	2150 1950 3700 1950
Wire Wire Line
	4300 1250 4300 1100
Wire Wire Line
	3700 1100 3700 5250
Connection ~ 4200 1400
Connection ~ 4300 1250
Wire Wire Line
	4200 1400 4200 1100
Wire Wire Line
	4100 1100 4100 3150
Wire Wire Line
	4100 3150 4650 3150
Wire Wire Line
	4000 1100 4000 3000
Wire Wire Line
	4000 3000 4650 3000
Wire Wire Line
	3800 1100 3800 4750
Wire Wire Line
	3800 4750 4600 4750
Wire Wire Line
	3900 1100 3900 4900
Wire Wire Line
	3900 4900 4600 4900
Wire Wire Line
	1300 1250 1150 1250
Wire Wire Line
	1150 1250 1150 1100
Wire Wire Line
	1150 1100 2700 1100
Wire Wire Line
	2700 1100 2700 1400
Wire Wire Line
	2700 1400 4650 1400
Wire Wire Line
	1800 1750 1800 2250
Wire Wire Line
	1300 1750 1300 2200
Wire Wire Line
	1300 2200 1800 2200
Connection ~ 1800 2200
Connection ~ 1800 1850
Connection ~ 1300 1850
Wire Wire Line
	1800 1350 2600 1350
Wire Wire Line
	2600 1350 2600 1550
Wire Wire Line
	2500 1650 2500 1000
Wire Wire Line
	2500 1000 1050 1000
Wire Wire Line
	1050 1000 1050 1450
Wire Wire Line
	1050 1450 1300 1450
Wire Wire Line
	2400 1750 2400 1450
Wire Wire Line
	2400 1450 1800 1450
Wire Wire Line
	2300 1850 2300 900 
Wire Wire Line
	2300 900  900  900 
Wire Wire Line
	900  900  900  1550
Wire Wire Line
	900  1550 1300 1550
Wire Wire Line
	2150 1950 2150 1900
Wire Wire Line
	2150 1700 2150 1550
Wire Wire Line
	2150 1550 1800 1550
Wire Wire Line
	6350 1400 6700 1400
Wire Wire Line
	6300 4900 6650 4900
Wire Wire Line
	7600 900  10100 900 
Connection ~ 9700 900 
Connection ~ 9900 1200
Wire Wire Line
	7600 1400 9400 1400
Connection ~ 9000 1400
Connection ~ 9200 1700
Wire Wire Line
	7600 1900 8700 1900
Connection ~ 8300 1900
Connection ~ 8500 2200
Wire Wire Line
	9600 1700 10550 1700
Wire Wire Line
	8900 2200 10450 2200
Wire Wire Line
	9900 1200 9900 1450
Wire Wire Line
	9900 1450 10750 1450
Wire Wire Line
	9200 1700 9200 1950
Wire Wire Line
	9200 1950 10750 1950
Wire Wire Line
	8500 2200 8500 2450
Wire Wire Line
	8500 2450 10750 2450
Wire Wire Line
	7600 2650 10100 2650
Connection ~ 9700 2650
Connection ~ 9900 2950
Wire Wire Line
	7600 3150 9400 3150
Connection ~ 9000 3150
Connection ~ 9200 3450
Wire Wire Line
	7600 3650 8700 3650
Connection ~ 8300 3650
Connection ~ 8500 3950
Wire Wire Line
	10550 3450 9600 3450
Wire Wire Line
	10450 3950 8900 3950
Wire Wire Line
	9900 2950 9900 3200
Wire Wire Line
	9900 3200 10750 3200
Wire Wire Line
	9200 3450 9200 3700
Wire Wire Line
	9200 3700 10750 3700
Wire Wire Line
	8500 3950 8500 4200
Wire Wire Line
	8500 4200 10750 4200
Wire Wire Line
	7550 4400 10100 4400
Connection ~ 9700 4400
Connection ~ 9900 4700
Wire Wire Line
	7550 4900 9400 4900
Connection ~ 9000 4900
Connection ~ 9200 5200
Wire Wire Line
	7550 5400 8700 5400
Connection ~ 8300 5400
Connection ~ 8500 5700
Wire Wire Line
	9600 5200 10300 5200
Wire Wire Line
	10300 5700 8900 5700
Wire Wire Line
	9900 4700 9900 4950
Wire Wire Line
	9900 4950 10750 4950
Wire Wire Line
	9200 5200 9200 5450
Wire Wire Line
	9200 5450 10750 5450
Wire Wire Line
	8500 5700 8500 5950
Wire Wire Line
	8500 5950 10750 5950
Wire Wire Line
	10300 1200 10650 1200
Wire Wire Line
	10650 1200 10650 2950
Wire Wire Line
	10650 2950 10300 2950
Wire Wire Line
	10550 1700 10550 3450
Wire Wire Line
	10450 2200 10450 3950
Wire Wire Line
	10750 1700 10650 1700
Connection ~ 10650 1700
Wire Wire Line
	10750 2200 10550 2200
Connection ~ 10550 2200
Wire Wire Line
	10750 2650 10450 2650
Connection ~ 10450 2650
Wire Wire Line
	10300 4700 10300 5700
Connection ~ 10300 5200
Wire Wire Line
	10300 4700 10750 4700
Connection ~ 10300 4700
Wire Wire Line
	2600 1550 4100 1550
Text GLabel 3000 700  3    60   Input ~ 0
VCC
$Comp
L VCC #PWR027
U 1 1 5A53770E
P 3000 700
F 0 "#PWR027" H 3000 550 50  0001 C CNN
F 1 "VCC" H 3000 850 50  0000 C CNN
F 2 "" H 3000 700 50  0001 C CNN
F 3 "" H 3000 700 50  0001 C CNN
	1    3000 700 
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR028
U 1 1 5A537876
P 3700 700
F 0 "#PWR028" H 3700 550 50  0001 C CNN
F 1 "VCC" H 3700 850 50  0000 C CNN
F 2 "" H 3700 700 50  0001 C CNN
F 3 "" H 3700 700 50  0001 C CNN
	1    3700 700 
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR029
U 1 1 5A68D6AA
P 3700 5700
F 0 "#PWR029" H 3700 5700 30  0001 C CNN
F 1 "GND" H 3700 5630 30  0001 C CNN
F 2 "" H 3700 5700 60  0001 C CNN
F 3 "" H 3700 5700 60  0001 C CNN
	1    3700 5700
	0    1    -1   0   
$EndComp
$Comp
L GND #PWR030
U 1 1 5A68D80B
P 3700 6100
F 0 "#PWR030" H 3700 6100 30  0001 C CNN
F 1 "GND" H 3700 6030 30  0001 C CNN
F 2 "" H 3700 6100 60  0001 C CNN
F 3 "" H 3700 6100 60  0001 C CNN
	1    3700 6100
	0    1    -1   0   
$EndComp
$EndSCHEMATC
