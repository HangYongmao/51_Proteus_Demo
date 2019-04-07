#include <AT892051.h>


#define uchar unsigned char
#define name_rd 0x12		 //一号机读命令
#define name_wr 0x02		 //一号机写命令
#define led_buff P1

uchar  name;
void led_int() interrupt 4 using 0
{ 
   if(RB8 && RI)
   {
      name=SBUF;	  
	  SM2=0;	  	       
   }
   else 
   {       
        if(name==name_wr)				   //串行接收        
          led_buff=SBUF;        
   }
   RI=0;
   TI=0;
}
main()
{
   TMOD=0x20;
   TH1=0xFD;
   TL1=0xFD;
   TR1=1;
   SCON=0xf0;
   led_buff=0x0f;
   EA=1;
   ES=1;                                 //开串口中断
   while (1)
     if(name==name_rd)				   //串行发送
        {
          ES=0;
		  SBUF=led_buff;
		  while (!TI);
		  TI=0;
		  ES=1;		  		  
        }   
}