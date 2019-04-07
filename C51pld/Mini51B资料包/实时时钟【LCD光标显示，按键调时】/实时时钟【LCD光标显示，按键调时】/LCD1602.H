#ifndef _LCD1602_H__
#define _LCD1602_H__

#include "absacc.h"
#define uchar unsigned char
#define uint unsigned int

//以下常数定义来自LCD数据手册  
#define LCD_LINE_1			  	0x00
#define LCD_LINE_2			 	0x40

#define LCD_ClEAR_SCREEN		0x01    //清屏
#define LCD_HOMING        		0x02    //光标返回原点  
#define LCD_AC_UP			    0x06	//地址计数器自动+1
#define LCD_AC_DOWN			  	0x04    //地址计数器自动-1,default
#define LCD_MOVE			    0x05    //画面可平移  
#define LCD_NO_MOVE			  	0x04    //画面不可平移,default

#define LCD_SHOW			    0x0c    //显示开
#define LCD_HIDE			    0x08    //显示关

#define LCD_CURSOR_NO_FLASH	  	0x0e    //显示光标不闪烁
#define LCD_CURSOR_FLASH  		0x0f    //显示光标不闪烁
#define LCD_NO_CURSOR		  	0x0c    //无光标

#define LCD_PIC_MOVE		  	0x18    //画面平移一个字符  
#define LCD_CURSOR_MOVE 		0x10    //光标平移一个字符  
#define LCD_RIGHT_MOVE			0x14    //右移
#define LCD_lEFT_MOVE		  	0x10    //左移			  
#define LCD_SET_7			    0x38    //8位接口，双行显示，5＊7字符  
#define LCD_SET_10			  	0x3c    //8位接口，双行显示，5＊10字符  

//以下编址由硬件决定，这里是基于51MCU&CPLD实验板
//RS=P2.0，RW=P2.1
#define LCD_CW XBYTE[0xfceb]
#define LCD_CR XBYTE[0xfeeb]
#define LCD_DW XBYTE[0xfdeb] 
#define LCD_DR XBYTE[0xffeb]

#define LCD_CGRAM_ADDR(addr) (0x40|addr)
#define LCD_DDRAM_ADDR(addr) (0x80|addr)

void delay_LCD(unsigned int i)
{
	while(i--);
}

//LCD状态检测,根据最高位判断LCD是否忙
unsigned char LCD_BUSY(void)
{
	if((bit)(LCD_CR & 0x80)) return (1);
	else  return (0);
}


//将要显示的字符写入LCD  
void Print(uchar *str,uchar n)
{
 uchar i;
 for(i=0;i<n;i++)
 {
   	while(LCD_BUSY());
   LCD_DW = *str;//直接针对外部地址些 movx指令  
   str++;
   delay_LCD(50);
 }
}

//LCD初始化
void LCD_Init(void)
{
	while(LCD_BUSY());
	LCD_CW = LCD_SET_7;	
	while(LCD_BUSY());
	LCD_CW = LCD_SHOW;
	while(LCD_BUSY());
	LCD_CW = LCD_AC_UP;	
}

//带定位参数的字符写函数  
void LCD_W_Data(uchar line,uchar column,uchar n,uchar *p_data)
{
  while(LCD_BUSY());
  switch(line)
  {
    case 1:      
	  LCD_CW = LCD_DDRAM_ADDR(LCD_LINE_1+column-1);//光标定位  
      delay_LCD(50);
      Print(p_data,n);
      break;
    case 2:
      LCD_CW = LCD_DDRAM_ADDR(LCD_LINE_2+column-1);
      delay_LCD(50);
      Print(p_data,n);
      break;
   default:
      break;
  }
}

//光标位置设定，由行列参数确定（1，16）（2，1）
void LCD_SET_CURSOR(uchar line,uchar column)
{
	while(LCD_BUSY());
  	switch(line)
  	{
	 case 1:
    	LCD_CW = 0x80 + column-1;//光标定位
      	break;
	 case 2:
    	LCD_CW = 0xc0 + column-1;//光标定位
		break;
	 default: break;
	}
}

//显示光标设定
void LCD_CURSOR_ONOFF(uchar cursor_flag)
{
	while(LCD_BUSY());
  	switch(cursor_flag)
  	{
	 case 1:
    	LCD_CW = LCD_NO_CURSOR;//无光标
      	break;
	 case 2:
    	LCD_CW = LCD_CURSOR_NO_FLASH;//有光标不闪烁
		break;
	case 3:
		LCD_CW = LCD_CURSOR_FLASH;//有光标闪烁
		break;
	 default: break;
	}
} 

#endif