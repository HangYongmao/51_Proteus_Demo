 ORG 0000H
SL      EQU   30H              ; SL存放秒的个位数
SH  EQU   31H              ; SH存放秒的十位数
ML      EQU   32H              ; ML存放分的个位数
MH      EQU   33H              ; MH存放分的十位数
HL      EQU   34H              ; HL存放时的个位数
HH  EQU   35H             ; HH存放时的十位数
;
L0      EQU   36H              ; L0~L3:显示数据存储器
L1  EQU   37H
L2      EQU   38H
L3  EQU   39H
DSPLYP  EQU   3AH              ; 显示数据指针(DISPLAY-POINT)
PLYTS   EQU   3BH              ; 显示次数计数器(DISPLAY-TIMES)
;
LPLMOD  BIT   39H              ; 低两位显示方式(LOW-PLAY-MOD)
HPLMOD  BIT   3AH              ; 高两位显示方式(HIGH-PLAY-MOD)
BRIGHT  BIT   3BH              ; DISPLAY子程序参数:亮灭指示位
;
TCOUNT  EQU   3CH              ; 时间计数器(TIME-COUNT)
;
ADDRES  EQU   3DH              ; 加1子程序参数
MAX     EQU   3EH              ; 加1子程序参数
IFDEC   BIT   20H              ; BCD加法子程序参数
;
R_MOD   EQU   3FH              ; 响铃方式参数
;
LED4    BIT   30H              ; 发光管状态位
BELL    BIT   P1.7             ; 蜂鸣器
SWITCH  BIT   P3.7             ; 继电器
FKEY    BIT   P3.0             ; 功能键 （S1）
MKEY    BIT   P3.1             ; 修改键 （S2）
;
WORKIN  BIT   38H              ; 工作状态指示位
;

                         SJMP START
                         ORG 000BH

                         LJMP LOOP1
                         ;ORG 001BH
    ;LJMP INT_1

ORG 001BH

 JNB P0.6,YINYUE1  ;低音乐
 LJMP DIANZIQIN1

ORG 0030H

              DIANZIQIN1:
               ;JB P0.1,ZIJIDE
               JnB P3.6,HUAN   ;高主
                ;YINYUE1:ljmp YINYUE11
              ZIJIDE:;CLR P2.0
              LJMP INT_1
              HUAN:LJMP DIANZIQIN
               YINYUE1:INC 20H ;中断服务,中断计数器加1
                       MOV TH1,#0D8H
                      MOV TL1,#0EFH ;12M晶振，形成10毫秒中断
                        RETI

                        START: LJMP  MAIN             ; 0000H  引向主程序
    LJMP  ERR              ; 0003H
    NOP
    NOP
    LJMP  ERR              ; 引向出错处理程序
   LOOP1: LJMP  PGT0             ; 000BH  引向中断处理程序PGT0
    NOP
    NOP
    LJMP  ERR              ; 引向出错处理程序
   LOOP2: LJMP  ERR              ; 0013H  INT1
    NOP
    NOP
    LJMP  ERR
   LOOP3:LJMP  ERR              ; 001BH  T1
    NOP
    NOP
    LJMP  ERR
   LOOP4:LJMP  ERR              ; 0023H
    NOP
    NOP
    LJMP  ERR
    LJMP  ERR              ; 002BH
    NOP
    NOP
;
;************
;   主程序  ;
;************
MAIN: JNB P0.6,CCC
  LJMP DIANZIQIN
;CCC:LJMP YINYUE

 CCC:MOV   IE,#00H          ; 关中断
    MOV   SP,#57H          ; 设置堆栈指针
    MOV   PSW,#00H         ; 选用寄存器组0
    MOV   TMOD,#11H        ; 设定中断工作方式为T0和T1
    ;
    MOV   A,56H
    CJNE  A,#0AAH,CSTART   ; 判上电复位标志，无标志转冷启动
    MOV   A,57H
    CJNE  A,#55H,CSTART    ; 无标志转冷启动
    AJMP  HSTART           ; 有上电复位标志转热启动
    NOP
    NOP
    LJMP  ERR              ; 软件陷阱,引向出错处理程序
