;�������ӿ�
;�ر����ѣ�����ʱ�뽫P1.0ͬLED�Ͽ�������ֱ�ӽ�LED0����P1.0������ɾ������
speaker equ P1.0


   ORG 0000H
   LJMP START
   ORG 000BH             ;�ж����
   INC 20H               ;�жϷ������,�жϼ�������1
   MOV TH0,#0D8H
   MOV TL0,#0EFH         ;12M�����γ�10�����ж�
   RETI


   ORG 0030h
START:
   MOV SP,#50H
   MOV TH0,#0D8H
   MOV TL0,#0EFH
   MOV TMOD,#01H
   MOV IE,#82H
MUSIC0:
   NOP
   MOV DPTR,#DAT        ;��ͷ��ַ��DPTR
   MOV 20H,#00H         ;�жϼ�������0
   MOV B,#00H           ;�������0
MUSIC1:
   NOP
   CLR A
   MOVC A,@A+DPTR       ;���ȡ����
   JZ END0              ;��00H,�����
   CJNE A,#0FFH,MUSIC5
   LJMP MUSIC3
MUSIC5:
   NOP
   MOV R6,A
   INC DPTR
   MOV A,B
   MOVC A,@A+DPTR       ;ȡ���Ĵ�����R7
   MOV R7,A
   SETB TR0             ;��������
MUSIC2:
   NOP
   CPL speaker
   MOV A,R6
   MOV R3,A
   CPL A
   ;MOV P1,A             ;��ʾ(�޸��߼������ʾ)
   CPL A
   LCALL DEL
   MOV A,R7
   CJNE A,20H,MUSIC2    ;�жϼ�����(20H)=R7��?
                        ;����,�����ѭ��
   MOV 20H,#00H         ;����,��ȡ��һ����
   INC DPTR
   LJMP MUSIC1
MUSIC3:
   NOP
   CLR TR0              ;��ֹ100����
   MOV R2,#0DH
MUSIC4:
   NOP
   MOV R3,#0FFH
   LCALL DEL
   DJNZ R2,MUSIC4
   INC DPTR
   LJMP MUSIC1
END0:
   NOP
   MOV R2,#64H          ;��������,��ʱ1������
MUSIC6:
   MOV R3,#00H
   LCALL DEL
   DJNZ R2,MUSIC6
   LJMP MUSIC0
DEL:
   NOP
DEL3:
   MOV R4,#05H
DEL4:
   NOP
   DJNZ R4,DEL4
   NOP
   DJNZ R3,DEL3
   RET
DAT:
DB 18H, 30H, 1CH, 10H
DB 20H, 40H, 1CH, 10H
DB 18H, 10H, 20H, 10H
DB 1CH, 10H, 18H, 40H
DB 1CH, 20H, 20H, 20H
DB 1CH, 20H, 18H, 20H
DB 20H, 80H, 0FFH,20H
DB 30H, 1CH, 10H, 18H
DB 20H, 15H, 20H, 1CH
DB 20H, 20H, 20H, 26H
DB 40H, 20H, 20H, 2BH
DB 20H, 26H, 20H, 20H
DB 20H, 30H, 80H, 0FFH
DB 20H, 20H, 1CH, 10H
DB 18H, 10H, 20H, 20H
DB 26H, 20H, 2BH, 20H
DB 30H, 20H, 2BH, 40H
DB 20H, 20H, 1CH, 10H
DB 18H, 10H, 20H, 20H
DB 26H, 20H, 2BH, 20H
DB 30H, 20H, 2BH, 40H
DB 20H, 30H, 1CH, 10H
DB 18H, 20H, 15H, 20H
DB 1CH, 20H, 20H, 20H
DB 26H, 40H, 20H, 20H
DB 2BH, 20H, 26H, 20H
DB 20H, 20H, 30H, 80H
DB 20H, 30H, 1CH, 10H
DB 20H, 10H, 1CH, 10H
DB 20H, 20H, 26H, 20H
DB 2BH, 20H, 30H, 20H
DB 2BH, 40H, 20H, 15H
DB 1FH, 05H, 20H, 10H
DB 1CH, 10H, 20H, 20H
DB 26H, 20H, 2BH, 20H
DB 30H, 20H, 2BH, 40H
DB 20H, 30H, 1CH, 10H
DB 18H, 20H, 15H, 20H
DB 1CH, 20H, 20H, 20H
DB 26H, 40H, 20H, 20H
DB 2BH, 20H, 26H, 20H
DB 20H, 20H, 30H, 30H
DB 20H, 30H, 1CH, 10H
DB 18H, 40H, 1CH, 20H
DB 20H, 20H, 26H, 40H
DB 13H, 60H, 18H, 20H
DB 15H, 40H, 13H, 40H
DB 18H, 80H, 00H
   end


