/*
 * cw_1.asm
 *
 *  Created: 05.10.2022 14:44:33
 *   Author: janek
 */ 
 
  ;*** Divide ***
; X/Y -> Quotient,Remainder
; Input/Output: R16-19, Internal R24-25
; inputs
.def XL=R16 ; divident 
.def XH=R17 
.def YL=R18 ; divisor
.def YH=R19 
; outputs
.def RL=R16 ; remainder 
.def RH=R17 
.def QL=R18 ; quotient
.def QH=R19 
; internal
.def QCtrL=R24
.def QCtrH=R25

 
 Main:
    ldi XL, 0x39
    ldi XH, 0x30

    ldi YL, 0xE8
    ldi YH, 0x03
    rcall Divide
    nop



Divide:
    push QCtrL
    push QCtrH
    clr QCtrL
    clr QCtrH

X_LESSEQUAL_Y:
    cp XL, YL
    cpc XH, YH
    brcs X_MORETHAN_Y
    adiw QCtrL:QCtrH, 1
    sub XL, YL
    sbc XH, YH
    rjmp X_LESSEQUAL_Y

X_MORETHAN_Y:
    mov RL, XL
    mov RH, XH
    mov QL, QCtrL
    mov QH, QCtrH
    pop QCtrH
    pop QCtrL
    ret