;********************************************************************************
;*  标题:  伟纳电子ME300B单片机开发系统演示程序 - DS18B20温度控制1602LCD显示    *
;*  文件:  DS18B20-LCD.asm                                                      *
;*  日期:  2005-3-20                                                            *
;*  版本:  1.0                                                                  *
;*  作者:  gguoqing                                                             *
;*  邮箱:  gguoqing@willar.com                                                  *
;*  网站： http://www.willar.com                                                *
;********************************************************************************
;*  描述:                                                                       *
;*          DS18B20温度控制1602LCD显示                                          *
;*                                                                              *
;*          使用方法参考readme.txt文档                                          *
;*                                                                              *
;*                                                                              *
;********************************************************************************
;* 【版权】 Copyright(C)伟纳电子 www.willar.com  All Rights Reserved            *
;* 【声明】 此程序仅用于学习与参考，引用请注明版权和作者信息！                  *
;********************************************************************************

 

          TEMP_ZH   DATA  24H     ;实时温度值存放单元
          TEMPL     DATA  25H     ;
          TEMPH     DATA  26H     ;
          TEMP_TH   DATA  27H     ;高温报警值存放单元
          TEMP_TL   DATA  28H     ;低温报警值存放单元
          TEMPHC    DATA  29H     ;
          TEMPLC    DATA  2AH

          K1     EQU  P1.4
          K2     EQU  P1.5
          K3     EQU  P1.6
          K4     EQU  P1.7

          BEEP      EQU  P3.7
          RELAY     EQU  P1.3
          LCD_X     EQU  2FH      ;LCD 地址变量
          LCD_RS    EQU  P2.0
          LCD_RW    EQU  P2.1
          LCD_EN    EQU  P2.2
          flag1     equ  20H.0    ;DS18B20是否存在标记
          KEY_UD    EQU  20H.1    ;设定 KEY 的UP与DOWN 标记
          date_line equ p3.3
;=====================================================
           ORG  0000H
           JMP  MAIN

		   
		  ORG  0030H
MAIN:     MOV  SP,#60H
          MOV  A,#00H
          MOV  R0,#20H       ;将 20H-2FH 单元清零
          MOV  R1,#10H
CLEAR:    MOV  @R0,A
          INC  R0
          DJNZ  R1,CLEAR

          CALL  SET_LCD
          CALL  RE_18B20

start:    CALL  RESET          ;18B20复位子程序
          JNB   FLAG1,START1   ;DS1820不存在
          CALL  MENU_OK
          CALL  READ_E2
          CALL  TEMP_BJ        ;显示温度标记
          JMP   START2
START1:   CALL  MENU_ERROR
          CALL  TEMP_BJ        ;显示温度标记
          JMP  $

START2:
          CALL  RESET
          JNB  FLAG1,START1    ;DS1820不存在
          MOV   A,#0CCH        ; 跳过ROM匹配
          CALL  WRITE
          MOV   A,#44H         ; 发出温度转换命令
          CALL  WRITE
          CALL  RESET
          MOV   A,#0CCH        ; 跳过ROM匹配
          CALL  WRITE
          MOV   A,#0BEH        ; 发出读温度命令
          CALL  WRITE
          CALL  READ
          call CONVTEMP
          Call DISPBCD
          CALL CONV
          CALL TEMP_COMP
          CALL  PROC_KEY       ; 键扫描

   SJMP START2
;-----------------------------------------------------
PROC_KEY:
  JB  K1,PROC_K1    ; 按键K1处理
         CALL  BEEP_BL
         JNB  K1,$
         MOV  DPTR,#M_ALAX1
         MOV  A,#1
         CALL  LCD_PRINT
         CALL  LOOK_ALARM
         JB  K3,$
         CALL  BEEP_BL
         JMP  PROC_K2
PROC_K1:     ; 按键K2处理
         JB  K2,PROC_END
         CALL  BEEP_BL
         JNB  K2,$
         MOV   DPTR,#RESET_A1
         MOV   A,#1
         CALL  LCD_PRINT
         CALL  SET_ALARM
         CALL  RE_18B20           ;将设定的TH,TL值写入DS18B20内
         CALL  WRITE_E2
PROC_K2:
         CALL  MENU_OK
         CALL  TEMP_BJ
PROC_END:
         RET
