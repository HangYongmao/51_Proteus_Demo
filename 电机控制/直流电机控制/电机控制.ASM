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

LEN     DATA  3FH       ;高电平比例初值存放单元
GAO     DATA  40H       ;高电平存放单元
DI      DATA  41H       ;低电平存放单元
GORD    BIT   20H       ;高电平或低电平位判断存放单元

JI_SHU1 DATA  42H       ;中断计数值低位存放单元
JI_SHU2 DATA  43H       ;中断计数值高位存放单元
TIMER   DATA  44H       ;定时循环次数存放单元

T_H     DATA  45H       ;十进制BCD数(17~24)位数存放单元
T_M     DATA  46H       ;十进制BCD数(9~16)位数存放单元
T_S     DATA  47H       ;十进制BCD数(1~8)位数存放单元
KEYBUF  EQU   48H       ;键号存放单元
SDJ     DATA  49H       ;设定键是否调用功能子程序偏仪量存储单元
SDJPD   DATA  4AH       ;设定键奇偶判值断存储单元
BI_JIAO DATA  50H       ;设定时的是否比较调用子程序偏移量存储单元
;******************************以上是接口定义
;电机转数检测显示
       ORG  0000H
       AJMP START
       ORG  000BH
       AJMP DVT0
       ORG 0013H
       AJMP INT1
       ORG 001BH
       AJMP TIMER1
       ORG 0040H
START: MOV  SP,#60H
       MOV R0,#00H
       CLR A
QING:  MOV @R0,A        ;将数据存放单元清零
       DJNZ R0,QING
;=================================
;设置液晶的工作方式
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
;初始显示设定子程序
;第一行显示子程序
        MOV     R0,#32H
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
;==============================
;各定时器、中断和相关单元的初始设置
     MOV JI_SHU1,#00H ;计数单元清零
     MOV JI_SHU2,#00H
     MOV TIMER,#20    ;置定时循环次数20次
     MOV R1,#6        ;设定显示单元个数
     MOV SDJPD,#00H   ;设定键奇偶判值初值为0
     MOV BI_JIAO,#00H ;不比较调用子程序偏移量初值
     SETB GORD    ;置高低电平判断位为1
     MOV GAO,LEN  ;置高电平初值
     MOV A,#100   ;置周期总长值
     SUBB A,GAO   ;求低电平比例值
     MOV DI,A     ;存低电平比例值
     MOV TMOD,#11H;置定时器0和1为定时工作方式1
     MOV TH0,#0FFH;赋定时器初值，定时时间为100us
     MOV TL0,#0ECH
     MOV TH1,#3CH ;赋定时器初值，定时时间为50ms
     MOV TL1,#0B0H
     SETB PT0     ;置定时器0为优先
     SETB ET0     ;开定时器0
     SETB IT1     ;置中断1为边沿触发方式
     SETB ET1     ;开定时器0
     SETB EA
     SETB EX1     ;开中断
     SETB TR1
     SETB TR0
LOOP:NOP          ;陷阱等待中断
     NOP
     NOP
     NOP
     AJMP LOOP
;=================================
;产生100赫兹的可调方波子程序
DVT0:PUSH PSW     ;保护现场
     PUSH A
     MOV TH0,#0FFH;重新赋初值
     MOV TL0,#0ECH
     MOV A,LEN
     CJNE A,#0,PD1  ;判断高电平比例初值是否为0
     CLR P2.1
     AJMP DVT2
PD1: CJNE A,#100,PD2;判断高电平比例初值是否为100
     SETB P2.1
     AJMP DVT2
PD2: JNB GORD,DVT1;判断高低电平位是否为0，为0转
     DJNZ GAO,DVT2;判断高电平是否已完
     CLR P2.1     ;置P2.1为低电平
     CLR GORD     ;置高低电平位为0
     MOV GAO,LEN
     MOV A,#100
     SUBB A,GAO
     MOV DI,A     ;求低电平比例值
     AJMP DVT2
DVT1:DJNZ DI,DVT2 ;判断低电平是否已完
     SETB P2.1    ;置P2.1为高电平
     SETB GORD    ;置高低电平位为1
     MOV GAO,LEN
DVT2:POP A        ;恢复现场
     POP PSW
     RETI         ;返回中断
