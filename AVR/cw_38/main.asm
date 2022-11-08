/*
 * cw_1.asm
 *
 *  Created: 05.10.2022 14:44:33
 *   Author: janek
 */ 

ldi R16, 9
rcall DigitTo7SegCode

nop

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