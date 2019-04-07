;*********************************************

 ;Controller:ST7920

 ;MCU:AT89C51 ,晶体频率：12MHz

 ;LCM:128*64

 ;LCM型号:带中文字库的128X64-0402

 ;LCM 接口:1:GND 2:VCC 3:V0 4.RS 5:RW 6:E 7--14:DB0-DB7 15:PSB 16:NC 17:RST 18:Vout

;**********************************************
;占用单元30H,31H,32H,33H,A,DPTR,R2,R4,R6,R7
;功能：显示    浙江工业职业技术
;              学院电子协会欢迎
;              您
;
RS      EQU   P2.4      ;RS=“H”,表示DB7——DB0为显示数据
                        ;RS=“L”,表示DB7——DB0为显示指令数据
RW      EQU   P2.5      ;R/W=“H”,E=“H”,数据被读到DB7——DB0
                        ;R/W=“L”,E=“H→L”, DB7——DB0的数据被写到IR或DR
E       EQU   P2.6      ;使能信号
PSB     EQU   P2.7      ;H：8位或4位并口方式，L：串口方式（见注释1）
RST     EQU   P2.0      ;复位端，低电平有效
                        ;模块内部接有上电复位电路，因此在不需要经常复位的场合可将该端悬空
COM     EQU   30H       ;DD RAM 地址存放单元
DAT     EQU   31H       ;汉字代码数据存放单元
DAT1    EQU   32H       ;汉字码址表低位存放单元
DAT2    EQU   33H       ;汉字码址表高位存放单元

;******************************以上是接口定义
       ORG   0000H
       AJMP  START
       ORG   0030H
START: MOV   SP,#60H
       LJMP  DISP
;*********************************
DISP:   CLR     PSB
        LCALL   DELAY
        SETB    PSB         ;将PSB置1，通信方式为8位数据并口
        LCALL   DELAY
        MOV     COM,#30H    ;功能设置---8BIT控制界面，基本指令集
        ACALL   WRI         ;调用写指令子程序
        LCALL   DELAY       ;延迟39uS
        MOV     COM,#0CH    ;显示打开，光标关，反白显示关
        ACALL   WRI         ;调用写指令子程序
        LCALL   DELAY       ;延迟39uS
        MOV     COM,#01H    ;清除屏幕显示，将DDRAM的地址计数器归零
        ACALL   WRI         ;调用写指令子程序
        LCALL   DELAY       ;延迟39uS
        MOV     COM,#06H    ;DDRAM的地址计数器（AC）加1
        ACALL   WRI         ;调用写指令子程序
        LCALL   DELAY       ;延迟39uS
;====================================================
DISPLAY:MOV     DAT1,#01H  ;汉字码址表低位初值
        MOV     DAT2,#00H  ;汉字码址表高位初值
        MOV     R2,#64      ;DDRAM地址记数器设为最大值64
        MOV     COM,#80H    ;DD RAM 地址-----0000000
        ACALL   WRI

DISP2:  MOV     A,DAT2
        MOV     DPTR,#TAB
        MOVC    A,@A+DPTR
        MOV     DAT,A       ;送汉字码址表高位
        ACALL   WRD         ;写入第一字节数据
        MOV     A,DAT2
        ADD     A,#2
        MOV     DAT2,A
        MOV     A,DAT1
        MOVC    A,@A+DPTR
        MOV     DAT,A       ;送汉字码址表低位
        ACALL   WRD         ;写入第二字节数据
        MOV     A,DAT1
        ADD     A,#2
        MOV     DAT1,A
        DJNZ    R2,DISP2    ;判断是否显示满
        LCALL   DELAY1      ;1S延时子程序
        AJMP    DISPLAY      
;**************************
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

;********************以上是写指令子程序

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

;********************以上是写数据子程序
DELAY:  MOV  R7,#0FFH
DELAY4: MOV  R6,#00FH
LOOP2:  DJNZ R6,LOOP2
        DJNZ R7,DELAY4
        RET

DELAY1: MOV  R4,#08H
DELAY11:MOV  R7,#0FFH
DELAY41:MOV  R6,#0FFH
        DJNZ R6,$
        DJNZ R7,DELAY41
        DJNZ R4,DELAY11
        RET

;************************以上是延时子程序
TAB: DB  0D5H,0E3H, 0BDH,0ADH, 0B9H,0A4H, 0D2H,0B5H   ;第一行前四个字（浙江工业）
     DB  0D6H,0B0H, 0D2H,0B5H, 0BCH,0BCH, 0CAH,0F5H   ;第一行后四个字（职业技术）
     DB  0C4H,0FAH, 0A3H,0A0H, 0A3H,0A0H, 0A3H,0A0H   ;第三行前四个字（您      ）
     DB  0A3H,0A0H, 0A3H,0A0H, 0A3H,0A0H, 0A3H,0A0H   ;第三行后四个字（        ）
     DB  0D1H,0A7H, 0D4H,0BAH, 0B5H,0E7H, 0D7H,0D3H   ;第二行前四个字（学院电子）
     DB  0D0H,0ADH, 0BBH,0E1H, 0BBH,0B6H, 0D3H,0ADH   ;第二行后四个字（协会欢迎）
     DB  0A3H,0A0H, 0A3H,0A0H, 0A3H,0A0H, 0A3H,0A0H   ;第四行前四个字（        ）
     DB  0A3H,0A0H, 0A3H,0A0H, 0A3H,0A0H, 0A3H,0A0H   ;第四行后四个字（        ）