;===========================================
INT1: PUSH PSW
      PUSH A
      INC JI_SHU1        ;中断计数值低位加1
      MOV A,JI_SHU1
      CJNE A,#00,INT11   ;判断是否溢出
      INC JI_SHU2        ;中断计数值高位加1
INT11:POP A
      POP PSW            ;中断返回
      RETI
TIMER1:CLR TR1           ;关定时器1
       CLR EX1
       PUSH PSW
       PUSH A
       ACALL WAIT
       JB P2.2,GUAN_FX
       JB P2.0,FAN
       JNB P2.0,ZHENG
GUAN_FX:
       MOV     COM,#8BH    ;DD RAM 地址-----10001011,即第三行显示第四个字的地址
       ACALL   WRI
       MOV     32H,#1EH    ;32H为"正"字偏移量
       MOV     33H,#1EH    ;33H为"转"字偏移量
       MOV     R2,#2
       ACALL   DISP1
HUI1:  MOV TH1,#3CH      ;重新赋定时器1的初值
       MOV TL1,#0B0H
       DJNZ TIMER,TIMER11;判断定时时间1秒是否已到
       CLR EX1           ;关中断1，停止计数
       ACALL JI_SUAN     ;调用相关的子程序

       MOV TIMER,#20     ;重赋定时循环次数
       MOV JI_SHU1,#00H  ;中断计数单元情零
       MOV JI_SHU2,#00H

TIMER11:POP A
        POP PSW
        SETB EX1         ;重新开中断1
        SETB TR1         ;重新开定时器1
        RETI

ZHENG:MOV     COM,#8BH    ;DD RAM 地址-----10001011,即第三行显示第四个字的地址
      ACALL   WRI
      MOV     32H,#20H    ;32H为"正"字偏移量
      MOV     33H,#10H    ;33H为"转"字偏移量
      MOV     R2,#2
      ACALL   DISP1
      AJMP    HUI1
FAN:  MOV     COM,#8BH    ;DD RAM 地址-----10001011,即第三行显示第四个字的地址
      ACALL   WRI
      MOV     32H,#22H    ;32H为"反"字偏移量
      MOV     33H,#10H    ;33H为"转"字偏移量
      MOV     R2,#2
      ACALL   DISP1
      AJMP    HUI1



;============================
;每分钟的脉冲个数计算
JI_SUAN:CLR C
        MOV A,JI_SHU1
        MOV B,#6
        MUL AB
        MOV R7,A
        MOV R6,B
        MOV A,JI_SHU2
        MOV B,#6
        MUL AB
        ADD A,R6
        MOV R6,A
        CLR A
        ADDC A,B
        MOV R5,A
;=============================
;十六进制转BCD码子程序
           CLR A       ;累加器清零
           MOV T_H,A   ;清除十进制数存放单元,准备转换
           MOV T_M,A
           MOV T_S,A
           MOV R2,#24   ;十六进制位数长度
           CLR C
SBIN_SBCD1:MOV A,R7  ;R7左移一位并送回
           RLC A
           MOV R7,A
           MOV A,R6  ;R6左移一位并送回
           RLC A
           MOV R6,A
           MOV A,R5  ;R5左移一位并送回
           RLC A
           MOV R5,A
           MOV A,T_S
           ADDC A,T_S
           DA A       ;T_S乘2并调整后送回
           MOV T_S,A
           MOV A,T_M
           ADDC A,T_M
           DA A       ;T_M乘2并调整后送回
           MOV T_M,A
           MOV A,T_H
           ADDC A,T_H
           DA A       ;T_H乘2并调整后送回
           MOV T_H,A
           DJNZ R2,SBIN_SBCD1 ;循环运行24次得到BCD码结果
;============================================
;八位BCD 码转四位BCD码子程序
           CLR A
           MOV 33H,A
           MOV 34H,A
           MOV 35H,A
           MOV 36H,A
           MOV 37H,A
