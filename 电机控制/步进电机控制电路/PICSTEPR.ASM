                   LIST    p=16F84 ; PIC16F844 is the target processor

              #include "P16F84.INC" ; Include header file

              CBLOCK 0x10   ; Temporary storage                 
                 pos
                 dc1
                 dc2
              ENDC
              LIST    p=16F84 ; PIC16F844 is the target processor

              #include "P16F84.INC" ; Include header file

              CBLOCK 0x10   ; Temporary storage
              ENDC

              ORG   0
entrypoint    goto  start

              ORG   4
intvector     goto  intvector
        
start         clrw                    ; Zero.

              movwf   PORTB           ; Ensure PORTB is zero before we enable it.
              bsf     STATUS,RP0      ; Select Bank 1
              movlw   0xF0            ; Set port B bits 0-3 as outputs
              movwf   TRISB           ; Set TRISB register.           
                                                               
              bcf     STATUS,RP0      ; Select Bank 0
                 
              movlw   3  	      ; Initialize the motor position 
              movwf   pos                                             
              movwf   PORTB
              call    delay
              clrf    PORTB	      ; Motor drive off	

;Main loop               
loop	      btfss   PORTA,0         ; Test clockwise button
	      call    stepcw
	      btfss   PORTA,1         ; Test anti-clockwise button
	      call    stepccw
	      goto loop
                               
;Rotate one step clockwise                               
stepcw        bcf    STATUS,C	      ; Clear the carry flag
 	      btfsc  pos,3            ; Set carry if this bit set
 	      bsf    STATUS,C
	      rlf    pos,W	      ; Pick up and rotate the motor's current position
              andlw  0x0F             ; Mask to lower nibble
              movwf  pos
              movwf  PORTB	      ; Drive the outputs
              call   delay	      ; Wait
              clrf   PORTB            ; Clear the output
              return

;Rotate one step counter clockwise                                                                             		
stepccw       bcf    STATUS,C	      ; Clear the carry flag
	      btfsc  pos,0
	      bsf    pos,4
	      rrf    pos,W	      ; Pick up and rotate the motor's current position
              andlw  0x0F             ; Mask to lower nibble
              movwf  pos
              movwf  PORTB	      ; Drive the outputs
              call   delay	      ; Wait
              clrf   PORTB            ; Clear the output
              return

; This routine implements the delay between steps,
; and thus controls the motor speed.
delay         movlw   18	     ; Outer loop iteration count
	      movwf   dc1		
dl1	      clrf    dc2            ; Initialize inner loop
dl2	      nop
	      nop
	      decfsz  dc2,F         
	      goto    dl2
	      decfsz  dc1,F
	      goto    dl1
	      return

	      END              
              
