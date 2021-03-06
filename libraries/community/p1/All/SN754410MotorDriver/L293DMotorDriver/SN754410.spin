   {{ SN754410.spin
Controls direction and speed of a motor using the SN754410 (or L293D) H-Bridge chip
Chips
 
Chip Pin 1 -> Propeller Pin 3
Chip Pin 2 -> Propeller Pin 4
Chip Pin 3 -> Motor
Chip Pin 4 -> Ground
Chip Pin 5 -> Ground
Chip Pin 6 -> Motor
Chip Pin 7 -> Propeller Pin 5
Chip Pin 8 -> V+ of Battery for Motor
Chip Pin 16 -> 5V pin from propeller board

Enable   Dir1 Dir2
   0      any  any   coast
   1       0    0    break
   1       1    1    break
   1       0    1    forward
   1       1    0    reverse


Methods:

setp : sets the speed to integer value between 0 and 100
setd : sets direction to forward (1) or reverse (0)
getp: gets value of speed
getd: gets value of direction
start: starts the controller  in a different cog


Copyright (c) Javier R. Movellan, 2008
Distribution and use: MIT License (see below)

Revision History:
        Version 1.03   - March 12 2008 added MIT terms of use  
        Version 1.02  - March 12 2008 changed to -100 100 velocity standard
        Version 1.0   - March 11 2008   original file created


}}
VAR long stack[20]
    long p  ' controls speed from 0 to 100
    long pin
CON
  _CLKMODE = XTAL1 + PLL16X
  _XINFREQ = 5_000_000
 
  EnablePin = 3
  Dir1Pin = 4
  Dir2Pin = 5
OBJ
  rnd : "Random"
PUB demo 
 
  CogNew(run, @stack)
  p := 100 
  repeat  while p > -100
    setp(getp -10)
    waitcnt(clkfreq+cnt)

PUB start ' runs infinite loop in new cog
  p :=0
  CogNew(run, @stack)
  

PUB run  ' we use random sampling to control the percentage of "on" duty
         ' the advantage is that it gives us very fine temporal control over the
         ' sampling probabilities     
  dira[EnablePin] := 1  ' Direction register set to high. This makes the pin an output
  dira[Dir1Pin] := 1
  dira[Dir2Pin] := 1
  outa[EnablePin] :=1     
  repeat
    if p <0
      pin := Dir2Pin
      outa[Dir1Pin] :=0
    else
      pin := Dir1Pin
      outa[Dir2Pin] :=0       
    if rnd.nextBinary(||p) ' p is a number between 0 and 100 controls proportion of time on
     outa[pin] := 1
    else
      outa[pin] :=  0
      
    waitcnt(clkfreq/30000+cnt)

PUB setp(_p)
  if _p > 100
    p :=100
  if _p< -100
    p := -100
  p := _p
PUB getp | y
  return p

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