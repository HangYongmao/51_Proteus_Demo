 ;设定
        QU_JIANZHI EQU 30H
        RS      EQU   P2.4
        RW      EQU   P2.5
        E       EQU   P2.6
        PSB     EQU   P2.7
        RST     EQU   P3.7
        COM     EQU   20H
        DAT     EQU   21H
;********************************************
        ORG 0000H
        AJMP MAIN
        ORG 0100H
 MAIN:  MOV  SP,#60H
        CLR     PSB
        LCALL   DELAY
        SETB    PSB                ;将PSB置1，通信方式为8位数据并口
        LCALL   DELAY
        MOV     COM,#30H           ;功能设置---8BIT控制界面，基本指令集
        ACALL   WRI           ;调用写指令子程序
        LCALL   DELAY              ;延迟39uS
        MOV     COM,#0CH           ;显示打开，光标关，反白显示关
        ACALL WRI         ;调用写指令子程序
        LCALL   DELAY              ;延迟39uS
        MOV  COM,#01H           ;清除屏幕显示，将DDRAM的地址计数器归零
        ACALL   WRI                ;调用写指令子程序
        LCALL   DELAY              ;延迟39uS
        MOV     COM,#06H           ;DDRAM的地址计数器（AC）加1
        ACALL   WRI           ;调用写指令子程序
        LCALL   DELAY              ;延迟39uS
        LJMP JIAN_ZI_CHU
;===============显示========================
;****************************************************
DISPLAY0:
        MOV     R2,#1    ;DDRAM地址记数器设为最大值      第一个 “角“的显示
        MOV     R1,#0C7H
        MOV     COM,#80H      ;DD RAM 地址-----0000000
        ACALL   WRI
DISP0:  MOV     DAT,#0BDH
        ACALL   WRD           ;写入第一字节数据
        MOV     DAT,R1
        ACALL   WRD           ;写入第二字节数据
        DJNZ    R2,DISP0
       ;LCALL   DELAY1        ;1S延时子程序
DISPLAY1:
        MOV     R2,#1    ;DDRAM地址记数器设为最大值      第二个”度“显示
        MOV     R1,#0C8H
        MOV     COM,#81H      ;DD RAM 地址-----0000000
        ACALL   WRI
DISP1:  MOV     DAT,#0B6H
        ACALL   WRD           ;写入第一字节数据
        MOV     DAT,R1
        ACALL   WRD           ;写入第二字节数据
        DJNZ    R2,DISP1
        ;LCALL   DELAY1       ;1S延时子程序
DISPLAY2:                                             ;  冒号显示
        MOV     R2,#1       ;DDRAM地址记数器设为最大值
        MOV     R1,#3AH
        MOV     COM,#82H      ;DD RAM 地址-----0000000
        ACALL   WRI
DISP2:  MOV     DAT,R1
        ACALL   WRD           ;写入第二字节数据
        DJNZ    R2,DISP2
        ;LCALL   DELAY1         ;1S延时子程序
DISPLAY3:                                             ;度单位符号的显示
        MOV     R2,#1    ;DDRAM地址记数器设为最大值
        MOV     R1,#0a4H
        MOV     COM,#86H      ;DD RAM 地址-----0000000
        ACALL   WRI
DISP3:  MOV     DAT,#0a1H
        ACALL   WRD           ;写入第一字节数据
        MOV     DAT,R1
        ACALL   WRD           ;写入第二字节数据
        DJNZ    R2,DISP3
       ; LCALL   DELAY1       ;1S延时子程序

DISPLAY4:
        MOV     R2,#1      ;DDRAM地址记数器设为最大值    百位上的显示数字
        MOV     R1,50H
        MOV     50H,#00H
        MOV     COM,#83H      ;DD RAM 地址-----0000000
        ACALL   WRI
DISP4:  MOV     DAT,R1
        ACALL   WRD           ;写入第二字节数据
        DJNZ    R2,DISP4
        ;LCALL   DELAY1       ;1S延时子程序
