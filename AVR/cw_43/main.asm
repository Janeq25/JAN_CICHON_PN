/*
 * cw_1.asm
 *
 *  Created: 05.10.2022 14:44:33
 *   Author: janek
 */ 
 
;*** NumberToDigits ***
;input : Number: R16-17
;output: Digits: R16-19
;internals: X_R,Y_R,Q_R,R_R - see _Divide
; internals
.def Dig0=R22 ; Digits temps
.def Dig1=R23 ; 
.def Dig2=R24 ; 
.def Dig3=R25 ; 



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
    ldi R16, 0x57
    ldi R17, 0x04
    rcall NumberToDIgits
    rjmp Main


NumberToDigits:
    ldi YL, 0xE8
    ldi YH, 0x03
    rcall Divide
    mov Dig3, QL

    ldi YL, 0x64
    ldi YH, 0x00
    rcall Divide
    mov Dig2, QL

    ldi YL, 0x0A
    ldi YH, 0x00
    rcall Divide
    mov Dig1, QL

    mov Dig0, RL
    ret


Divide:
    push QCtrL
    push QCtrH
    clr QCtrH
    clr QCtrL

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