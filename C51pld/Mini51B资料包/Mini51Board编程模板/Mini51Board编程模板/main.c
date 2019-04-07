#include "Mini51B.H"   //������Ӳ����صĽӿں�������
#include "AUTO_ISP.H"  //�Զ�ISP��ʼ��,ռ��timer1
#include "UART.H"      //������������
#include "LCD1602.H"   //LCD1602��������
#include "LCD12864.H"  //LCD12864��������
#include "DS1302.H"	   //DS1302ʵʱʱ����������
#include "STCEEPROM.H" //EEPROM��д����
#include "IRM.H"       //���������������
#include <stdio.h>	   //C��׼�����⣬ϵͳ����

#include "logo_stuelab.h"

SYSTEMTIME RTC;

//�ж�����������������Ԥ��
void extern0_ISR() interrupt 0{}
void timer0_ISR () interrupt 1{}
void extern1_ISR() interrupt 2{}
void timer1_ISR () interrupt 3{}
//void serial_ISR () interrupt 4{} AUTO ISPռ��
//void extern2_ISR() interrupt 6{} IRMռ��
void extern3_ISR() interrupt 7{}


void main()
{	
	float V;
	uint DACD;
	uchar i,temp;


	uchar str_buff[20];//�ַ�������
	timer1_init();//AUTO ISP��ʼ��
	extern2_init();//�������

/*****************����������*****************/
//*
	BEEP_ON();
	delay_ms(100);
	BEEP_OFF();
/********************************************/

/**************STCEEPROM����*****************/	
//ÿ�ο������������ʾ������1
//EEPROM58��STCEEPROM.H�ж���
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

/***************LCD1602����******************/
//*�˲���ע��ֻҪɾ��ǰ��һλб��
	lcd1602_init();
	lcd_put_xyns(2,1,14,"www.stuelab.cn");
/********************************************/

/***************LCD12864����*****************/
//*�˲���ע��ֻҪɾ��ǰ��һλб��
	lcd12864_init();	
	lcd12864_put_xywhb(0,0,128,64,stuelab);		
	delay_ms(1000);
	lcd12864_clr();
	lcd12864_put_xyns(1,0,6,hanzi1);
	lcd12864_put_xyns(0,1,12,hanzi2);
	lcd12864_put_xyns(0,3,8,hanzi3);
/********************************************/

/**************LCD12864������**************/
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

/*****************�̵�������*****************/
//*
	JDQ_CLOSE();  //�̵�������
	delay_ms(100);
	JDQ_OPEN();   //�̵�����
/********************************************/

/***************ʱ�Ӳ���*********************/	
	Initial_DS1302();
/*ʱ���趨,ִ��һ�κ�ɾ���ò���
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
			put5615_data(DACD);//DAC���
		}		
		
		V = get1549_data();//��ADC
		V = V/200;
		sprintf(str_buff,"%3.2f",V);//��ʽת��
		lcd_put_xyns(16,2,1,"V");	
		lcd_put_xyns(12,2,4,str_buff);

		seg7_disp(irm_code); //�������ʾ���ⰴ������ֵ
		uart_put_uchar(irm_code);//���ڷ��ͺ������ֵ

		temp = uart_get_uchar();//�˺���Ϊ��ѯģʽ��Ҫ�Ǵ���û�����ݷ��ͣ������ͣ�ڴ˴�

		delay_ms(100);		
	}	
}

