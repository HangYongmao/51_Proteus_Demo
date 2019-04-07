/*一个机器周期采样值为1,下一个机器周期采样为0,则计数器加1*/
/*外部事件的最高计数频率为晶振的1/24,故最高计数为0.9216M;*/
/*目前状态下只是显示0到9999HZ的频率*/
/*原创作者：陈永刚*/
/*优化整理：tiansir*/

/*测频率原理*/
/*定时器T0作为定时装置，编程设定定时1s，定时器T1对外部信号计数，每1S中对计数结果处理*/

#include<reg51.h> 
#include<absacc.h>

#define SEG_Q XBYTE[0xfcec]
#define SEG_B XBYTE[0xfced]
#define SEG_S XBYTE[0xfcee]
#define SEG_G XBYTE[0xfcef]  

//通用数码管显示函数，传入数据0～9999
void renew_disp(unsigned int number)
{
	unsigned char code tab1[10]={0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xf8,0x80,0x90};
	unsigned char temp,flag=0;

	if(number < 10000)
	{		
		//千位数码管
		temp = number/1000%10;
		if (temp)
		{
			SEG_Q = tab1[temp];
			flag = 1;	
		}
		else 
		{
			SEG_Q = 0xff;//数码管熄灭
			flag = 0;	
		}

		//百位数码管
		temp = number/100%10;		
		if(flag | temp)
		{
			SEG_B = tab1[temp];
			flag = 1;	
		}
		else 
		{
			SEG_B = 0xff;//数码管熄灭
			flag = 0;	
		}					
		
		//十位数码管
		temp = number/10%10;
		if(flag | temp) SEG_S = tab1[temp];		
		else SEG_S = 0xff;//数码管熄灭		
		
		//个位数码管
		temp = number%10;	
		SEG_G = tab1[temp];
	}
	else
	{
		SEG_Q = 0xbf;
		SEG_B = 0xbf;
		SEG_S = 0xbf;
		SEG_G = 0xbf;	
	}
}

//T0定时中断，晶振22.1184M
void T0_int(void) interrupt 1
{   
	static char counter=0;	
	TH0=(65536-46063)/256;
    TL0=(65536-46063)%256;
	if(counter++==39)	   	     
    { 
		counter=0; 
	   	TR1=0;	   	
		renew_disp(256*TH1+TL1);
		TH1=TL1=0;		
		TR1=1;	  
	}	 
}

void main()
{ 
   	TMOD = 0x51;/*01010001 T1计数,T0定时*/
   	TH1 = 0;
   	TL1 = 0;   	 
	//晶振22.1184M
   	TH0 = (65536-46063)/256;//定时25MS
   	TL0 = (65536-46063)%256; 
   	TR0 = 1;		//开定时器0
   	TR1 = 1;		//启动计时器1
   	EA  = 1; 		//开总中断
   	ET0 = 1;		//开定时器0中断
   	while(1);		//原地踏步，等待中断
}