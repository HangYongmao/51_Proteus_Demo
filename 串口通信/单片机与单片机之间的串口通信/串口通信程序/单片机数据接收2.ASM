;本程序收发数据采用查询方式
ORG 0000H
AJMP START
ORG 0030H
START:MOV TMOD,#20H  ;定时器1置为方式2
      MOV TH1,#0F4H  ;装载定时器初值，波特率2400
      MOV TL1,#0F4H  
      CLR EA         
      SETB TR1       ;启动定时器
      MOV PCON,#00H  
      MOV SCON,#50H  ;设定串口方式1，且准备接收
LOOP1:JNB RI,$       ;等待1号机的联络信号
      CLR RI
      MOV A,SBUF     ;收到1号机信号
      XRL A,#0E1H    ;判是否为1号机联络信号
      JNZ LOOP1      ;不是一号机联络信号，再等待
      MOV SBUF,#0E2H ;是1号机联络信号，发应答信号
      JNB TI,$
      CLR TI
      MOV R0,#30H    ;设定数据快地址指针初值
      MOV R7,#10H    ;设定数据块长度初值
      MOV R6,#00H    ;清校验和单元
LOOP2:JNB RI,$
      CLR RI
      MOV A,SBUF
      MOV @R0,A      ;接收数据转储
      INC R0
      ADD A,R6       ;求校验和
      MOV R6,A
      DJNZ R7,LOOP2  ;判断数据块是否接收完毕

      JNB RI,$       ;完毕，接收1号机发来的校验和
      CLR RI
      MOV A,SBUF
      XRL A,R6       ;比较校验和
      JZ END1        ;校验和相等，跳至发正确标志
      MOV SBUF,#0FFH ;校验和不相等，发错误标志
      JNB TI,$       ;转重新接收
      CLR TI
      SJMP LOOP2
END1: MOV SBUF,#00H
JS1:  MOV R0,#30H     ;显示接到的数据
JS3:  MOV A,@R0
      MOV P0,A
      ACALL DELAY
      INC R0
      MOV A,R0
      CJNE A,#40H,JS2
      AJMP JS1
JS2:  AJMP JS3

DELAY: MOV  R4,#04H
   D1: MOV  R7,#0FFH
   D2: MOV  R6,#0FFH
       DJNZ R6,$
       DJNZ R7,D2
       DJNZ R4,D1
       RET
       END            