CSTART: MOV   P1,#0FFH         ; 冷启动,全面初始化
    MOV   P3,#0FFH
    MOV   TCON,#00H        ; 计时停止
    MOV   TL0,#0B0H        ; 赋中断T0初值
    MOV   TH0,#3CH
    MOV   TCOUNT,#0AH      ; 赋定时器初值
    MOV   R5,#00H          ; R5为一空单元(备用)
    MOV   R4,#00H          ; R4 为工作模式选择寄存器
    MOV   SL,#00H          ; 定时单元清零
    MOV   SH,#00H          ; 秒
    MOV   ML,#00H          ;
    MOV   MH,#00H          ; 分
    MOV   HL,#00H          ;
    MOV   HH,#00H          ; 时
    MOV   PLYTS,#64H       ; 赋显示次数初值为100次
    MOV   DSPLYP,#L0       ; 显示指针指向显存单元
    MOV   L0,#0AH          ; 送显示数据"-----"
    MOV   L1,#0AH
    MOV   L2,#0AH
    MOV   L3,#04H
    SETB  LED4             ; LED4为数码管之间的发光二极管
    SETB  LPLMOD           ; 设定显示方式为闪烁
    SETB  HPLMOD           ;
    SETB  BRIGHT           ; 允许显示
    CLR   WORKIN          ; 清工作标志 , 待命
    AJMP  SETUP            ; 转开始工作
    NOP
    NOP
    LJMP  ERR              ; 软件陷阱
HSTART: MOV   SCON,#00H        ; 有上电标志,热启动,清串行口控制寄存器
    MOV   IP,#00H          ; 清中断优先控制寄存器
    SETB  FKEY             ; 重设按键
    SETB  MKEY
    SETB  EA               ; 开中断
    AJMP  BEGIN            ; 转向继续工作
    NOP
    NOP
    LJMP  ERR              ; 软件陷阱
SETUP:  SETB  EA               ; 开中断
;
MAIN1:  ACALL DISPLY           ; 调用显示
    JB    FKEY,JUDGE       ; 按键扫描
    ACALL KEYDLY           ; 延时消抖动
    JB    FKEY,JUDGE       ; 无键按下转向判断是否到点
    CLR   ET0              ; 功能键被按下,则
    CLR   TR0          ; 暂停计时
    ACALL MENU             ; 调用菜单设置程序
BEGIN:  SETB  WORKIN           ; 置工作标志位,开始工作
    SETB  ET0              ; 开中断
    SETB  TR0              ; 开始计时
    MOV   A,R4             ; 移入工作模式选择
    RL    A         ; 指针放大
    MOV   DPTR,#M_TAB
    JMP   @A+DPTR          ; 根据工作模式跳转到相应程序段
M_TAB:  AJMP  WORK1
    AJMP  WORK2
    AJMP  WORK3
    AJMP  WORK4
    NOP
    NOP
    LJMP  ERR              ; 软件陷阱
WORK1:  ;
WORK2:  CLR   SWITCH           ; 工作方式1和2:开继电器
    AJMP  MAIN2
    NOP
    NOP
    LJMP  ERR              ; 软件陷阱
WORK3:  ;
WORK4:  SETB  SWITCH           ; 工作方式3和4:不开继电器
MAIN2:  CLR   BELL             ; 蜂鸣器短鸣一声,以示开始工作
    ACALL DL05S
    SETB  BELL
JUDGE:  JNB   WORKIN,MAIN1     ; 判断是否在定时之中
    MOV   A,SL             ; 判断秒是否为零
    JNZ   MAIN1
    MOV   A,SH             ; 判断秒是否为零
    JNZ   MAIN1
    MOV   A,ML             ; 判断分是否为零
    JNZ   MAIN1
    MOV   A,MH             ; 判断分是否为零
    JNZ   MAIN1
    MOV   A,HL             ; 判断时是否为零
    JNZ   MAIN1
    MOV   A,HH             ; 判断时是否为零
    JNZ   MAIN1            ; 若时分秒全为零则
    CLR   ET0              ; 停止计时
    CLR   TR0              ;


    ACALL ACTION          ; 调用到点工作子程序

    AJMP  MAIN             ; 返回
    NOP
    NOP
    LJMP  ERR              ; 软件陷阱
    ;