BA_SI_BCD: MOV A,T_S
           MOV B,A
           ANL A,#0FH ;将T_S里面的数据存放寄存器B里后再进行与操作得到低四位
           MOV 37H,A  ;并存放到数码管显示的第一位地址40H里面
           MOV A,B
           SWAP A     ;从寄存器取回原来保存的数，再进行高低位互换
           ANL A,#0FH ;进行与操作后得到高四位
           MOV 36H,A  ;最后存放到数码管显示的第二位地址41H里面
           MOV A,T_M  ;同上
           MOV B,A
           ANL A,#0FH
           MOV 35H,A
           MOV A,B
           SWAP A
           ANL A,#0FH
           MOV 34H,A
           MOV A,T_H
           ANL A,#0FH
           MOV 33H,A
           MOV     COM,#82H    ;DD RAM 地址-----10000010,即第一行显示第三个字的地址
           ACALL   WRI
           MOV     32H,#0AH    ;32H为(:)偏移量
           MOV     R2,#6
           ACALL   DISP2
           MOV DPTR,#BJ_KG
           MOV A,BI_JIAO
           JMP @A+DPTR
GUAN:      RET
BJ_KG:     AJMP GUAN
           AJMP KAI
KAI:       CLR C
           MOV A,37H
           SUBB A,4FH
           MOV A,36H
           SUBB A,4EH
           MOV A,35H
           SUBB A,4DH
           MOV A,34H
           SUBB A,4CH
           MOV A,33H
           SUBB A,4BH
           JC JIA_1
           DEC LEN
           MOV A,LEN
           CJNE A,#0FFH,GUAN
           MOV LEN,#0
           AJMP GUAN
JIA_1:     INC LEN
           MOV A,LEN
           CJNE A,#101,GUAN
           MOV LEN,#100
           AJMP GUAN
;==========================================
;液晶初始显示调用子程序
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
WAIT:    MOV KEYBUF,#0    ;初始键号设位0，也可以为任意值
;键盘扫描子程序
         MOV P1,#0FFH        ;P1口送高电平
         CLR P1.0            ;第一行清零
         MOV A,P1            ;读P1口
         ANL A,#0F0H         ;低位屏蔽
         XRL A,#0F0H         ;判断低位是否有低电平 ,即判断是否有按键按下
         JZ NOKEY1           ;地位有低电平继续扫描,否者跳到第而行去扫描
         LCALL DELY10ms      ;延时10ms去抖在进行判断是否有按键按下
         MOV A,P1            ;继续读P1口
         ANL A,#0F0H         ;判断低位是否有低电平
         CJNE A,#0E0H,NK1    ;如果扫描数据不为0E0H就转到NK1
         MOV KEYBUF,#0       ;否者判断为0号键
         AJMP DK             ;转DK1查表程序
NK1:     CJNE A,#0D0H,NK2    ;如果扫描数据不为0D0H就转到NK2
         MOV KEYBUF,#1       ;否者判断为1号键
         AJMP DK             ;转DK2查表程序
NK2:     CJNE A,#0B0H,NK3    ;如果扫描数据不为0B0H就转到NK3
         MOV KEYBUF,#2       ;否者判断为2号键
         AJMP DK             ;转DK3查表程序
NK3:     CJNE A,#70H,NK4     ;如果扫描数据不为70H就转到NK4
         AJMP QI_OR_TING
NK4:     NOP

NOKEY1:  MOV P1,#0FFH        ;和上面相同
         CLR P1.1
         MOV A,P1
         ANL A,#0F0H
         XRL A,#0F0H
         JZ NOKEY2
         LCALL DELY10MS
         MOV A,p1
         ANL A,#0F0H
         XRL A,#0F0H
         JZ NOKEY2
         MOV A,P1
         ANL A,#0F0H
         CJNE A,#0E0H,NK5
         MOV KEYBUF,#3
         AJMP DK
NK5:     CJNE A,#0D0H,NK6
         MOV KEYBUF,#4
         AJMP DK
NK6:     CJNE A,#0B0H,NK7
         MOV KEYBUF,#5
         AJMP DK
NK7:     CJNE A,#70H,NK8
         MOV KEYBUF,#6       ;否者判断为3号键
         AJMP DK             ;转DK4查表程序
NK8:     NOP

NOKEY2:  MOV P1,#0FFH
         CLR P1.2
         MOV A,P1
         ANL A,#0F0H
         XRL A,#0F0H
         JZ NOKEY3
         LCALL DELY10MS
         MOV A,P1
         ANL A,#0F0H
         XRL A,#0F0H
         JZ NOKEY3
         MOV A,P1
         ANL A,#0F0H
         CJNE A,#0E0H,NK9
         MOV KEYBUF,#7
         AJMP DK
