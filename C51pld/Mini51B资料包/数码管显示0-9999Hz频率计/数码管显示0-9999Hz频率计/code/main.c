/*һ���������ڲ���ֵΪ1,��һ���������ڲ���Ϊ0,���������1*/
/*�ⲿ�¼�����߼���Ƶ��Ϊ�����1/24,����߼���Ϊ0.9216M;*/
/*Ŀǰ״̬��ֻ����ʾ0��9999HZ��Ƶ��*/
/*ԭ�����ߣ�������*/
/*�Ż�����tiansir*/

/*��Ƶ��ԭ��*/
/*��ʱ��T0��Ϊ��ʱװ�ã�����趨��ʱ1s����ʱ��T1���ⲿ�źż�����ÿ1S�жԼ����������*/

#include<reg51.h> 
#include<absacc.h>

#define SEG_Q XBYTE[0xfcec]
#define SEG_B XBYTE[0xfced]
#define SEG_S XBYTE[0xfcee]
#define SEG_G XBYTE[0xfcef]  

//ͨ���������ʾ��������������0��9999
void renew_disp(unsigned int number)
{
	unsigned char code tab1[10]={0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xf8,0x80,0x90};
	unsigned char temp,flag=0;

	if(number < 10000)
	{		
		//ǧλ�����
		temp = number/1000%10;
		if (temp)
		{
			SEG_Q = tab1[temp];
			flag = 1;	
		}
		else 
		{
			SEG_Q = 0xff;//�����Ϩ��
			flag = 0;	
		}

		//��λ�����
		temp = number/100%10;		
		if(flag | temp)
		{
			SEG_B = tab1[temp];
			flag = 1;	
		}
		else 
		{
			SEG_B = 0xff;//�����Ϩ��
			flag = 0;	
		}					
		
		//ʮλ�����
		temp = number/10%10;
		if(flag | temp) SEG_S = tab1[temp];		
		else SEG_S = 0xff;//�����Ϩ��		
		
		//��λ�����
		temp = number%10;	
		SEG_G = tab1[temp];
	}
	else
	{
		SEG_Q = 0xbf;
		SEG_B = 0xbf;
		SEG_S = 0xbf;
		SEG_G = 0xbf;	
	}
}

//T0��ʱ�жϣ�����22.1184M
void T0_int(void) interrupt 1
{   
	static char counter=0;	
	TH0=(65536-46063)/256;
    TL0=(65536-46063)%256;
	if(counter++==39)	   	     
    { 
		counter=0; 
	   	TR1=0;	   	
		renew_disp(256*TH1+TL1);
		TH1=TL1=0;		
		TR1=1;	  
	}	 
}

void main()
{ 
   	TMOD = 0x51;/*01010001 T1����,T0��ʱ*/
   	TH1 = 0;
   	TL1 = 0;   	 
	//����22.1184M
   	TH0 = (65536-46063)/256;//��ʱ25MS
   	TL0 = (65536-46063)%256; 
   	TR0 = 1;		//����ʱ��0
   	TR1 = 1;		//������ʱ��1
   	EA  = 1; 		//�����ж�
   	ET0 = 1;		//����ʱ��0�ж�
   	while(1);		//ԭ��̤�����ȴ��ж�
}