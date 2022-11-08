/*
 * cw_1.asm
 *
 *  Created: 05.10.2022 14:44:33
 *   Author: janek
 */ 

 Main:
    ldi R16, 0b00001111 //mask for xor
    ldi R17, 0          //temp xor register
    out DDRB, R16
Loop:
    in R17, PORTB
    eor R17, R16
    out PORTB, R17
    rjmp Loop
    