NK9:     CJNE A,#0D0H,NK10
         MOV KEYBUF,#8
         AJMP DK
NK10:    CJNE A,#0B0H,NK11
         MOV KEYBUF,#9
         AJMP DK
NK11:    CJNE A,#70H,NK12
         AJMP SHE_DING
NK12:    NOP

NOKEY3:  MOV P1,#0FFH
         CLR P1.3
         MOV A,P1
         ANL A,#0F0H
         XRL A,#0F0H
         JZ NOKEY4
         LCALL DELY10MS
         MOV A,P1
         ANL A,#0F0H
         XRL A,#0F0H
         JZ NOKEY4
         MOV A,P1
         ANL A,#0F0H
         CJNE A,#0E0H,NK13
         AJMP JIA_SU
NK13:    CJNE A,#0D0H,NK14
         AJMP JIAN_SU
NK14:    CJNE A,#0B0H,NK15
         AJMP ZHENG_OR_FAN
NK15:    CJNE A,#70H,NK16
         AJMP QING_CHU
NK16:    NOP

;=======================================================
;查表求键值程序
DK:      MOV A,KEYBUF         ;查表程序 查对应的键号数据
         MOV DPTR,#TABLE      ;把表头地址放入DPTR
         MOVC A,@A+DPTR       ;A里面存放的为键号,利用A和表头地址找到对应的键号数据
         DJNZ R1,DK1
         MOV R1,#1
         AJMP DKA
DK1:     MOV 4BH,4CH
         MOV 4CH,4DH
         MOV 4DH,4EH
         MOV 4EH,4FH
         MOV 4FH,A
         MOV DPTR,#SD_KAI
         MOV A,SDJ
         JMP @A+DPTR
DKA:     MOV A,P1             ;读P1口
         ANL A,#0F0H          ;屏蔽高四位
         XRL A,#0F0H          ;地位是有低电平
         JNZ DKA              ;如果有低电平继续读P1口,否者向下执行,查找第二行
NOKEY4:  RET

SD_KAI:  AJMP DKA
         AJMP SDK

SDK:     MOV     COM,#92H    ;DD RAM 地址-----10010010,即第二行显示第三个字的地址
         ACALL   WRI
         MOV     32H,#0AH    ;32H为(:)偏移量
         MOV     33H,4BH
         MOV     34H,4CH
         MOV     35H,4DH
         MOV     36H,4EH
         MOV     37H,4FH
         MOV     R2,#6
         ACALL   DISP2
         AJMP    DKA
;===================================
;功能按键功能设定
;启动和停止键:按奇次为启动，按偶次为停止
QI_OR_TING:
         CLR P2.2            ;开电源
         INC R3
         MOV A,R3
         CJNE A,#2,DONG      ;判断按键奇偶次
         MOV R3,#0
         SETB P2.2           ;关电源
TING:    MOV LEN,#0
         MOV BI_JIAO,#0      ;关设定比较和显示
         MOV     COM,#90H    ;DD RAM 地址-----10010000,即第二行显示单元起始地址
         ACALL   WRI
         MOV     32H,#30H    ;32H为"关"字偏移量
         MOV     33H,#32H    ;33H为"闭"字偏移量
         ACALL   DIS
         MOV     COM,#9BH    ;DD RAM 地址-----10011011,即第四行显示第四个字的地址
         ACALL   WRI
         MOV     32H,#28H    ;32H为"停"字偏移量
         MOV     33H,#2AH    ;33H为"止"字偏移量
         MOV     R2,#2
         ACALL   DISP1
         AJMP    DKA
DONG:    MOV     LEN,#15     ;置高电平比例初值
         MOV     COM,#9BH    ;DD RAM 地址-----10011011,即第四行显示第四个字的地址
         ACALL   WRI
         MOV     32H,#2CH    ;32H为"运"字偏移量
         MOV     33H,#2EH    ;33H为"行"字偏移量
         MOV     R2,#2
         ACALL   DISP1
         AJMP    DKA
