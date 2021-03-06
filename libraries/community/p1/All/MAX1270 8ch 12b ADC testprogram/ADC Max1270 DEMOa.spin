{{      
***************************************************
* Propeller Max1270 8ch 12b ADC test program v1.0 *
* Author: Henk Kiela                              *
* Copyright (c) 2009 Opteq                        *
* See end of file for terms of use.               *
***************************************************
}}

CON
    _clkmode = xtal1 + pll16x                           
    _xinfreq = 5_000_000

OBJ
    Ser     :       "FullDuplexSerial"                      ''Used in this DEMO for Debug
    t       :       "Timing"                                ''Delay object
    ADC   :         "Max1270"                               '' Max 1270 8 ch adc

Con
{{
--------------------------------------------------------------------------------------------------------
     The MAX1270 is uses fast ADC via the SPI's asm assembly SHIFTIN and SHIFTOUT functions.
--------------------------------------------------------------------------------------------------------

Schematic MAX1270:
                    Vdd
                     
                ┌────┴────┐
     P11 --─--─┤6   1  13├──Ch0
                │         │
     P10 ──────┤5       x├──Chx
                │         │
     P8 ───────┤7      20├──Ch7
                │         │
     P9 ───────┤10  24   ├
                └────┬────┘
                     
                    Vss
}}


'' Serial port 
   CR = 13
   LF = 10
   TXD = 31
   RXD = 30
   Baud = 115200

   DebugLed1 = 27               '' Debug led

   nCh = 5   'Number of ADC channels to scan

Var
  Long Volt[nCh]  'Voltage readings 
  
PUB Max1270Demo| i, lCr, CogNr  '' Demo for Max 1270 8ch ADC, with display on serial terminal

'' -----[ Initialization ]--------------------------------------------------
  dira[DebugLed1]~~
  !outa[DebugLed1]                         'Toggle I/O Pin for debug

''Serial communication Setup
    Ser.start(TXD, RXD, 0, 115200)  '' Initialize serial communication to the PC through the USB connector
                                 '' To view Serial data on the PC use the Parallax Serial Terminal (PST) program.
'pub start(control,average,ADC_addr)

    ADC.start(2,@Volt,nCh)
     
    Ser.str(string("Max1270 init  Cognr "))
    Ser.dec(CogNr)
    Ser.Tx(CR)
    Ser.Tx(CR)
    i:=0
                                                                             
' -----[ Main loop ]-----Send measured values to serial port for (graphical) display------------------------------------
      repeat
        Ser.Tx("$")
        Ser.Hex(i++,4)
        Ser.Tx(",")

        Ser.hex(Volt[0],3)
        Ser.Tx(",")
        Ser.hex(Volt[1],3)
        Ser.Tx(",")
        Ser.hex(Volt[2],3)
        Ser.Tx(",")
        Ser.hex(Volt[3],3)
        Ser.Tx(",")
        Ser.hex(Volt[4],3)
        Ser.Tx("|")
'        Ser.Tx(" ")
'        Ser.Bin(Volt,16)
        Ser.Tx(CR)

        !outa[DebugLed1]                         'Toggle I/O Pin for debug
        t.Pause1ms(15)
        
    
{{
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                   TERMS OF USE: MIT License                                                  │                                                            
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation    │ 
│files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,    │
│modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software│
│is furnished to do so, subject to the following conditions:                                                                   │
│                                                                                                                              │
│The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.│
│                                                                                                                              │
│THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE          │
│WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR         │
│COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,   │
│ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                         │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
}}    