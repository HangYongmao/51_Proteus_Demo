;本程序收发数据采用查询方式
ORG 0000H
AJMP START
ORG 0030H
START:MOV 30H,#0C0H   ;传送的16个数据(0～F)
      MOV 31H,#0F9H
      MOV 32H,#0A4H
      MOV 33H,#0B0H
      MOV 34H,#99H
      MOV 35H,#92H
      MOV 36H,#82H
      MOV 37H,#0F8H
      MOV 38H,#80H
      MOV 39H,#90H
      MOV 3AH,#88H
      MOV 3BH,#83H
      MOV 3CH,#0C6H
      MOV 3DH,#0A1H
      MOV 3EH,#086H
      MOV 3FH,#08EH
      MOV TMOD,#20H  ;定时器1置为方式2
      MOV TH1,#0F4H  ;装载定时器初值，波特率2400
      MOV TL1,#0F4H  
      CLR EA         
      SETB TR1       ;启动定时器
      MOV PCON,#00H  
      MOV SCON,#50H  ;设定串口方式1，且准备接收应答信号
LOOP1:MOV SBUF,#0E1H ;发联络信号
      JNB TI,$       ;等待一帧发送完毕
      CLR TI         ;允许再发送
      JNB RI,$       ;等待2号机的应答信号
      CLR RI         ;允许再接收
      MOV A,SBUF     ;2号机应答后，渎至A
      XRL A,#0E2H    ;判断2号机是否准备完毕
      JNZ LOOP1      ;2号机未准备好，继续联络
LOOP2:MOV R0,#30H    ;2号机准备好，设数据块指针初值
      MOV R7,#10H    ;设定数据块长度初值
      MOV R6,#00H    ;清校验和单元
LOOP3:MOV SBUF,@R0   ;发送一个数据字节
      MOV A,R6       
      ADD A,@R0      ;求校验和
      MOV R6,A       ;保存校验和
      INC R0
      JNB TI,$
      CLR TI
      DJNZ R7,LOOP3  ;整个数据块是否发送完毕
      MOV SBUF,R6    ;发送校验和
      JNB TI,$
      CLR TI
      JNB RI,$       ;等待2号机的应答信号
      CLR RI
      MOV A,SBUF     ;2号机应答，读至A
      JNZ LOOP2      ;2号机应答”错误“，转重新发送
      RET            ;2号机应答”正确“，返回                 
