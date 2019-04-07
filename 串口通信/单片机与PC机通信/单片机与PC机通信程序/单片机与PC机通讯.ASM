;本程序用来判断接收数据和发送数据是否一致
ORG 0000H
AJMP MAIN
ORG 0030H
MAIN:MOV TMOD,#20H   ;在11.0592MHz下，串行接口波特率
     MOV TH1,#0FDH   ;9600bps,方式3
     MOV TL1,#00H
     MOV PCON,#00H
     SETB TR1
     MOV SCON,#0D8H
LOOP:JBC RI,RECEIVE  ;接收到数据后立即发出
     SJMP LOOP
RECEIVE:
     MOV A,SBUF      ;接收
     MOV SBUF,A      ;发送
SEND:JBC TI,SENDEND
     SJMP SEND
SENDEND:
     SJMP LOOP
     END
