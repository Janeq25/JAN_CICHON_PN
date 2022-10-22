/*
 * cw_1.asm
 *
 *  Created: 05.10.2022 14:44:33
 *   Author: janek
 */ 

 MainLoop:
    rcall DelayNCycles
    rjmp Mainloop

 DelayNCycles:
    nop
    nop
    nop
    rcall DelayNCycles2
    ret

DelayNCycles2:
    nop
    nop
    nop
    ret