;占用单元30H~3CH,40H,A,B,DPTR,R0,R1,R2,R3,R4,R6,R7
  KEYBUF EQU 40H          ;键号存放单元
         ORG 0000H
         LJMP MAIN
         ORG 0030H
MAIN:    MOV KEYBUF,#0    ;初始键号设位0，也可以为任意值
         MOV R0,#30H      ;显示首地址
         MOV R2,#0CH      ;计算数据存放单元个数
         CLR A
QING:    MOV @R0,A        ;将数据存放单元清零
         INC R0
         DJNZ R2,QING
         MOV P0,#8FH      ;关闭显示
         MOV R1,#30H      ;将显示首地址存放R1里
;===============================================
;五位无符号显示子程序
DIS1:    MOV R0,#30H      ;把显示数据第一位放在R0里
         MOV R2,#04H      ;把显示的位码放在R2里
         MOV R3,#05H      ;把显示的长度放在R3里
DIS2:    MOV A,@R0
         ANL A,#0FH       ;屏蔽显示数据的高四位
         MOV B,A
         MOV A,R2
         ANL A,#0FH       ;屏蔽位码的高四位
         SWAP A
         ORL A,B
         MOV P0,A         ;送总显示数据到P0显示
         LCALL DELY4ms    ;调用延时4ms
         INC R0           ;取下一个显示数据
         DEC R2
         DJNZ R3,DIS2     ;四位显示晚后重新开始显示
;===================================================
;键盘扫描子程序
WAIT:    MOV P1,#0FFH        ;P1口送高电平
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
         AJMP SAN_CHU
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
         MOV KEYBUF,#10
         AJMP DK
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
         MOV KEYBUF,#6
         AJMP DK
NK9:     CJNE A,#0D0H,NK10
         MOV KEYBUF,#7
         AJMP DK
NK10:    CJNE A,#0B0H,NK11
         MOV KEYBUF,#8
         AJMP DK
NK11:    CJNE A,#70H,NK12
         AJMP DENG_HAO
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
         AJMP CHU
NK13:    CJNE A,#0D0H,NK14
         AJMP CHENG
NK14:    CJNE A,#0B0H,NK15
         AJMP JIAN
NK15:    CJNE A,#70H,NK16
         AJMP JIA
NK16:    NOP

;=======================================================
;查表求键值程序
;查表求键值程序
DK:      MOV B,#00H
         MOV A,KEYBUF         ;查表程序 查对应的键号数据
         MOV DPTR,#TABLE      ;把表头地址放入DPTR
         MOVC A,@A+DPTR       ;A里面存放的为键号,利用A和表头地址找到对应的键号数据
         MOV B,A              ;把查到的数据送往显示单元
         INC R1               ;取下一个显示单元
         MOV A,R1
         CJNE A,#36H,DKA1     ;判断显示单元是否已满
         MOV R1,#35H          ;35H,36H单元用于更好的控制五位显示
         AJMP DKA

DKA1:    MOV 34H,33H          ;按键代码按左移显示，先按先显示
         MOV 33H,32H
         MOV 32H,31H
         MOV 31H,30H
         MOV 30H,B
DKA:     MOV A,P1             ;读P1口
         ANL A,#0F0H          ;屏蔽高四位
         XRL A,#0F0H          ;地位是有低电平
         JNZ DKA              ;如果有低电平继续读P1口,否者向下执行,查找第二行
NOKEY4:  LJMP DIS1
;===================================
;功能按键功能设定
DENG_HAO:MOV DPTR,#JI_SUAN    ;等号键功能通过加、减、乘、除设定的偏移量来调用子程序
         MOV A,3CH            ;3CH存放的为功能程序入口地址偏移量
         JMP @A+DPTR          ;转移到按键功能程序

JI_SUAN: AJMP JIA1            ;加计算子程序
         AJMP JIAN1           ;减计算子程序
         AJMP CHENG1          ;乘计算子程序
         AJMP CHU             ;除计算子程序
;=======删除键功能
SAN_CHU: ACALL QING_DIS
         AJMP DKA
;=======加键功能
JIA:     MOV 3CH,#00H
         ACALL CUN_SHU
         ACALL QING_DIS
         AJMP DKA
;=======减键功能
JIAN:    MOV 3CH,#02H
         ACALL CUN_SHU
         ACALL QING_DIS
         AJMP DKA
;=======乘键功能
CHENG:   MOV 3CH,#04H
         ACALL CUN_SHU
         ACALL QING_DIS
         AJMP DKA
;=======除键功能
CHU:     MOV 3DH,#06H
         ACALL CUN_SHU
         ACALL QING_DIS
         AJMP DKA

;=================================
;存被加（减、乘、除）数，存放在37H~3BH里
CUN_SHU: MOV 37H,30H    ;36H存放的为最低位
         MOV 38H,31H
         MOV 39H,32H
         MOV 3AH,33H
         MOV 3BH,34H    ;3AH存放的为最高位
         RET
;================================
;清除显示单元
QING_DIS: MOV R1,#30H
QING1:    MOV @R1,#00H
          INC R1
          MOV A,R1
          CJNE A,#36H,QING1
          MOV R1,#30H
LOP1:     RET
;================================
;十进制加法子程序
JIA1:    ;??????
         AJMP DKA
;================================
;十进制减法子程序
JIAN1:   ;??????
         AJMP DKA
;================================
;十进制乘法子程序
CHENG1:  ;??????
         AJMP DKA
;================================
;十进制除法子程序
CHU1:    ;??????
         AJMP DKA
;=============================================
;延时程序和查表表格
DELY4ms: MOV R6,#8        ;延时4毫秒
D1:      MOV R7,#248
         DJNZ R7,$
         DJNZ R6,D1
         RET

DELY10ms:MOV R6,#20       ;延时10毫秒
D2:      MOV R7,#248
         DJNZ R7,$
         DJNZ R6,D2
         RET

TABLE:   DB 07H, 04H, 01H  ; /   本表格是以键盘为参考   7   8   9   /
         DB 08H, 05H, 02H  ; *                          4   5   6   *
         DB 09H, 06H, 03H  ; -                          1   2   3   -
         DB 00H, 00H ;=      +                         清除 0   =   +
         END
