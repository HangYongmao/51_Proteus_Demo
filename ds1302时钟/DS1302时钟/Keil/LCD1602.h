/**************************************************************************
  
                   		THE 1602 CHAR LCD LIB
  
             		COPYRIGHT (c)   2005 BY JJJ.
                       		--  ALL RIGHTS RESERVED  --
  
   File Name:       LCD.h
   Author:          Jiang Jian Jun
   Created:         2005/4/3
   Modified:		NO
   Revision: 		1.0
  
***************************************************************************/

#ifndef LCD_CHAR_1602_2005_4_9
#define LCD_CHAR_1602_2005_4_9

#include <intrins.h>

//Port Definitions**********************************************************
sbit LcdRs		= P2^0;
sbit LcdRw		= P2^1;
sbit LcdEn  	= P2^2;
sfr  DBPort 	= 0x80;		//P0=0x80,P1=0x90,P2=0xA0,P3=0xB0.���ݶ˿�

//�ڲ��ȴ�����**************************************************************************
unsigned char LCD_Wait(void)
{
	LcdRs=0;
	LcdRw=1;	_nop_();
	LcdEn=1;	_nop_();
	//while(DBPort&0x80);//����Proteus����ʱ��ע�������δ���䣬�ڵ���GotoXY()ʱ���������ѭ����
						 //������д�ÿ�����ʱ����ģ��û�з���д���걸�����DBPort&0x80==0x80
						 //ʵ��Ӳ��ʱ�򿪴����
	LcdEn=0;
	return DBPort;		
}
//��LCDд�����������************************************************************
#define LCD_COMMAND			0      // Command
#define LCD_DATA			1      // Data
#define LCD_CLEAR_SCREEN	0x01      // ����
#define LCD_HOMING  		0x02      // ��귵��ԭ��
void LCD_Write(bit style, unsigned char input)
{
	LcdEn=0;
	LcdRs=style;
	LcdRw=0;		_nop_();
	DBPort=input;	_nop_();//ע��˳��
	LcdEn=1;		_nop_();//ע��˳��
	LcdEn=0;		_nop_();
	LCD_Wait();	
}

//������ʾģʽ************************************************************
#define LCD_SHOW			0x04    //��ʾ��
#define LCD_HIDE			0x00    //��ʾ��	  

#define LCD_CURSOR			0x02 	//��ʾ���
#define LCD_NO_CURSOR		0x00    //�޹��		     

#define LCD_FLASH			0x01    //�������
#define LCD_NO_FLASH		0x00    //��겻����

void LCD_SetDisplay(unsigned char DisplayMode)
{
	LCD_Write(LCD_COMMAND, 0x08|DisplayMode);	
}

//��������ģʽ************************************************************
#define LCD_AC_UP			0x02
#define LCD_AC_DOWN			0x00      // default

#define LCD_MOVE			0x01      // �����ƽ��
#define LCD_NO_MOVE			0x00      //default

void LCD_SetInput(unsigned char InputMode)
{
	LCD_Write(LCD_COMMAND, 0x04|InputMode);
}

//�ƶ�������Ļ************************************************************
/*
#define LCD_CURSOR		0x02      
#define LCD_SCREEN		0x08
#define LCD_LEFT		0x00
#define LCD_RIGHT		0x04
void LCD_Move(unsigned char object, unsigned char direction)
{
	if(object==LCD_CURSOR)
		LCD_Write(LCD_COMMAND,0x10|direction);
	if(object==LCD_SCREEN)
		LCD_Write(LCD_COMMAND,0x18|direction);
}
*/
//��ʼ��LCD************************************************************
void LCD_Initial()
{
	LcdEn=0;
	LCD_Write(LCD_COMMAND,0x38);           //8λ���ݶ˿�,2����ʾ,5*7����
	LCD_Write(LCD_COMMAND,0x38);
	LCD_SetDisplay(LCD_SHOW|LCD_NO_CURSOR);    //������ʾ, �޹��
	LCD_Write(LCD_COMMAND,LCD_CLEAR_SCREEN);   //����
	LCD_SetInput(LCD_AC_UP|LCD_NO_MOVE);       //AC����, ���治��
}

//************************************************************************
void GotoXY(unsigned char x, unsigned char y)
{
	if(y==0)
		LCD_Write(LCD_COMMAND,0x80|x);
	if(y==1)
		LCD_Write(LCD_COMMAND,0x80|(x-0x40));
}
void Print(unsigned char *str)
{
	while(*str!='\0')
	{
		LCD_Write(LCD_DATA,*str);
		str++;
	}
}
/*
void LCD_LoadChar(unsigned char user[8], unsigned char place)
{
	unsigned char i;
	LCD_Write(LCD_COMMAND,0x40|(place*8));
	for(i=0; i<8; i++)
		LCD_Write(LCD_DATA,user[i]);
}
*/
//************************************************************************
#endif
