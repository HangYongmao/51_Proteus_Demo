;伪定义
        KEYBUF    EQU    30H     ;键值暂存单元,查表时用
        ;ZSDZ1     EQU   27H
        ZSDZ2     EQU   28H
        ZSDZ3     EQU   29H
        ZSDZ4     EQU   2AH
        ZSDZ5     EQU   2BH
        ZSDZ6     EQU   2DH
        ;*********************************************

 ;Controller:ST7920

 ;MCU:AT89C52 ,晶体频率：12MHz

 ;LCM:128*64

 ;LCM型号:带中文字库的128X64-0402

 ;LCM 接口:1:GND 2:VCC 3:V0 4.RS 5:RW 6:E 7--14:DB0-DB7 15:PSB 16:NC 17:RST 18:Vout

;**********************************************

      RS      EQU   P2.7

      RW      EQU   P2.6

      E       EQU   P2.5

      PSB     EQU   P2.4

      RST     EQU   P2.3

      COM     EQU   20H

      DAT     EQU   21H

;******************************以上是接口定义
        ORG     0000H       ;程序执行开始地址
        AJMP    MAIN               ;跳至MAIN执行
        ORG     0100H
MAIN:    MOV  SP,#60H
         MOV R1,#0FFH
         MOV R2,#0FCH
         MOV A,#00H
QING:    MOV @R1,A
         DEC R1
         DJNZ R2,QING
         ;MOV R0,#27H
         MOV 40H,#28H
         LJMP    DISP

;*********************************主程序入口地址



DISP:   CLR     PSB
        LCALL   time
        SETB    PSB                ;将PSB置1，通信方式为8位数据并口
        LCALL  time
        MOV     COM,#30H           ;功能设置---8BIT控制界面，基本指令集
        ACALL   WRI                ;调用写指令子程序
        LCALL   time               ;延迟39uS
        MOV     COM,#0CH           ;显示打开，光标关，反白显示关
        ACALL WRI                  ;调用写指令子程序
        LCALL  time                ;延迟39uS
        MOV  COM,#01H              ;清除屏幕显示，将DDRAM的地址计数器归零
        ACALL   WRI                ;调用写指令子程序
        LCALL  time                ;延迟39uS
        MOV     COM,#06H           ;DDRAM的地址计数器（AC）加1
        ACALL   WRI                ;调用写指令子程序
        LCALL   time               ;延迟39uS
 ;以下为字显示
        MOV COM,#01H


ZIXIANSHI:
        MOV     R2,#1       ;DDRAM地址记数器设为最大值
        MOV     R1,2DH
        MOV     COM,#80H      ;DD RAM 地址-----0000000
        ACALL   WRI

ZIXIANSHI1:  MOV     DAT,R4
        ACALL   WRD           ;写入第一字节数据
        MOV     DAT,R1
        ACALL   WRD           ;写入第二字节数据
        ;INC R1
        DJNZ    R2,ZIXIANSHI1
       
        LCALL DELAY     ;1S延时子程序




;****************************************************

        MOV     P1,#0FFH
        CLR     P2.0
        LJMP   KEYSCAN         ;调用查键子程序


;*************************************
;*                                   *
;* 键盘工作子程序(4 * 4 阵列)      *
;* 出口为各键工作程序入口 P1口      *
;*************************************
KEYSCAN:
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
     MOV KEYBUF,#00H;赋键值
     LJMP KEYWORK;转键处理
KB2: CJNE A,#0DH,KB3;如果值为#0D则为P1.4与P1.1组合的键
     MOV KEYBUF,#01H
     LJMP KEYWORK;转键处理
KB3: CJNE A,#0BH,KB4;如果值为#0B则为P1.4与P1.2组合的
     MOV KEYBUF,#02H
     LJMP KEYWORK;转键处理
KB4: CJNE A,#07H,KB5;如果值为#07则为P1.4与P1.3组合的
     MOV KEYBUF,#03H
     LJMP KEYWORK;转键处理
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
     MOV KEYBUF,#04H
     LJMP KEYWORK;转键处理
KB6: CJNE A,#0DH,KB7
     MOV KEYBUF,#05H
     LJMP KEYWORK;转键处理
KB7: CJNE A,#0BH,KB8
     MOV KEYBUF,#06H
     LJMP KEYWORK;转键处理
KB8: CJNE A,#07H,KB9
     MOV KEYBUF,#07H
     LJMP KEYWORK;转键处理
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
     MOV KEYBUF,#08H
     LJMP KEYWORK;转键处理
KB10: CJNE A,#0DH,KB11
     MOV KEYBUF,#09H
     LJMP KEYWORK;转键处理
KB11: CJNE A,#0BH,KB12
     MOV KEYBUF,#0AH
     LJMP KEYWORK;转键处理
KB12: CJNE A,#07H,KB13
     MOV KEYBUF,#0BH
     LJMP KEYWORK;转键处理

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
     MOV KEYBUF,#0CH
     LJMP KEYWORK;转键处理
KB14: CJNE A,#0DH,KB15
     MOV KEYBUF,#0DH
     LJMP KEYWORK
KB15: CJNE A,#0BH,KB16
     MOV KEYBUF,#0EH
     LJMP KEYWORK;转键处理
KB16: CJNE A,#07H,KB17
     MOV KEYBUF,#0FH
     LJMP KEYWORK;转键处理
KB17: NOP

NOKEY4:
     LJMP DISP

KEYWORK: MOV R0,40H
      MOV @R0,KEYBUF           ;得到键值
      MOV A,40H
      INC A
      MOV 40H,A
      CJNE A,#2CH,WAITFREE
      ACALL time1s
      MOV A,28H
      SWAP A
      ADD A,29H
      MOV R4,A
      MOV A,2AH
      SWAP A
      ADD A,2BH
      MOV 2DH,A
      CLR A
      MOV 28H,A
      MOV 29H,A
      MOV 2AH,A
      MOV 2BH,A
      MOV 40H,#28H
      ;MOV ZSDZ6,A
      ACALL ZIXIANSHI

                 ;以上程序等待键释放

      LJMP DISP    ;转DISP循环
WAITFREE:
     MOV A,P1
     MOV KEYBUF,#00H
     ANL A,#0FH
     XRL A,#0FH
     JNZ WAITFREE
     LJMP DISP    ;转DISP循环
      RET


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
        RET                     ;以上是写数据子程序

;延迟39uS    *************
time:  MOV     R7,#0FFH

time1: MOV  R6,#00FH

LOOP2:  DJNZ R6,LOOP2

        DJNZ    R7,time1

        RET
;*****************************************************
;延时1S
;*****************************************************

time1s:      mov r5,#08h        	;1001.401ms
time1s_1:    mov r6,#0f4h		;125.173ms
time1s_2:    mov r7,#0ffh		;511us
             djnz r7,$
             djnz r6,time1s_2
             djnz r5,time1s_1
             ret
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
;*************************************
;*                                   *
;*             延时10ms             *
;*                                   *
;*************************************
;
;10毫秒延时程序
DL10MS:         MOV     R3,#14H
DL10MS1:        LCALL   DELAY
                DJNZ    R3,DL10MS1
          RET

END              ;程序结束
