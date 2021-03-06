{{
***********************************************

  Simple Radio Control Capture & Repeat to Servo
                                                                    
  Author: Travis, 10-Jan-09
        
***********************************************

This demo connects a PropStick USB to a radio receiver and a servo.  It receives the incoming signal from
the radio receiver and re-transmits it to the servo.  It outputs the incoming servo position setting and the
position being transmitted to the servo to the Parallax Serial Terminal (via FullDuplexSerial).
It also flashes the LEDs to indicate the program is running.

Note: The output to the servo is a bit jerky. I tried several other Servo control objects from OBEX, but
      I couldn't figure out the timing relationship between PULSIN and and any other Servo control objects.
      If you can figure out how to get rid of the jerkiness, please post it in the forum or comments.  Thanks!

Objects used:

  Debug  : "FullDuplexSerial"           'standard from propeller library  
  SERVO  : "Servo32v3"                  'standard from propeller library
    
Components needed:
  Breadboard w/ connector wire set
  5-9V power supply for PropStick USB (9v battery or 4 AA batteries)
  7.4v power supply for Servo and Radio Receiver
  PropStick USB - http://www.parallax.com/Store/Microcontrollers/BASICStampModules/tabid/134/txtSearch/PropStick/List/1/ProductID/411/Default.aspx?SortField=ProductName%2cProductName
  Radio Transmitter & Receiver
  Servo
  Fubuta 3-wire connectors (several)
  3 LEDs
  1 - 270 Ohm resistor
  1 - 4.7k Ohm resistor

Software/Downloads needed:

  Propeller Tool Software (used to program the Prop):
    http://www.parallax.com/Portals/0/Downloads/sw/propeller/Setup-Propeller-Tool-v1.2.5.exe

  FTDI USB VCP Drivers (for WinXP):
    http://www.parallax.com/Portals/0/Downloads/sw/R9052151.zip

  Parallax Serial Terminal:
    http://www.parallax.com/Portals/0/Downloads/sw/propeller/PST.exe.zip

Relevant Documentation:

  PE-Lab-Setup-for-PropStick USB v1.0.pdf (Simple LED Code)
    http://www.parallax.com/Portals/0/Downloads/docs/prod/prop/PE-Lab-Setup-PropStick-USB-v1.0.zip

  32210-PropStickUSB-v1.1.pdf (Schematic of PropStick USB)
    http://www.parallax.com/Portals/0/Downloads/docs/prod/prop/32210-PropStickUSB-v1.1.pdf

  WebPM-v1.01.pdf (Detailed SPIN language documentation 
    http://www.parallax.com/Portals/0/Downloads/docs/prod/prop/WebPM-v1.01.pdf
    
Basic Build Instructions:

   1. Configure the components based on the PIN diagrams below.  Use a breadboard for testing purposes.
   2. Download and install the required software (listed above).
   3. Open the Propeller Tool Software.
   4. From within the Propeller Tool Software, open this file (Simple RX Capture & Repeat.spin).
   5. Connect the PropStick USB to the computer.
   6. Power on the PropStick USB with 5-9v.
   7. Power on the Radio Transmitter, Receiver and Servo.
   8. From within the Propeller Tool Software, hit F7 to confirm communication with PropStick USB.
   9. From within the Propeller Tool Softwere, hit F10 to compile and load program into the PropStick USB.
      Make sure this file (Simple RX Capture & Repeat.spin) has the focus when you hit F10,
      otherwise the file with current focus is loaded onto the PropStick.
  10. Open the Parallax Serial Terminal.
  11. From within the Parallax Serial Terminal, make sure the COM Port is set to the COM port indicated when
      you hit F7 from the Propeller Tool Softwere and the Baud Rate is 19200 (unless you changed it in this
      file below).
  12. From within the Parallax Serial Terminal, click 'Enable' (which should be flashing anytime the PropStick
      USB is connected).
  13. Confirm the screen is output the readings from the sensors.
  14. Move the Radio Transmitter to change the position of the servo.  The screen should display the current
      position of the servo. 

Pin Diagram for PropStick USB

                                        ┌──────────┐
   Radio Receiver Signal ── RX-IN ──│P0        │
      (white/orange)                    │          │
                                        │          │
 Servo Signal ── 4.7k ── RX-OUT ──│P1        │
(white/orange)   Resistor               │          │
                                        │          │
                             Ground ──│VSS    VDD│── 270 ── LED ── Ground  (this is the power indicator LED)
                                        │          │   Resistor
                              +5-9V ──│VIN       │
                                        │          │
              Ground ────┐─── LED ──│P15    P16│── LED ── Ground
                          │             │          │
                          │             │   USB    │
                          │             │   Plug   │
                          │             └──────────┘
                          │
                          │
                          └─ Ground of Servo Power Supply (very important, otherwise it won't work)

}}

CON

  _CLKMODE = XTAL1 + PLL16X
  _XINFREQ = 5_000_000

  'Pin on Prop Chip for LED Indicator
  PIN_LED = 15

  'Pins on Prop Chip for Servo Input/Output
  PIN_SERVO_IN = 0
  PIN_SERVO_OUT = 1

OBJ
  Debug  : "FullDuplexSerial"           'standard from propeller library
  SERVO  : "Servo32v3"                  'standard from propeller library
  
PUB Begin | x,y,z

  'start debugger
  debug.start(31,30,0,19200)
      
  'set pin direction for LED to output
  dira[PIN_LED]~~

  'flash the LED to confirm the program is running
  repeat 10
    !outa[PIN_LED]
    waitcnt(clkfreq / 2 + cnt) '0.5 seconds

  debug.str(string(16))
  debug.Str(string("Starting Simple RX Capture...", 13))

  'Start Servo handler
  SERVO.Set(PIN_SERVO_OUT,1422)
  SERVO.Start 
    
  repeat
    y := PULSIN(PIN_SERVO_IN,1)
    debug.str(string("BS2.PULSIN="))
    debug.Dec(y)
    debug.str(string(13))

    SERVO.Set(PIN_SERVO_OUT,(y * 2))
    debug.str(string("SERVO.Set(1,"))
    debug.Dec((y * 2))
    debug.str(string(")"))
    debug.str(string(13))

    debug.str(string(5,5))
    
    waitcnt(clkfreq / 4 + cnt) '0.25 seconds


PUB PULSIN (Pin, State) : Duration | us
{{ From BS2 Functions Library Object

   Reads duration of Pulse on pin defined for state, returns duration in 2uS resolution
   Shortest measureable pulse is around 20uS
   Note: Absence of pulse can cause cog lockup if watchdog is not used - See distributed example
    x := BS2.Pulsin(5,1)
    BS2.Debug_Dec(x)
}}
   us :=   clkfreq / 1_000_000                  ' Clock cycles for 1 us
    
   Duration := PULSIN_Clk(Pin, State) / us / 2 + 1         ' Use PulsinClk and calc for 2uS increments \

PUB PULSIN_Clk(Pin, State) : Duration 
{{ From BS2 Functions Library Object; modified waitpne and waitpeq functions to use |< Pin

   Reads duration of Pulse on pin defined for state, returns duration in 1/clkFreq increments - 12.5nS at 80MHz
   Note: Absence of pulse can cause cog lockup if watchdog is not used - See distributed example
    x := BS2.Pulsin_Clk(5,1)
    BS2.Debug_Dec(x)
}}

  DIRA[pin]~
  ctra := 0
  if state == 1
    ctra := (%11010 << 26 ) | (%001 << 23) | (0 << 9) | (PIN) ' set up counter, A level count
  else
    ctra := (%10101 << 26 ) | (%001 << 23) | (0 << 9) | (PIN) ' set up counter, !A level count
  frqa := 1
  waitpne(|< Pin, |< Pin, 0)                         ' Wait for opposite state ready
  phsa:=0                                                  ' Clear count
  waitpeq(|< Pin, |< Pin, 0)                         ' wait for pulse
  waitpne(|< Pin, |< Pin, 0)                         ' Wait for pulse to end
  Duration := phsa                                         ' Return duration as counts
  ctra :=0                                                 ' stop counter