/****************************************************************
移植到硬件环境注意修改ReadTemperature()函数相关部分，程序中有说明
*****************************************************************/

#include "STC89C51RC.H"
#include "ds18b20.h"
#include <absacc.h>

#define seg1 XBYTE[0xffec]
#define seg2 XBYTE[0xffed]
#define seg3 XBYTE[0xffee]
#define seg4 XBYTE[0xffef]


unsigned char ledmap[]=		 //共阴LED数码管译码表
{	
	0x3f,0x06,0x5b,0x4f,0x66,	//0,1,2,3,4,
	0x6d,0x7d,0x07,0x7f,0x6f,	//5,6,7,8,9,		
	0xbf,0x86,0xdb,0xcf,0xe6,	//0.,1.,2.,3.,4.,
	0xed,0xfd,0x87,0xff,0xef,	//5.,6.,7.,8.,9.,	
};

void delay(unsigned int time)
{				  
	while(--time);
}


main()
{
	unsigned int temp;
	
	Init_DS18B20();
	delay(5000);	

	while(1)
	{
		
		temp = ReadTemperature();//*5;

		if(flag_Negative_number)seg1 = 0xbf;
		else seg1 = 0xff;

		seg2 = ~ledmap[temp/100%10];
		seg3 = ~ledmap[temp/10%10+10];
		seg4 = ~ledmap[temp%10];

		delay(50000);
	
	}

}