;============================================
;设定报警值 TH、TL
;============================================
SET_ALARM:
         ;CALL  RESET_ALARM
         CALL  LOOK_ALARM
AS0:
         JB   K1,AS00
         CALL  BEEP_BL
         JNB  K1,$
         CPL  20H.1            ;UP/DOWN 标记
AS00:    JB  20H.1,ASZ01       ;20H.1=1，UP
         JMP  ASJ01            ;20H.1=0，DOWN

ASZ01:   JB  K2,ASZ02          ;TH值调整（增加）
         CALL  BEEP_BL
         INC  TEMP_TH
         MOV  A,TEMP_TH
         CJNE  A,#120,ASZ011
         MOV  TEMP_TH,#0
ASZ011:  CALL  LOOK_ALARM
         MOV  R5,#10
         CALL  DELAY
         JMP  ASZ01

ASZ02:   JB  K3,ASZ03          ;TL值调整（增加）
         CALL  BEEP_BL
         INC  TEMP_TL
         MOV  A,TEMP_TL
         CJNE  A,#99,ASZ021
         MOV  TEMP_TL,#00H
ASZ021:  CALL  LOOK_ALARM    ;
         MOV  R5,#10
         CALL  DELAY
         JMP  ASZ02
ASZ03:   JB  K4,AS0          ;确定调整 OK
         CALL  BEEP_BL
         JNB  K4,$
         RET

ASJ01:
         JB  K2,ASJ02          ;TH值调整 （减少）
         CALL  BEEP_BL
         DEC   TEMP_TH
         MOV  A,TEMP_TH
         CJNE  A,#0FFH,ASJ011
         JMP  ASJ022
ASJ011:  CALL  LOOK_ALARM
         MOV  R5,#10
         CALL  DELAY
         JMP  AS0

ASJ02:   JB  K3,ASJ03         ;TL值调整（减少）
         CALL  BEEP_BL
         DEC  TEMP_TL
         MOV  A,TEMP_TL
         CJNE  A,#0FFH,ASJ021
         JMP  ASJ022
ASJ021:  CALL  LOOK_ALARM    ;
         MOV  R5,#10
         CALL  DELAY
         JMP  AS0
ASJ022:  CPL  20H.1
         JMP  ASZ01
ASJ03:   JMP  ASZ03
         RET


RESET_ALARM:
          MOV  DPTR,#RESET_A1  ;指针指到显示信息区
          MOV  A,#1            ;显示在第一行
          CALL  LCD_PRINT
          RET
RESET_A1:
     DB  "RESET ALERT CODE"
;====================================================
;实际温度值与标记温度值比较子程序
;====================================================
TEMP_COMP:
          MOV  A,TEMP_TH       
          SUBB  A,TEMP_ZH       ;减数>被减数，则
          JC  CHULI1            ;借位标志位C=1，转
          MOV  A,TEMP_ZH
          SUBB  A,TEMP_TL       ;减数>被减数，则
          JC  CHULI2            ;借位标志位C=1，转
          MOV  DPTR,#BJ5
          CALL  TEMP_BJ3
          CLR   RELAY           ;继电器吸合
          RET
 CHULI1:
          MOV  DPTR,#BJ3
          CALL  TEMP_BJ3
          SETB  RELAY           ;继电器关闭
          CALL  BEEP_BL
          RET
 CHULI2:
          MOV  DPTR,#BJ4
          CALL  TEMP_BJ3
          CALL  BEEP_BL
          RET
;-----------------------------------------
TEMP_BJ3:
          MOV  A,#0CEH
          CALL WCOM
          MOV  R1,#0
          MOV  R0,#2

BBJJ3:    MOV  A,R1
          MOVC A,@A+DPTR
          CALL  WDATA
          INC R1
          DJNZ  R0,BBJJ3
          RET
BJ3:
      DB  ">H"
BJ4:
      DB  "<L"
BJ5:
      DB  " !"
;==================================================
;显示温度标记子程序
;==================================================
TEMP_BJ:
          MOV  A,#0CBH
          CALL WCOM
          MOV  DPTR,#BJ1  ;指针指到显示消息
          MOV  R1,#0
          MOV  R0,#2

BBJJ1:    MOV  A,R1
          MOVC A,@A+DPTR
          CALL  WDATA
          INC R1
          DJNZ  R0,BBJJ1
          RET
BJ1:
      DB  00H,"C"
