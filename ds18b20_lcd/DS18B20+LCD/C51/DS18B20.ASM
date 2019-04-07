	TEMPER_L 	EQU 	36H	;��Ŷ����¶ȵ�λ����
	TEMPER_H 	EQU 	35H	;��Ŷ����¶ȸ�λ����
	TEMPER_NUM 	EQU 	60H	;���ת������¶�ֵ
	FLAG1 		BIT	00H
	DQ 		BIT	P3.3	;һ�����߿��ƶ˿�
;ORG		08500H
?PR?GET_TEMPER?DS18B20      SEGMENT CODE 
	PUBLIC	GET_TEMPER
	RSEG  ?PR?GET_TEMPER?DS18B20



;	LJMP	MAIN
;	ORG		8100H
;MAIN:
;	MOV 	SP,#70H
;	LCALL 	GET_TEMPER	;��DS18B20�����¶�����
;	LCALL	 TEMPER_COV	;ת���������¶����ݲ�����
;	SJMP 	$						;���һ�������¶Ȳɼ�
;

;-------����ת������¶�ֵ

GET_TEMPER:
	SETB 	DQ 		; ��ʱ���
BCD:	LCALL 	INIT_1820
	JB 	FLAG1,S22
	LJMP 	BCD 		; ��DS18B20�������򷵻�
S22:	LCALL 	DELAY1
	MOV 	A,#0CCH 	; ����ROMƥ��------0CC
	LCALL 	WRITE_1820
	MOV 	A,#44H 		; �����¶�ת������
	LCALL 	WRITE_1820
	NOP
	LCALL 	DELAY
	LCALL 	DELAY
CBA:	LCALL 	INIT_1820
	JB 	FLAG1,ABC
	LJMP 	CBA
ABC:	LCALL 	DELAY1
	MOV 	A,#0CCH 	; ����ROMƥ��
	LCALL 	WRITE_1820
	MOV 	A,#0BEH 	; �������¶�����
	LCALL 	WRITE_1820
	LCALL 	READ_18200 	;READ_1820
	mov	r6,TEMPER_H
	mov	r7,TEMPER_L
	RET

;-------��DS18B20�ĳ���,��DS18B20�ж���һ���ֽڵ�����
READ_1820:
	MOV 	R2,#8
RE1:	CLR 	C
	SETB 	DQ
	NOP
	NOP
	CLR 	DQ
	NOP
	NOP
	NOP
	SETB 	DQ
	MOV 	R3,#7
	DJNZ 	R3,$
	MOV 	C,DQ
	MOV 	R3,#23
	DJNZ 	R3,$
	RRC 	A
	DJNZ 	R2,RE1
	RET

;-------дDS18B20�ĳ���
WRITE_1820:
	MOV 	R2,#8
	CLR 	C
WR1:	CLR 	DQ
	MOV 	R3,#6
	DJNZ 	R3,$
	RRC 	A
	MOV 	DQ,C
	MOV 	R3,#23
	DJNZ 	R3,$
	SETB 	DQ
	NOP
	DJNZ 	R2,WR1
	SETB 	DQ
	RET

;-------��DS18B20�ĳ���,��DS18B20�ж��������ֽڵ��¶�����
READ_18200:
	MOV 	R4,#2 	; ���¶ȸ�λ�͵�λ��DS18B20�ж���
	MOV 	R1,#36H ; ��λ����36H(TEMPER_L),��λ����35H(TEMPER_H)
RE00:	MOV 	R2,#8
RE01:	CLR 	C
	SETB 	DQ
	NOP
	NOP
	CLR 	DQ
	NOP
	NOP
	NOP
	SETB 	DQ
	MOV 	R3,#7
	DJNZ 	R3,$
	MOV 	C,DQ
	MOV 	R3,#23
	DJNZ 	R3,$
	RRC 	A
	DJNZ 	R2,RE01
	MOV 	@R1,A
	DEC 	R1
	DJNZ 	R4,RE00
	RET

?PR?_TEMPER_COV?DS18B20      SEGMENT CODE 
;?DT?_TEMPER_COV?DS18B20      SEGMENT DATA OVERLAYABLE  
;	PUBLIC	 ?_TEMPER_COV?BYTE
	PUBLIC	_TEMPER_COV
		