;******************
;    倒计时程序   ;
;******************
PGT0:   CLR   EA               ; 关中断
    PUSH  ACC          ; 保护现场
    PUSH  PSW
    PUSH  DPL
    PUSH  DPH
    MOV   PSW,#08H        ; 选用寄存器组1
    CLR   TR0              ; 暂停计时
    MOV   A,#0B7H          ; 中断同步修正
    ADD   A,TL0
    MOV   TL0,A
    MOV   A,#3CH
    ADD   A,TH0
    MOV   TH0,A
    SETB  TR0              ; 恢复计时
    DEC   TCOUNT           ; 定时器T0每50 000毫秒溢出一次,则
    MOV   A,TCOUNT         ; 溢出10次为0.5秒
    JNZ   OUTT0        ; 判断是否到半秒
    MOV   TCOUNT,#0AH      ;
    CPL   LED4         ; 若到半秒LED取反
    JNB   LED4,OUTT0       ; LED每闪烁一次是一秒
    MOV   R0,#SH           ; 移入秒位的地址
    SETB  IFDEC            ; BCD子程序参数,使其做减法
    ACALL ADDBCD           ; 调用BCD子程序, 秒减1
    CJNE  R3,#99H,OUTT0    ; 判断秒要否借位
    MOV   SH,#05H          ; 要借位则
    MOV   SL,#09H          ; 送数据59(否则显示99)
    MOV   R0,#MH           ; 移入分位的地址
    ACALL ADDBCD          ; 分减1
    CJNE  R3,#99H,OUTT0    ; 判断分要否借位
    MOV   MH,#05H
    MOV   ML,#09H
    MOV   R0,#HH
    ACALL ADDBCD
OUTT0:  POP   DPH         ; 恢复现场
    POP   DPL
    POP   PSW
    POP   ACC
    SETB  EA

    RETI                   ; 中断返回
    NOP
    NOP
    LJMP ERR               ; 软件陷阱
    ;
;
;**************************
;   BCD子程序(加1或减1 )  ;
;**************************
ADDBCD: MOV   A,@R0            ; 移入被操作数的高位
    DEC   R0               ; 指针减一
    SWAP  A
    ORL   A,@R0            ; 移入被操作数的低位
    MOV   B,#01H           ; B寄存器送立即数#01H
    MOV   C,IFDEC          ; 若减法标志位为1,则
    MOV   B.3,C            ;
    MOV   B.4,C            ; B寄存器的值被改为#99H
    MOV   B.7,C            ;
    ADD   A,B              ; 对一个压缩的BCD码加#99H等于对其减一
    DA    A                ; BCD码调整
    MOV   R3,A             ; 暂存结果
    ANL   A,#0FH           ; 取低位码
    MOV   @R0,A            ; 存数
    MOV   A,R3             ; 取回结果
    INC   R0               ; 指针加一
    SWAP  A                ; 交换
    ANL   A,#0FH           ; 取结果数的高位
    MOV   @R0,A            ; 存数
    RET
    NOP
    NOP
    LJMP  ERR              ; 软件陷阱
;
;**************
;   加1程序   ;
;**************
ADDONE: MOV   R0,ADDRES        ; 移入被加数单元的地址
    CLR   IFDEC            ; 设定BCD子程序做加法
    ACALL ADDBCD           ; 调用BCD子程序
    CLR   C                ; 判断被加数是否大于
    MOV   A,R3             ; 最大值"MAX"
    CJNE  A,MAX,JGOVER
JGOVER: JC    ENDADO
    CLR   A                ; 若大于"MAX",则清零
    MOV   @R0,A
    DEC   R0
    MOV   @R0,A
ENDADO: RET
    NOP
    NOP
    LJMP  ERR              ; 软件陷阱
;
;******************
;   调时快进程序  ;
;******************
QUICK:  CLR   LPLMOD         ; 设定显示方式不闪烁
    CLR   HPLMOD
    ACALL ADDONE           ; 调用加1子程序
    MOV   L0,R4            ; 将工作模式选择数移入显存
    INC   L0               ; 加1转化成显示值
    ACALL KEYDLY           ; 延时
    ACALL DL100
    JNB   MKEY,QUICK       ; 判断键是否松开
    SETB  LPLMOD           ; 若松开则恢复闪烁显示方式
    CJNE  R6,#02H,ENDQUK
    SETB  HPLMOD
    CLR   LPLMOD
ENDQUK: RET
    NOP
    NOP
    LJMP  ERR              ; 软件陷阱
