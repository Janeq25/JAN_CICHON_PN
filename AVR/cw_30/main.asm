/*
 * cw_1.asm
 *
 *  Created: 05.10.2022 14:44:33
 *   Author: janek
 */ 

 .macro LOAD_CONST
    ldi @0, low(@2)
    ldi @1, high(@2)
.endmacro


Main:
    ldi R18, 0b01111111
    out DDRD, R18  //set anode pins direction
    ldi R18, 0b00011110
    out DDRB,  R18 //set cathode pin direction

    ldi R18, 0b0111111 // disp_0
    out PORTD, R18 //set 0

Main_Loop:
    ldi R19, 0b00000010
    out PORTB, R19
    ldi R19, 0b00000100
    out PORTB, R19
    ldi R19, 0b00001000
    out PORTB, R19
    ldi R19, 0b00010000
    out PORTB, R19
    rjmp Main_Loop
    



DelayInMs:
    rcall DelayOneMs
    dec R16
    brne DelayInMs
    dec R17          // 1c                                                      LSB init for fine control     for crude control                                                      |                 |   |                        |
    brpl DelayInMs   // 2c (-1 for every R25)       petla duration = -1 + R25*(5 + 5*(255-LSB_init))-1 + (255-MSB_init)*(255*5 - 1))
    ret
       
DelayOneMs:
    push R16
    push R17
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
    pop R17
    pop R16
    ret