DISPLAY5:
        MOV     R2,#1        ;DDRAM地址记数器设为最大值   十位上的显示数字
        MOV     R1,51H
        MOV     51H,#00H
        MOV     COM,#84H      ;DD RAM 地址-----0000000
        ACALL   WRI
DISP5:  MOV     DAT,R1
        ACALL   WRD           ;写入第二字节数据
        DJNZ    R2,DISP5
        ;LCALL   DELAY1       ;1S延时子程序
DISPLAY6:
        MOV     R2,#1       ;DDRAM地址记数器设为最大值     个位上的显示数字
        MOV     R1,52H
        MOV     52H,#00H
        MOV     COM,#85H      ;DD RAM 地址-----0000000
        ACALL   WRI
DISP6:  MOV     DAT,R1
        ACALL   WRD           ;写入第二字节数据
        DJNZ    R2,DISP6
        ;LCALL   DELAY1        ;1S延时子程序
DISPLAY7:
        MOV     R2,#1    ;DDRAM地址记数器设为最大值      第二行第一个”转“显示
        MOV     R1,#0AAH
        MOV     COM,#90H      ;DD RAM 地址-----0000000
        ACALL   WRI
DISP7:  MOV     DAT,#0D7H
        ACALL   WRD           ;写入第一字节数据
        MOV     DAT,R1
        ACALL   WRD           ;写入第二字节数据
        DJNZ    R2,DISP7
        ;LCALL   DELAY1        ;1S延时子程序
DISPLAY8:                                             ;   第二行第一个”向“显示
        MOV     R2,#1    ;DDRAM地址记数器设为最大值
        MOV     R1,#0F2H
        MOV     COM,#91H      ;DD RAM 地址-----0000000
        ACALL   WRI
DISP8:  MOV     DAT,#0CFH
        ACALL   WRD           ;写入第一字节数据
        MOV     DAT,R1
        ACALL   WRD           ;写入第二字节数据
        DJNZ    R2,DISP8
        ;LCALL   DELAY1        ;1S延时子程序
DISPLAY9:
        MOV     R2,#1       ;DDRAM地址记数器设为最大值      冒号的显示
        MOV     R1,#3AH
        MOV     COM,#92H      ;DD RAM 地址-----0000000
        ACALL   WRI
DISP9:  MOV     DAT,R1
        ACALL   WRD           ;写入第二字节数据
        DJNZ    R2,DISP9
       ; LCALL   DELAY1         ;1S延时子程序
Z_HAI_F: MOV A,31H
         MOV 31H,#00H
         CJNE A,#11,DISPLAY10
DISPLAY11:                  ;“正反”转的显示
        MOV     R2,#1    ;DDRAM地址记数器设为最大值
        MOV     R1,#0B4H ;FD   (反)
        MOV     COM,#93H      ;DD RAM 地址-----0000000
        ACALL   WRI
DISP11:  MOV     DAT,#0B7H  ;D5
        ACALL   WRD           ;写入第一字节数据
        MOV     DAT,R1
        ACALL   WRD           ;写入第二字节数据
        DJNZ    R2,DISP11
       ;LJMP  DELAY
        LCALL   YUNSUAN
DISPLAY10:                  ;“正反”转的显示
        MOV     R2,#1    ;DDRAM地址记数器设为最大值
        MOV     R1,#0FdH ;b4   (正)
        MOV     COM,#93H      ;DD RAM 地址-----0000000
        ACALL   WRI
DISP10:  MOV     DAT,#0d5H  ;b7
        ACALL   WRD           ;写入第一字节数据
        MOV     DAT,R1
        ACALL   WRD           ;写入第二字节数据
        DJNZ    R2,DISP10
       ;LJMP  DELAY
       LCALL   YUNSUAN
;*************************************************************************
JIAN_ZI_CHU:MOV     P1,#0FFH
        CLR     P2.0
        MOV 40H,#28H
        LCALL JIAN_ZI         ;主体程序,调用查键子程序
        LJMP MAIN    ;转MAIN循环
        NOP     ;软件陷阱
        NOP
        NOP
        LJMP MAIN
