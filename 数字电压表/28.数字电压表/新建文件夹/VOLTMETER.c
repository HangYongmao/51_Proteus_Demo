#include<AT89X52.H>
unsigned char uchar;
unsigned int uint;
sbit START=P3^0;
sbit OE=P3^1;
sbit EOC=P3^2;

unsigned char data  led[4];
unsigned int data  tvdata;
unsigned int i; 
unsigned int k;
    

unsigned char code  tv[]={0xfe,0xfd,0xfb,0xf7};
unsigned char code  a[]={0x3f,0x06,0x5b,0x4f,
                 0x66,0x6d,0x7d,0x07,0x7f,0x6f};
                     

void delay(void)                      //延时程序
{
  for(i=0;i<10;i++);
}


void ledxianshi(void)       //显示模块
{
  tvdata*=2;
  led[0]=tvdata%10;
  led[1]=tvdata/10%10;
  led[2]=tvdata/100%10;
  led[3]=tvdata/1000;
		
  for(k=0;k<4;k++)
  { 
   P2=tv[k];
   i=led[k];
   P1=a[i];
   delay();
  }
} 
void sentdata_ser()
{
	TMOD=0x20;
	TL1=0xfd;TH1=0xfd;
	SCON=0xd8;PCON=0x00;
	TR1=1;
}
void sentdata(i)
{
	SBUF=i;
	while(TI==0);
	TI=0;
}


void main(void)
{
  sentdata_ser(); 
  while(1)
  {
   START=1;
   START=0;          //启动转换
   while(EOC==0);
   OE=1;
   tvdata=P0;
   OE=0;
	sentdata(tvdata);

     ledxianshi();
     delay();
   }
}

