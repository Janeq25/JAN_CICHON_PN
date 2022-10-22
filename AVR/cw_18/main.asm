/*
 * cw_1.asm
 *
 *  Created: 05.10.2022 14:44:33
 *   Author: janek
 */ 

 //R24, R25 word registers, R22 milliseconds counter

       ldi R22, $0A  // 1c - iloœæ ms
Delay: ldi R25, $F9 // 1c MSB_init
       ldi R24, $C1 // 1c LSB_init

Loop:  adiw R24, 1  // 2c
       nop          // 1c
       brcc Loop    // 2c (-1 for every 255-MSB_INIT=6)

       dec R22      // 1c                                                      LSB init for fine control     for crude control
       nop          // 1c                                                         |                 |   |                        |
       brne Delay   // 2c (-1 for every R25)       petla duration = -1 + R25*(5 + 5*(255-LSB_init))-1 + (255-MSB_init)*(255*5 - 1))  
       nop
       

