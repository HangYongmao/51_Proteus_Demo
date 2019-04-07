	.module delay.c
	.area text(rom, con, rel)
	.dbfile D:\MyProject\SMS-MC55\Code\ÇÔÌýÆ÷delay\delay.c
	.dbfunc e DelayMs _DelayMs fV
;              i -> R20,R21
;             ms -> R16,R17
	.even
_DelayMs::
	rcall push_gset1
	.dbline -1
	.dbline 17
; ////////////////////////////////////////////////////////////////////////////////
; // ICC-AVR application builder : 2006-6-25 ÏÂÎç 06:02:39
; // Target : M8
; // Crystal: 3.6864Mhz
; // Author:  Anwarye
; // Title:   Detcetaphone
; ////////////////////////////////////////////////////////////////////////////////
; 
; #include <iom8v.h>
; #include <macros.h>
; //#include "define.h"
; 
; extern volatile unsigned char          PhoneNum[12]; 
; 
; 
; void DelayMs(unsigned int ms)
; {
	rjmp L3
L2:
	.dbline 20
;     unsigned int i;
;     while(ms--)
; 	{
	.dbline 21
; 	    for(i=0;i<450;i++)   // 3.6864MHz  =  450  ,7.3728MHz = 900
	clr R20
	clr R21
	rjmp L8
L5:
	.dbline 22
	.dbline 23
	NOP
	.dbline 24
L6:
	.dbline 21
	subi R20,255  ; offset = 1
	sbci R21,255
L8:
	.dbline 21
	cpi R20,194
	ldi R30,1
	cpc R21,R30
	brlo L5
	.dbline 25
L3:
	.dbline 19
	movw R2,R16
	subi R16,1
	sbci R17,0
	tst R2
	brne L2
	tst R3
	brne L2
X0:
	.dbline -2
L1:
	rcall pop_gset1
	.dbline 0 ; func end
	ret
	.dbsym r i 20 i
	.dbsym r ms 16 i
	.dbend
	.dbfunc e Write_EEPROM _Write_EEPROM fV
;        Address -> R22,R23
;           Data -> R20
	.even
_Write_EEPROM::
	rcall push_gset2
	movw R22,R18
	mov R20,R16
	.dbline -1
	.dbline 29
; 	    {
; 	        asm("NOP");
; 		}
; 	}
; }
; 
; void Write_EEPROM(unsigned char Data,unsigned int Address)
; {
	.dbline 30
;     if(EECR&0x20) DelayMs(8);
	sbis 0x1c,5
	rjmp L10
	.dbline 30
	ldi R16,8
	ldi R17,0
	rcall _DelayMs
L10:
	.dbline 31
;     EEARH=Address>>8;
	movw R2,R22
	mov R2,R3
	clr R3
	out 0x1f,R2
	.dbline 32
;     EEARL=Address&0x00ff;
	movw R24,R22
	andi R25,0
	out 0x1e,R24
	.dbline 33
;     EEDR=Data;
	out 0x1d,R20
	.dbline 34
;     EECR=EECR|0x04;
	sbi 0x1c,2
	.dbline 35
;     EECR=EECR|0x02;
	sbi 0x1c,1
	.dbline 36
;     DelayMs(8);
	ldi R16,8
	ldi R17,0
	rcall _DelayMs
	.dbline -2
L9:
	rcall pop_gset2
	.dbline 0 ; func end
	ret
	.dbsym r Address 22 i
	.dbsym r Data 20 c
	.dbend
	.dbfunc e Read_EEPROM _Read_EEPROM fc
;              i -> R20
;        Address -> R20,R21
	.even
_Read_EEPROM::
	rcall push_gset1
	movw R20,R16
	.dbline -1
	.dbline 40
; }
; 
; unsigned char Read_EEPROM(unsigned int Address)
; {
	.dbline 43
;     unsigned char i;
; 	
;     if(EECR&0x01) DelayMs(8);
	sbis 0x1c,0
	rjmp L13
	.dbline 43
	ldi R16,8
	ldi R17,0
	rcall _DelayMs
L13:
	.dbline 44
;     EEARH=Address>>8;
	movw R2,R20
	mov R2,R3
	clr R3
	out 0x1f,R2
	.dbline 45
;     EEARL=Address&0x00ff;
	movw R24,R20
	andi R25,0
	out 0x1e,R24
	.dbline 46
;     EECR=EECR|0x01;
	sbi 0x1c,0
	.dbline 47
;     DelayMs(10);
	ldi R16,10
	ldi R17,0
	rcall _DelayMs
	.dbline 48
;     i=EEDR;
	in R20,0x1d
	.dbline 49
;     return(i);
	mov R16,R20
	.dbline -2
L12:
	rcall pop_gset1
	.dbline 0 ; func end
	ret
	.dbsym r i 20 c
	.dbsym r Address 20 i
	.dbend
	.dbfunc e PhoneNum_to_EEPROM _PhoneNum_to_EEPROM fV
;             ch -> R20
;              n -> R22
	.even
_PhoneNum_to_EEPROM::
	rcall push_gset2
	.dbline -1
	.dbline 53
; }
; 
; void PhoneNum_to_EEPROM(void)
; {
	.dbline 55
;     unsigned char n,ch;
; 	for(n=0;n<12;n++)
	clr R22
	rjmp L19
L16:
	.dbline 56
	.dbline 57
	ldi R24,<_PhoneNum
	ldi R25,>_PhoneNum
	mov R30,R22
	clr R31
	add R30,R24
	adc R31,R25
	ldd R20,z+0
	.dbline 58
	mov R18,R22
	clr R19
	mov R16,R20
	rcall _Write_EEPROM
	.dbline 59
L17:
	.dbline 55
	inc R22
L19:
	.dbline 55
	cpi R22,12
	brlo L16
	.dbline -2
L15:
	rcall pop_gset2
	.dbline 0 ; func end
	ret
	.dbsym r ch 20 c
	.dbsym r n 22 c
	.dbend
	.dbfunc e EEPROM_to_PhoneNum _EEPROM_to_PhoneNum fV
;             ch -> R20
;              n -> R22
	.even
_EEPROM_to_PhoneNum::
	rcall push_gset2
	.dbline -1
	.dbline 63
; 	{
; 	    ch = PhoneNum[n];
; 	    Write_EEPROM(ch,n);
; 	}
; }
; 
; void EEPROM_to_PhoneNum(void)
; {
	.dbline 65
;     unsigned char n,ch;
; 	for(n=0;n<12;n++)
	clr R22
	rjmp L24
L21:
	.dbline 66
	.dbline 67
	mov R16,R22
	clr R17
	rcall _Read_EEPROM
	mov R20,R16
	.dbline 68
	ldi R24,<_PhoneNum
	ldi R25,>_PhoneNum
	mov R30,R22
	clr R31
	add R30,R24
	adc R31,R25
	std z+0,R20
	.dbline 69
L22:
	.dbline 65
	inc R22
L24:
	.dbline 65
	cpi R22,12
	brlo L21
	.dbline -2
L20:
	rcall pop_gset2
	.dbline 0 ; func end
	ret
	.dbsym r ch 20 c
	.dbsym r n 22 c
	.dbend