;*************************************
;*                                   *
;* 键盘工作子程序(4 * 4 阵列)      *
;* 出口为各键工作程序入口 P1口      *
;*************************************
JIAN_ZI:

     MOV P1,#0FFH;清P1口，初始化键低电平有效
     CLR P1.4;清P1.4口
     MOV A,P1;读P1口状态
     ANL A,#0FH;清高4位，保留低四位低电平有效
     XRL A,#0FH;异或相同则为0不同结果为1，为0则表示无键被按下(这一行)
     JZ NOKEY1;为0则转下一行键值处理
     LCALL DL10MS;有键按下则延时10ms再测一次抗干扰
     MOV A,P1
     ANL A,#0FH
     XRL A,#0FH
     JZ NOKEY1;是干扰则转下一行键值处理程序
     MOV A,P1
     ANL A,#0FH;保留低四?
KB1:
     CJNE A,#0EH,KB2;如果值为#0E则为P1.4与P1.0组合的键
     MOV QU_JIANZHI,#0;赋键值
     LJMP KEYWORK;转键处理
KB2: CJNE A,#0DH,KB3;如果值为#0D则为P1.4与P1.1组合的键
     MOV QU_JIANZHI,#1
     LJMP KEYWORK
KB3: CJNE A,#0BH,KB4;如果值为#0B则为P1.4与P1.2组合的
     MOV QU_JIANZHI,#2
     LJMP KEYWORK
KB4: CJNE A,#07H,KB5;如果值为#07则为P1.4与P1.3组合的
     MOV QU_JIANZHI,#3
     LJMP KEYWORK
KB5: NOP


NOKEY1:
     MOV P1,#0FFH
     CLR P1.5
     MOV A,P1
     ANL A,#0FH
     XRL A,#0FH
     JZ NOKEY2
     LCALL DL10MS
     MOV A,P1
     ANL A,#0FH
     XRL A,#0FH
     JZ NOKEY2
     MOV A,P1
     ANL A,#0FH
     CJNE A,#0EH,KB6
     MOV QU_JIANZHI,#4
     LJMP KEYWORK
KB6: CJNE A,#0DH,KB7
     MOV QU_JIANZHI,#5
     LJMP KEYWORK
KB7: CJNE A,#0BH,KB8
     MOV QU_JIANZHI,#6
     LJMP KEYWORK
KB8: CJNE A,#07H,KB9
     MOV QU_JIANZHI,#7
     LJMP KEYWORK
KB9: NOP


NOKEY2:
     MOV P1,#0FFH
     CLR P1.6
     MOV A,P1
     ANL A,#0FH
     XRL A,#0FH
     JZ NOKEY3
     LCALL DL10MS
     MOV A,P1
     ANL A,#0FH
     XRL A,#0FH
     JZ NOKEY3
     MOV A,P1
     ANL A,#0FH
     CJNE A,#0EH,KB10
     MOV QU_JIANZHI,#8
     LJMP KEYWORK
KB10: CJNE A,#0DH,KB11
     MOV QU_JIANZHI,#9
     LJMP KEYWORK
KB11: CJNE A,#0BH,KB12
     MOV QU_JIANZHI,#10 ;正
     MOV 31H,QU_JIANZHI
     LJMP WAITFREE
KB12:CJNE A,#07H,KB13
     MOV QU_JIANZHI,#11 ;反
     MOV 31H,QU_JIANZHI
     LJMP WAITFREE

KB13: NOP
NOKEY3:
     MOV P1,#0FFH
     CLR P1.7
     MOV A,P1
     ANL A,#0FH
     XRL A,#0FH
     JZ NOKEY4
     LCALL DL10MS
     MOV A,P1
     ANL A,#0FH
     XRL A,#0FH
     JZ NOKEY4
     MOV A,P1
     ANL A,#0FH
     CJNE A,#0EH,KB14
     MOV QU_JIANZHI,#12   ;确定
     LJMP KEYWORK
