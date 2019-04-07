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

;****************************************************
;右移显示，时间间隔为1秒
DISPX:  MOV     R0,#00H     ;显示文字偏移量
        MOV     R1,#00H     ;附加显示文字偏移量
        MOV     R2,#1       ;显示文字个数
        MOV     R3,#1       ;附加显示文字个数
        MOV     R4,#25      ;总的显示次数
DISP1:  MOV     COM,#80H    ;显示首地址
        ACALL   WRI         ;调用写指令子程序
        ACALL   DISP11      ;调用右移显示子程序
        INC     R3          ;取下一次显示文字个数
        MOV     A,R3        
        CJNE    A,#9,DISP12 ;判断文字个数是否超过8
        MOV     A,#8        ;超过8个就定死显示个数
        MOV     R3,A        ;把新的显示个数进行保存
DISP12: MOV     R2,A        
        MOV     A,R1        ;把原先的文字偏移量加2得到新的首位文字偏移量
        ADD     A,#2        
        MOV     R0,A        ;保存新的文字偏移量
        MOV     R1,A        
        ACALL   DELAY1      ;延时下1秒再进行下一次显示
        MOV     COM,#01H    ;清除屏幕显示，将DDRAM的地址计数器归零
        ACALL   WRI         ;调用写指令子程序
        ACALL   DELAY       ;延时
        ACALL   DELAY
        ACALL   DELAY       
        DJNZ    R4,DISP1    ;判断移位显示是否完毕


        MOV     R0,#00H     ;显示文字偏移量
        MOV     R1,#00H     ;附加显示文字偏移量
        MOV     R2,#1       ;显示文字个数
        MOV     R3,#1       ;附加显示文字个数
        MOV     R4,#25      ;总的显示次数
        MOV     B,#97H      ;显示首地址
DISP2:  MOV     COM,B       ;送首位显示地址
        ACALL   WRI         ;调用写指令子程序
        ACALL   DISP21      ;调用左移显示子程序
        MOV     R0,#00H     ;重新放首位显示偏移量
        INC     R3          ;取下一次显示位数，并进行判断
        MOV     A,R3
        CJNE    A,#9,DISP22
        MOV     A,#8
        MOV     R3,A        ;保存显示位数
DISP22: MOV     R2,A
        DEC     B           ;取下一次显示首地址，并进行判断
        MOV     A,B
        CJNE    A,#8FH,DISP23
        MOV     B,#90H      ;首地址小于90H时就定死在90H
        INC     R1          ;这时的首位文字偏移量也要相应改变
        INC     R1
        MOV     A,R1
        MOV     R0,A
DISP23: ACALL   DELAY1      
        MOV     COM,#01H    ;清除屏幕显示，将DDRAM的地址计数器归零
        ACALL   WRI         ;调用写指令子程序
        ACALL   DELAY
        ACALL   DELAY
        ACALL   DELAY
        DJNZ    R4,DISP2
        
        
;右移显示，时间间隔为1秒
        MOV     R0,#00H
        MOV     R1,#00H
        MOV     R2,#1
        MOV     R3,#1
        MOV     R4,#25
DISP3:  MOV     COM,#88H
        ACALL   WRI
        ACALL   DISP11
        INC     R3
        MOV     A,R3
        CJNE    A,#9,DISP32
        MOV     A,#8
        MOV     R3,A
DISP32: MOV     R2,A
        MOV     A,R1
        ADD     A,#2
        MOV     R0,A
        MOV     R1,A
        ACALL   DELAY1
        MOV     COM,#01H    ;清除屏幕显示，将DDRAM的地址计数器归零
        ACALL   WRI         ;调用写指令子程序
        ACALL   DELAY
        ACALL   DELAY
        ACALL   DELAY
        DJNZ    R4,DISP3


        MOV     R0,#00H
        MOV     R1,#00H
        MOV     R2,#1
        MOV     R3,#1
        MOV     R4,#25
        MOV     B,#9FH
DISP4:  MOV     COM,B
        ACALL   WRI        
        ACALL   DISP21
        MOV     R0,#00H
        INC     R3
        MOV     A,R3
        CJNE    A,#9,DISP42
        MOV     A,#8
        MOV     R3,A
DISP42: MOV     R2,A
        DEC     B
        MOV     A,B
        CJNE    A,#97H,DISP43
        MOV     B,#98H
        INC     R1
        INC     R1
        MOV     A,R1
        MOV     R0,A