;=================================================
MENU_OK:

          MOV  DPTR,#M_OK1  ;指针指到显示消息
          MOV  A,#1          ;显示在第一行
          CALL  LCD_PRINT
          MOV  DPTR,#M_OK2  ;指针指到显示消息
          MOV  A,#2          ;显示在第一行
          CALL  LCD_PRINT

          RET
M_OK1:
    DB   "   DS18B20 OK   ",0
M_OK2:
    DB   " TEMP:          ",0
;-----------------------------------------------
MENU_ERROR:
          MOV  DPTR,#M_ERROR1  ;指针指到显示消息1
          MOV  A,#1          ;显示在第一行
          CALL  LCD_PRINT
          MOV  DPTR,#M_ERROR2  ;指针指到显示消息1
          MOV  A,#2          ;显示在第一行
          CALL  LCD_PRINT
          RET
M_ERROR1:
    DB   " DS18B20 ERROR  ",0
M_ERROR2:
    DB   " TEMP: ----     ",0
;====================================================
reset:  setb date_line
        nop
        clr date_line
        mov r0,#6bh         ;主机发出延时复位低脉冲
        mov r1,#04h
tsr1:   djnz r0,$
        mov r0,#6bh
        djnz r1,tsr1
        setb date_line        ;然后拉高数据线
        nop
        nop
        nop
        mov r0,#32h
tsr2:   jnb date_line,tsr3   ;等待DS18B20回应
        djnz r0,tsr2
        jmp tsr4             ; 延时
tsr3:   setb flag1           ; 置标志位,表示DS1820存在
        jmp tsr5
tsr4:   clr flag1            ; 清标志位,表示DS1820不存在
        jmp tsr7
tsr5:   mov r0,#06bh
tsr6:   djnz r0,$            ; 时序要求延时一段时间
tsr7:   setb date_line
        ret
;=======================================================
RE_18B20:
        JB  FLAG1,RE_18B20A
        RET
