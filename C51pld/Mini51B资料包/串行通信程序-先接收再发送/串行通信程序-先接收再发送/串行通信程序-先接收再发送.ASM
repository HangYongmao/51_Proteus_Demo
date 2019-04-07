            org  0000h
            mov  scon,#70h  ;设置成串口1方式,SM2=1,REN=1
            mov  tmod,#20h  ;波特率发生器T1工作在模式2上
            mov  pcon,#00h  ;波特率翻倍80H,不翻倍00H
			;晶振22.1184M，12T模式（STC单片机）
            mov  th1, #0fah ;预置初值(按照波特率9600BPS预置初值)
            mov  tl1, #0fah ;预置初值(按照波特率9600BPS预置初值)
            setb tr1        ;启动定时器T1
            clr  ti                
            clr  ri         ;启动数据接收
//==========================;以上完成通讯初始化设置

receive:    jnb  ri,$       ;判断是否接收到数据，如果没有，原地踏步
            mov  a,sbuf      
            clr  ri
send:       mov  sbuf,a
            cpl  a
			mov  p1,a       ;接收到的数据送P1口显示      
            jnb  ti,$        
			clr  ti
            ajmp receive                    
            end        
            
            
           
           
           
            
           
           
           
           
           
           
           
           
           
           