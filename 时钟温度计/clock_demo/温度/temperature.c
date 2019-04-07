#include "reg51.h"

char disp[11]={0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x07,0x7f,0x6f,0x40};
char disp_dot[11]={0xbf,0x86,0xdb,0xcf,0xe6,0xed,0xfd,0x87,0xff,0xef,0xc0};

sbit DQ = P1^3;   //����ͨ�Ŷ˿� 

//����12MHz  
void delay_18B20(unsigned int i)
{
	while(i--);
}

//��ʼ������
Init_DS18B20(void) 
{
	 unsigned char x=0;
	 DQ = 1;          //DQ��λ
	 delay_18B20(8);  //������ʱ
	 DQ = 0;          //��Ƭ����DQ����
	 delay_18B20(80); //��ȷ��ʱ ���� 480us
	 DQ = 1;          //��������
	 delay_18B20(14);
	 x=DQ;            //������ʱ�� ���x=0���ʼ���ɹ� x=1���ʼ��ʧ��
	 delay_18B20(20);
}


//��һ���ֽ�  
ReadOneChar(void)
{
	unsigned char i=0;
	unsigned char dat = 0;
	for (i=8;i>0;i--)
	 {
		  DQ = 0; // �������ź�
		  dat>>=1;
		  DQ = 1; // �������ź�
		  if(DQ)
		  dat|=0x80;
		  delay_18B20(4);
	 }
 	return(dat);
}

//дһ���ֽ�  
WriteOneChar(unsigned char dat)
{
 unsigned char i=0;
 for (i=8; i>0; i--)
 {
  DQ = 0;
  DQ = dat&0x01;
  delay_18B20(5);
  DQ = 1;
  dat>>=1;
 }
}

//��ȡ�¶�
ReadTemperature(void)
{
	unsigned char a=0;
	unsigned char b=0;
	unsigned int  t=0;
	
	Init_DS18B20();
	WriteOneChar(0xCC); // ����������кŵĲ���
	WriteOneChar(0x44); // �����¶�ת��
	delay_18B20(100);
	Init_DS18B20();
	WriteOneChar(0xCC); //����������кŵĲ���
	WriteOneChar(0xBE); //��ȡ�¶ȼĴ����ȣ����ɶ�9���Ĵ����� ǰ���������¶�
	a=ReadOneChar();
	b=ReadOneChar();
		
	//����������ֵ��16��ʵ���¶�ֵ
	//Ϊ�˵õ�2λС��λ���ȳ�100���ٳ�16�������������ݳ��ȣ�
	//���ɴ�����ȳ�25���ٳ�4����4������ʵ��

	t = (b*256+a)*25;	
	return( t >> 2  );
}

main()
{
	unsigned int tmp;
	unsigned char counter;
	while(1)
	{
		//�¶Ȳ���Ƶ��û�б�Ҫ̫�ߣ�̫�߷���Ӱ��������ʾ
		//�����ü��������Կ���
		if(counter-- == 0)
		{
			tmp = ReadTemperature(); 			
			counter = 20;
		}

		P2 = 0xff;
		P0 = disp[tmp%10];
		P2 = 0xfb;
		delay_18B20(1000);
		P2 = 0xff;
		P0 = disp[tmp/10%10];
		P2 = 0xf7;
		delay_18B20(1000);
		P2 = 0xff;
		P0 = disp_dot[tmp/100%10];
		P2 = 0xef;
		delay_18B20(1000);
		P2 = 0xff;
		P0 = disp[tmp/1000%10];
		P2 = 0xdf;
		delay_18B20(1000);
	}
}