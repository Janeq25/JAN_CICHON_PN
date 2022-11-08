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


Main:
    ldi R16, 6
    mov Digit_0, R16
    ldi R16, 7
    mov Digit_1, R16
    ldi R16, 8
    mov Digit_2, R16
    ldi R16, 9
    mov Digit_3, R16

    ldi R18, 0b01111111
    out DDRD, R18  //set anode pins direction
    ldi R18, 0b00011110
    out DDRB,  R18 //set cathode pin direction

Main_Loop:
    mov R16, Digit_3
    rcall DigitTo7SegCode
    out Segments_P, R16
    ldi R19, 0b00000010
    out Digits_P, R19
    LOAD_CONST R16, R17, 5
    rcall DelayInMs

    mov R16, Digit_2
    rcall DigitTo7SegCode
    out Segments_P, R16
    ldi R19, 0b00000100
    out Digits_P, R19
    LOAD_CONST R16, R17, 5
    rcall DelayInMs

    mov R16, Digit_1
    rcall DigitTo7SegCode
    out Segments_P, R16
    ldi R19, 0b00001000
    out Digits_P, R19
    LOAD_CONST R16, R17, 5
    rcall DelayInMs

    mov R16, Digit_0
    rcall DigitTo7SegCode
    out Segments_P, R16
    ldi R19, 0b00010000
    out Digits_P, R19
    LOAD_CONST R16, R17, 5
    rcall DelayInMs

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