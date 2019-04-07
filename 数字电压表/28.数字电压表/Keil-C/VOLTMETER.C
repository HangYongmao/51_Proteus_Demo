#include <AT89X52.H>  
unsigned char code dispbitcode[]={0xfe,0xfd,0xfb,0xf7, 0xef,0xdf,0xbf,0x7f}; 
unsigned char code dispcode[]={0x3f,0x06,0x5b,0x4f,0x66, 0x6d,0x7d,0x07,0x7f,0x6f,0x00}; 
unsigned char dispbuf[8]={10,10,10,10,10,0,0,0}; 
unsigned char dispcount; 
unsigned char getdata; 
unsigned int temp; 
long int  i; 
unsigned int R1; 

sbit ST=P3^0; 
sbit OE=P3^1; 
sbit EOC=P3^2; 
sbit CLK=P3^3; 
  
void main(void) 
{ 
  ST=0; 
  OE=0; 
  ET0=1; 
  ET1=1; 
  EA=1; 
  TMOD=0x12; 
  TH0=216; 
  TL0=216; 
  TH1=(65536-5000)/256; 
  TL1=(65536-5000)%256; 
  TR1=1; 
  TR0=1; 
  ST=1; 
  ST=0; 
  while(1) 
    { 
      if(EOC==1) 
        { 
          OE=1; 
          getdata=P0; 
          OE=0;
		    i=getdata*196;
			dispbuf[5]=i/10000; 
			i=i%10000; 
			dispbuf[6]=i/1000;
			i=i%1000; 
			dispbuf[7]=i/100;          
          ST=1; 
          ST=0; 
        } 
    } 
} 
  
void t0(void) interrupt 1 using 0           //定时器0  中断服务
{ 
  CLK=~CLK; 
} 
  
void t1(void) interrupt 3 using 0          //定时器1  中断服务
{ 
  TH1=(65536-6000)/256; 
  TL1=(65536-6000)%256; 
  P2=0xff;
  P1=dispcode[dispbuf[dispcount]]; 
  P2=dispbitcode[dispcount]; 
  if(dispcount==5) 
    { 
      P1=P1 | 0x80; 
    } 
  dispcount++; 
  if(dispcount==8) 
    { 
      dispcount=0; 
    }  
} 

