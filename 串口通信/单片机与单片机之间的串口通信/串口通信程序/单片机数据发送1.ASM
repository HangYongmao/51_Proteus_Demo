ORG 0000H
AJMP MAIN
ORG 0030H
MAIN:MOV 30H,#0C0H
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
     MOV SCON,#80H;设定串口为工作方式2
     MOV PCON,#00H;波特率为fosc/64
     MOV R0,#30H  ;设置发送数据指针
     MOV R3,#10H  ;设置数据块长度
XHA: MOV A,@R0    ;取出待发送的数据
     MOV C,PSW.0
     MOV TB8,C    ;奇偶位送TB8
     MOV SBUF,A   ;发送数据                    
LOOP:JBC TI,ZZ1   ;判断一帧数据是否发送完成
     AJMP LOOP    ;没发送完继续发送
ZZ1: INC R0       ;发送完一字节取下一个数据
     DJNZ R3,XHA  ;判断16个数据是否发送完
     END

