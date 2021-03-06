{{
┌──────────────────────────────────────────┐
│ TLC1543ADC.spin v0.0                     │
│ Author: Mark M. Owen                     │               
│ Copyright (c) 2013 Mark M. Owen          │               
│ See end of file for terms of use.        │                
└──────────────────────────────────────────┘

General description

The TLC1543 is a CMOS A/D converter built around a 10-bit
switched-capacitor successive approximation A/D converter.

The device uses a serial interface to a microprocessor or
peripheral providing a 3-state output with three control
inputs (I/O CLOCK, chip select [CS], and ADDRESS INPUT).

In addition to the high-speed converter and control logic,there
is an on-chip, 14-channel analog multiplexer (used to sample any
one of the 11 inputs or one of three self-test voltages) and a
sample-and hold function that operates automatically.

This software provides a method for sampling a single channel via
two invocations of the Fetch method or up to 14 channels in a series
of invocations of the Fetch method.  For a single channel access,
two invocations are required as the TLC1543 always returns the value
of the previous conversion while accepting the multiplexer channel
address for the next conversion.

When run in a separate cog via the Start method, the ADC is continuously
sampled across a specified range of channels with the results saved in
an internal buffer, accessible by calling the Get method with the
desired channel as its parameter.

Multiplexer channel addresses are zero (0) through thirteen (13) with
the last three being the internal self test outputs for the chip.


Hardware interfacing

Since the TLC1543 uses a 5 volt supply a voltage conversion is
required.

A pair of diodes and a resistor may be used to convert between the
5 volt and 3.3 volt signal levels for the prop output pins:  

        5.0v reg supply
                │
                 10k
                │┌─3.3v reg supply
                ┣┫
                │└─3.3v logic (prop output)
                │
        5.0v logic (ADC input)
         
The prop input pin voltage difference may be dealt with using a simple
resistive voltage divider or potentiometer.                 

        5.0v logic (ADC output)
                │
               ┌┻┐
            2k   1k
                └─ 3.3v logic (prop input)
           
One clock pin is required, along with a chip select, address and
data pins.


Timing chart (approximate, see datasheet)


EOCpin ...

CSpin  ...                    

IOCpin ...

DATpin ─────────────────...

ADRpin ───────────────────────────────────────────────...


EOC is ignored.


Object Details

}}

CON
  _clkmode = xtal1 + pll16x                  ' System clock → 80 MHz
  _xinfreq = 5_000_000                       ' external crystal 5MHz

  POST_CS_LOW_DELAY             =  150_000 ' 6.6µS 
  POST_ADR_DELAY                =   50_000 ' 20µS
  IOC_HIGH_TIME                 =   25_000 ' 40µS
  LAST_IOC_TO_CS_DELAY          =  100_000 ' 10µS