;	RSEG  ?DT?_TEMPER_COV?DS18B20
;?_TEMPER_COV?BYTE:
;	kk?00: DS 2
	
;	retval?01: ds 1

	RSEG  ?PR?_TEMPER_COV?DS18B20

;-------����DS18B20�ж������¶����ݽ���ת��
_TEMPER_COV:
	MOV 	A,#0F0H
	ANL 	A,TEMPER_L ; ��ȥ�¶ȵ�λ��С��������λ�¶���ֵ
	SWAP 	A
	MOV 	TEMPER_NUM,A
	MOV 	A,TEMPER_L
	JNB 	ACC.3,TEMPER_COV1 ; ��������ȥ�¶�ֵ
	INC 	TEMPER_NUM

TEMPER_COV1:
	MOV 	A,TEMPER_H
	ANL 	A,#07H
	SWAP 	A
	ADD 	A,TEMPER_NUM
	MOV 	TEMPER_NUM,A ; ����任����¶�����
	LCALL 	BIN_BCD
	mov	R7,TEMPER_NUM
	RET

;-------��16���Ƶ��¶�����ת����ѹ��BCD��
BIN_BCD:
	MOV 	DPTR,#TEMP_TAB
	MOV 	A,TEMPER_NUM
	MOVC 	A,@A+DPTR
	MOV 	TEMPER_NUM,A
	RET

TEMP_TAB:
	DB 00H,01H,02H,03H,04H,05H,06H,07H
	DB 08H,09H,10H,11H,12H,13H,14H,15H
	DB 16H,17H,18H,19H,20H,21H,22H,23H
	DB 24H,25H,26H,27H,28H,29H,30H,31H
	DB 32H,33H,34H,35H,36H,37H,38H,39H
	DB 40H,41H,42H,43H,44H,45H,46H,47H
	DB 48H,49H,50H,51H,52H,53H,54H,55H
	DB 56H,57H,58H,59H,60H,61H,62H,63H
	DB 64H,65H,66H,67H,68H,69H,70H,71H
	DB 72H,73H,74H,75H,76H,77H,78H,79H
	DB 80H,81H,82H,83H,84H,85H,86H,87H
	DB 88H,89H,90H,91H,92H,93H,94H,95H
	DB 96H,97H,98H,99H

;-------DS18B20��ʼ������
INIT_1820:
	SETB 	DQ
	NOP
	CLR 	DQ
	MOV 	R0,#80H
TSR1:	DJNZ 	R0,TSR1 ; ��ʱ
	SETB 	DQ
	MOV 	R0,#25H ;96US-25H
TSR2:	DJNZ 	R0,TSR2
	JNB 	DQ,TSR3
	LJMP 	TSR4 	; ��ʱ
TSR3:	SETB 	FLAG1 	; �ñ�־λ,��ʾDS1820����
	LJMP 	TSR5
TSR4:	CLR 	FLAG1 	; ���־λ,��ʾDS1820������
	LJMP 	TSR7
TSR5:	MOV 	R0,#06BH ;200US
TSR6:	DJNZ 	R0,TSR6 ; ��ʱ
TSR7:	SETB 	DQ
	RET

;-------����дDS18B20�ݴ�洢���趨ֵ
RE_CONFIG:
	JB 	FLAG1,RE_CONFIG1 ; ��DS18B20����,תRE_CONFIG1
	RET
RE_CONFIG1:
	MOV 	A,#0CCH ; ��SKIP ROM����
	LCALL 	WRITE_1820
	MOV 	A,#4EH ; ��д�ݴ�洢������
	LCALL 	WRITE_1820
	
	MOV 	A,#00H ; TH(��������)��д��00H
	LCALL 	WRITE_1820
	MOV 	A,#00H ; TL(��������)��д��00H
	LCALL 	WRITE_1820
	MOV 	A,#7FH ; ѡ��12λ�¶ȷֱ���
	LCALL 	WRITE_1820
	RET

;------------------��ʱ�ӳ���
DELAY:
	MOV 	R7,#00H
MIN:	DJNZ 	R7,YS500
	RET
YS500:	LCALL 	YS500US
	LJMP 	MIN
YS500US:MOV 	R6,#00H
	DJNZ 	R6,$
	RET
DELAY1:	MOV 	R7,#20H
	DJNZ 	R7,$
	RET

	END