DISP43: ACALL   DELAY1
        MOV     COM,#01H    ;清除屏幕显示，将DDRAM的地址计数器归零
        ACALL   WRI         ;调用写指令子程序
        ACALL   DELAY
        ACALL   DELAY
        ACALL   DELAY
        DJNZ    R4,DISP4

;逐个显示从“浙”开始到“您”；时间间隔为1秒
DISP5:  MOV    R0,#00H
        MOV    R2,#8
        MOV    COM,#80H
        ACALL  WRI
        ACALL  DISP31
        MOV    R0,#10H
        MOV    R2,#8
        MOV    COM,#90H
        ACALL  WRI
        ACALL  DISP31
        MOV    R0,#20H
        MOV    R2,#1
        MOV    COM,#88H
        ACALL  WRI
        ACALL  DISP31
        ACALL   DELAY1
;====================================
;清除屏幕显示，延时1秒
        MOV     COM,#01H    ;清除屏幕显示，将DDRAM的地址计数器归零
        ACALL   WRI         ;调用写指令子程序
        ACALL   DELAY1
;====================================       
        AJMP    DISPX


;==============================
;字符显示子程序
DISP11: MOV     A,R0        ;送偏高位偏移量
        MOV     DPTR,#TAB   ;置表头地址
        MOVC    A,@A+DPTR   ;查表得到字符代码
        MOV     DAT,A       ;送汉字码址表高位
        ACALL   WRD         ;写入第一字节数据
        INC     R0
        MOV     A,R0
        MOVC    A,@A+DPTR   ;查表得到字符代码
        MOV     DAT,A       ;送汉字码址表低位
        ACALL   WRD         ;写入第二字节数据
        MOV     A,R0        ;文字偏移量减三得到下一个要显示文字的偏移量
        CLR     C
        SUBB    A,#3
        MOV     R0,A
        DJNZ    R2,DISP11   ;判断是否显示满
        RET      
;=============================
;字符显示子程序
DISP21: MOV     A,R0        ;送偏高位偏移量
        MOV     DPTR,#TAB   ;置表头地址
        MOVC    A,@A+DPTR   ;查表得到字符代码
        MOV     DAT,A       ;送汉字码址表高位
        ACALL   WRD         ;写入第一字节数据
        INC     R0
        MOV     A,R0
        MOVC    A,@A+DPTR   ;查表得到字符代码
        MOV     DAT,A       ;送汉字码址表低位
        ACALL   WRD         ;写入第二字节数据
        INC     R0          ;取下一个字符地址
        ACALL   DELAY
        DJNZ    R2,DISP21   ;判断是否显示满
        RET        
;==========================
;字符显示子程序
DISP31: MOV     A,R0        ;送偏高位偏移量
        MOV     DPTR,#TAB   ;置表头地址
        MOVC    A,@A+DPTR   ;查表得到字符代码
        MOV     DAT,A       ;送汉字码址表高位
        ACALL   WRD         ;写入第一字节数据
        INC     R0
        MOV     A,R0
        MOVC    A,@A+DPTR   ;查表得到字符代码
        MOV     DAT,A       ;送汉字码址表低位
        ACALL   WRD         ;写入第二字节数据
        INC     R0          ;取下一个字符地址
        ACALL   DELAY1
        DJNZ    R2,DISP31   ;判断是否显示满
        RET        
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

DELAY1: MOV  R5,#08H
DELAY11:MOV  R7,#0FFH
DELAY41:MOV  R6,#0FFH
        DJNZ R6,$
        DJNZ R7,DELAY41
        DJNZ R5,DELAY11
        RET

;************************以上是延时子程序

TAB: DB  0D5H,0E3H, 0BDH,0ADH, 0B9H,0A4H, 0D2H,0B5H   ;第一行前四个字（浙江工业）
     DB  0D6H,0B0H, 0D2H,0B5H, 0BCH,0BCH, 0CAH,0F5H   ;第一行后四个字（职业技术）
     DB  0D1H,0A7H, 0D4H,0BAH, 0B5H,0E7H, 0D7H,0D3H   ;第二行前四个字（学院电子）
     DB  0D0H,0ADH, 0BBH,0E1H, 0BBH,0B6H, 0D3H,0ADH   ;第二行后四个字（协会欢迎）
     DB  0C4H,0FAH, 0A3H,0A0H, 0A3H,0A0H, 0A3H,0A0H   ;第三行前四个字（您      ）
     DB  0A3H,0A0H, 0A3H,0A0H, 0A3H,0A0H, 0A3H,0A0H   ;第三行后四个字（        ）
     DB  0A3H,0A0H, 0A3H,0A0H, 0A3H,0A0H, 0A3H,0A0H  