KB14: CJNE A,#0DH,KB15
      MOV QU_JIANZHI,#13   ;
      LJMP ting
KB15: CJNE A,#0BH,KB16
      MOV QU_JIANZHI,#14   ;停止转动
      LJMP ting
KB16: CJNE A,#07H,KB17
      MOV QU_JIANZHI,#15   ;复位
      LJMP fu_wei
KB17: NOP

NOKEY4:
      LJMP JIAN_ZI
KEYWORK:MOV R0,40H
       MOV @R0,QU_JIANZHI          ;得到键值  查表得各值
       LCALL   DELAY
       MOV A,40H
       INC A
       MOV 40H,A
       CJNE A,#2CH,WAITFREE
       ACALL time1s
       MOV R6,28H
       MOV R5,29H
       MOV R4,2AH
       MOV A,28H    ;显示百位的数字 （扫描的数）
       MOV DPTR,#TABLE
       MOVC A,@A+DPTR
       MOV 50H,A
       CLR A
       MOV A,29H    ;显示十位的数字
       MOV DPTR,#TABLE
       MOVC A,@A+DPTR
       MOV 51H,A
       CLR A
       MOV A,2AH    ;显示个位的数字
       MOV DPTR,#TABLE
       MOVC A,@A+DPTR
       MOV 52H,A
       CLR A
       MOV 28H,A
       MOV 29H,A
       MOV 2AH,A
       MOV A,2BH
       CJNE A,#12,LOOP  ;送显示部分
      LJMP DISPLAY0
LOOP:  CLR A
       MOV 28H,A
       MOV 29H,A
       MOV 2AH,A
       MOV 2BH,A
       MOV 40H,#28H
       LJMP MAIN

WAITFREE:
       MOV A,P1
       MOV QU_JIANZHI,#00H
       ANL A,#0FH
       XRL A,#0FH
       JNZ WAITFREE
       LJMP JIAN_ZI    ;转JIAN_ZI 循环
       RET
 ;*******************************************

;******************************************************
;******************运算**************************

YUNSUAN:MOV R7,#12H  ;运算(十进制转十六进制)
        MOV R3,#100
        MOV A,R6
        MOV B,R3
        MUL AB
        MOV R1,B
        XCH A,R5
        MOV B,#10
        MUL AB
        MOV R2,A
        ADD A,R4
        ADD A,R5
        MOV R0,A
        MOV A,#00H
        MOV R6,A
        MOV R5,A
        MOV R4,A
        MOV R3,A
        MOV R2,A
        CLR C
        MOV A,R1  ;双字节除以单字节（结果存在R1）
        SUBB A,R7
        JC DV50
        SETB OV
        RET
  DV50: MOV R6,#8
  DV51: MOV A,R0
        RLC A
        MOV R0,A
        MOV A,R1
        RLC A
        MOV R1,A
        MOV F0,C
        CLR C
        SUBB A,R7
        ANL C,/F0
        JC DV52
        MOV R1,A
  DV52: CPL C
        MOV A,R3
        RLC A
        MOV R3,A
        DJNZ R6,DV51
        MOV A,R1
        ADD A,R1

        SUBB A,R7
        JC DV54

  DV54: CLR OV
        MOV A,R3
        MOV B,#0AH
        MUL AB
        mov R5,A
        mov r4,b
        cjne r4,#00h,de
    de: cjne r5,#00h,main0
        ljmp main
  main0:MOV A,31H        ;判断正反转
        CJNE A,#10, MAIN4
        mov p3,#01H  ;电机工作部分
        acall time2ms
        dec r5
        cjne r5,#00h,main1
        cjne r4,#00h,zhuang
        ljmp fu_wei
 zhuang:acall pan
        ljmp main1
           
        
  main1:mov p3,#03h    ;正
        acall time2ms
        
        dec r5
        cjne r5,#00h,main2
        cjne r4,#00h,zhuang1
        ljmp fu_wei
 zhuang1:acall pan
        ljmp main2
  main2:mov p3,#07h
        acall time2ms
        
        dec r5
        cjne r5,#00h,main3
        cjne r4,#00h,zhuang2
        ljmp fu_wei
 zhuang2:acall pan
        ljmp main3
  main3:mov p3,#05h
        acall time2ms
        dec r5
        cjne r5,#00h,main0
        cjne r4,#00h,zhuang3
        ljmp fu_wei
 zhuang3:acall pan
        ljmp main0
  MAIN4:MOV P3,#05H       ;反
        ACALL time2ms
        dec r5
        cjne r5,#00h,main5
        cjne r4,#00h,zhuang4
        ljmp fu_wei
 zhuang4:acall pan
        ljmp main5
        LJMP fu_wei
  MAIN5:MOV P3,#07H
        ACALL time2ms
        dec r5
        cjne r5,#00h,main6
        cjne r4,#00h,zhuang5
        ljmp fu_wei
 zhuang5:acall pan
        ljmp main6
        LJMP fu_wei
  MAIN6:MOV P3,#03H
        ACALL time2ms
        dec r5
        cjne r5,#00h,main7
        cjne r4,#00h,zhuang6
        ljmp fu_wei
 zhuang6:acall pan
        ljmp main7
        LJMP fu_wei
  MAIN7:MOV P3,#01H
        ACALL time2ms
        dec r5
        cjne r5,#00h,main4
        cjne r4,#00h,zhuang7
        ljmp fu_wei
 zhuang7:acall pan
        ljmp main4
        LJMP fu_wei
 ;************************************************ ;减法的补码
 pan: dec r4
      dec r5
      mov r5,#00h
       ret 