;设定键：按奇次为开设定，按偶次为设定
SHE_DING:INC SDJPD        ;SDJPD为设定键奇偶判值断存储单元
         MOV A,SDJPD      ;SDJ为设定键是否调用功能子程序偏仪量存储单元
         CJNE A,#2,SD1    ;BI_JIAO设定时的是否比较调用子程序偏移量存储单元
         MOV SDJPD,#00H
         MOV SDJ,#0
         MOV BI_JIAO,#2
         MOV R1,#6
         AJMP DKA
SD1:     MOV SDJ,#2
         MOV BI_JIAO,#0
         MOV    COM,#90H    ;DD RAM 地址-----10010000,即第二行显示单元起始地址
         ACALL  WRI
         MOV    32H,#14H    ;32H为"设"字偏移量
         MOV    33H,#16H    ;33H为"定"字偏移量
         MOV    R2,#2
         ACALL  DISP1
         AJMP DKA
;加速键：按下时连续加
JIA_SU:  MOV A,LEN
         ADD A,#1
         CJNE A,#101,JIA_HUI1
         MOV LEN,#100
         AJMP NOKEY4
JIA_HUI1:MOV LEN,A
         AJMP NOKEY4
;减速键：按下时连续减
JIAN_SU: CLR C
         MOV A,LEN
         SUBB A,#1
         CJNE A,#0FFH,JIAN_HUI
         MOV LEN,#0
         AJMP NOKEY4
JIAN_HUI:MOV LEN,A
         AJMP NOKEY4
;正反转键：奇次正转，偶次反转
ZHENG_OR_FAN:
         CPL P2.0
         AJMP DKA
QING_CHU:MOV BI_JIAO,#0
         MOV SDJPD,#00H
         MOV     COM,#90H    ;DD RAM 地址-----10010000,即第二行显示单元起始地址
         ACALL   WRI
         MOV     32H,#30H    ;32H为"关"字偏移量
         MOV     33H,#32H    ;33H为"闭"字偏移量
         MOV     R2,#2
         ACALL   DISP1
         CLR A
         MOV 33H,A
         MOV 34H,A
         MOV 35H,A
         MOV 36H,A
         MOV 37H,A
         MOV 4BH,A
         MOV 4CH,A
         MOV 4DH,A
         MOV 4EH,A
         MOV 4FH,A
         MOV     COM,#92H    ;DD RAM 地址-----10010010,即第二行显示第三个字的地址
         ACALL   WRI
         MOV     32H,#0AH    ;32H为(:)偏移量
         MOV     R2,#6
         ACALL   DISP2
         MOV     R1,#6
         MOV BI_JIAO,#00H
         AJMP    DKA
;==================================
;延时子程序
DELAY:  MOV  R7,#0FFH
DELAY4: MOV  R6,#00FH
LOOP2:  DJNZ R6,LOOP2
        DJNZ R7,DELAY4
        RET

;键盘延时程序和查表表格
DELY10ms:MOV R6,#20       ;延时10毫秒
D2:      MOV R7,#248
         DJNZ R7,$
         DJNZ R6,D2
         RET

TABLE:   DB 07H, 04H, 01H  ;启/停 本表格是以键盘为参考  7   8   9   加速
         DB 08H, 05H, 02H, 00H  ;                       4   5   6   减速
         DB 09H, 06H, 03H   ;设定                       1   2   3   正反转
         DB;加速 减速 正反转 清除                     启/停 0  设定 清除
;==================================
;半宽字符码和字符码
TAB: DB  30H,31H,32H,33H,34H,35H,36H,37H,38H,39H ;(0,1,2,3,4,5,6,7,8,9)16*8半宽字符
     DB  3AH,20H,2FH,69H,6DH,6EH                 ;(:, ,/,i,m,n)16*8半宽字符
     DB  0D7H,0AAH, 0CBH,0D9H, 0C9H,0E8H, 0B6H,0A8H ;(转,速,设,定)
     DB  0CFH,0F2H, 0A1H,0B2H, 0A1H,0B3H, 0A1H,0A0H ;(向,( , ),  )
     DB  0D5H,0FDH, 0B7H,0B4H, 0D7h,0B4h, 0CCH,0ACH ;(正,反,状,态)
     DB  0CDH,0A3H, 0D6H,0B9H, 0D4h,0CBH, 0D0H,0D0H ;(停,止,运,行)
     DB  0B9H,0D8H, 0B1H,0D5H                       ;(关,闭)







