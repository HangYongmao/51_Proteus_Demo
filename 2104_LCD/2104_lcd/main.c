#include  "config.h"



/****************************************************************************
* ���ƣ�DelayNS()
* ���ܣ��������ʱ
* ��ڲ�����dly		��ʱ������ֵԽ����ʱԽ��
* ���ڲ�������
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

uint8 rd_state()	//��״̬
	{
	uint8 temp;
	IODIR=0x700;
	IOSET=cd;
	IOCLR=rd;
	temp=IOPIN;
	IOSET=rd;
	return(temp);
	}

void rd_enable()	//�ȴ��ɶ�д
	{
	uint8 temp;
	temp=rd_state();
	while((temp&0x03)!=0x03)
		temp=rd_state();
	}

void rd_auto()	//�ȴ��Զ���д
	{
	uint8 temp;
	temp=rd_state();
	while((temp&0x04)!=0x04)
		temp=rd_state();
	}

void wr_auto()	//�ȴ��Զ�д
	{
	uint8 temp;
	temp=rd_state();
	while((temp&0x08)!=0x08)
		temp=rd_state();
	}

/*д���д��������*********************
����1������2�������������*************
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

char rd_data()	//������
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
	wr_data(0x00,0x00,0x40,0x02);	//�����ı���ʾ�׵�ַ
	wr_data(0x14,0x00,0x41,0x02);	//�����ı���ʾ���
	wr_data(0x40,0x01,0x42,0x02);	//����ͼ����ʾ�׵�ַ
	wr_data(0x14,0x00,0x43,0x02);	//����ͼ����ʾ���
	wr_data(0x00,0x00,0xa1,0x00);	//�����״����
	wr_data(0x00,0x00,0x80,0x00);	//��ʾ��ʽ���ã�����
	wr_data(0x00,0x00,0x9c,0x00);	//��ʾ��������
	}
//******************lcd programme end*******************************


/****************************************************************************
* ���ƣ�main()
* ���ܣ�
****************************************************************************/
int  main(void)
	{
	char i;
	lcd_init();
	wr_data(0xe0,0x01,0x24,0x02);	//����д��ַ
	wr_data(0x00,0x00,0xb0,0x00);	//�����Զ�д��ʽ
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
	wr_data(0x00,0x00,0xb2,0x00);	//�Զ�д����
	while(1);
	}
