{{
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│               Doug Dingus         Text Generator Cog 8x8 Character Font Raster                                               │                                                            
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│                                    TERMS OF USE: Parallax Object Exchange License                                            │                                                            
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

'done:  Code speedups?
'done:  Add run time parameters and logic during VBLANK to permit chars / line / and two color per screen mode
'TODO:  Implement upper and lower border color selection.


PUB start(params) | i, j, k

'Fire off the Text COG, with a pointer to it's HUB lineRAM buffer, and start up values.
  
  cognew(@cogstart,params)

DAT

                        ORG     0
'-------------------------------------------------------------
'Quick conversion of 2 color font to 4 color  Reverses pixels at the same time
'-------------------------------------------------------------
'Pixel table located at cog $0 to speed up pointer conversion
'Therefore, first cogstart jmp replaced after execution
'-------------------------------------------------------------

cogstart
pixel_table             jmp     #cogstart1          'long    %00_00_00_00_00_00_00_00            '%0000
                        long    %0100000000000000        '%0001
                        long    %0001000000000000        '%0010
                        long    %0101000000000000        '%0011
                        long    %0000010000000000        '%0100
                        long    %0100010000000000        '%0101
                        long    %0001010000000000        '%0110
                        long    %0101010000000000        '%0111
                        long    %0000000100000000        '%1000
                        long    %0100000100000000        '%1001
                        long    %0001000100000000        '%1010
                        long    %0101000100000000        '%1011
                        long    %0000010100000000        '%1100
                        long    %0100010100000000        '%1101
                        long    %0001010100000000        '%1110
                        long    %0101010100000000        '%1111
                                
                        long    %0000000001000000        '%0000
                        long    %0100000001000000        '%0001
                        long    %0001000001000000        '%0010
                        long    %0101000001000000        '%0011
                        long    %0000010001000000        '%0100
                        long    %0100010001000000        '%0101
                        long    %0001010001000000        '%0110
                        long    %0101010001000000        '%0111
                        long    %0000000101000000        '%1000
                        long    %0100000101000000        '%1001
                        long    %0001000101000000        '%1010
                        long    %0101000101000000        '%1011
                        long    %0000010101000000        '%1100
                        long    %0100010101000000        '%1101
                        long    %0001010101000000        '%1110
                        long    %0101010101000000        '%1111
                                
                        long    %0000000000010000        '%0000
                        long    %0100000000010000        '%0001
                        long    %0001000000010000        '%0010
                        long    %0101000000010000        '%0011
                        long    %0000010000010000        '%0100
                        long    %0100010000010000        '%0101
                        long    %0001010000010000        '%0110
                        long    %0101010000010000        '%0111
                        long    %0000000100010000        '%1000
                        long    %0100000100010000        '%1001
                        long    %0001000100010000        '%1010
                        long    %0101000100010000        '%1011
                        long    %0000010100010000        '%1100
                        long    %0100010100010000        '%1101
                        long    %0001010100010000        '%1110
                        long    %0101010100010000        '%1111
                                
                        long    %0000000001010000        '%0000
                        long    %0100000001010000        '%0001
                        long    %0001000001010000        '%0010
                        long    %0101000001010000        '%0011
                        long    %0000010001010000        '%0100
                        long    %0100010001010000        '%0101
                        long    %0001010001010000        '%0110
                        long    %0101010001010000        '%0111
                        long    %0000000101010000        '%1000
                        long    %0100000101010000        '%1001
                        long    %0001000101010000        '%1010
                        long    %0101000101010000        '%1011
                        long    %0000010101010000        '%1100
                        long    %0100010101010000        '%1101
                        long    %0001010101010000        '%1110
                        long    %0101010101010000        '%1111
                                
                        long    %0000000000000100        '%0000
                        long    %0100000000000100        '%0001
                        long    %0001000000000100        '%0010
                        long    %0101000000000100        '%0011
                        long    %0000010000000100        '%0100
                        long    %0100010000000100        '%0101
                        long    %0001010000000100        '%0110
                        long    %0101010000000100        '%0111
                        long    %0000000100000100        '%1000
                        long    %0100000100000100        '%1001
                        long    %0001000100000100        '%1010
                        long    %0101000100000100        '%1011
                        long    %0000010100000100        '%1100
                        long    %0100010100000100        '%1101
                        long    %0001010100000100        '%1110
                        long    %0101010100000100        '%1111
                                
                        long    %0000000001000100        '%0000
                        long    %0100000001000100        '%0001
                        long    %0001000001000100        '%0010
                        long    %0101000001000100        '%0011
                        long    %0000010001000100        '%0100
                        long    %0100010001000100        '%0101
                        long    %0001010001000100        '%0110
                        long    %0101010001000100        '%0111
                        long    %0000000101000100        '%1000
                        long    %0100000101000100        '%1001
                        long    %0001000101000100        '%1010
                        long    %0101000101000100        '%1011
                        long    %0000010101000100        '%1100
                        long    %0100010101000100        '%1101
                        long    %0001010101000100        '%1110
                        long    %0101010101000100        '%1111
                                
                        long    %0000000000010100        '%0000
                        long    %0100000000010100        '%0001
                        long    %0001000000010100        '%0010
                        long    %0101000000010100        '%0011
                        long    %0000010000010100        '%0100
                        long    %0100010000010100        '%0101
                        long    %0001010000010100        '%0110
                        long    %0101010000010100        '%0111
                        long    %0000000100010100        '%1000
                        long    %0100000100010100        '%1001
                        long    %0001000100010100        '%1010
                        long    %0101000100010100        '%1011
                        long    %0000010100010100        '%1100
                        long    %0100010100010100        '%1101
                        long    %0001010100010100        '%1110
                        long    %0101010100010100        '%1111
                                
                        long    %0000000001010100        '%0000
                        long    %0100000001010100        '%0001
                        long    %0001000001010100        '%0010
                        long    %0101000001010100        '%0011
                        long    %0000010001010100        '%0100
                        long    %0100010001010100        '%0101
                        long    %0001010001010100        '%0110
                        long    %0101010001010100        '%0111
                        long    %0000000101010100        '%1000
                        long    %0100000101010100        '%1001
                        long    %0001000101010100        '%1010
                        long    %0101000101010100        '%1011
                        long    %0000010101010100        '%1100
                        long    %0100010101010100        '%1101
                        long    %0001010101010100        '%1110
                        long    %0101010101010100        '%1111
                                
                        long    %0000000000000001        '%0000
                        long    %0100000000000001        '%0001
                        long    %0001000000000001        '%0010
                        long    %0101000000000001        '%0011
                        long    %0000010000000001        '%0100
                        long    %0100010000000001        '%0101
                        long    %0001010000000001        '%0110
                        long    %0101010000000001        '%0111
                        long    %0000000100000001        '%1000
                        long    %0100000100000001        '%1001
                        long    %0001000100000001        '%1010
                        long    %0101000100000001        '%1011
                        long    %0000010100000001        '%1100
                        long    %0100010100000001        '%1101
                        long    %0001010100000001        '%1110
                        long    %0101010100000001        '%1111
                                
                        long    %0000000001000001        '%0000
                        long    %0100000001000001        '%0001
                        long    %0001000001000001        '%0010
                        long    %0101000001000001        '%0011
                        long    %0000010001000001        '%0100
                        long    %0100010001000001        '%0101
                        long    %0001010001000001        '%0110
                        long    %0101010001000001        '%0111
                        long    %0000000101000001        '%1000
                        long    %0100000101000001        '%1001
                        long    %0001000101000001        '%1010
                        long    %0101000101000001        '%1011
                        long    %0000010101000001        '%1100
                        long    %0100010101000001        '%1101
                        long    %0001010101000001        '%1110
                        long    %0101010101000001        '%1111
                                
                        long    %0000000000010001        '%0000
                        long    %0100000000010001        '%0001
                        long    %0001000000010001        '%0010
                        long    %0101000000010001        '%0011
                        long    %0000010000010001        '%0100
                        long    %0100010000010001        '%0101
                        long    %0001010000010001        '%0110
                        long    %0101010000010001        '%0111
                        long    %0000000100010001        '%1000
                        long    %0100000100010001        '%1001
                        long    %0001000100010001        '%1010
                        long    %0101000100010001        '%1011
                        long    %0000010100010001        '%1100
                        long    %0100010100010001        '%1101
                        long    %0001010100010001        '%1110
                        long    %0101010100010001        '%1111
                                
                        long    %0000000001010001        '%0000
                        long    %0100000001010001        '%0001
                        long    %0001000001010001        '%0010
                        long    %0101000001010001        '%0011
                        long    %0000010001010001        '%0100
                        long    %0100010001010001        '%0101
                        long    %0001010001010001        '%0110
                        long    %0101010001010001        '%0111
                        long    %0000000101010001        '%1000
                        long    %0100000101010001        '%1001
                        long    %0001000101010001        '%1010
                        long    %0101000101010001        '%1011
                        long    %0000010101010001        '%1100
                        long    %0100010101010001        '%1101
                        long    %0001010101010001        '%1110
                        long    %0101010101010001        '%1111
                                
                        long    %0000000000000101        '%0000
                        long    %0100000000000101        '%0001
                        long    %0001000000000101        '%0010
                        long    %0101000000000101        '%0011
                        long    %0000010000000101        '%0100
                        long    %0100010000000101        '%0101
                        long    %0001010000000101        '%0110
                        long    %0101010000000101        '%0111
                        long    %0000000100000101        '%1000
                        long    %0100000100000101        '%1001
                        long    %0001000100000101        '%1010
                        long    %0101000100000101        '%1011
                        long    %0000010100000101        '%1100
                        long    %0100010100000101        '%1101
                        long    %0001010100000101        '%1110
                        long    %0101010100000101        '%1111
                                
                        long    %0000000001000101        '%0000
                        long    %0100000001000101        '%0001
                        long    %0001000001000101        '%0010
                        long    %0101000001000101        '%0011
                        long    %0000010001000101        '%0100
                        long    %0100010001000101        '%0101
                        long    %0001010001000101        '%0110
                        long    %0101010001000101        '%0111
                        long    %0000000101000101        '%1000
                        long    %0100000101000101        '%1001
                        long    %0001000101000101        '%1010
                        long    %0101000101000101        '%1011
                        long    %0000010101000101        '%1100
                        long    %0100010101000101        '%1101
                        long    %0001010101000101        '%1110
                        long    %0101010101000101        '%1111
                                
                        long    %0000000000010101        '%0000
                        long    %0100000000010101        '%0001
                        long    %0001000000010101        '%0010
                        long    %0101000000010101        '%0011
                        long    %0000010000010101        '%0100
                        long    %0100010000010101        '%0101
                        long    %0001010000010101        '%0110
                        long    %0101010000010101        '%0111
                        long    %0000000100010101        '%1000
                        long    %0100000100010101        '%1001
                        long    %0001000100010101        '%1010
                        long    %0101000100010101        '%1011
                        long    %0000010100010101        '%1100
                        long    %0100010100010101        '%1101
                        long    %0001010100010101        '%1110
                        long    %0101010100010101        '%1111
                                
                        long    %0000000001010101        '%0000
                        long    %0100000001010101        '%0001
                        long    %0001000001010101        '%0010
                        long    %0101000001010101        '%0011
                        long    %0000010001010101        '%0100
                        long    %0100010001010101        '%0101
                        long    %0001010001010101        '%0110
                        long    %0101010001010101        '%0111
                        long    %0000000101010101        '%1000
                        long    %0100000101010101        '%1001
                        long    %0001000101010101        '%1010
                        long    %0101000101010101        '%1011
                        long    %0000010101010101        '%1100
                        long    %0100010101010101        '%1101
                        long    %0001010101010101        '%1110
                        long    %0101010101010101        '%1111

Pixel_table_0000        long    %0000000000000000        '%0000
cogstart1               mov     pixel_table, pixel_table_0000


'-------------------------------------------------------------
'Fetch Parameters from parent SPIN program these are read only
'-------------------------------------------------------------
                        mov     index, PAR             ' get parameter block address
                        rdlong  numwtvd, index         ' read VALUE and store
                        mov     _numwtvd, index
                        add     index, #4                                    
                        rdlong  lnram, index


'-------------------------------------------------------------
'Double Buffering Color
'-------------------------------------------------------------
                        add     index, #4
                        rdlong  clram, index                 'Actual address of color ram
                        mov     clrama, clram
                        mov     clramp, index                'Pointer to address read by TV COG to find color buffer 

                        

'-------------------------------------------------------------
'These are address pointers for the text COG to communicate with the TV cog
'Write a 0 here, then wait for a signal back from TV cog.
'-------------------------------------------------------------
                        add     index, #4               'develop shared HUB memory address
                        mov     tv_vblank, index        'store in COG as pointer
                        add     index, #4
                        mov     tv_actv, index

'--------------------------------------------------------------
' More read only parameters
'--------------------------------------------------------------
                        add     index, #4               'Index to additional read params
                        rdlong  screen, index             'Screen buffer and such...
                        add     index, #4               'Index to additional read params
                        rdlong  colors, index            'Screen buffer and such...
                        add     index, #4
                        rdlong  fonttab, index          'Pointer to font table
                        add     index, #8
                        rdlong  two_colors, index       'Fetch two color value
                        mov     _two_colors, index      'Pointer to HUB two color mode

'-------------------------------------------------------------
'Begin Scan Line Graphics Processing
'-------------------------------------------------------------
mainloop                MOV     scanline_count, #241             'scanline_count number of scanlines
                        MOV     scanline, #0                     'current scanline 
                        
'-------------------------------------------------------------
'Sync Text COG with TV Cog -- Wait for Vblank, Frame 0
'-------------------------------------------------------------
                        wrlong  zero, tv_vblank          'Clear the vblank long
:loop                   rdlong  temp, tv_vblank          'Check to see if TV Cog indicates start of frame
                        cmp     temp, #1   wz            'Which frame is it?
                 if_z   jmp     #frame1                  'Frame 1?           
                        cmp     temp, #2   wz            'Frame 2?
                 if_z   jmp     #frame2
                        jmp     #:loop

'-------------------------------------------------------------
'Vblank code happens here
'-------------------------------------------------------------
frame1                  rdlong  numwtvd, _numwtvd                                'Fetch Number of chars change
                        rdlong  two_colors_temp, _two_colors                     'Get color mode changes
                        jmp     #active_init

frame2                  sub     scanline_count, #1                              'Frame 2  "Scan Doubling going on"                       
                        add     scanline, #1               
                               


'-------------------------------------------------------------
'Setup active video frame pointers
'-------------------------------------------------------------
active_init             mov     _screen, screen            'point to start of screen memory
                        mov     _colors, colors            'point to start of color memory 
                        mov     _linechar, numwtvd
                        mov     _colchar, numwtvd          'color bytes per line
                        shl     _colchar, #1                     
                        mov     active_scan, #0                  'active area scan counter



'-------------------------------------------------------------
'Sync Text COG with TV Cog -- Wait for start of active pixels
'-------------------------------------------------------------
activeloop              wrlong  zero, tv_actv           'Get ready to watch for active video to begin
:loop1                  rdlong  temp, tv_actv  wz       'Check to see if the pixels are happening yet


                        'wrlong  _colors, clramp

                        '[18 hub accesses possible here]



              if_z      jmp     #:loop1                 'Has the TV cog started drawing pixels yet?
                   

'-------------------------------------------------------------
'Scanline Processing Code begins here, all based off scanline_count
'Blank HUB scan line color and pixel ram to form borders
'-------------------------------------------------------------
                        cmp     scanline, #20     wz, wc                        'top border test
        if_z_OR_c       jmp     #blank_line                                     'if scanline <= 20, blank line
                        cmp     scanline_count, #20  wz, wc                     'bottom border test
        if_z_OR_c       jmp     #blank_line                                     'if scanline_count <=20, blank line

'-------------------------------------------------------------
'Build graphics for the active scanline....
'-------------------------------------------------------------
                        wrlong  _colors, clramp                                  'point TV COG at the color RAM
                        mov     _fontline, active_scan                           'Prepare to operate on active_scan
                        and     _fontline, #%111        wr
                        'wrlong  two_colors_temp, _two_colors                          'Set color value for active scan
                        mov     _fontsum, _fontline                              'calculate font table offset once per scanline
                        add     _fontsum, fonttab                                'font table offset keyed to active scanlines
                        add     active_scan, #1                                  'pre add counter for next scanline

                        mov     count, numwtvd                                   'do every character on scanline
                        mov     _lnram, lnram                                    'point to beginning of line buffer
                        mov     _clram, clram                                    'point to beginning of color buffer

'=============================================================
'The following code reads blocks of 4 characters at a time 
'Then the code has been further optimised to produce re-ordered
' instructions to get a further 20% speed improvement by catching
' the hub window. (Cluso99)
'=============================================================
{
'For clarity, this is the code before re-ordering (commented out)
:loop4                  rdlong  C4, _screen             'get 4 character from screen memory
'process 1st char
                        rol     C4, #3                  '1: top byte first
                        mov     C, C4                   '1: get it (already shifted <<3 i.e multiply x8)
                        and     C, x07F8                '1: remove other bits ($FF << 3)
                        add     C, _fontsum             '1: add font tab + scanline offset
                        rdbyte  D, C                    '1: get pixels from fonttab
                        movs    :p2a, D                 '1: modify P2 (need at least 1 instr before P2)
                        nop                             '1: 
:P2a                    mov     E, pixel_table          '1: source self modify
'process 2nd char
                        ror     C4, #8                  '2: next byte
                        mov     C1, C4                  '2: get it (already shifted <<3 i.e multiply x8)
                        and     C1, x07F8               '2: remove other bits
                        add     C1, _fontsum            '2: add font tab + scanline offset
                        rdbyte  D, C1                   '2: get pixels from fonttab
                        movs    :p2b, D                 '2: modify P2 (need at least 1 instr before P2) 
                        nop                             '2: 
:P2b                    mov     E2, pixel_table         '2: source self modify
                        shl     E2, #16                 '1/2: shift for combination
                        or      E, E2                   '1/2: combine 2 sets font pixels

                        wrlong  E, _lnram               '1/2: put 2 sets font pixels into line ram
                        add     _lnram, #4              '1/2: next lineram long 

'process 3rd char
                        ror     C4, #8                  '3: next byte
                        mov     C, C4                   '3: get it (already shifted <<3 i.e multiply x8)
                        and     C, x07F8                '3: remove other bits
                        add     C, _fontsum             '3: add font tab + scanline offset
                        rdbyte  D, C                    '3: get pixels from fonttab
                        movs    :p2c, D                 '3: modify P2 (need at least 1 instr before P2) 
                        nop                             '3: 
:P2c                    mov     E, pixel_table          '3: source self modify
'process 4th char
                        ror     C4, #8                  '4: last byte (use in C4) (already shifted <<3 i.e multiply x8)
                        and     C4, x07F8               '4: remove other bits
                        add     C4, _fontsum            '4: add font tab + scanline offset
                        rdbyte  D, C4                   '4: get pixels from fonttab
                        movs    :p2d, D                 '4: modify P2 (need at least 1 instr before P2) 
                        nop                             '4: 
:P2d                    mov     E2, pixel_table         '4: source self modify
                        shl     E2, #16                 '3/4: shift for combination
                        or      E, E2                   '3/4: combine 2 sets font pixels

                        wrlong  E, _lnram               '3/4: put 2 sets font pixels into line ram
                        add     _lnram, #4              '3/4: next lineram long

                        add     _screen, #4             '1-4: next block of 4 characters

                        sub     count, #4       wz      '1-4:
        if_nz           jmp     #:loop4                 'next group of 4 chars                        
}
'=============================================================
'This is the faster re-ordered code...
:loop4                  rdlong  C4, _screen             'get 4 character from screen memory
'process 1st char
                        rol     C4, #3                  '1: top byte first
                        mov     C, C4                   '1: get it (already shifted <<3 i.e multiply x8)
                        and     C, x07F8                '1: remove other bits ($FF << 3)
                        add     C, _fontsum             '1: add font tab + scanline offset
                        ror     C4, #8                   '2: next byte
                        mov     C1, C4                   '2: get it (already shifted <<3 i.e multiply x8)
                        rdbyte  D, C                    '1: get pixels from fonttab
                        movs    :p2a, D                 '1: modify P2 (need at least 1 instr before P2)
                        and     C1, x07F8                '2: remove other bits
:P2a                    mov     E, pixel_table          '1: source self modify

                        add     C1, _fontsum             '2: add font tab + scanline offset
                        ror     C4, #8                    '3: next byte
                        mov     C, C4                     '3: get it (already shifted <<3 i.e multiply x8)
                        rdbyte  D, C1                    '2: get pixels from fonttab
                        movs    :p2b, D                  '2: modify P2 (need at least 1 instr before P2) 
                        and     C, x07F8                  '3: remove other bits
:P2b                    mov     E2, pixel_table          '2: source self modify
                        shl     E2, #16                 '1/2: shift for combination
                        or      E, E2                   '1/2: combine 2 sets font pixels
                        ror     C4, #8                     '4: last byte (use in C4) (already shifted <<3 i.e multiply x8)

                        wrlong  E, _lnram               '1/2: put 2 sets font pixels into line ram
                        add     _lnram, #4              '1/2: next lineram long 

                        add     C, _fontsum               '3: add font tab + scanline offset
                        rdbyte  D, C                      '3: get pixels from fonttab
                        movs    :p2c, D                   '3: modify P2 (need at least 1 instr before P2) 
                        and     C4, x07F8                  '4: remove other bits
:P2c                    mov     E, pixel_table            '3: source self modify

                        add     C4, _fontsum               '4: add font tab + scanline offset
                        add     _screen, #4              '1-4: next block of 4 characters
                        sub     count, #4       wz       '1-4:
                        rdbyte  D, C4                      '4: get pixels from fonttab
                        movs    :p2d, D                    '4: modify P2 (need at least 1 instr before P2) 
                        
                        nop
:P2d                    mov     E2, pixel_table            '4: source self modify
                        shl     E2, #16                  '3/4: shift for combination
                        or      E, E2                    '3/4: combine 2 sets font pixels
                        wrlong  E, _lnram                '3/4: put 2 sets font pixels into line ram
                        add     _lnram, #4               '3/4: next lineram long
        if_nz           jmp     #:loop4                  'next group of 4 chars

'=============================================================

                        
                        'scanline processing done!
                        'now sort out screen pointers for next one
                        cmp     _fontline, #7 wz, wc
                        add     _colors, _colchar
        if_nz_AND_c     sub     _screen, _linechar
        if_nz_AND_c     sub     _colors, _colchar              
                        jmp     #next_scan



'-------------------------------------------------------------
'Blank Scanline  --Plenty of time to do this on blank scan.
'-------------------------------------------------------------

'***Need to fix this so that 40 pixel longs are done and 80 color longs are done
'***Patched right now, by doubling the pixel longs, even though they are not
'***Needed. 

blank_line              wrlong  clrama, clramp          'point to HUB color RAM
                        mov     count, numwtvd          'count all hub buffer
                        mov     A, lnram                'point to line ram  (HUB)
                        'wrlong  blank, _two_colors
                        mov     B, clram                'point to color ram (HUB)
                        sub     B, #4
:loop3                  wrlong  zero, A                 'clear all pixels
                        add     A, #2
                        add     B, #4
                        wrlong  blank, B                'clear all colors
                        djnz    count, #:loop3          'do all of it



next_scan               add     scanline, #1                                    'update current scanline
                        djnz    scanline_count, #activeloop                     'New Scanline, wait for HSYNC


                        jmp     #mainloop                                       'New Frame, wait for VSYNC






C1                      LONG    0
C4                      LONG    0
E2                      LONG    0
x07F8                   LONG    $FF << 3        'mask 8 bit char shifted left x3



'-------------------------------------------------------------
'Working registers
'-------------------------------------------------------------
scanline_count          LONG    $0                      'number of scan lines
scanline                LONG    $0                      'current scan line
active_scan             LONG    $0                      'current active scanline
count                   LONG    $0
index                   LONG    $0
A                       LONG    $0
B                       LONG    $0
C                       LONG    $0
D                       LONG    $0
E                       LONG    $0
F                       LONG    $0
G                       LONG    $0              
temp                    LONG    $0
cogbuff                 LONG    $0
_fontline               LONG    $0
_screen                 LONG    $0                      'screen memory working register
_colors                 LONG    $0
_linechar               LONG    $0                      'characters per line = waitvids * 2
_lnram                  LONG    $0
_clram                  LONG    $0
_fontsum                LONG    $0
_colchar                LONG    $0
two_colors               LONG    $02_04_06_07           'Color Mode Value, read by TV COG
_two_colors             LONG    $0                      'pointer
two_colors_temp         LONG    $0                      'Working copy of color mode value 



'-------------------------------------------------------------
'Useful Constants
'-------------------------------------------------------------              
d1                      LONG    1<<9                                            ' destination = ++1
zero                    LONG    0
blank                   LONG    $02_02_02_02                                    'All colors black
ptable                  LONG    pixel_table                                     'just a COG address (thanks Jim & Mike)



'------------------------------------------------------------
'Read only parameters from calling program
'-------------------------------------------------------------
numwtvd                 LONG    32                                              ' Number of waitvids
_numwtvd                LONG    0                                               ' Pointer to this
lnram                   LONG    $0                                              ' Address of HUB Pixel Ram
clram                   LONG    $0                                              ' Address of HUB Color Ram
clrama                  LONG    $0
'clram1                  LONG    $0                                              ' Address of HUB Color Ram 1
clramp                  LONG    $0                                              ' Address of TV COG Color Ram Pointer
'ctable                  LONG    $0
 
'-------------------------------------------------------------
'COG Write to HUB addresses for inter-cog communication
'-------------------------------------------------------------
tv_vblank               LONG    0                                               'set to 1 during VBLANK
tv_actv                 LONG    0                                               'set to 1 while drawing active video

'-------------------------------------------------------------
'Additional Read Parameters from calling program
'-------------------------------------------------------------
screen                  LONG    0                                               'address of pixel buffer
colors                  LONG    0                                               'address of color buffer
fonttab                 LONG    0                                               'address of font table


{ Change log
2009-09-??    Released on forums.parallax.com
2009-09-19    First real release, with code cleanups
2009-09-24    Changed core character to color value 01
}