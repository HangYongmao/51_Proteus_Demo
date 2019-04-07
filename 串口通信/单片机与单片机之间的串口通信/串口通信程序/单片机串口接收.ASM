     ORG 0000H
     AJMP MAIN
     ORG 30H
MAIN:MOV SP,#5FH
;-------------------------------------;
     ACALL INIT_RS232 ;调用INIT_232子程序
     CPL P1.0         ; P0.0亮表示正在设定串口
     CALL DELAY
     CPL P1.0         ;P0.0暗表示设定完成
     MOV DPTR,#tab    ;只需要设一次就可以了
;------手动控制闪烁子程序-------------
WAIT:
     JNB RI,WAIT;接收电脑发过来的数据
     ClR RI     ;清RI，继续下次接收。
     MOV A,SBUF ;接收到数据应当尽快去处理，不要等待，以免接下来的数据将有用数据覆盖
     MOVC A,@A+DPTR  ;提取字模
     SETB P1.1
     MOV P0,A        ;送出显示数据
     CLR P1.1        ;p0.1亮表示正在接收资料
     JMP WAIT        ;循环

INIT_RS232:               ;RS232初始化设定
     MOV TMOD,#20H        ;2400bs,晶振11.0592MHz
     MOV TH1,#0E8H
     SETB TR1
     MOV SCON,#01010000B
     RET

delay:MOV R5,#20
   D2:MOV R6,#50
   D1:MOV R7,#250
      DJNZ R7,$
      DJNZ R6,D1
      DJNZ R5,D2
      RET
tab:  DB  0c0H,0f9H,0a4H,0b0h,99h  ;"0","1","2","3","4"
      DB   92H, 82H,0f8H, 80H,90h  ;"5","6","7","8","9'
      DB   88H, 83H, 46H,0a1H,86h  ;"a","b","c","d" ,"e"
      DB   8eh ;"F"
      END
