/*
 * cw_1.asm
 *
 *  Created: 05.10.2022 14:44:33
 *   Author: janek
 */ 

  //brne = 1 if false, 2 if true, Cycles = (R20*3)


//decrement R21 from 250 to 0 twice and for each decrement do nop

Start:   ldi R20, 2


Loop2:   ldi R21, 250
Loop1:   nop
         dec R21
         brne Loop1
         dec R20
         brne Loop2
         rjmp Start 