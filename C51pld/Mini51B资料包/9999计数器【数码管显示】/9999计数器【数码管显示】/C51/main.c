#include "STC89C51RC.H"//STC单片机头文件，相当与一般51的reg51.h
#include <absacc.h>

#define SEG1 XBYTE[0xffec]
#define SEG2 XBYTE[0xffed]
#define SEG3 XBYTE[0xffee]
#define SEG4 XBYTE[0xffef]

unsigned char ledmap[]=	 //共阴LED数码管译码表
{	
	0x3f,0x06,0x5b,0x4f,0x66,	//0,1,2,3,4,
	0x6d,0x7d,0x07,0x7f,0x6f,	//5,6,7,8,9,		
	0xbf,0x86,0xdb,0xcf,0xe6,	//0.,1.,2.,3.,4.,
	0xed,0xfd,0x87,0xff,0xef,	//5.,6.,7.,8.,9.,	
};


unsigned int counter;

void timer2_init(void)
{
 T2MOD = 0;
 //16位自动重装载模式，RCAP2HL为预设值
 RCAP2H = 0x0;
 RCAP2L = 0x0;
 TR2 = 1;
 ET2 = 1;
}

//定时中断服务
void Timer2(void) interrupt 5 using 2
{
	static unsigned char time=0;
	TF2 = 0;
		
	RCAP2H = 0x0;
 	RCAP2L = 0x0;

	if(time++ > 10)//调整计数器速度
	{
		counter ++;
		SEG1 = ~ledmap[counter/1000%10];		
		SEG2 = ~ledmap[counter/100%10];
		SEG3 = ~ledmap[counter/10%10];
		SEG4 = ~ledmap[counter%10];
		time = 0; 
	}
}

main()
{
	timer2_init();
	EA = 1;
	while(1);
}



