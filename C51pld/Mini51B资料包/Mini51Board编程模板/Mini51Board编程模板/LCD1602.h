#ifndef __LCD_1602_H__
#define __LCD_1602_H__

//���³�����������LCD�����ֲ�  
#define LCD_LINE_1			  	0x00
#define LCD_LINE_2			 	0x40

#define LCD_ClEAR_SCREEN		0x01    //����
#define LCD_HOMING        		0x02    //��귵��ԭ��  
#define LCD_AC_UP		        0x06	//��ַ�������Զ�+1
#define LCD_AC_DOWN		  	0x04    //��ַ�������Զ�-1,default
#define LCD_MOVE			0x05    //�����ƽ��  
#define LCD_NO_MOVE			0x04    //���治��ƽ��,default
#define LCD_SHOW			0x0c    //��ʾ��
#define LCD_HIDE			0x08    //��ʾ��			  
#define LCD_CURSOR_NO_FLASH	  	0x0e    //��ʾ��겻��˸
#define LCD_CURSOR_FLASH  		0x0f    //��ʾ��겻��˸
#define LCD_NO_CURSOR		  	0x0c    //�޹��			  
#define LCD_PIC_MOVE		  	0x18    //����ƽ��һ���ַ�  
#define LCD_CURSOR_MOVE 		0x10    //���ƽ��һ���ַ�  
#define LCD_RIGHT_MOVE			0x14    //����
#define LCD_lEFT_MOVE		  	0x10    //����			  
#define LCD_SET_7			0x38    //8λ�ӿڣ�˫����ʾ��5��7�ַ�  
#define LCD_SET_10			0x3c    //8λ�ӿڣ�˫����ʾ��5��10�ַ�  

//LCD1602_CW����Mini51BH�ж���
#define LCD_CW M51_LCD1602_CW		  //����Һ����д�����ַ
#define LCD_CR M51_LCD1602_CR		  //����Һ�����ж�æ��־λ
#define LCD_DW M51_LCD1602_DW 		  //��Ƭ����LCDд����
#define LCD_DR M51_LCD1602_DR		  //������ һ������õĺ���

#define LCD_CGRAM_ADDR(addr) (0x40|addr)
#define LCD_DDRAM_ADDR(addr) (0x80|addr)

void delay_LCD(uint i)
{
	while(i--);
}

//LCD״̬���,�������λ�ж�LCD�Ƿ�æ
void loop_lcd1602_is_busy(void)
{
	uchar temp=0;
	while((bit)(LCD_CR & 0x80))//�����ݿڵ����λ���ж�Һ���Ƿ�æ	
	 	if(temp++>50) break;//��ʱ����
}


//��Ҫ��ʾ���ַ�д��LCD  
void lcd_put_ns(uchar n,uchar *str)
{
 uchar i;
 for(i=0;i<n;i++)
 {
   	loop_lcd1602_is_busy(); //д����֮ǰ���Һ���Ƿ���æ״̬
   	LCD_DW = *str;     //ֱ������ⲿ��ַЩ movxָ��  
   	str++;
   	delay_LCD(50);
 }
}

//LCD��ʼ��
void lcd1602_init(void)
{
	loop_lcd1602_is_busy();	  //ͬ��
	LCD_CW = LCD_SET_7;	  
	loop_lcd1602_is_busy();	  //ͬ��
	LCD_CW = LCD_SHOW;
	loop_lcd1602_is_busy();    //ͬ��
	LCD_CW = LCD_AC_UP;	
}
//����λ�������ַ�д����  
void lcd_put_xyns(uchar column,uchar line,uchar n,uchar *str)
{
  loop_lcd1602_is_busy();	  //ͬ��
  switch(line)
  {
    case 1:      
	  LCD_CW = LCD_DDRAM_ADDR(LCD_LINE_1+column-1);//��λ���Ǹ�λ�ÿ�ʼ��ʾ
      delay_LCD(50);
      lcd_put_ns(n,str);
      break;
    case 2:
      LCD_CW = LCD_DDRAM_ADDR(LCD_LINE_2+column-1);//��λ���Ǹ�λ�ÿ�ʼ��ʾ
      delay_LCD(50);
      lcd_put_ns(n,str);
      break;
   default:
      break;
  }
}
#endif