;
;
;******************
;   功能菜单程序  ;
;******************
MENU:   MOV   R6,#00H        ; 初始化;  R6 计功能键按键次数
    MOV   ADDRES,#05H      ; 将 R5 的地址送入，以便于改变 R4 的值
    MOV   MAX, #04H        ; 定义工作模式选择寄存器R4 的最大值
    MOV   DSPLYP,#L0       ; 定义显示指针指向显存
    SETB  LPLMOD          ; 设定低两位数闪烁
    CLR   HPLMOD
    MOV   L0,R4            ; 送显示数据"F-0X"
    INC   L0
    MOV   L1,#00H
    MOV   L2,#0BH
    MOV   L3,#00H
    SETB  LED4
;
WAITFK: ACALL DISPLY           ; 等待F键释放
        JNB   FKEY,WAITFK
MENU1:  ACALL DISPLY
    JB    MKEY,JGFKEY      ; M键扫描
    ACALL KEYDLY           ; 延时消抖动
    JB    MKEY,JGFKEY      ; 未按下则转F键扫描
    CJNE  R6,#00H,NEXT1    ;
    MOV   SL,#00H          ; 若中途改变定时方式,则清除原计时数据
    MOV   SH,#00H
    MOV   ML,#00H
    MOV   MH,#00H
    MOV   HL,#00H
    MOV   HH,#00H
NEXT1:  MOV   R2,#00H          ; R2用于判断按键时间是否超过0.5秒
NEXT2:  ACALL ADDONE           ; 调用加1程序
    MOV   L0,R4            ; 移入工作方式选择数
    INC    L0
    ;
WAITMK: ACALL DISPLY         ; 等待M键释放
    INC   R2               ; R2自增一
    CLR   C
    CJNE  R2,#0C8H,JGQUIC  ; 若R2大于等于200则调用快进子程序
JGQUIC: JC    WATMK1
        ACALL QUICK
WATMK1: JNB   MKEY,WAITMK      ; R2小于200则等待M键释放
;
JGFKEY: JB    FKEY,MENU1       ; 功能(F)键扫描
    ACALL KEYDLY           ; 延时消抖动
    JB    FKEY,MENU1       ; 键未按下则转修改(M)键扫描
    INC   R6               ; F键按键次数加1
    MOV   A,R6             ; 移入按键次数
    RL    A            ; 指针放大
    MOV   DPTR,#FUNTAB
    JMP   @A+DPTR          ; 根据按键次数跳转到相应的程序段
FUNTAB: AJMP  WAITFK
    AJMP  SETLOW
    AJMP  SETHI
    AJMP  ENDMEN
    NOP
    NOP
    AJMP  ENDMEN
;STWKMD:                       ; 工作模式设定,不需另外改变菜单
;
SETLOW: MOV   MAX,#60H         ; 设置低位(秒位或分位)
    MOV   A,R4             ; 移入工作模式选择数
    RL    A            ; 指针放大
    MOV   DPTR,#FTAB1
    JMP   @A+DPTR          ; 根据工作模式选择数跳转到相应的程序段
FTAB1:  AJMP  SETSS
    AJMP  SETM60
    AJMP  SETSS
    AJMP  SETM60
    NOP
    NOP
    AJMP  WAITFK
SETSS:    MOV   DSPLYP,#SL       ; 设定显示区域为MM:SS
    MOV   ADDRES,#SH
    AJMP  WAITFK
SETM60:   MOV   DSPLYP,#ML       ; 设定显示区域为HH:MM
    MOV   ADDRES,#MH
    AJMP  WAITFK
;
SETHI:    CLR   LPLMOD           ; 设置高位(分位或时位)
    SETB  HPLMOD           ; 高两位数码管闪烁
    MOV   MAX,#31H         ; 最大数为30
    MOV   A,R4             ; 移入工作模式选择数
    RL    A                ; 指针放大
    MOV   DPTR,#FTAB2      ; 移入表首地址
    JMP   @A+DPTR          ; 根据工作模式选择数跳转到相应的程序段
FTAB2:  AJMP  SETM30
    AJMP  SETHH
    AJMP  SETM30
    AJMP  SETHH
    NOP
    NOP
    AJMP  WAITFK           ; 返回等待键释放
SETM30: MOV   ADDRES,#MH       ; 移入分位的地址
        AJMP  WAITFK           ; 转向等待键释放
SETHH:  MOV   ADDRES,#HH       ; 移入时位的地址
    AJMP  WAITFK           ; 转向等待键释放
;
ENDMEN: CLR   HPLMOD           ; 恢复不闪烁显示方式
    RET
    NOP
    NOP
    LJMP  ERR              ; 软件陷阱
