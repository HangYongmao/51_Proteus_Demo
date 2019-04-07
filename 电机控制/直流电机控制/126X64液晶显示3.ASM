;*********************************************

 ;Controller:ST7920

 ;MCU:AT89C51 ,晶体频率：12MHz

 ;LCM:128*64

 ;LCM型号:带中文字库的128X64-0402

 ;LCM 接口:1:GND 2:VCC 3:V0 4.RS 5:RW 6:E 7--14:DB0-DB7 15:PSB 16:NC 17:RST 18:Vout

;**********************************************

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

;******************************以上是接口定义
;电机转数检测显示
       ORG  0000H
       AJMP START
       ORG 0030H
START: MOV  SP,#60H
 ;=================================
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

;================================================
;第一行显示子程序
DISPLAY:MOV     COM,#80H    ;DD RAM 地址-----10000000,即第一行显示单元起始地址
        ACALL   WRI
        MOV     32H,#10H    ;32H为"转"字偏移量
        MOV     33H,#12H    ;33H为"速"字偏移量
        ACALL   DIS
;第二行显示子程序
        MOV     COM,#90H    ;DD RAM 地址-----10010000,即第二行显示单元起始地址
        ACALL   WRI
        MOV     32H,#30H    ;32H为"关"字偏移量
        MOV     33H,#32H    ;33H为"闭"字偏移量
        ACALL   DIS
;第三行显示子程序
        MOV     COM,#88H    ;DD RAM 地址-----10001000,即第三行显示单元起始地址
        ACALL   WRI
        MOV     32H,#10H    ;32H为"转"字偏移量
        MOV     33H,#18H    ;33H为"向"字偏移量
        MOV     35H,#1EH    ;33H为"  "字偏移量
        MOV     36H,#1EH    ;33H为"  "字偏移量
        ACALL   DIS1
        MOV     COM,#98H    ;DD RAM 地址-----10011000,即第四行显示单元起始地址
        ACALL   WRI
        MOV     32H,#24H    ;32H为"状"字偏移量
        MOV     33H,#26H    ;33H为"态"字偏移量
        MOV     35H,#28H    ;33H为"停"字偏移量
        MOV     36H,#2AH    ;33H为"止"字偏移量
        ACALL   DIS1
        ACALL   DELAY1
;=============================
;有关设定和测速显示调用子程序
        MOV     COM,#82H    ;DD RAM 地址-----10000010,即第一行显示第三个字的地址
        ACALL   WRI
        MOV     32H,#0AH    ;32H为(:)偏移量
        MOV     33H,#08H    ;33H到39H为转数偏移量
        MOV     34H,#08H
        MOV     35H,#08H
        MOV     36H,#08H
        MOV     37H,#08H
        MOV     R2,#6
        ACALL   DISP2
        MOV     COM,#90H    ;DD RAM 地址-----10010000,即第二行显示单元起始地址
        ACALL   WRI
        MOV     32H,#14H    ;32H为"设"字偏移量
        MOV     33H,#16H    ;33H为"定"字偏移量
        MOV     R2,#2
        ACALL   DISP1
        MOV     COM,#92H    ;DD RAM 地址-----10010010,即第二行显示第三个字的地址
        ACALL   WRI
        MOV     32H,#0AH    ;32H为(:)偏移量
        MOV     33H,#08H    ;33H到39H为转数偏移量
        MOV     34H,#08H
        MOV     35H,#08H
        MOV     36H,#08H
        MOV     37H,#08H
        MOV     R2,#6
        ACALL   DISP2
        MOV     COM,#8BH    ;DD RAM 地址-----10001011,即第三行显示第四个字的地址
        ACALL   WRI
        MOV     32H,#20H    ;32H为"正"字偏移量
        MOV     33H,#10H    ;33H为"转"字偏移量
        MOV     R2,#2
        ACALL   DISP1
        MOV     COM,#9BH    ;DD RAM 地址-----10011011,即第四行显示第四个字的地址
        ACALL   WRI
        MOV     32H,#2CH    ;32H为"正"字偏移量
        MOV     33H,#2EH    ;33H为"转"字偏移量
        MOV     R2,#2
        ACALL   DISP1
        ACALL   DELAY1

        AJMP    DISPLAY
