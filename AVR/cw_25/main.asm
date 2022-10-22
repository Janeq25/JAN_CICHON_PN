/*
 * cw_1.asm
 *
 *  Created: 05.10.2022 14:44:33
 *   Author: janek
 */ 

 //R24, R25 word registers, R22 milliseconds counter

Main:
    nop
    ldi R24, $04  // 1c - iloœæ ms
    rcall DelayInMs
    rjmp Main

DelayInMs:
    rcall DelayOneMs
    dec R24      // 1c                                                      LSB init for fine control     for crude control                                                      |                 |   |                        |
    brne DelayInMs   // 2c (-1 for every R25)       petla duration = -1 + R25*(5 + 5*(255-LSB_init))-1 + (255-MSB_init)*(255*5 - 1))  
    ret
       
DelayOneMs:
    sts 0x60, R24
    ldi R25, $06 // 1c MSB_init
    ldi R24, $3D // 1c LSB_init

    Loop:
        sbiw R24, 1  // 2c
        nop          // 1c
        brcc Loop    // 2c (-1 for every 255-MSB_INIT=6)

    lds R24, 0x60
    ret


