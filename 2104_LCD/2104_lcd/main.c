#include  "config.h"



/****************************************************************************
* 名称：DelayNS()
* 功能：长软件延时
* 入口参数：dly		延时参数，值越大，延时越久
* 出口参数：无
****************************************************************************/
/*void  delay(uint32  dly)
{  uint32  i;

   for(; dly>0; dly--) 
      for(i=0; i<500; i++);
}*/

__inline void enable_irq()
	{
	uint8 tmp;
	__asm
		{
		MRS tmp,CPSR
		BIC tmp,tmp,#0x80
		MSR CPSR_c,tmp
		}
	}

__inline void disable_irq()
	{
	uint8 tmp;
	__asm
		{
		MRS tmp,CPSR
		ORR tmp,tmp,#0x80
		MSR CPSR_c,tmp
		}
	}

__inline void enable_frq()
	{
	uint8 tmp;
	__asm
		{
		MRS tmp,CPSR
		BIC tmp,tmp,#0x40
		MSR CPSR_c,tmp
		}
	}

__inline void disable_frq()
	{
	uint8 tmp;
	__asm
		{
		MRS tmp,CPSR
		ORR tmp,tmp,#0x40
		MSR CPSR_c,tmp
		}
	}

//**************lcd programme start*****************************
#define wr (1<<8)
#define rd (1<<9)
#define cd (1<<10)


void delay(int c)
	{
	int j;
	while(c--)
		for(j=500;j>0;j--)
			;
	}

uint8 rd_state()	//读状态
	{
	uint8 temp;
	IODIR=0x700;
	IOSET=cd;
	IOCLR=rd;
	temp=IOPIN;
	IOSET=rd;
	return(temp);
	}

void rd_enable()	//等待可读写
	{
	uint8 temp;
	temp=rd_state();
	while((temp&0x03)!=0x03)
		temp=rd_state();
	}

void rd_auto()	//等待自动读写
	{
	uint8 temp;
	temp=rd_state();
	while((temp&0x04)!=0x04)
		temp=rd_state();
	}

void wr_auto()	//等待自动写
	{
	uint8 temp;
	temp=rd_state();
	while((temp&0x08)!=0x08)
		temp=rd_state();
	}

/*写命令、写数据命令*********************
数据1、数据2、命令、参数个数*************
*****************************************/
void wr_data(char data1,char data2,char cmd,char num)
	{
	char temp;
	temp=num;
	if(temp==2)
		{
		rd_enable();
		IODIR=0x7ff;
		IOCLR=cd;
		IOCLR=0xff;
		IOSET=data1;
		IOCLR=wr;
		IOSET=wr;
		}
	 if(temp==2||temp==1)
	 	{
		rd_enable();
		IODIR=0x7ff;
		IOCLR=cd;
		IOCLR=0xff;
		IOSET=data2;
		IOCLR=wr;
		IOSET=wr;
		}
	rd_enable();
	IODIR=0x7ff;
	IOSET=cd;
	IOCLR=0xff;
	IOSET=cmd;
	IOCLR=wr;
	IOSET=wr;
	}

char rd_data()	//读数据
	{
	char temp;
	rd_enable();
	IODIR=0x700;
	IOCLR=cd;
	IOCLR=rd;
	temp=IOPIN;
	IOSET=rd;
	return(temp);
	}



void lcd_init()
	{
	IODIR=cd|rd|wr;
	IOSET=cd|rd|wr;
	wr_data(0x00,0x00,0x40,0x02);	//设置文本显示首地址
	wr_data(0x14,0x00,0x41,0x02);	//设置文本显示宽度
	wr_data(0x40,0x01,0x42,0x02);	//设置图形显示首地址
	wr_data(0x14,0x00,0x43,0x02);	//设置图形显示宽度
	wr_data(0x00,0x00,0xa1,0x00);	//光标形状设置
	wr_data(0x00,0x00,0x80,0x00);	//显示方式设置，“或”
	wr_data(0x00,0x00,0x9c,0x00);	//显示开关设置
	}
//******************lcd programme end*******************************


/****************************************************************************
* 名称：main()
* 功能：
****************************************************************************/
int  main(void)
	{
	char i;
	lcd_init();
	wr_data(0xe0,0x01,0x24,0x02);	//设置写地址
	wr_data(0x00,0x00,0xb0,0x00);	//设置自动写方式
	for(i=0;i<20;i++)
		{
		rd_enable();
		IODIR=0x7ff;
		IOCLR=cd;
		IOCLR=0xff;
		IOSET=0xaa;
		IOCLR=wr;
		IOSET=wr;
		}
	wr_data(0x00,0x00,0xb2,0x00);	//自动写结束
	while(1);
	}
