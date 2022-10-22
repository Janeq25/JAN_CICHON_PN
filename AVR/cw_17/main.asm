/*
 * cw_1.asm
 *
 *  Created: 05.10.2022 14:44:33
 *   Author: janek
 */ 

  //brne = 1 if false, 2 if true, Cycles = (R20*3)


//decrement R21 from 250 to 0 twice and for each decrement do nop
         ldi R22, 5
Delay:   ldi R20, 10
Loop2:   ldi R21, 159
Loop1:   nop
         nop
         dec R21
         brne Loop1
         dec R20
         nop
         nop
         brne Loop2
         dec R22
         brne Delay
         nop