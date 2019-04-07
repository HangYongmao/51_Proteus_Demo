#include "Mini51B.H"   //所有与硬件相关的接口函数定义
#include "AUTO_ISP.H"  //自动ISP初始化,占用timer1
#include "UART.H"      //串口驱动函数
#include "LCD1602.H"   //LCD1602驱动函数
#include "LCD12864.H"  //LCD12864驱动函数
#include "DS1302.H"	   //DS1302实时时钟驱动函数
#include "STCEEPROM.H" //EEPROM读写函数
#include "IRM.H"       //红外解码驱动函数
#include <stdio.h>	   //C标准函数库，系统集成

#include "logo_stuelab.h"

SYSTEMTIME RTC;

//中断入口申明，不用最好预留
void extern0_ISR() interrupt 0{}
void timer0_ISR () interrupt 1{}
void extern1_ISR() interrupt 2{}
void timer1_ISR () interrupt 3{}
//void serial_ISR () interrupt 4{} AUTO ISP占用
//void extern2_ISR() interrupt 6{} IRM占用
void extern3_ISR() interrupt 7{}


void main()
{	
	float V;
	uint DACD;
	uchar i,temp;


	uchar str_buff[20];//字符缓冲区
	timer1_init();//AUTO ISP初始化
	extern2_init();//红外解码

/*****************蜂鸣器测试*****************/
//*
	BEEP_ON();
	delay_ms(100);
	BEEP_OFF();
/********************************************/

/**************STCEEPROM测试*****************/	
//每次开机，数码管显示计数加1
//EEPROM58在STCEEPROM.H中定义
	temp = byte_read(EEPROM58);
	if(temp!=0xff) 
	{
		seg7_disp(temp++);
		sector_erase(EEPROM58);
		byte_write(EEPROM58,temp);
	}
	else byte_write(EEPROM58,0);


	array_write(EEPROM58+10,1,&temp);
	array_read(EEPROM58,1,&temp);
/********************************************/	

/***************LCD1602测试******************/
//*此部分注销只要删除前面一位斜线
	lcd1602_init();
	lcd_put_xyns(2,1,14,"www.stuelab.cn");
/********************************************/

/***************LCD12864测试*****************/
//*此部分注销只要删除前面一位斜线
	lcd12864_init();	
	lcd12864_put_xywhb(0,0,128,64,stuelab);		
	delay_ms(1000);
	lcd12864_clr();
	lcd12864_put_xyns(1,0,6,hanzi1);
	lcd12864_put_xyns(0,1,12,hanzi2);
	lcd12864_put_xyns(0,3,8,hanzi3);
/********************************************/

/**************LCD12864打点测试**************/
//*
	lcd12864_init();	
	lcd12864_clr();

	for(i=0;i<64;i++)
	{
		lcd12864_set_xy(i,i);		
	}

	for(i=64;i<128;i++)
	{
		lcd12864_set_xy(i,128-i);		
	}	
/********************************************/

/*****************继电器测试*****************/
//*
	JDQ_CLOSE();  //继电器吸合
	delay_ms(100);
	JDQ_OPEN();   //继电器打开
/********************************************/

/***************时钟测试*********************/	
	Initial_DS1302();
/*时间设定,执行一次后删除该部分
	Write1302(DS1302_MINUTE, 0x40);	
	Write1302(DS1302_HOUR,   0x16);		
	Write1302(DS1302_DAY,    0x10);
	Write1302(DS1302_MONTH,  0x08);
	Write1302(DS1302_YEAR,   0x07);	
/********************************************/	

	while(1)
	{
		DS1302_GetTime(&RTC);
		DateToStr(&RTC);
		TimeToStr(&RTC);
		//lcd_put_xyns(6,1,8,RTC.DateString);
		lcd_put_xyns(1,2,8,RTC.TimeString);			
		
		if(!KEY0)
		{
			DACD+=10;
			put5615_data(DACD);//DAC输出
		}		
		
		V = get1549_data();//读ADC
		V = V/200;
		sprintf(str_buff,"%3.2f",V);//格式转换
		lcd_put_xyns(16,2,1,"V");	
		lcd_put_xyns(12,2,4,str_buff);

		seg7_disp(irm_code); //数码管显示红外按键解码值
		uart_put_uchar(irm_code);//串口发送红外解码值

		temp = uart_get_uchar();//此函数为查询模式，要是串口没有数据发送，程序会停在此处

		delay_ms(100);		
	}	
}

