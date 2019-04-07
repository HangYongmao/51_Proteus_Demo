//写汉字液晶，液晶屏为128*64，4行*8列汉字
/*
 D7 D6 D5 D4 D3 D2 D1 D0   
 0  0  0  1  1  1  1  D  	*D=1时显示开,D=0时显示关
 1  1  A  A  A  A  A  A 	*设定显示开始行寄存器位置
 1  0  1  1  1  A  A  A 	*设定页地址
 0  1  A  A  A  A  A  A 	*设定列地址
 D7 0  D5 D4 0  0  0  0 	*D7=1表示LCD忙，D7=0可以读写操作，D5=1显示关状态，
 							*D5=0显示开状态，D4=1表示正在初始化，D4=0初始化完毕
*/

/**************头文件定义***********/
#include "STC89C51RC.H"
#include <intrins.h>
#include "logo.h"

/************常用操作命令和参数定义********/
#define DISPON 0x3f      //display on
#define DISPOFF 0x3e     //display off
#define DISPFIRST 0xc0   //define the first row
#define SETY 0xb8        //define page address
#define SETX 0x40        //define column address
#define SIZE 0x500

/*以下定义与硬件电路设计有关*/
//RS-----------P2.0
//R/W----------P2.1
//CS1----------P2.2
//CS2----------P2.3
uchar xdata LLCD_CMD_WR  _at_ 0xf4ea;
uchar xdata LLCD_CMD_RD  _at_ 0xf6ea;
uchar xdata LLCD_DATA_WR _at_ 0xf5ea;
uchar xdata LLCD_DATA_RD _at_ 0xf7ea;
uchar xdata RLCD_CMD_WR  _at_ 0xf8ea;
uchar xdata RLCD_CMD_RD  _at_ 0xfaea;
uchar xdata RLCD_DATA_WR _at_ 0xf9ea;
uchar xdata RLCD_DATA_RD _at_ 0xfbea;

/************sub function******************/
void init_lcd(void);          
void Delay(uchar);
void lcd_cmd_wr(uchar,uchar);
void lcd_data_wr(uchar,uchar);
void lcd_busy(uchar);
void chk_busy(uchar);
void lcd_hanzi_wr(uchar,uchar,uchar *);
void lcd_str_wr(uchar,uchar,uchar,uchar *);
void lcd_bmp_wr(uchar,uchar,uchar,uchar,uchar *);
void lcd_clr(void);
void lcd_rol();

/************main function*****************/
void main(void)
{
  init_lcd(); 

  while(1)	
  { 	
	lcd_bmp_wr(0,0,128,64,logo);  
	Delay(500);
	lcd_bmp_wr(0,0,128,64,logo1);  
	Delay(500);
  }
}

void lcd_cmd_wr(uchar cmdcode,uchar right)
{
  chk_busy(right);
  if(right)
  {
    RLCD_CMD_WR = cmdcode;
  }
  else
  {
    LLCD_CMD_WR = cmdcode;
  }
}

void lcd_data_wr(uchar ldata,uchar right)
{
  chk_busy(right);
  if(right)
  {
    RLCD_DATA_WR = ldata;
  }
  else
  {
    LLCD_DATA_WR = ldata;
  }
}

void chk_busy(uchar right)
{
  uchar tmp;
  do
  {
  	if(right) tmp = RLCD_CMD_RD;
  	else tmp = LLCD_CMD_RD;
  }
  while ((tmp|0x7f)==0xff);	  
 }

void Delay(uchar ms)
{
  uchar us,usn;
  while(ms!=0)
  {
     usn = 100;
	 while(usn!=0)
	 {
	   us = 0xf0;
	   while(us!=0) us--;
	   usn--;
	 }
     ms--;
  }
}

void init_lcd(void)
{
  lcd_cmd_wr(DISPON,0);
  lcd_cmd_wr(DISPFIRST,0);
  lcd_cmd_wr(SETY,0);
  lcd_cmd_wr(SETX,0);

  lcd_cmd_wr(DISPON,1);
  lcd_cmd_wr(DISPFIRST,1);
  lcd_cmd_wr(SETY,1);
  lcd_cmd_wr(SETX,1);
}

/*
void lcd_clr(void)
{
	uchar i,j;

	for(i=0;i<8;i++)
	{
		lcd_cmd_wr(SETY+i,0);
		lcd_cmd_wr(SETX,0);
		lcd_cmd_wr(SETY+i,1);
		lcd_cmd_wr(SETX,1);	

		for(j=0;j<64;j++)
		{
			lcd_data_wr(0,0);
			lcd_data_wr(0,1);
		}
	}
}

void lcd_hanzi_wr(uchar posx,uchar posy,uchar *hanzi)
{
  uchar i;
  if(posx<4)
  {
    lcd_cmd_wr(SETY+2*posy,0);
 	lcd_cmd_wr(SETX+16*posx,0);
 	for(i=0;i<16;i++)
  	{
   		lcd_data_wr(hanzi[i],0);
 	}
 	lcd_cmd_wr(SETY+2*posy+1,0);
 	lcd_cmd_wr(SETX+16*posx,0);

 	for(i=16;i<32;i++)
 	{
   		lcd_data_wr(hanzi[i],0);
 	}
  }
  else
  {
    lcd_cmd_wr(SETY+2*posy,1);
 	lcd_cmd_wr(SETX+16*(posx-4),1);
 	for(i=0;i<16;i++)
 	{
   		lcd_data_wr(hanzi[i],1);
	}
 	lcd_cmd_wr(SETY+2*posy+1,1);
 	lcd_cmd_wr(SETX+16*(posx-4),1);
 	for(i=16;i<32;i++)
 	{
   		lcd_data_wr(hanzi[i],1);
 	}
  }
}

void lcd_str_wr(uchar row,uchar col,uchar n,uchar *str)
{
  	uchar i;
  	for(i=0;i<n;i++)
  	{
    	if(col>7)
 		{
  			row ++;
   			col = 0;
   		}
    	lcd_hanzi_wr(col,row,str+i*32);
 		col ++;
  	}
}


void lcd_rol()
{
  uchar i;
  for(i=0;i<64;i++)
  {
    lcd_cmd_wr(DISPFIRST+i,0);
 	lcd_cmd_wr(DISPFIRST+i,1);
 	Delay(300);
  }
}

*/
void lcd_bmp_wr(uchar posx,uchar posy,uchar width,uchar high,uchar *bmp)
{
  	uchar i,j;
  	high = high/8;

  	for(i=0;i<high;i++)
  	{
	   		lcd_cmd_wr(SETY+posy+i,0);
		   	lcd_cmd_wr(SETX+posx,0);
		   	for(j=0;j<width-64;j++)
		   	{
		     	lcd_data_wr(bmp[128*i+j],0);
		   	}

	   		lcd_cmd_wr(SETY+posy+i,1);
		   	lcd_cmd_wr(SETX+posx,1);
		   	for(j=64;j<width;j++)
		   	{
		     	lcd_data_wr(bmp[128*i+j],1);
		   	}
	  }
}

