;CLK0接2MHz的脉冲信号定时器/计数器0工作方式3，输出10KHz的方波，定时时间为100us
;CLK1接2MHz的脉冲信号定时器/计数器1工作方式3，输出1KHz的方波，定时时间为1000us
;CLK2接2MHz的脉冲信号定时器/计数器2工作方式3，输出100Hz的方波，定时时间为10000us
;计数初值=定时时间/(1/fclk)   
;占用单元A，DPTR
ORG 0000H
AJMP MAIN
ORG 0030H
MAIN:MOV DPTR,#7FFFH  ;写入控制字，设置为定时器/计数器0工作方式3
     MOV A,#036H
     MOVX @DPTR,A
     MOV DPTR,#7FFCH  ;写入计数初值：000CH，先低8位，后高8位
     MOV A,#0C8H
     MOVX @DPTR,A
     MOV A,#00H
     MOVX @DPTR,A
     MOV DPTR,#7FFFH  ;写入控制字，设置为定时器/计数器1工作方式3
     MOV A,#076H
     MOVX @DPTR,A
     MOV DPTR,#7FFDH  ;写入计数初值：07D0H，先低8位，后高8位
     MOV A,#0D0H
     MOVX @DPTR,A
     MOV A,#07H
     MOVX @DPTR,A
     MOV DPTR,#7FFFH  ;写入控制字，设置为定时器/计数器2工作方式3
     MOV A,#0B6H
     MOVX @DPTR,A
     MOV DPTR,#7FFEH  ;写入计数初值：4E20H，先低8位，后高8位
     MOV A,#20H
     MOVX @DPTR,A
     MOV A,#4EH
     MOVX @DPTR,A
     RET
