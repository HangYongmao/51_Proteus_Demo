/****************************************************************
��ֲ��Ӳ������ע���޸�ReadTemperature()������ز��֣���������˵��
*****************************************************************/

#include "STC89C51RC.H"
#include "ds18b20.h"
#include <absacc.h>

#define seg1 XBYTE[0xffec]
#define seg2 XBYTE[0xffed]
#define seg3 XBYTE[0xffee]
#define seg4 XBYTE[0xffef]

sbit Run = P1^0;

unsigned char ledmap[]=		 //����LED����������
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
		seg1 = ~ledmap[temp/1000%10];
		seg2 = ~ledmap[temp/100%10+10];
		seg3 = ~ledmap[temp/10%10];
		seg4 = ~ledmap[temp%10];

		delay(50000);
	
	}

}