RE_18B20A:
        CALL  RESET
        MOV  A,#0CCH       ;跳过ROM匹配
        LCALL  WRITE
        MOV  A,#4EH        ;写暂存寄存器
        LCALL  WRITE
        MOV  A,TEMP_TH     ;TH(报警上限）
        LCALL  WRITE
        MOV  A,TEMP_TL     ;TL(报警下限）
        LCALL  WRITE
        MOV  A,#7FH        ;12位精确度
        LCALL  WRITE
        RET
;------------------------------------------------------------
WRITE_E2:
        CALL  RESET
        MOV  A,#0CCH        ;跳过ROM匹配
        LCALL  WRITE
        MOV  A,#48H         ;把暂存器里的温度报警值拷贝到EEROM
        LCALL  WRITE
        RET
;--------------------------------------------------------------
READ_E2:
        CALL  RESET
        MOV  A,#0CCH        ;跳过ROM匹配
        LCALL  WRITE
        MOV  A,#0B8H        ;把EEROM里的温度报警值拷贝回暂存器
        CALL  WRITE
        RET
;--------------------------------------------------------------
;将自定义字符写入LCD1602的CGRAM中
;--------------------------------------------------------------
STORE_DATA:
        MOV  A,#40H
        CALL  WCOM
        MOV  R2,#08H
        MOV  DPTR,#D_DATA
        MOV  R3,#00H
S_DATA:
        MOV  A,R3
        MOVC  A,@A+DPTR
        CALL  WDATA      ;写入数据
        INC  R3
        DJNZ  R2,S_DATA
        RET

D_DATA:
    DB  0CH,12H,12H,0CH,00H,00H,00H,00H
;==============================================================
write:  mov r2,#8            ;一共8位数据
        CLR  C
wr1:
        clr date_line        ;开始写入DS18B20总线要处于复位（低）状态
        mov r3,#07
        djnz r3,$            ;总线复位保持16微妙以上
        rrc a                ;把一个字节DATA 分成8个BIT环移给C
        mov date_line,c      ;写入一个BIT
        mov r3,#3CH
        djnz r3,$            ;等待100微妙
        setb date_line       ;重新释放总线
        nop
        djnz r2,wr1          ;写入下一个BIT
        setb date_line
        ret
;--------------------------------------------------------------------
read:    mov r4,#4          ; 将温度低位、高位、TH、TL从DS18B20中读出
         mov r1,#TEMPL        ; 存入25H、26H、27H、28H
re00:    mov r2,#8
re01:    clr cy
         setb date_line
         nop
         nop
         clr date_line        ;读前总线保持为低
         nop
         nop
         nop
         setb date_line       ;开始读总线释放
         mov r3,#09           ;延时18微妙
         djnz r3,$
         mov c,date_line      ;从DS18B20总线读得一个BIT
         mov r3,#3CH
         djnz r3,$            ;等待100微妙
         rrc a                ;把读得的位值环移给A
         djnz r2,re01         ;读下一个BIT
         mov @r1,a
         inc r1
         djnz r4,re00
         ret


;*****************************************************
;  处理温度 BCD 码子程序
;****************************************************
CONVTEMP:      MOV  A,TEMPH       ;判温度是否零下
               ANL  A,#80H
               JZ  TEMPC1         ;温度零上转
               CLR  C
               MOV  A,TEMPL       ;二进制数求补（双字节）
               CPL  A             ;取反加1
               ADD  A,#01H
               MOV  TEMPL,A
               MOV  A,TEMPH
               CPL  A
               ADDC  A,#00H
               MOV  TEMPH,A
               SJMP  TEMPC11

TEMPC1:        MOV  TEMPHC,#0AH     ;+
TEMPC11:       MOV  A,TEMPHC
               SWAP  A
               MOV  TEMPHC,A
               MOV  A,TEMPL
               ANL  A,#0FH              ;乘0.0625
               MOV  DPTR,#TEMPDOTTAB
               MOVC  A,@A+DPTR
               MOV  TEMPLC,A            ;TEMPLC LOW=小数部分 BCD

               MOV  A,TEMPL             ;整数部分
               ANL  A,#0F0H             ;取出高四位
               SWAP  A
               MOV  TEMPL,A
               MOV  A,TEMPH             ;取出低四位
               ANL  A,#0FH
               SWAP  A
               ORL  A,TEMPL             ;重新组合
               MOV  TEMP_ZH,A
               LCALL  HEX2BCD1
               MOV  TEMPL,A
               ANL  A,#0F0H
               SWAP  A
               ORL  A,TEMPHC            ;TEMPHC LOW = 十位数 BCD
               MOV  TEMPHC,A
               MOV  A,TEMPL
               ANL  A,#0FH
               SWAP  A                  ;TEMPLC HI = 个位数 BCD
               ORL  A,TEMPLC
               MOV  TEMPLC,A
               MOV  A,R4
               JZ  TEMPC12
               ANL  A,#0FH
               SWAP  A
               MOV  R4,A
               MOV  A,TEMPHC            ;TEMPHC HI = 百位数 BCD
               ANL  A,#0FH
               ORL  A,R4
               MOV  TEMPHC,A
TEMPC12:       RET
;---------------------------------------------------------------
HEX2BCD1:
              MOV  B,#064H          ;十六进制-> BCD
              DIV  AB               ;B= A % 100
              MOV  R4,A             ;R7 = 百位数
              MOV  A,#0AH
              XCH  A,B
              DIV  AB               ;B = A % B
              SWAP  A
              ORL  A,B
              RET
;-------------------------------------------------------------
;  小数部分码表
;-------------------------------------------------------------
TEMPDOTTAB:
         DB   00H,00H,01H,01H,02H,03H,03H,04H
         DB   05H,05H,06H,06H,07H,08H,08H,09H
;=====================================================
LOOK_ALARM:

          MOV  DPTR,#M_ALAX2   ;指针指到显示信息区
          MOV  A,#2            ;显示在第二行
          CALL  LCD_PRINT

          MOV  A,#0C6H
          CALL  TEMP_BJ1
          MOV  A,TEMP_TH       ;加载TH数据
          MOV  LCD_X,#3        ;设置位置
          CALL  SHOW_DIG2H     ;显示数据

          MOV  A,#0CEH
          CALL  TEMP_BJ1
          MOV  A,TEMP_TL       ;加载TL数据
          MOV  LCD_X,#12       ;设置位置
          CALL  SHOW_DIG2L     ;显示数据
          RET
;--------------------------------------------
M_ALAX1:
     DB   " LOOK ALERT CODE",0
M_ALAX2:
     DB   "TH:      TL:    ",0
;--------------------------------------------
TEMP_BJ1:
          CALL WCOM
          MOV  DPTR,#BJ2      ;指针指到显示信息区
          MOV  R1,#0
          MOV  R0,#2

BBJJ2:    MOV  A,R1
          MOVC A,@A+DPTR
          CALL  WDATA
          INC R1
          DJNZ  R0,BBJJ2
          RET
BJ2:
      DB  00H,"C"

;---------------------------------------------------
SHOW_DIG2H:                ;在 LCD 的第二行显示数字
          MOV  B,#100
          DIV  AB
          ADD  A,#30H
          PUSH  B
          MOV  B,LCD_X
          CALL  LCDP2
          POP  B
          MOV  A,#0AH
          XCH  A,B
          DIV  AB
          ADD  A,#30H
          INC  LCD_X
          PUSH  B
          MOV  B,LCD_X
          CALL  LCDP2
          POP  B
          INC  LCD_X
          MOV  A,B
          MOV  B,LCD_X
          ADD  A,#30H
          CALL  LCDP2
          RET

SHOW_DIG2L:                ;在 LCD 的第二行显示数字
          MOV  B,#100
          DIV  AB
          MOV  A,#0AH
          XCH  A,B
          DIV  AB
          ADD  A,#30H
          PUSH  B
          MOV  B,LCD_X
          CALL  LCDP2
          POP  B
          INC  LCD_X
          MOV  A,B
          MOV  B,LCD_X
          ADD  A,#30H
          CALL  LCDP2
          RET
;-------------------------------------------------------------
;显示区 BCD 码温度值刷新子程序
;-------------------------------------------------------------
DISPBCD:
              MOV  A,TEMPLC
              ANL  A,#0FH
              MOV  70H,A                 ;小数位
              MOV  A,TEMPLC
              SWAP  A
              ANL  A,#0FH
              MOV  71H,A                 ;个位
              MOV  A,TEMPHC
              ANL  A,#0FH
              MOV  72H,A                 ;十位
              MOV  A,TEMPHC
              SWAP  A
              ANL  A,#0FH
              MOV  73H,A                 ;百位
              MOV  A,TEMPHC
              ANL  A,#0F0H
              CJNE  A,#010H,DISPBCD0
              SJMP  DISPBCD2

DISPBCD0:     MOV  A,TEMPHC
              ANL  A,#0FH
              JNZ  DISPBCD2               ;十位数是0
              MOV  A,TEMPHC
              SWAP  A
              ANL  A,#0FH
              MOV  73H,#0AH               ;符号位不显示
              MOV  72H,A                  ;十位数显示符号
DISPBCD2:     RET

;==========================================================
; LCD 1602 显示子程序
;==========================================================
CONV:
          MOV  A,73H         ;加载百位数据
          MOV  LCD_X,#6      ;设置位置
          CJNE A,#1,CONV1
          JMP  CONV2
CONV1:    MOV  A,#" "
          MOV  B,LCD_X
          CALL  LCDP2
          JMP  CONV3
CONV2:    CALL  SHOW_DIG2    ;显示数据
CONV3:    INC  LCD_X             ;
          mov  a,72h         ;十位
          CALL  SHOW_DIG2
          inc  LCD_X
          mov  a,71h         ;个位
          CALL  SHOW_DIG2
          inc  LCD_X
          MOV  A,#'.'
          MOV  B,LCD_X
          CALL  LCDP2
          MOV  A,70h         ;加载小数点位
          INC  LCD_X         ;设置位置
          CALL  SHOW_DIG2    ;显示数据
          RET
;-------------------------------------------------------
SHOW_DIG2:                 ;在 LCD 的第二行显示数字
          ADD  A,#30H
          MOV  B,LCD_X
          CALL  LCDP2
          RET
;---------------------------------------------------------
LCDP2:                    ;在LCD的第二行显示字符
         PUSH  ACC        ;
         MOV  A,B         ;设置显示地址
         ADD  A,#0C0H     ;设置LCD的第二行地址
         CALL  WCOM       ;写入命令
         POP  ACC         ;由堆栈取出A
         CALL  WDATA      ;写入数据
         RET
;---------------------------------------------------------


SET_LCD:                     ;对 LCD 做初始化设置及测试
          CLR  LCD_EN
          CALL  INIT_LCD     ;初始化 LCD
          CALL  STORE_DATA   ;将自定义字符存入LCD的CGRAM
          RET
INIT_LCD:                  ;8位I/O控制 LCD 接口初始化
          MOV  A,#38H        ;双列显示，字形5*7点阵
          CALL  WCOM
          call  delay1
          MOV  A,#38H
          CALL  WCOM
          call  delay1

          MOV  A,#38H
          CALL  WCOM
          call  delay1
          MOV  A,#0CH        ;开显示，显示光标，光标不闪烁
          CALL  WCOM
          call  delay1
          MOV  A,#01H        ;清除 LCD 显示屏
          CALL  WCOM
          call  delay1
          RET
;==================================================
CLR_LINE1:                   ;清除LCD的第一行字符
          MOV  A,#80H        ;设置 LCD 的第一行地址
          CALL  WCOM         ;
          MOV  R0,#24        ;设置计数值
    C1:   MOV  A,#' '        ;载入空格符至LCD
          CALL  WDATA        ;输出字符至LCD
          DJNZ  R0,C1        ;计数结束
          RET
;==================================================
LCD_PRINT:       ;在LCD的第一行或第二行显示字符

          CJNE  A,#1,LINE2  ;判断是否为第一行
  LINE1:  MOV  A,#80H       ;设置 LCD 的第一行地址
          CALL  WCOM        ;写入命令
          CALL  CLR_LINE    ;清除该行字符数据
          MOV  A,#80H       ;设置 LCD 的第一行地址
          CALL  WCOM        ;写入命令
          JMP  FILL

  LINE2:  MOV  A,#0C0H      ;设置 LCD 的第二行地址
          CALL  WCOM        ;写入命令
          CALL  CLR_LINE    ;清除该行字符数据
          MOV  A,#0C0H      ;设置 LCD 的第二行地址
          CALL  WCOM
  FILL:   CLR  A            ;填入字符
          MOVC  A,@A+DPTR   ;由消息区取出字符
          CJNE  A,#0,LC1    ;判断是否为结束码
          RET
  LC1:    CALL  WDATA       ;写入数据
          INC  DPTR         ;指针加1
          JMP  FILL         ;继续填入字符
          RET
;=========================================
CLR_LINE:                  ;清除该行 LCD 的字符
          MOV  R0,#24
   CL1:   MOV  A,#' '
          CALL  WDATA
          DJNZ  R0,CL1
          RET
   DE:    MOV  R7,#250
          DJNZ  R7,$
          RET
;============================================
WCOM:                     ;以8位控制方式将命令写至LCD
          MOV  P0,A       ;写入命令
          CLR LCD_RS      ;RS=L,RW=L,D0-D7=指令码，E=高脉冲
          CLR LCD_RW
          SETB LCD_EN
          ACALL DELAY1        
          CLR LCD_EN
          RET
;=============================================
WDATA:                    ;以8位控制方式将数据写至LCD
          MOV  P0,A       ;写入数据
          SETB  LCD_RS        
          CLR  LCD_RW
          SETB  LCD_EN        
          CALL  DE
          CLR  LCD_EN
          CALL  DE
          RET
;=============================================
;PRINT A CHAR ON LINE 1
;A=ASC DATA, B=LINE X POS
;==============================================
LCDP1:                    ;在LCD的第一行显示字符
         PUSH  ACC        ;
         MOV  A,B         ;设置显示地址
         ADD  A,#80H      ;设置LCD的第一行地址
         CALL  WCOM       ;写入命令
         POP  ACC         ;由堆栈取出A
         CALL  WDATA      ;写入数据
         RET

;==============================================
BEEP_BL:
         MOV  R6,#100
 BL2:    CALL  DEX1
         CPL  BEEP
         DJNZ  R6,BL2
         MOV  R5,#10
         CALL  DELAY
         RET
 DEX1:   MOV  R7,#180
 DE2:    NOP
         DJNZ  R7,DE2
         RET
DELAY:                    ;(R5)*延时10MS
         MOV  R6,#50
 DL1:    MOV  R7,#100
         DJNZ  R7,$
         DJNZ  R6,DL1
         DJNZ  R5,DELAY
         RET

DELAY1:                    ;延时5MS
         MOV  R6,#25
 DL2:    MOV  R7,#100
         DJNZ  R7,$
         DJNZ  R6,DL2
         RET
;================================================
         END
