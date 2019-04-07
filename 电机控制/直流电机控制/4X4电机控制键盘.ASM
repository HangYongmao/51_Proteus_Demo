KEYBUF   EQU   40H        ;键号存放单元
         ORG 0000H
         LJMP MAIN
         ORG 0030H
MAIN:    MOV KEYBUF,#0    ;初始键号设位0，也可以为任意值
;===============================================
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
         MOV KEYBUF,#10       ;否者判断为3号键
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
         MOV KEYBUF,#6
         AJMP DK
NK9:     CJNE A,#0D0H,NK10
         MOV KEYBUF,#7
         AJMP DK
NK10:    CJNE A,#0B0H,NK11
         MOV KEYBUF,#8
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
QI_OR_TING:?????
SHE_DING:?????
JIA_SU:?????
JIAN_SU:?????
ZHENG_OR_FAN:?????
QING_CHU:?????

;=============================================
;延时程序和查表表格
DELY10ms:MOV R6,#20       ;延时10毫秒
D2:      MOV R7,#1248
         DJNZ R7,$
         DJNZ R6,D2
         RET

TABLE:   DB 07H, 04H, 01H  ;启/停 本表格是以键盘为参考  7   8   9   加速
         DB 08H, 05H, 02H，00H  ;                       4   5   6   减速
         DB 09H, 06H, 03H   ;设定                       1   2   3   正反转
         DB;加速 减速 正反转 清除                     启/停 0  设定 清除
         END