;
;****************
;  到点工作程序 ;
;****************
ACTION: MOV   L0,R4            ; 移入工作模式选择数
    INC   L0               ; 送显示数"F-0X"
    MOV   L1,#00H
    MOV   L2,#0BH
    MOV   L3,#00H
    SETB  LED4
    MOV   DSPLYP,#L0       ; 指针指向显存
    SETB  LPLMOD           ; 设定显示方式不闪烁
    SETB  HPLMOD
    MOV   A,R4             ; 移入工作模式选择数
    RL    A                ;
    MOV   DPTR,#A_TAB
    JMP   @A+DPTR          ; 根据工作模式选择数跳转
A_TAB:  AJMP  ACTF1            ; 工作模式一
    AJMP  ACTF1            ; 工作模式二
    AJMP  ACTF3            ; 工作模式三
    AJMP  ACTF3            ; 工作模式四
    NOP
    NOP
    LJMP  ERR              ; 软件陷阱
ACTF1:  SETB  SWITCH           ; 工作模式一(或二): 开继电器
 LJMP AAA
    BBB: MOV   R_MOD,#82H       ; 响铃模式参数#82H
    MOV   R2,#96H          ; 响铃次数参数#96H
ACTF11: ACALL RING           ; 调用响铃子程序
    JNB   MKEY,ENDACT      ; 等待键按下
    JNB   FKEY,ENDACT      ; 有键按下则结束响铃
    DJNZ  R2, ACTF11       ; 次数未满继续响铃
    MOV   R_MOD,#0FFH      ; 参数#0FF使响铃无效
    AJMP  ACTF11           ; 无键按下返回
    NOP
    NOP
    LJMP  ERR              ; 软件陷阱
ACTF3:  CLR   SWITCH           ; 工作模式三(或四): 开继电器
    CLR   BELL             ; 蜂鸣器短鸣一声
    ACALL DL1S
    SETB  BELL
    MOV   R_MOD,#0FFH      ; 响铃模式参数#0FFH
    MOV   R2,#96H          ; 响铃时间参数#96H
ACTF31: ACALL RING        ; 调用响铃子程序
    JNB   MKEY,ENDACT      ; 等待键按下
    JNB   FKEY,ENDACT      ; 有键按下则结束
    DJNZ  R2,ACTF31        ; 次数未满继续
    MOV   R2,#96H          ; 重新赋值
    CLR   BELL             ; 短鸣一声(说明: 响铃模式参数#0FFH使
    ACALL DL100            ; 响铃程序无效,仅起延时作用,
    SETB  BELL             ; 每延时一段时间短鸣一声,以
    AJMP  ACTF31           ; 提醒使用者继电器仍在工作)
    NOP
    NOP
    LJMP  ERR              ; 软件陷阱
ENDACT: SETB  SWITCH           ; 关继电器
AWAITF: ACALL DISPLY           ; 调用显示
        JNB   FKEY,AWAITF      ; 等待键释放
AWAITM: ACALL DISPLY           ; 调用显示
    JNB   MKEY,AWAITM      ; 等待键释放
    RET
    NOP
    NOP
    LJMP  ERR              ; 软件陷阱
    ;
;**************
;   响铃程序  ;
;**************
RING:   MOV   R5,#18H          ; R5为循环控制变量
RING1:  JNB   MKEY,R_EXIT      ; 键扫描
    JNB   FKEY,R_EXIT      ; 有键按下则退出
    MOV   A,R_MOD          ; 移入响铃模式参数
    MOV   C,ACC.7          ; 根据响铃模式参数改变响铃
    MOV   BELL,C
    RL    A
    MOV   R_MOD,A
    ACALL DL100            ; 延时
    DJNZ  R5,RING1         ; 循环次数控制
R_EXIT: SETB  BELL             ; 关闭响铃
    RET
    NOP
    NOP
    LJMP ERR               ; 软件陷阱
;
;**************
;   显示程序  ;
;**************
DISPLY: PUSH  ACC              ; 数据压栈保护
    PUSH  PSW
    MOV   PSW,#10H         ; 选用寄存器组2
    MOV   R0,DSPLYP        ; 移入显示指针
    MOV   R2,#0FDH         ; R2寄存的是数码管选通数
    MOV   A,PLYTS          ; 移入显示循环控制量
    JNZ   PLAY             ; 不为0则转PLAY
    MOV   PLYTS,#64H       ; 否则从新赋值
    CPL   BRIGHT           ; 亮灭指示位取反
