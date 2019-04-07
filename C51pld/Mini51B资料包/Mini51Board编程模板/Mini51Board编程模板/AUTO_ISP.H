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
 TL1 = 0xff; //22.1184M晶振，12T模式，波特率为115200
 TR1 =1;
 ES = 1;
 EA = 1; 
}


//自动ISP功能函数
void isp_check(unsigned char tmp)
{
    static isp_counter=0;
	uint j;
    unsigned char code isp_comm[16]={0x12,0x34,0x56,0x78,0x90,0xab,0xcd,0xef,0x12,0x34,0x56,0x78,0x90,0xab,0xcd,0xef};
    if(tmp != isp_comm[isp_counter++]) {
    	isp_counter = 0;  
    	return;
    }
    else if (isp_counter > 15) {
        EA = 0;     
        for(j=0;j<50000;j++);
        ISP_CONTR = 0x60; //软复位进入ISP下载模式   
    }   
}

//串口接收中断
void serial_int(void) interrupt 4
{ 
    unsigned char tmp;
	if (RI) 
    {
      tmp = SBUF;
	  isp_check(tmp); 	  
	  //USER代码区
      RI = 0;
    }
}

#endif 