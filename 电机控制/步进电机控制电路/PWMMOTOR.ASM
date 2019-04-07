;HC11 PWM Motor Control Example
;Demonstrates ADC and Timer Output Capture functions

PORTA             equ      $1000
PORTC             equ      $1003
PORTB             equ      $1004
DDRC              equ      $1007
TOC1              equ      $1016
TOC2              equ      $1018
TCTL1             equ      $1020
TCTL2             equ      $1021
TMSK1             equ      $1022
TFLG1             equ      $1023
TMSK2             equ      $1024
PACTL             equ      $1026
ADCTL             equ      $1030
ADR1              equ      $1031
ADR2              equ      $1032

                org $F000

start:          lds  #$FF

		ldaa #$FF			;Port C is output
		staa DDRC

		ldaa #$80			;Enable OC1 interrupts.
		staa TMSK1			;

		ldaa #$2			;Set the prescaler (divide by 16)
		staa TMSK2

		ldaa #$80			;Enable PA7 as output
		staa PACTL
	
                          
                ldaa #$10			;Start first ADC conversion - multi mode enable
                staa ADCTL
                          
		ldd #$0100			;Load the capture register
		std TOC1
			
		cli				;Enable interupts

loop		wai
		bra loop



;OC1 interrupt service
oc1f		ldaa #$10 			;Start another ADC conversion
		staa ADCTL

		ldaa ADR1			;Read the pot position from ADC channel 1
		staa PORTB			;Display it
                                                                                                   
		suba #127			;0x7F is zero reference.
		
		bne oc1f_ne            		;Jump if values not same

;Set Both outputs low. Motor is stationary
		clrb                                   
		stab PORTA			;Both OC1 and OC2 outputs low
		stab TCTL1			;TOC2 mode is disabled
		bra done
		
;Non-zero drive - decide if +ve or -ve:
		
oc1f_ne		bcs oc1f_cs

;Positive result - motor spins clockwise:

		ldab #$40			;Port A drives this value:
		stab PORTA
		clrb				;Release TOC2 latch - Port A acquires value, above.
		stab TCTL1
		ldab #$40 			;TOC 2 output toggles on OC2 event; motor drive stops.
		stab TCTL1
		bra done		

;Negative result - motor spins anti-clockwise:

oc1f_cs		ldab #$80			;Port A drives this value:
		stab PORTA
		clrb                            ;Release TOC2 latch - Port A acquires value, above.
		stab TCTL1
		ldab #$40 			;TOC 2 output toggles on OC2 event; motor drive stops.
		stab TCTL1
		nega				;Invert result -> 0xFF -> 0x01 etc.

;Now set up TOC2 to trigger at a time forward of TOC1. This means that the motor will 
;be powered for the number of ticks in ACCA * 256.                                                                                
		                                                     		                                                     		                                                     
done:		tab     			;TOC 2 is set to trigger after this no of cycles.
 		clra
		rolb
		rola
		rolb
		rola		
		rolb
		rola
		rolb
		rola		
		rolb
		rola		
		addd TOC1  
		std TOC2 
		
		ldd #$1000
		addd TOC1
		std TOC1
		
		ldaa #$80			;Clear the TOC 1 interrupt
		staa TFLG1
		rti


;Interrupt Vectors

		org $FFE8
		dw oc1f		

                org $FFFE
                dw start

