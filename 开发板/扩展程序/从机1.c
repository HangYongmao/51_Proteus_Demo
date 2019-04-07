#include <AT89x52.h>
#include <intrins.h>

#define led_io P0
#define led_st P2
#define name_rd 0x11		 //一号机读命令
#define name_wr 0x01		 //一号机写命令


void led_disp(uchar *num);
void delay10ms(uchar t);

sbit key_1=P1^5;          //换位
sbit key_2=P1^6;          //加一
sbit key_3=P1^7;          //减一

uchar code led_code[]={
0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x07,0x7f,
0x6f,0x77,0x7c,0x39,0x5e,0x79,0x71,0x76,0x73,0x40};

uchar name,len,i;
uchar  led_buff[]={0xff,0xff,0xff};
void led_int() interrupt 4 using 0
{ 
   if(RB8 & RI)
   {
      name=SBUF;	  
	  SM2=0;	  	       
   }
   else 
   { 	     
      if(name==name_wr)				   //串行接收
        {
          led_buff[len]=SBUF;
	      len++;
		  if (len==3)
		  {
		    len=0;
		  } 
        }
   }
   TI=0;
   RI=0;
}
delay1ms(uchar t)
{
  while (t--);
}
main()
{
   TMOD=0x20;
   TH1=0xFD;
   TL1=0xFD;
   TR1=1;
   len=0;   
   key_1=0;
   key_2=0;
   key_3=0;
   EA=1;
   ES=1;				 //开串口中断
   SCON=0xF0;
   while (1)
   {
     if ( key_2 )
	 {
	   delay10ms(5);
	   if ( key_2 );
	    
	 }
	  if ( key_3 )
	 {
	   delay10ms(5);
	   if ( key_3 );
	    
	 }
	 if(name==name_rd)				   //串行发送
        {
		  ES=0;
          for(i=0;i<3;i++)
		  { 
		     SBUF=led_buff[i];		     
		     while(!TI);
		     TI=0;
		  }	
		  ES=1; 				  
        }
	 led_disp(led_buff);
   }   
}
void led_disp(uchar *num)
{
  led_st=0x7f;
  led_io=led_code[num[2]&0x0f];			   //显示个位
  delay1ms(200);
  led_st=0xbf;
  led_io=led_code[(num[2]&0xf0)>>4];
  delay1ms(200);
  led_st=0xdf;
  led_io=led_code[num[1]&0x0f];
  delay1ms(200);
  led_st=0xef;
  led_io=led_code[(num[1]&0xf0)>>4];
  delay1ms(200);
  led_st=0xf7;
  led_io=led_code[num[0]&0x0f];
  delay1ms(200);
  led_st=0xfb;
  led_io=led_code[(num[0]&0xf0)>>4];
  delay1ms(200);
  led_st=0xfd;
  led_io=led_code[18];
  delay1ms(200);
  led_st=0xfe;
  if(name==name_rd)  
     led_io=led_code[17];                //如果位读显示“P”  
  else 
   	 led_io=led_code[16];                //如果位写显示“H”
  delay1ms(200);
   
}

void delay10ms (  uchar t )			 //延时 10 MS
   {    uint i;
        for (i=0;i<t;i++)
		{
		   TMOD=0x01;
		   TH0=0x0D8;
		   TL0=0X0F0;
		   TR0=1;
		   while(TF0!=1);
		   TF0=0;
		   TR0=0; 		   
		 }	   

   }