PLAY:   DEC   PLYTS            ; 显示循环控制量减1
    JNB   LPLMOD,PLAYL     ; 低两位数码管不闪则"PLAYL"
    JB    BRIGHT,PLAYL     ; 亮灭指示为1也"PLAYL"
    ACALL NOPLAY           ; 否则灭灯延时
    AJMP  PLAY1            ; 转显示高位数码管
    NOP
    NOP
    LJMP ERR               ; 软件陷阱
;用来显示低位
PLAYL:  ORL   P1,#7FH          ; 清原显示数据
    ORL   P3,#3CH          ; 清原选通数据
    MOV   A,R2             ; 移入数码管位选数
    RL    A                ; 换一位
    ANL   P3,A             ; 选通低位的个位数码管
    MOV   R2,A             ; 暂存位选数
    MOV   A,@R0            ; 移入显示数值
    MOV   DPTR,#TABLE1     ; 移入表首地址
    MOVC  A,@A+DPTR        ; 查表
    ANL   P1,A             ; 送显示数据
    ACALL DL1MS            ; 延时
    INC   R0               ; 指向低位的十位数
    JB    P3.3,PLAYL       ; 显示低位的十位数
;
PLAY1:  JNB   HPLMOD,PLAYH     ; 高两位数码管不闪则"PLAYH"
    JB    BRIGHT,PLAYH     ; 亮灭指示为1也"PLAYH"
    ACALL NOPLAY           ; 否则灭灯延时
    AJMP  OUTPLY           ; 转结束
    NOP
    NOP
    LJMP ERR               ; 软件陷阱
;
;用来显示高位
PLAYH:  ORL   P1,#7FH          ; 清原显示数据
    ORL   P3,#3CH          ; 清原选通数据
    ANL   P3,#0EFH         ; 选通高位的个位数数码管
    MOV   A,@R0            ; 移入显示数值
    MOV   DPTR,#TABLE1     ; 移入表首地址
    MOVC  A,@A+DPTR        ; 查表
    ANL   P1,A             ; 送显示数据
    ACALL DL1MS            ; 延时
    INC   R0               ; 指向高位的十位数
    ;                      ; 显示高位的十位数
    ORL   P1,#7FH          ; 清原显示数据
    ORL   P3,#3CH          ; 清原选通数据
    ANL   P3,#0DFH         ; 选通高位的十位数
    MOV   A,@R0            ; 移入显示数值
    MOV   C,LED4          ; 指针放大＋小灯状态
    RLC   A                ;
    MOV   DPTR,#TABLE2     ; 移入表首地址
    MOVC  A,@A+DPTR        ; 查表
    ANL   P1,A             ; 送显示数据
    ACALL DL1MS            ; 延时
;
OUTPLY: POP   PSW              ; 恢复数据
    POP   ACC
    RET
    NOP
    NOP
    LJMP ERR               ; 软件陷阱
;
TABLE1: DB  0C0H,0F9H,0A4H,0B0H, 99H, 92H, 82H,0F8H, 80H, 90H,0BFH, 8EH,0FFH
;           "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "-", "F", " "
;
TABLE2: DB  0FFH, 0DFH, 0F9H, 0D9H, 0A4H,  84H, 0B0H,  90H, 0BFH, 09FH
;    "  ",  " :",   "1 ",  "1:",  "2 ",    "2:",  "3 ",  "3:",  "- ",  "-:"
;
;
;
;**********************
;    无显示(灭灯)程序   ;
;**********************
NOPLAY: ORL   P1,#7FH          ; 清显示数据
    ORL   P3,#3CH          ; 清选通数据
    INC   R0               ; 指针自增2
    INC   R0
    ACALL DL1MS            ; 延时
    RET
    NOP
    NOP
    LJMP  ERR              ; 软件陷阱
    ;
;******************
;     延时程序    ;
;******************
DL1MS:  MOV   R3,#0F9H         ; 延时 1250US  只为DISPLY所调用
DL1MS1: NOP
    NOP
    NOP
    DJNZ  R3,DL1MS1
    RET
    NOP
    NOP
    LJMP  ERR              ; 软件陷阱
    ;
