#ifndef _timer1_h_
#define _timer1_h_

//定时器1初始化,串口波特率初始化
//自动ISP功能模块
void timer1_init(void)
{
 //定时器1工作在模式2，8Bit自动重装载模式
 TMOD = (TMOD & 0X0F) | 0X20;  
 SCON = 0x50;
 PCON |= 0x80;//波特率翻倍
 TH1 = 0xff;
 TL1 = 0xff; 
 TR1 =1;
 ES = 1;
 EA = 1; 
}

void delay(unsigned int time)
{
	while(--time);
}

//自动ISP功能函数
void ISP_Check(unsigned char tmp)
{
    static isp_counter=0;
    unsigned char code isp_comm[16]={0x12,0x34,0x56,0x78,0x90,0xab,0xcd,0xef,0x12,0x34,0x56,0x78,0x90,0xab,0xcd,0xef};
    if(tmp != isp_comm[isp_counter++]) {
    	isp_counter = 0;  
    	return;
    }
    else if (isp_counter > 15) {
      EA = 0;
	  delay(10000);
      ISP_CONTR = 0x60; //软复位进入ISP下载模式   
    }   
}

//串口接收中断
void Serial_int(void) interrupt 4 using 1
{ 
    unsigned char tmp;
	unsigned char xdata *pbuf;
//	static unsigned int i = 0;

	pbuf = 0;
	if (RI) 
    {
      tmp = SBUF;
	  ISP_Check(tmp); 
 /*
	  if(riflag==0x7e)
	  {
	  	*(pbuf+i)=tmp;
		if((++i)>640) i=0 ;
	  }	  
*/
	  //USER代码区
      RI = 0;
    }
}

#endif 