;**--------------�ļ���Ϣ--------------------------------------------------------------------------------
;**��   ��   ��: vectors.s
;**��        ��: lpc210x�쳣������ڼ��쳣������c���Դ���Ľӿڣ�������ʼ����ջ�Ĵ���
;********************************************************************************************************/

;�����ջ�Ĵ�С
USR_STACK_LEGTH     EQU         64
SVC_STACK_LEGTH     EQU         0
FIQ_STACK_LEGTH     EQU         16
IRQ_STACK_LEGTH     EQU         64
ABT_STACK_LEGTH     EQU         0
UND_STACK_LEGTH     EQU         0


;������ⲿ�����������
    IMPORT  FIQ_Exception                   ;�����ж��쳣�������
    IMPORT  Reset

;���ⲿʹ�õı����������
    EXPORT  InitStack
    EXPORT  Vectors


    CODE32

    AREA    Startup,CODE,READONLY

;�ж�������
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

;δ����ָ��
Undefined
        B       Undefined

;���ж�
SoftwareInterrupt
        B       SoftwareInterrupt

PrefetchAbort
        B       PrefetchAbort

;ȡ������ֹ
DataAbort
        B       DataAbort


;�����ж�
FIQ_Handler
        STMFD   SP!, {R0-R3, LR}
        BL      FIQ_Exception
        LDMFD   SP!, {R0-R3, LR}
        SUBS    PC,  LR,  #4

;/*********************************************************************************************************
;** ��������: InitStack
;** ��������: ��ʼ����ջ
;** �䡡��:   ��
;** �䡡�� :  ��
;** ȫ�ֱ���: ��
;** ����ģ��: ��
;********************************************************************************************************/
InitStack    
        MOV     R0, LR   ;������򷵻�ֵ��bxָ��Ὣpc���Ƹ�lr=r14��pc=r15

;���ù���ģʽ��ջ
        MSR     CPSR_c, #0xd3 ;ģʽ�л�������ģʽ
        LDR     SP, StackSvc
;�����ж�ģʽ��ջ
        MSR     CPSR_c, #0xd2 ;ģʽ�л����ж�ģʽ
        LDR     SP, StackIrq
;���ÿ����ж�ģʽ��ջ
        MSR     CPSR_c, #0xd1 ;ģʽ�л��������ж�ģʽ
        LDR     SP, StackFiq
;������ֹģʽ��ջ
        MSR     CPSR_c, #0xd7 ;ģʽ�л����쳣��ֹģʽ
        LDR     SP, StackAbt
;����δ����ģʽ��ջ
        MSR     CPSR_c, #0xdb ;ģʽ�л���δ����ģʽ
        LDR     SP, StackUnd
;����ϵͳģʽ��ջ
        MSR     CPSR_c, #0xdf ;ģʽ�л���ϵͳģʽ
        LDR     SP, StackUsr

        MOV     PC, R0   ;�ϵ㷵��

StackUsr           DCD     UsrStackSpace + (USR_STACK_LEGTH - 1) * 4
StackSvc           DCD     SvcStackSpace + (SVC_STACK_LEGTH - 1)* 4
StackIrq           DCD     IrqStackSpace + (IRQ_STACK_LEGTH - 1)* 4
StackFiq           DCD     FiqStackSpace + (FIQ_STACK_LEGTH - 1)* 4
StackAbt           DCD     AbtStackSpace + (ABT_STACK_LEGTH - 1)* 4
StackUnd           DCD     UndtStackSpace + (UND_STACK_LEGTH - 1)* 4


;/* �����ջ�ռ� */
        AREA    MyStacks, DATA, NOINIT, ALIGN=2
UsrStackSpace      SPACE   USR_STACK_LEGTH * 4  ;�û���ϵͳ��ģʽ��ջ�ռ�
SvcStackSpace      SPACE   SVC_STACK_LEGTH * 4  ;����ģʽ��ջ�ռ�
IrqStackSpace      SPACE   IRQ_STACK_LEGTH * 4  ;�ж�ģʽ��ջ�ռ�
FiqStackSpace      SPACE   FIQ_STACK_LEGTH * 4  ;�����ж�ģʽ��ջ�ռ�
AbtStackSpace      SPACE   ABT_STACK_LEGTH * 4  ;��ֹ��ģʽ��ջ�ռ�
UndtStackSpace     SPACE   UND_STACK_LEGTH * 4  ;δ����ģʽ��ջ

    END
;/*********************************************************************************************************
;**                            End Of File
;********************************************************************************************************/
