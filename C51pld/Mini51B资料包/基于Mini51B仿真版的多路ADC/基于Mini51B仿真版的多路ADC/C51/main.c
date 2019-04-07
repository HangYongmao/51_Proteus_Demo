#include "STC89C51RC.H"//STC单片机头文件，相当与一般51的reg51.h
#include <absacc.h>
#include <stdio.h>


#define SEG1 XBYTE[0xffec]
#define SEG2 XBYTE[0xffed]
#define SEG3 XBYTE[0xffee]
#define SEG4 XBYTE[0xffef]
#define ADC XBYTE[0xffe0]

sbit  KEY0 = P3^5;
sbit  KEY1 = P3^4;
sbit  KEY2 = P3^3;
sbit  KEY3 = P3^2;//中断占用

unsigned char CH;//通道变量

unsigned char ledmap[]=		 //共阴LED数码管译码表
{	
	0x3f,0x06,0x5b,0x4f,0x66,	//0,1,2,3,4,
	0x6d,0x7d,0x07,0x7f,0x6f,	//5,6,7,8,9,		
	0xbf,0x86,0xdb,0xcf,0xe6,	//0.,1.,2.,3.,4.,
	0xed,0xfd,0x87,0xff,0xef,	//5.,6.,7.,8.,9.,	
};

extern void ext_int0_init(void);
extern void delay(unsigned int); 

main()
{
	ext_int0_init();
	CH = 0;
	EA = 1;	
	ADC = CH;	//首次启动ADC 
	while(1)
	{  	
		if(!KEY0)
		{
		  delay(10);
		  if(KEY0==0)
		  {			
			  CH++;
			  CH = CH%8;//通道选择
		  }
		  while(KEY0==0);
		}
	}
}

//外部中断0初始化
void ext_int0_init(void)
{
	IT0 = 1;//下降沿触发	
	EX0 = 1;//开外部中断
}

//外部中断函数
void ext_int0(void) interrupt 0 using 1
{
	unsigned int temp;

	temp = ADC;	//读ADC
	SEG1 = ~ledmap[CH];	//通道		
	
	//结果，未作任何处理	
	SEG2 = ~ledmap[temp/100%10];
	SEG3 = ~ledmap[temp/10%10];
	SEG4 = ~ledmap[temp%10];

	ADC = CH;	//选择当前通道启动ADC
}

//通用延时函数
void delay(unsigned int time)
{
	while(--time);
}

