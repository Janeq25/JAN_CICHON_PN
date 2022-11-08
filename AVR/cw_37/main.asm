/*
 * cw_1.asm
 *
 *  Created: 05.10.2022 14:44:33
 *   Author: janek
 */ 

    ldi R16, 3
    rcall SQUARE
    nop

SQUARE:
    ldi R17, 0
    ldi R31, high(SQUARES<<1)
    ldi R30, low(SQUARES<<1)

    add R30, R16
    adc R31, R17

    lpm R16, Z
    ret


SQUARES: .db 0, 1, 4, 9, 16, 25, 36, 49, 64, 81