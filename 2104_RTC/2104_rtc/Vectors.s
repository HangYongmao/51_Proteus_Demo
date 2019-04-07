;**--------------文件信息--------------------------------------------------------------------------------
;**文   件   名: vectors.s
;**描        述: lpc210x异常向量入口及异常向量与c语言代码的接口，包括初始化堆栈的代码
;********************************************************************************************************/

;定义堆栈的大小
USR_STACK_LEGTH     EQU         64
SVC_STACK_LEGTH     EQU         0
FIQ_STACK_LEGTH     EQU         16
IRQ_STACK_LEGTH     EQU         64
ABT_STACK_LEGTH     EQU         0
UND_STACK_LEGTH     EQU         0


;引入的外部标号在这声明
    IMPORT  FIQ_Exception                   ;快速中断异常处理程序
    IMPORT  Reset

;给外部使用的标号在这声明
    EXPORT  InitStack
    EXPORT  Vectors


    CODE32

    AREA    Startup,CODE,READONLY

;中断向量表
Vectors
        LDR     PC, ResetAddr
        LDR     PC, UndefinedAddr
        LDR     PC, SWI_Addr
        LDR     PC, PrefetchAddr
        LDR     PC, DataAbortAddr
        DCD     0xb9205f80
        LDR     PC, [PC, #-0xff0]
        LDR     PC, FIQ_Addr

ResetAddr           DCD     Reset
UndefinedAddr       DCD     Undefined
SWI_Addr            DCD     SoftwareInterrupt
PrefetchAddr        DCD     PrefetchAbort
DataAbortAddr       DCD     DataAbort
Nouse               DCD     0
IRQ_Addr            DCD     0
FIQ_Addr            DCD     FIQ_Handler

;未定义指令
Undefined
        B       Undefined

;软中断
SoftwareInterrupt
        B       SoftwareInterrupt

PrefetchAbort
        B       PrefetchAbort

;取数据中止
DataAbort
        B       DataAbort


;快速中断
FIQ_Handler
        STMFD   SP!, {R0-R3, LR}
        BL      FIQ_Exception
        LDMFD   SP!, {R0-R3, LR}
        SUBS    PC,  LR,  #4

;/*********************************************************************************************************
;** 函数名称: InitStack
;** 功能描述: 初始化堆栈
;** 输　入:   无
;** 输　出 :  无
;** 全局变量: 无
;** 调用模块: 无
;********************************************************************************************************/
InitStack    
        MOV     R0, LR   ;保存程序返回值，bx指令会将pc复制给lr=r14，pc=r15

;设置管理模式堆栈
        MSR     CPSR_c, #0xd3 ;模式切换，管理模式
        LDR     SP, StackSvc
;设置中断模式堆栈
        MSR     CPSR_c, #0xd2 ;模式切换，中断模式
        LDR     SP, StackIrq
;设置快速中断模式堆栈
        MSR     CPSR_c, #0xd1 ;模式切换，快速中断模式
        LDR     SP, StackFiq
;设置中止模式堆栈
        MSR     CPSR_c, #0xd7 ;模式切换，异常中止模式
        LDR     SP, StackAbt
;设置未定义模式堆栈
        MSR     CPSR_c, #0xdb ;模式切换，未定义模式
        LDR     SP, StackUnd
;设置系统模式堆栈
        MSR     CPSR_c, #0xdf ;模式切换，系统模式
        LDR     SP, StackUsr

        MOV     PC, R0   ;断点返回

StackUsr           DCD     UsrStackSpace + (USR_STACK_LEGTH - 1) * 4
StackSvc           DCD     SvcStackSpace + (SVC_STACK_LEGTH - 1)* 4
StackIrq           DCD     IrqStackSpace + (IRQ_STACK_LEGTH - 1)* 4
StackFiq           DCD     FiqStackSpace + (FIQ_STACK_LEGTH - 1)* 4
StackAbt           DCD     AbtStackSpace + (ABT_STACK_LEGTH - 1)* 4
StackUnd           DCD     UndtStackSpace + (UND_STACK_LEGTH - 1)* 4


;/* 分配堆栈空间 */
        AREA    MyStacks, DATA, NOINIT, ALIGN=2
UsrStackSpace      SPACE   USR_STACK_LEGTH * 4  ;用户（系统）模式堆栈空间
SvcStackSpace      SPACE   SVC_STACK_LEGTH * 4  ;管理模式堆栈空间
IrqStackSpace      SPACE   IRQ_STACK_LEGTH * 4  ;中断模式堆栈空间
FiqStackSpace      SPACE   FIQ_STACK_LEGTH * 4  ;快速中断模式堆栈空间
AbtStackSpace      SPACE   ABT_STACK_LEGTH * 4  ;中止义模式堆栈空间
UndtStackSpace     SPACE   UND_STACK_LEGTH * 4  ;未定义模式堆栈

    END
;/*********************************************************************************************************
;**                            End Of File
;********************************************************************************************************/