VAR
  long  stack[143]              ' Cog stack space 
  byte  cog                     ' Cog ID                            
  word  output[ADCH#NCHANNELS+ADCH#NTESTCHANNELS]' channel samples [0..10] & self tests [11..13]

  long pcsld
  long padrd
  long iocht
  long lioctcsd


OBJ
  ADCH          : "TLC1543ADC_H"


PUB Start(IOCpin, CSpin, ADRpin, DATpin, alpha, omega)
{{
    starts ADCdriver running continuously in a new cog   
    continuously samples a specified range of adc channels
    specified by the alpha and omega parameters

    use Get(channel) or GetChannels(array) to obtain results
    
    parameters:
      IOCpin                    output IO clock
      CSpin                     output chip select
      ADRpin                    output multiplexer channel address (MSB first)
      DATpin                    input data conversion result (MSB first)
      freq                      CTRA FRQA value for SCpin timing
      alpha                     first multiplexer channel to sample
      omega                     last multiplexer channel to sample

}}
  Stop
  result := (cog := cognew(ADCdriver(IOCpin, CSpin, ADRpin, DATpin, alpha, omega), @stack) + 1)

PUB Stop
{{
    stops this cog if started with cog new

}}
  if cog
    cogstop(cog~ - 1)

PUB Get(channel)
{{
    returns most recent ADC conversion sample for the specified channel.

    parameters:
      channel                   MUX channel whose data is to be returned in result

}}
  result := output[channel]

PUB GetChannels(awaData)
{{
    returns most recent ADC conversion samples for all data channels.

    parameters:
      awaData                   address of 11 word array to receive the data

}}
  wordmove(awaData, @output, ADCH#NCHANNELS)

                   
PUB Init(IOCpin, CSpin, ADRpin, DATpin)
{{
    configure IO pins for use

    parameters:
      IOCpin                    output IO clock
      CSpin                     output chip select
      ADRpin                    output multiplexer channel address (MSB first)
      DATpin                    input data conversion result (MSB first)

}}
  ' establish delay times
  pcsld    := clkfreq/POST_CS_LOW_DELAY
  padrd    := clkfreq/POST_ADR_DELAY
  iocht    := clkfreq/IOC_HIGH_TIME
  lioctcsd := clkfreq/LAST_IOC_TO_CS_DELAY
  ' configure IO pins for use
  dira[IOCpin]~~                ' output
  dira[CSpin]~~                 ' output
  dira[ADRpin]~~                ' output
  dira[DATpin]~                 ' input
  outa[CSpin]~~                 ' CS high (ADC idle)

PUB FetchRange(IOCpin, CSpin, ADRpin, DATpin, alpha, omega, awaData) | i
{{
    stores the results of a range of conversion samples for ADC channels
    alpha to omega into the array at address agData.  agData must be word[12]
    and the samples are stored there using the channel number as the array
    index.  

    parameters:
      IOCpin                    output IO clock
      CSpin                     output chip select
      ADRpin                    output multiplexer channel address (MSB first)
      DATpin                    input data conversion result (MSB first)
      alpha                     first multiplexer channel to sample
      omega                     last multiplexer channel to sample
      awaData                   address of array of 12 longs for sample storage

}}
  omega++
  Fetch(IOCpin, CSpin, ADRpin, DATpin, alpha) {ignore this result}
  repeat while alpha < omega
    i := alpha + 1 
    word[awaData][alpha] := Fetch(IOCpin, CSpin, ADRpin, DATpin, i)
    alpha++    

PUB Fetch(IOCpin, CSpin, ADRpin, DATpin, nxt) | t
{{
    starts a conversion for channel nxt
    returns the result of the previous conversion
    
    parameters:
      IOCpin                    output IO clock
      CSpin                     output chip select
      ADRpin                    output multiplexer channel address (MSB first)
      DATpin                    input data conversion result (MSB first)
      nxt                       next multiplexer channel to sample

    return result:              10 bit value of previous conversion

}}

  outa[CSpin]~       ' low CS start address and data transfer
  waitcnt( pcsld + cnt)
  result := 0
  t := cnt
  repeat 10
    result := (result<<1)|ina[DATpin]  ' shift in the next data bit
    nxt := nxt << 1 ' shift next MUX address bit into bit 5 (MSB first)
    outa[ADRpin] := nxt>>4 ' shift out only the bit 5 value
    waitcnt(padrd + cnt) 
    outa[IOCpin]~~ ' high
    waitcnt(iocht + cnt) 
    outa[IOCpin]~   ' low
  t := cnt - t
  waitcnt(lioctcsd + cnt) 
  outa[CSpin]~~      ' high CS stop address and data transfer
  waitcnt(t+cnt)

PRI ADCdriver(IOCpin, CSpin, ADRpin, DATpin, alpha, omega)  ' internal driver for cog use
  Init(IOCpin, CSpin, ADRpin, DATpin)
  repeat ' until cog is stopped
    FetchRange(IOCpin, CSpin, ADRpin, DATpin, alpha, omega, @output)

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
        