#ifndef _timer2_h_
#define _timer3_h_
#define Run0 P1_0 = ~P1_0

extern unsigned int addr0;

sbit P1_0 = P1^0;

void timer2_init(void)
{
 T2MOD = 0;

 //16位自动重装载模式，RCAP2HL为预设值
 RCAP2H = 0x0;
 RCAP2L = 0x0;
 TR2 = 1;

 ET2 = 1;
 //EXF2 = 1;

}

//定时中断服务
void Timer2(void) interrupt 5 using 2
{
	static unsigned char tmp=0;
	TF2 = 0;
	

	if(tmp++ > 2)
	{
		Run0;
		tmp = 0; 
		counter ++;
	}

}
#endif