;************************************
    ting:mov p2,#00h    ;电机停止
        ljmp  main
        ret
;*********************************************
 fu_wei:clr a       ;复位清零  回到主程序
        mov r0,a
        mov r1,a
        mov r2,a
        mov r3,a
        mov r4,a
        mov r4,a
        mov r6,a
        mov 28h,a
        mov 29h,a
        mov 2ah,a
        mov 2bh,a
        ljmp main
;****************************************************88
WRI:    PUSH    ACC
        CLR     RS
        SETB    RW
WRI1:   MOV     P0,#0FFH
        SETB    E
        MOV     A,P0
        CLR     E
        JB      ACC.7,WRI1
        CLR     RW
        MOV     P0,COM
        SETB    E
        CLR     E
        POP     ACC
        RET
;******************************************以上是写指令子程序
WRD:    PUSH    ACC
        CLR     RS
        SETB    RW
WRD1:   MOV     P0,#0FFH
        SETB    E
        MOV     A,P0
        CLR     E
        JB      ACC.7,WRD1
        SETB    RS
        CLR     RW
        MOV     P0,DAT
        SETB    E
        CLR     E
        POP     ACC
        RET
;******************************************以上是写数据子程序
;*************************************
;*                                   *
;*          延时513 us              *
;*                                   *
;*************************************
;
;513微秒延时程序
DELAY:          MOV     R2,#0FEH
DELAY1:         DJNZ    R2,DELAY1
  RET
;
;
;
;*****************************************************

time2ms: mov r7,#50
time2ms1:mov r6,#220
         nop
time2ms2:djnz r6,time2ms2
         djnz r7,time2ms1
         ret

;*****************************************************
;*************************************
;*                                   *
;*             延时10ms             *
;*                                   *
;*************************************
;
;10毫秒延时程序
;延时1S
;*****************************************************

time1s:                 mov    r5,#08h			;1001.401ms
time1s_1:               mov    r6,#0f4h		;125.173ms
time1s_2:               mov    r7,#0ffh		;511us
                        djnz   r7,$
                        djnz   r6,time1s_2
                        djnz   r5,time1s_1
                        ret
;*****************************************************
DL10MS:         MOV     R3,#14H
DL10MS1:        LCALL   DELAY
                DJNZ    R3,DL10MS1
          RET
;***********************表
TABLE: DB  30H,31H,32H,33H,34H ;01234
       DB  35H,36H,37H,38H,39H ;56789
END              ;程序结束
