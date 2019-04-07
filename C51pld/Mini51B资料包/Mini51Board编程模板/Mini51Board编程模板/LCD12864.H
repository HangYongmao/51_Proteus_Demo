#ifndef __LCD_12864_H__
#define __LCD_12864_H__

/************常用操作命令和参数定义********/
#define DISPON    0x3f    //display on
#define DISPOFF   0x3e    //display off
#define DISPFIRST 0xc0    //define the first row
#define SETY      0xb8    //define page address
#define SETX      0x40    //define column address
//#define SIZE      0x500

/*以下定义与硬件电路设计有关，参考Mini51.H*/
#define LCD_LCW  M51_LCD12864_LCW
#define LCD_LDW  M51_LCD12864_LDW
#define LCD_LCR  M51_LCD12864_LCR
#define LCD_LDR  M51_LCD12864_LDR
#define LCD_RCW  M51_LCD12864_RCW
#define LCD_RDW  M51_LCD12864_RDW
#define LCD_RCR  M51_LCD12864_RCR
#define LCD_RDR  M51_LCD12864_RDR

void loop_lcd12864_is_busy(uchar right)
{
  uchar tmp,counter=0;
  do
  {
  	if(right) tmp = LCD_RCR;
  	else tmp = LCD_LCR;	
	if(counter++>50) break;//超时跳出
  }
  while ((tmp|0x7f)==0xff);	 
}

void lcd_cmd_wr(uchar cmdcode,uchar right)
{
  loop_lcd12864_is_busy(right);
  if(right) LCD_RCW = cmdcode;
  else LCD_LCW = cmdcode;  
}

void lcd_data_wr(uchar ldata,uchar right)
{
  loop_lcd12864_is_busy(right);
  if(right) LCD_RDW = ldata;
  else LCD_LDW = ldata;
}



void lcd12864_init(void)
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


void lcd12864_clr(void)
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

//16*16点阵汉字显示函数
//xyns:坐标x，y，字数n，字符串s，左上角坐标为（0,0）
void lcd12864_put_xyns(uchar x,uchar y,uchar n,uchar *str)
{
    uchar i,j;
    for(i=0;i<n;i++)
    {
        if(x>7)
        {
            y ++;
            x = 0;
        }
        
        if(x<4)
        {
            lcd_cmd_wr(SETY+2*y,0);
            lcd_cmd_wr(SETX+16*x,0);
            for(j=0;j<16;j++)
                lcd_data_wr(str[j+i*32],0);
            lcd_cmd_wr(SETY+2*y+1,0);
            lcd_cmd_wr(SETX+16*x,0);
            for(j=16;j<32;j++)
                lcd_data_wr(str[j+i*32],0);
        }
        else
        {
            lcd_cmd_wr(SETY+2*y,1);
            lcd_cmd_wr(SETX+16*(x-4),1);
            for(j=0;j<16;j++)
                lcd_data_wr(str[j+i*32],1);
            lcd_cmd_wr(SETY+2*y+1,1);
            lcd_cmd_wr(SETX+16*(x-4),1);
            for(j=16;j<32;j++)
                lcd_data_wr(str[j+i*32],1);
        }
        x ++;
    }
}

//在x，y处写1点
void lcd12864_set_xy(uchar x,uchar y)
{
	uchar dat;
	if(x>=128)x=127;
	if(y>=64)y=63;
	y = 63-y;
	dat=1<<(y%8);
	y=y/8;

	if(x>63)
	{
		x=x-64;
		lcd_cmd_wr(SETX+x,1);
		lcd_cmd_wr(SETY+y,1);
		loop_lcd12864_is_busy(1);
		LCD_RDW = dat;
	}
	else
	{		
		lcd_cmd_wr(SETX+x,0);
		lcd_cmd_wr(SETY+y,0);
		loop_lcd12864_is_busy(0);
		LCD_LDW = dat;	
	}

} 

/*图片写入函数*/
void lcd12864_put_xywhb(uchar x,uchar y,uchar w,uchar h,uchar *bmp)
{
  	uchar i,j;
  	h = h/8;
  	for(i=0;i<h;i++)
  	{
	   		lcd_cmd_wr(SETY+y+i,0);
		   	lcd_cmd_wr(SETX+x,0);
		   	for(j=0;j<w-64;j++)
		     	lcd_data_wr(bmp[128*i+j],0);

	   		lcd_cmd_wr(SETY+y+i,1);
		   	lcd_cmd_wr(SETX+x,1);
		   	for(j=64;j<w;j++)
		     	lcd_data_wr(bmp[128*i+j],1);
	  }
}
/*命令滚屏函数*/
/*
void lcd_rol()
{
  uchar i;
  for(i=0;i<64;i++)
  {
    lcd_cmd_wr(DISPFIRST+i,0);
 	lcd_cmd_wr(DISPFIRST+i,1);
 	delay(300);//延时实现滚屏效果
  }
}*/
#endif
