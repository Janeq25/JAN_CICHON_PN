/*
 * cw_1.asm
 *
 *  Created: 05.10.2022 14:44:33
 *   Author: janek
 */ 
 .equ Digits_P=PORTB
 .equ Segments_P=PORTD

 .def Digit_0=R2
 .def Digit_1=R3
 .def Digit_2=R4
 .def Digit_3=R5


 .macro LOAD_CONST
    ldi @0, low(@2)
    ldi @1, high(@2)
.endmacro

.macro SET_DIGIT
    mov R16, Digit_@0
    rcall DigitTo7SegCode
    out Segments_P, R16
    ldi R19, (0b00010000>>@0)
    out Digits_P, R19
    LOAD_CONST R16, R17, 0b10111111
    rcall DelayInMs
    
.endmacro


Main:
    ldi R18, 0b01111111
    out DDRD, R18  //set anode pins direction
    ldi R18, 0b00011110
    out DDRB,  R18 //set cathode pin direction
    ldi R18, 10

Main_Loop:

    inc Digit_0
    cp Digit_0, R18
    brne Not_Equal
    clr Digit_0
    inc Digit_1
    cp Digit_1, R18
    brne Not_Equal
    clr Digit_1
    inc Digit_2
    cp Digit_2, R18
    brne Not_Equal
    clr Digit_2
    inc Digit_3
    cp Digit_3, R18
    brne Not_Equal
    clr Digit_3
Not_Equal:

    SET_DIGIT 0
    SET_DIGIT 1
    SET_DIGIT 2
    SET_DIGIT 3
    rjmp Main_Loop
    

DelayInMs:
    rcall DelayOneMs
    dec R16
    brne DelayInMs
    dec R17          // 1c                                                      LSB init for fine control     for crude control                                                      |                 |   |                        |
    brpl DelayInMs   // 2c (-1 for every R25)       petla duration = -1 + R25*(5 + 5*(255-LSB_init))-1 + (255-MSB_init)*(255*5 - 1))
    ret
       
DelayOneMs:
    push R24
    push R25
    ldi R25, $06 // 1c MSB_init
    ldi R24, $3D // 1c LSB_init

    Loop:
        sbiw R24, 1  // 2c
        nop          // 1c
        brcc Loop    // 2c (-1 for every 255-MSB_INIT=6)

    pop R25
    pop R24
    ret

DigitTo7SegCode:
    push R17
    push R31
    push R30

    ldi R17, 0
    ldi R31, high(SEG_CODES<<1)
    ldi R30, low(SEG_CODES<<1)

    add R30, R16
    adc R31, R17

    lpm R16, Z

    pop R30
    pop R31
    pop R30

    ret


SEG_CODES: .db 0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110, 0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01101111