KEYDLY: CLR   BELL        ; 按键消抖动专用延时程序,
    ACALL DISPLY           ; 在消除抖动的同时发出按键提示音
    SETB  BELL
    RET
    NOP
    NOP
    LJMP ERR               ; 软件陷阱
;
DL50MS: MOV   R7,#0AH          ; 50毫秒延时程序
DL50M1: ACALL DISPLY         ; 每调用一次显示程序5MS
    DJNZ  R7,DL50M1        ; 调用10次
    RET
    NOP
    NOP
    LJMP  ERR              ; 软件陷阱
;
DL100:  ACALL DL50MS           ; 延时100毫秒
    ACALL DL50MS
    RET
    NOP
    NOP
    LJMP  ERR              ; 软件陷阱
;
DL05S:  ACALL DL100            ; 延时0.5秒
    ACALL DL100
    ACALL DL100
    ACALL DL100
    ACALL DL100
    RET
    NOP
    NOP
    LJMP  ERR              ; 软件陷阱
    ;
DL1S:   ACALL DL05S            ; 延时1秒
    ACALL DL05S
    RET
    NOP
    NOP
    LJMP  ERR              ; 软件陷阱
    ;
;****************************
;     ERR(出错处理) 程序    ;
;****************************
ERR:    CLR   EA               ; 关中断
    MOV   DPTR,#ERR1       ; 准备返回地址
    PUSH  DPL              ; 压栈
    PUSH  DPH              ;
    RETI                   ; 中断返回
ERR1:   MOV   56H,#0AAH        ; 建立上电标志(出错标志)
    MOV   57H,#55H
    MOV   A,#00H           ; 准备返回地址
    PUSH  ACC              ; 压栈
    PUSH  ACC
    RETI                   ; 中断返回
    NOP
    NOP
    LJMP  ERR              ; 软件陷阱
;
    ORG   07FAH
    NOP
    NOP
    NOP
    LJMP  ERR              ; 软件陷阱
    ;AAA:JNB P0.6,CCC
    ;CCC:LJMP YINYUE

                          ;LJMP DIANZIQIN
                  DIANZIQIN:;MOV P0,#00H
                         ;clr p3.6
                        ;setb P0.1
                         SETB EA
                         SETB ET1                       ;计数器0
                         MOV TMOD,#20H
                         MOV TH1,#09CH
                         MOV TL1,#09CH                 ;定时器初植
                         CLR TR1                        ;定时器不允许
                  SCAN:                                 ;键盘扫描
                         MOV A,P2                   ;判断键盘按下，跳到SCAN_1，若未按，继续扫描
                         CJNE A,#0FFH,SCAN_1
                         NOP

                         SJMP SCAN
                  SCAN_1:
                         ACALL DELAY ;是不是真的要按下？如果是，则跳转SU_KEY查询是哪个按下？
                         MOV A,P2
                         CJNE A,#0FFH,SU_KEY
                         NOP
                         SJMP SCAN
                  SU_KEY:JNB P0.6,LOOP11
                         ;SJMP LOOP2
                   ;LOOP11:LJMP AAA
                         JNB P2.1,MU_1                  ;判断是哪个键按下？
                         JNB P2.2,MU_2
                         JNB P2.3,MU_3
                         JNB P2.4,MU_4
                         JNB P2.5,MU_5
                         JNB P2.6,MU_6
                         JNB P2.7,MU_7
                         SJMP SCAN
                  LOOP11:LJMP AAA
                                                           ;R1信号周期
                  MU_1:  MOV R1,#19                ;如果第一个按键按下，则R1=19，同时程序转NEXT
                         SJMP NEXT
                  MU_2:  MOV R1,#17
                         SJMP NEXT
                  MU_3:  MOV R1,#15
                         SJMP NEXT
                  MU_4:  MOV R1,#14
                         SJMP NEXT
                  MU_5:  MOV R1,#13
                         SJMP NEXT
                  MU_6:  MOV R1,#11
                         SJMP NEXT
                  MU_7:  MOV R1,#10
                         SJMP NEXT
                  NEXT:  MOV A,R1
                         MOV R0,A
                         SETB TR1                      ;启动定时器0

                  NEXT_1:MOV A,P2                     ; 没键按下继续执行，有键按下，返回读引脚
                         CJNE A,#0FFH,NEXT_1
                         ACALL DELAY
                         MOV A,P2                       ;真的没键按下？
                         CJNE A,#0FFH,NEXT_1
                         CLR TR1                        ;不响
                         AJMP SCAN                     ;扫描键盘去
                  INT_1:                                 ;中断程序
                        DJNZ R0,RE                      ;R0不等于0时，返回
                        CPL P0.0
                        MOV A,R1
                        MOV R0,A
                  RE:   RETI
                  DELAY:MOV R7,#100                    ;延长时间等待，键盘消抖
                  D1:   MOV R6,#10
                  D2:   DJNZ R6,D2
                        DJNZ R7,D1
                        ;LJMP BBB
                        RET


     AAA:
     SETB P3.6
 ;CLR P0.6
