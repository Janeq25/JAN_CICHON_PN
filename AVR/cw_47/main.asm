/*
 * cw_1.asm
 *
 *  Created: 05.10.2022 14:44:33
 *   Author: janek
 */ 
 
.cseg                         ; segment pamiêci kodu programu 
.org 0 rjmp _main             ; skok po resecie (do programu g³ównego)
.org OC1Aaddr rjmp _timer_isr ; skok do obs³ugi przerwania timera

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

;*** NumberToDigits ***
;input : Number: R16-17
;output: Digits: R16-19
;internals: X_R,Y_R,Q_R,R_R - see _Divide
; internals
.def Dig0=R22 ; Digits temps
.def Dig1=R23 ; 
.def Dig2=R24 ; 
.def Dig3=R25 ; 


.equ Digits_P=PORTB
.equ Segments_P=PORTD

.def Digit_0=R2
.def Digit_1=R3
.def Digit_2=R4
.def Digit_3=R5

.def PulseEdgeCtrL=R0
.def PulseEdgeCtrH=R1





.macro LOAD_CONST
    ldi @0, low(@2)
    ldi @1, high(@2)
.endmacro

.macro SET_DIGIT
    mov R16, Digit_@0
    rcall DigitTo7SegCode
    out Segments_P, R16
    ldi R19, (0b00010000>>@0)
    out Digits_P, R19
    LOAD_CONST R16, R17, 10
    rcall DelayInMs
    
.endmacro



_timer_isr:                   ; procedura obs³ugi przerwania timera
    
        //ctr modulo 1000   
    push R16
    push R17
    push YL
    push YH

    mov R16, PulseEdgeCtrL
    mov R17, PulseEdgeCtrH //get ctr and prepare for mod division

    ldi YL, 0xE8
    ldi YH, 0x03           //set divider to 1000

    mov R16, RL
    mov R17, RH            //bardzo mo¿liwe ¿e coœ popierdoli³em ale troche za póŸno ¿eby to naprawiaæ

    rcall Divide           //modulo 1000 with results in R16, R17
    rcall NumberToDigits   // R16, R17 to digits_0-4

        //increment 16 bit counter
    inc PulseEdgeCtrL
    brne No_Overflow
    inc PulseEdgeCtrH
No_Overflow: 

    pop YH
    pop YL
    pop R17
    pop R16

    reti


_main:
    ldi R18, 0b01111111
    out DDRD, R18       //set anode pins direction
    ldi R18, 0b00011110
    out DDRB,  R18      //set cathode pin direction

    //timer1, prescaling 256, mode CTC, interrupt init
    ldi R18, 0
    out TCCR1A, R18
    ldi R18, 0b00001100 //set WGM11 (CTC mode) set CS12 (prescaler 256)
    out TCCR1B, R18

    ldi R18, 0x7A
    out OCR1AH, R18
    ldi R18, 0x12
    out OCR1AL, R18 //set output compare to 400 (1sek) 

    ldi R18, 0b01000000 //set output compare A interrupt
    out TIMSK, R18

    sei //global interrupt enable

Main_Loop:

    SET_DIGIT 0
    SET_DIGIT 1
    SET_DIGIT 2
    SET_DIGIT 3

    rjmp Main_Loop
    

DelayInMs:
    rcall DelayOneMs
    dec R16
    brne DelayInMs
    dec R17          // 1c                                                      LSB init for fine control     for crude control                                                      |                 |   |                        |
    brpl DelayInMs   // 2c (-1 for every R25)       petla duration = -1 + R25*(5 + 5*(255-LSB_init))-1 + (255-MSB_init)*(255*5 - 1))
    ret
       
DelayOneMs:
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
    ret

DigitTo7SegCode:
    push R17
    push R31
    push R30

    ldi R17, 0
    ldi R31, high(SEG_CODES<<1)
    ldi R30, low(SEG_CODES<<1)

    add R30, R16
    adc R31, R17

    lpm R16, Z

    pop R30
    pop R31
    pop R30

    ret


SEG_CODES: .db 0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110, 0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01101111

NumberToDigits:
    ldi YL, 0xE8
    ldi YH, 0x03
    rcall Divide
    mov Digit_3, QL

    ldi YL, 0x64
    ldi YH, 0x00
    rcall Divide
    mov Digit_2, QL

    ldi YL, 0x0A
    ldi YH, 0x00
    rcall Divide
    mov Digit_1, QL

    mov Digit_0, RL
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