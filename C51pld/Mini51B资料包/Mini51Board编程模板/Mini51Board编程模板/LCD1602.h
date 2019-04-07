#ifndef __LCD_1602_H__
#define __LCD_1602_H__

//以下常数定义来自LCD数据手册  
#define LCD_LINE_1			  	0x00
#define LCD_LINE_2			 	0x40

#define LCD_ClEAR_SCREEN		0x01    //清屏
#define LCD_HOMING        		0x02    //光标返回原点  
#define LCD_AC_UP		        0x06	//地址计数器自动+1
#define LCD_AC_DOWN		  	0x04    //地址计数器自动-1,default
#define LCD_MOVE			0x05    //画面可平移  
#define LCD_NO_MOVE			0x04    //画面不可平移,default
#define LCD_SHOW			0x0c    //显示开
#define LCD_HIDE			0x08    //显示关			  
#define LCD_CURSOR_NO_FLASH	  	0x0e    //显示光标不闪烁
#define LCD_CURSOR_FLASH  		0x0f    //显示光标不闪烁
#define LCD_NO_CURSOR		  	0x0c    //无光标			  
#define LCD_PIC_MOVE		  	0x18    //画面平移一个字符  
#define LCD_CURSOR_MOVE 		0x10    //光标平移一个字符  
#define LCD_RIGHT_MOVE			0x14    //右移
#define LCD_lEFT_MOVE		  	0x10    //左移			  
#define LCD_SET_7			0x38    //8位接口，双行显示，5＊7字符  
#define LCD_SET_10			0x3c    //8位接口，双行显示，5＊10字符  

//LCD1602_CW等在Mini51BH中定义
#define LCD_CW M51_LCD1602_CW		  //定义液晶的写命令地址
#define LCD_CR M51_LCD1602_CR		  //定义液晶的判断忙标志位
#define LCD_DW M51_LCD1602_DW 		  //单片机向LCD写数据
#define LCD_DR M51_LCD1602_DR		  //读数据 一般情况用的很少

#define LCD_CGRAM_ADDR(addr) (0x40|addr)
#define LCD_DDRAM_ADDR(addr) (0x80|addr)

void delay_LCD(uint i)
{
	while(i--);
}

//LCD状态检测,根据最高位判断LCD是否忙
void loop_lcd1602_is_busy(void)
{
	uchar temp=0;
	while((bit)(LCD_CR & 0x80))//读数据口的最高位，判断液晶是否忙	
	 	if(temp++>50) break;//超时跳出
}


//将要显示的字符写入LCD  
void lcd_put_ns(uchar n,uchar *str)
{
 uchar i;
 for(i=0;i<n;i++)
 {
   	loop_lcd1602_is_busy(); //写数据之前检测液晶是否处于忙状态
   	LCD_DW = *str;     //直接针对外部地址些 movx指令  
   	str++;
   	delay_LCD(50);
 }
}

//LCD初始化
void lcd1602_init(void)
{
	loop_lcd1602_is_busy();	  //同上
	LCD_CW = LCD_SET_7;	  
	loop_lcd1602_is_busy();	  //同上
	LCD_CW = LCD_SHOW;
	loop_lcd1602_is_busy();    //同上
	LCD_CW = LCD_AC_UP;	
}
//带定位参数的字符写函数  
void lcd_put_xyns(uchar column,uchar line,uchar n,uchar *str)
{
  loop_lcd1602_is_busy();	  //同上
  switch(line)
  {
    case 1:      
	  LCD_CW = LCD_DDRAM_ADDR(LCD_LINE_1+column-1);//定位从那个位置开始显示
      delay_LCD(50);
      lcd_put_ns(n,str);
      break;
    case 2:
      LCD_CW = LCD_DDRAM_ADDR(LCD_LINE_2+column-1);//定位从那个位置开始显示
      delay_LCD(50);
      lcd_put_ns(n,str);
      break;
   default:
      break;
  }
}
#endif