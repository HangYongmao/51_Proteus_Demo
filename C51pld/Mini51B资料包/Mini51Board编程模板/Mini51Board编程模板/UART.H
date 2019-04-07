#ifndef __UART_H__
#define __UART_H__

//串口波特率初始化已经在AUTO_ISP.H中完成

//发送1字节
void uart_put_uchar(unsigned char c)
{
	SBUF = c;
    while(!TI);
    TI = 0;
}

//接收1字节
unsigned char uart_get_uchar(void)
{
     //while(!RI);//查询模式
     RI = 0;
     return SBUF;
}	 

#endif