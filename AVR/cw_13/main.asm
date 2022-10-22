/*
 * cw_1.asm
 *
 *  Created: 05.10.2022 14:44:33
 *   Author: janek
 */ 

  //brne = 1 if false, 2 if true, Cycles = (R20*3)


  Start: ldi R20, 10
         nop
         nop
         nop
         nop
         nop
  Loop:  dec R20
         nop
         nop
         brne Loop 
         rjmp Start