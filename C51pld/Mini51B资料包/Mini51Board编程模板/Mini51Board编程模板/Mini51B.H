/*以下地址编排是基于CPLD的V2版*/
#ifndef __Mini51_Board_H__
#define __Mini51_Board_H__

#include <reg52.h>

#define uchar unsigned char
#define uint unsigned int

/*STC单片机特有寄存器定义*/
sfr P4  = 0xe8;
sfr XICON = 0xc0;/*外部中断扩展控制寄存器*/
sfr WDT_CONTR = 0xe1;/*看门狗定时器*/
/*ISP功能控制，读写EEPROM用到*/
sfr ISP_DATA  = 0xe2;
sfr ISP_ADDRH = 0xe3;
sfr ISP_ADDRL = 0xe4;
sfr ISP_CMD   = 0xe5;
sfr ISP_TRIG  = 0xe6;
sfr ISP_CONTR = 0xe7;

/*外部中断2、3控制位*/
sbit IT2 = XICON^0;
sbit IE2 = XICON^1;
sbit EX2 = XICON^2;
sbit PX2 = XICON^3;
sbit IT3 = XICON^4;
sbit IE3 = XICON^5;
sbit EX3 = XICON^6;
sbit PX3 = XICON^7;
/* Above is STC additional SFR */

/*蜂鸣器*/
sbit BEEP_PIN = P1^0;
#define BEEP_ON() BEEP_PIN = 0
#define BEEP_OFF() BEEP_PIN = 1

/*温度计DS18B20接口，V3取消了*/
sbit DS18B20_DQ = P1^1;

/*继电器*/
sbit JDQ_PIN = P1^2;
#define JDQ_CLOSE() JDQ_PIN = 0
#define JDQ_OPEN() JDQ_PIN = 1


/*串行ADC接口定义*/
sbit ADC_CS = P1^5;
sbit ADC_DA = P1^6;
sbit ADC_CK = P1^7;

/*串行DAC接口定义*/
sbit DAC_DA = P1^1;
sbit DAC_CK = P1^2;
sbit DAC_CS = P1^4;

/*P1口定义*/
sbit P10 = P1^0;
sbit P11 = P1^1;
sbit P12 = P1^2;
sbit P13 = P1^3;
sbit P14 = P1^4;
sbit P15 = P1^5;
sbit P16 = P1^6;
sbit P17 = P1^7;

/*按键定义*/
sbit KEY0 = P3^2;
sbit KEY1 = P3^3;
sbit KEY2 = P3^4;
sbit KEY3 = P3^5;

/*实时时钟*/
sbit  M51_DS1302_CK = P4^0; 
sbit  M51_DS1302_RT = P4^1;
sbit  M51_DS1302_IO = P4^2;

/*红外接收头*/
sbit M51_IRM_DQ = P4^3; 


/*数码管地址定义*/
uchar xdata SEG_Q _at_ 0xffec;//千位，LEFT
uchar xdata SEG_B _at_ 0xffed;//百位
uchar xdata SEG_S _at_ 0xffee;//十位
uchar xdata SEG_G _at_ 0xffef;//个位，RIGHT

/*LCD1602接口定义*/
uchar xdata M51_LCD1602_CW _at_ 0xfceb;
uchar xdata M51_LCD1602_CR _at_ 0xfeeb;
uchar xdata M51_LCD1602_DW _at_ 0xfdeb; 
uchar xdata M51_LCD1602_DR _at_ 0xffeb;

/*LCD128X64接口定义*/
uchar xdata M51_LCD12864_LCW _at_ 0xf4ea;
uchar xdata M51_LCD12864_LDW _at_ 0xf5ea;
uchar xdata M51_LCD12864_LCR _at_ 0xf6ea;
uchar xdata M51_LCD12864_LDR _at_ 0xf7ea;
uchar xdata M51_LCD12864_RCW _at_ 0xf8ea;
uchar xdata M51_LCD12864_RDW _at_ 0xf9ea;
uchar xdata M51_LCD12864_RCR _at_ 0xfaea;
uchar xdata M51_LCD12864_RDR _at_ 0xfbea;


/*数码管字符译码定义，根据需要选择*/
/*
uchar code led_code[]=
{	
	0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xf8,0x80,0x90,//0,1,2,3,4,5,6,7,8,9,
	0x88,0x83,0xC6,0xA1,0x86,0x8E,	//A,b,C,d,E,F
	0x40,0x79,0x24,0x30,0x19,0x12,0x02,0x78,0x00,0x10,//带小数点0～9,
	0x08,0x03,0x46,0x21,0x06,0x0E	//带小数点A～F
};
*/

void delay_ms(unsigned int n)
{
     unsigned char j;
     while(n--)
     for(j=0;j<230;j++);//230是实验测试所得！
}

/*ADC1549数据读取，首次无效*/
//读取ADC结果函数
uint get1549_data(void)
{
  uchar i;  
  uint temp=0; 

  ADC_CS = 0;/*开启控制电路，使能DA和CK IO引脚*/

  for(i=0;i<10;i++)  //采集10次 ，即10bit
  { 
    ADC_CK = 0;        
    temp <<= 1;
    if(ADC_DA) temp++;  
    ADC_CK = 1;
  }
  ADC_CS = 1;
  return(temp);
}

/*DAC5615数据写入函数*/
//数据写入
void put5615_data(uint da)
{
  uchar i;
  da <<= 6;//10有效数据左对齐
  DAC_CS = 0;
  DAC_CK = 0;
  for (i=0;i<12;i++)
  {
    DAC_DA = (bit)(da & 0x8000);
    DAC_CK = 1;
    da <<= 1;
    DAC_CK = 0;
  }
  DAC_CS = 1;
  DAC_CK = 0;
}

//通用数码管显示函数，传入数据0～9999
void seg7_disp(uint number)
{
	unsigned char code tab1[10]=
	{
		0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xf8,0x80,0x90
	};
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
#endif