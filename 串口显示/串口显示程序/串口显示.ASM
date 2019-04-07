;本电路占用了三条I/0口线：RXD、TXD、P1.0
;占用数据单元：R1、R2、20H、30H、31H、32H、33H
;R1:显单元地址存放单元
;R2:显示位数存放单元
;20H:4位显示器是否显示是否完成标志位存放单元
;入口：30H(低位)、31H、32H、33H(高位)即显示数值的偏移量存放单元
;本程序采用串口中断显示
;==================================================
ORG 0000H
AJMP MAIN
ORG 0023H
AJMP CHX1
ORG 0030H
MAIN:MOV 30H,#6
     MOV 31H,#8
     MOV 32H,#1
     MOV 33H,#5
     MOV SCON,#00H ;设置串行口为工作方式0
     SETB 20H      ;设置4位显示器是否显示是否完成标志
     MOV R2,#04H   ;设置显示位数
     CLR P1.0      ;关闭显示
     SETB EA       ;开中断总允许
     SETB ES       ;开串口中断允许
     MOV DPTR,#TAB ;取第一个显示段码
     MOV R1,#30H
     MOV A,@R1
     MOVC A,@A+DPTR;取显示段码
     MOV SBUF,A    ;段码送串行口
LOOP:JNB 20H,MAIN  ;根据标志位，判断4位显示器是否显示完成
     SJMP LOOP     ;等待中断

CHX1:CLR P1.0      ;中断服务程序开始显示器亮
     LCALL DELAY   ;调延时程序
     CLR TI        ;清发送中断标志
     INC R1
     MOV A,@R1
     MOVC A,@A+DPTR;取下一个显示段码
     DJNZ R2,LOOP1 ;判断4位显示器是否显示完成
     SETB P1.0     ;显示器灭
     CLR 20H       ;设置4位显示器显示完毕标志
     AJMP LOOP3    ;4位显示器没显示完返回
LOOP1:MOV SBUF,A   ;串行口输出
LOOP3:RETI         ;中断返回

TAB:  DB 03H,9FH,25H,0DH,99H,49H,41H,1FH,01H ;proteus仿真电路的(0～F)的代码
      DB 09H,11H,0C1H,63H,85H,61H,71H

DELAY:MOV R5,#10   ;延时5ms
   D1:MOV R6,#248
   D2:DJNZ R6,D2
      DJNZ R5,D1
      RET
      END
