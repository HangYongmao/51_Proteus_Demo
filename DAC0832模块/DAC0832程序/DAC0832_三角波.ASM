;利用DAC0832产生三角波，程序如下：
;本程序中产生的电压的最大幅度受DAC0832的基准电压限制
;产生的的三角波周期受累加器A的控制，可以通过改变每次加的数值来改变周期，但连续性绘变差
;也可以改变延时时间来实现
;占用单元:A,DPTR
ORG 0000H
AJMP MAIN
ORG 0030H
MAIN: MOV DPTR,#7FFFH   ;置DAC0832入口地址
      MOV A,#00H        ;置初时值
LOOP1:MOVX @DPTR,A      ;送数字电压值
      INC A             ;加1
      NOP
      CJNE A,#0FFH,LOOP1;不等于50H转回去，生成三角波从低到高的这部分，否者向下
LOOP2:DEC A             ;减1
      MOVX @DPTR,A      ;送数字电压值
      CJNE A,#00H,LOOP2 ;不等于00H转回去，生成三角波从高到低的这部分，否者向下
      INC A             ;为了不让第二个周期产生于前一个周期的00H的数字电压重复
      NOP
      AJMP LOOP1        ;必须加1后在返回到LOOP1
      END

