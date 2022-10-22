/*
 * cw_1.asm
 *
 *  Created: 05.10.2022 14:44:33
 *   Author: janek
 */ 

ldi R20, 0x2C //lower
ldi R21, 0x01 //higher

ldi R22, 0x90 //lower
ldi R23, 0x01 //higher

add R20, R22
adc R21, R23