;==========================================

DIS:    MOV     R2,#2       ;显示字的字数
        ACALL   DISP1       ;调用字显示
        MOV     32H,#0AH    ;32H为(:)偏移量
        MOV     33H,#00H    ;33H到39H为转数偏移量
        MOV     34H,#00H
        MOV     35H,#00H
        MOV     36H,#00H
        MOV     37H,#00H
        MOV     R2,#6       ;显示数字的字数
        ACALL   DISP2       ;调用半角字符显示
        MOV     32H,#10H    ;32H为"转"字偏移量
        MOV     R2,#1       ;显示字的字数
        ACALL   DISP1       ;调用字显示
        MOV     32H,#0CH    ;32H为(/)偏移量
        MOV     33H,#0EH    ;33H为(m)偏移量
        MOV     34H,#0DH    ;32H为(i)偏移量
        MOV     35H,#0FH    ;33H为(n)偏移量
        MOV     R2,#4       ;显示数字的字数
        ACALL   DISP2       ;调用半角字符显示
        RET
DIS1:   MOV     34H,#1AH    ;33H为"（"字偏移量

        MOV     37H,#1CH    ;33H为"）"字偏移量
        MOV     R2,#6
        ACALL   DISP1
        RET
;========================================
;字符显示子程序
DISP1:  MOV     A,@R0       ;送偏高位偏移量
        MOV     DPTR,#TAB   ;置表头地址
        MOVC    A,@A+DPTR   ;查表得到字符代码
        MOV     DAT,A       ;送汉字码址表高位
        ACALL   WRD         ;写入第一字节数据
        MOV     A,@R0       ;送偏高位偏移量
        ADD     A,#1        ;加1得到低位偏移量
        MOVC    A,@A+DPTR   ;查表得到字符代码
        MOV     DAT,A       ;送汉字码址表低位
        ACALL   WRD         ;写入第二字节数据
        INC     R0          ;取下一个字符地址
        DJNZ    R2,DISP1    ;判断是否显示满
        MOV     R0,#32H     ;重赋显示单元起始地址
        RET
;=================================
;半宽字符显示子程序
DISP2:  MOV     A,@R0       ;送偏偏移量
        MOV     DPTR,#TAB   ;置表头地址
        MOVC    A,@A+DPTR   ;查表得到字符代码
        MOV     DAT,A       ;送汉字码址表高位
        ACALL   WRD         ;写入第一字节数据
        INC     R0          ;取下一个字符地址
        DJNZ    R2,DISP2    ;判断是否显示满
        MOV     R0,#32H     ;重赋显示单元起始地址
        RET
;==================================
;写指令子程序
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
;==================================
;写数据子程序
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
;==================================
;延时子程序
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
;==================================
;半宽字符码和字符码
TAB: DB  30H,31H,32H,33H,34H,35H,36H,37H,38H,39H ;(0,1,2,3,4,5,6,7,8,9)16*8半宽字符
     DB  3AH,20H,2FH,69H,6DH,6EH                 ;(:, ,/,i,m,n)16*8半宽字符
     DB  0D7H,0AAH, 0CBH,0D9H, 0C9H,0E8H, 0B6H,0A8H ;(转,速,设,定)
     DB  0CFH,0F2H, 0A1H,0B2H, 0A1H,0B3H, 0A1H,0A0H ;(向,( , ),  )
     DB  0D5H,0FDH, 0B7H,0B4H, 0D7h,0B4h, 0CCH,0ACH ;(正,反,状,态)
     DB  0CDH,0A3H, 0D6H,0B9H, 0C6h,0F4H, 0B6H,0AFH ;(停,止,启,动)
     DB  0B9H,0D8H, 0B1H,0D5H                       ;(关,闭)