MOV SP,#50H
MOV TH1,#0D8H
MOV TL1,#0EFH
MOV TMOD,#10H
MOV IE,#88H
 LJMP TIAO
MUSIC0:;JB P0.6,QIN


;LJMP BBB
TIAO:
NOP
MOV DPTR,#DAT ;表头地址送DPTR
MOV 20H,#00H ;中断计数器清0
MOV B,#00H ;表序号清0
MUSIC1:
 ;JnB P0.1,duan
NOP
CLR A
MOVC A,@A+DPTR ;查表取代码
JZ END0 ;是00H,则结束
CJNE A,#0FFH,MUSIC5
LJMP MUSIC3
 duan:ljmp BBB
MUSIC5:
NOP
MOV R6,A
INC DPTR
MOV A,B
MOVC A,@A+DPTR ;取节拍代码送R7
MOV R7,A
SETB TR1 ;启动计数
MUSIC2:

 ;clr P3.6
NOP
CPL P0.0
MOV A,R6
MOV R3,A
LCALL DEL
MOV A,R7
CJNE A,20H,MUSIC2 ;中断计数器(20H)=R7否?
;不等,则继续循环
 ;JB P0.6,QIN
;jb p0.6,QIN
;jnb p0.4,ting
MOV 20H,#00H ;等于,则取下一代码
INC DPTR
  ;JB P0.6,QIN
; INC B
LJMP MUSIC1
;ting:ljmp BBB
;QIN:CLR TR1
 ;QIN:LJMP DIANZIQIN
;DIANZIQIN
MUSIC3:
NOP
CLR TR1 ;休止100毫秒
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
MOV R2,#64H ;歌曲结束,延时1秒后继续
MUSIC6:
MOV R3,#00H
LCALL DEL
DJNZ R2,MUSIC6
LJMP MUSIC0
DEL:
NOP
DEL3:
MOV R4,#02H
DEL4:
NOP
DJNZ R4,DEL4
NOP
DJNZ R3,DEL3
RET
NOP
DAT:
db 26h,20h,20h,20h,20h,20h,26h,10h,20h,10h,20h,80h,26h,20h,30h,20h
db 30h,20h,39h,10h,30h,10h,30h,80h,26h,20h,20h,20h,20h,20h,1ch,20h
db 20h,80h,2bh,20h,26h,20h,20h,20h,2bh,10h,26h,10h,2bh,80h,26h,20h
db 30h,20h,30h,20h,39h,10h,26h,10h,26h,60h,40h,10h,39h,10h,26h,20h
db 30h,20h,30h,20h,39h,10h,26h,10h,26h,80h,26h,20h,2bh,10h,2bh,10h
db 2bh,20h,30h,10h,39h,10h,26h,10h,2bh,10h,2bh,20h,2bh,40h,40h,20h
db 20h,10h,20h,10h,2bh,10h,26h,30h,30h,80h,18h,20h,18h,20h,26h,20h
db 20h,20h,20h,40h,26h,20h,2bh,20h,30h,20h,30h,20h,1ch,20h,20h,20h
db 20h,80h,1ch,20h,1ch,20h,1ch,20h,30h,20h,30h,60h,39h,10h,30h,10h
db 20h,20h,2bh,10h,26h,10h,2bh,10h,26h,10h,26h,10h,2bh,10h,2bh,80h
db 18h,20h,18h,20h,26h,20h,20h,20h,20h,60h,26h,10h,2bh,20h,30h,20h
db 30h,20h,1ch,20h,20h,20h,20h,80h,26h,20h,30h,10h,30h,10h,30h,20h
db 39h,20h,26h,10h,2bh,10h,2bh,20h,2bh,40h,40h,10h,40h,10h,20h,10h
db 20h,10h,2bh,10h,26h,30h,30h,80h,00H

END
