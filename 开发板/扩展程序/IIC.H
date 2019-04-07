sbit   SDA=P1^7;
sbit   SCL=P1^6;
#ifndef __IIC_H__
#define __IIC_H__
delay1()
{
   _nop_();
   _nop_();
   _nop_();
   _nop_();
}

/*****************启动总线**********************/
void IICStart(void)
{
               
   SDA=1;   
   SCL=1;
   delay1();
   SDA=0;
   delay1();
   SCL=0;
                
}

/*****************停止IIC总线****************/
void IICStop(void)
{
  
  SDA=0;
  SCL=1;
  delay1();
  SDA=1;
  delay1();  
}

/**************检查应答位*******************/
bit IICRecAck(void)
{
	bit sample;
		
	SCL = 1;
	delay1();
	sample = SDA;
	SCL = 0;
	delay1();
	return (~sample);
}

/***************对IIC总线产生应答*******************/
void IICAck(void)
{
  SDA=0;
  SCL=1;
  delay1();
  SCL=0;
  delay1();
  SDA=1;
}

/*****************不对IIC总线产生应答***************/
void IICNoAck(void)
{
  SDA=1;
  SCL=1;
  delay1();
  SCL=0;
  SDA=0;
}

/*******************向IIC总线写数据*********************/
bit IICSendByte(unsigned char sendbyte)
{
  unsigned char data d;
  for(d=8;d>0;d--)
  {	     
     SDA = (bit)(sendbyte & 0x80);
     sendbyte<<=1;          //无论C51怎样实现这个操作，始终会使CY=sendbyte^7;
	 IICRecAck();
  }  
  return (IICRecAck());  
}

/**********************从IIC总线上读数据子程序**********/
unsigned char IICReceiveByte(void)
{
   uchar receivebyte,m; 

   for (m=0;m<8;m++)
   {     
	 SCL=1;
	 receivebyte=receivebyte<<1;
	 if (SDA==1)
	    receivebyte=receivebyte|0x01;	 
	 SCL=0;
  }
  return(receivebyte);
}
#endif