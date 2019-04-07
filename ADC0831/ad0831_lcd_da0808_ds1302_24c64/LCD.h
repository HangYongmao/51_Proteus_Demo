#include <absacc.h>
#include <intrins.h>
#include <reg51.h>

//#include "1302.h"
// LCD128*64 ������
#define LCD12864DataPort P1
#define uchar unsigned char
#define uint unsigned char
// LCD128*64 I/O �źŹܽ�
sbit di = P2^0; // ����\ָ�� ѡ��
sbit rw = P2^2; // ��\д ѡ��
sbit en = P2^1; // ��\дʹ��
sbit cs1= P2^3; // Ƭѡ1,����Ч(ǰ64��)
sbit cs2= P2^4; // Ƭѡ2,����Ч(��64��)

void nop(void)
{
	_nop_(); _nop_(); _nop_(); _nop_(); _nop_(); _nop_(); _nop_(); _nop_(); _nop_(); _nop_(); _nop_();
}

//״̬���
void CheckState(void)
{
	uchar dat;
	dat = 0x00;
	di=0;
	rw=1;
/*	do
	{
		P1=0xff;
		en=1;
		dat=P1; 
		en=0;
		dat&=0x80; //������7λΪ0ʱ�ſɲ���
	}while(dat);*/
}

//д��ʾ����
//dat:��ʾ����
void WriteByte(uchar dat)
{
	CheckState();
	di=1; 
	rw=0;
	LCD12864DataPort=dat;
	en=1; 
	en=0;
}
/*-----------------------------------------------------------------------------------------------------*/
//��LCD��������
//command :����
SendCommandToLCD(uchar command)
{
	CheckState();
	rw=0;
	di=0;
	LCD12864DataPort=command;
	en=1;
	en=0;
}
/*----------------------------------------------------------------------------------------------------*/
//�趨�е�ַ(ҳ)--X 0-7
void SetLine(uchar line)
{
	line &= 0x07; // 0<=line<=7
	line |= 0xb8; //1011 1xxx
	SendCommandToLCD(line);
}
//�趨�е�ַ--Y 0-63
void SetColumn(uchar column)
{
	column &= 0x3f; // 0=<column<=63
	column |= 0x40; //01xx xxxx
	SendCommandToLCD(column);
}
//�趨��ʾ��ʼ��--XX
void SetStartLine(uchar startline) //0--63
{
	//startline &= 0x07;
	startline |= 0xc0; //1100 0000
	SendCommandToLCD(startline);
}
//������ʾ
void SetOnOff(uchar onoff)
{
	onoff|=0x3e; //0011 111x
	SendCommandToLCD(onoff);
}
/*---------------------------------------------------------------------------------------------------*/
//ѡ����Ļ
//screen: 0-ȫ��,1-����,2-����
void SelectScreen(uchar screen)
{ //������ʾ��:����Ч cs1: 0--��; cs2: 0--��
	switch(screen)
	{ 
		case 0: 
			cs1=0;//ȫ��
			nop();
			cs2=0; 
			nop();
			break; 
		case 1: 
			cs1=1;//����
			nop();
			cs2=0;
			nop();
			break;
		case 2: 
			cs1=0;//����
			nop();
			cs2=1;
			nop();
			break;
		default:
			break;
	}
}
/*---------------------------------------------------------------------------------------------------*/
//����
//screen: 0-ȫ��,1-����,2-��
void ClearScreen(uchar screen)
{ 
	uchar i,j;
	SelectScreen(screen);
	for(i=0;i<8;i++)
	{ 
		SetLine(i);
		for(j=0;j<64;j++)
		{
			WriteByte(0x00);
		}
	}
}
/*--------------------------------------------------------------------------------------------------*/
//��ʾ8*8����
//lin:��(0-7), column: ��(0-127)
//address : ��ģ���׵�ַ
void Show8x8(uchar lin,uchar column,uchar *address)
{ 
	uchar i;
//	if(column>128) {return;}
	if(column<64)
	{
		SelectScreen(1); //�������<64��ӵ�һ���Ͽ�ʼд
		SetLine(lin);
		SetColumn(column);
		for(i=0;i<8;i++)
		{
			if(column+i<64)
			{
				WriteByte(*(address+i));
			}
			else
			{
				SelectScreen(2);
				SetLine(lin);
				SetColumn(column-64+i);
				WriteByte(*(address+i));
			}
		}
	}
	else 
	{
		SelectScreen(2); //����ӵڶ����Ͽ�ʼд
		column-=64; //��ֹԽ��
		SetLine(lin);
		SetColumn(column);
		for(i=0;i<8;i++)
		{
			if(column+i<64)
			{
				WriteByte(*(address+i));
			}
			else
			{
				SelectScreen(1);
				SetLine(lin);
				SetColumn(column-64+i);
				WriteByte(*(address+i));
			}
		}
	}
}

//��ʾ����8*16
void ShowNumber(uchar lin,uchar column,uchar num)
{
	uchar *address;
	address=&Numcode[num][0];
	Show8x8(lin,column,address);
   	Show8x8(lin+1,column,address+8);
}
//��ʾ����16*16
void ShowChina(uchar lin,uchar column,uchar num)
{
	uchar *address;
//	if(lin>7 || column>127){return;}	
	address = &HZcode[num][0];
	Show8x8(lin,column,address);
   	Show8x8(lin,column+8,address+8);
   	Show8x8(lin+1,column,address+16);
   	Show8x8(lin+1,column+8,address+24);
}

void InitLCD(void) //��ʼ��LCD
{ 
	uchar i=2000; //��ʱ
	while(i--);
 	SetOnOff(1); //����ʾ
	ClearScreen(1);//����
	ClearScreen(2);
  	SetStartLine(0); //��ʼ��:0
}
