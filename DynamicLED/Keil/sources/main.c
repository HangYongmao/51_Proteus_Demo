//*************************************************************************************************
//*************************************************************************************************
//**<������>��LED��̬ɨ����ʾ																	 **
//**<����>��LED��̬��ʾ1s������																	 **
//**<����>��LastRitter																			 **
//**<���ʱ��>��2007��7��28��																	 **
//**<��ϵ��ʽ>��superyongzhe@163.com															 **
//*************************************************************************************************
//*************************************************************************************************


//*************************************************************************************************
//*																								  *
//*			 ******************************ͷ�ļ����궨��**************************				  *
//*																								  *
//*************************************************************************************************
#include "includes.h"

#define TIME0H 0xFC
#define TIME0L 0x18		//��ʱ��0���ʱ�䣺5ms,����ˢ��LED��

#define TIME1H 0x40
#define TIME1L 0x98		//��ʱ��1���ʱ�䣺49ms�����ڼ�ʱģʽ�ļ������ӡ�


//*************************************************************************************************
//*																								  *
//*			  ********************************ȫ�ֱ���******************************			  *
//*																								  *
//*************************************************************************************************

unsigned char uc_DisCount=1;		//��ʱ��0��ʱˢ��LED������

unsigned char uc_TimeCount=0;		//��ʱ��1��ʱ������

unsigned long ul_Number=0;			//LED��ʾ���֡�


//*************************************************************************************************
//*																								  *
//*			  ********************************������******************************				  *
//*																								  *
//*************************************************************************************************
void main()
{
	TMOD=0x11;		  //��ʱ��0:ģʽһ;��ʱ��0:ģʽһ.


//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<��ʱ��0������LCDˢ��>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	TH0=TIME0H;
	TL0=TIME0L;
	TR0=1;			 //������ʱ��0
	ET0=1;			 //����ʱ��0�ж�


//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<��ʱ��1������1s��ʱ >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	TH1=TIME1H;
	TL1=TIME1L;
	TR1=1;			 //������ʱ��1
	ET1=1;			 //����ʱ��1�ж�


	EA=1;			 //�������ж�

	while(1);
}


//*************************************************************************************************
//*																								  *
//*		*****************************��ʱ��1�жϣ����ڼ�ʱ����******************************	  *
//*																								  *
//*************************************************************************************************
void vTimer1(void) interrupt 3
{

		if(uc_TimeCount==19)
			{
			uc_TimeCount=0;
			ul_Number++;
			}
		else uc_TimeCount++;

	TH1=TIME1H;
	TL1=TIME1L;
}


//*************************************************************************************************
//*																								  *
//*		***************************��ʱ��0����ʱˢ��LED*************************				  *
//*																								  *
//*************************************************************************************************
void vTimer0(void) interrupt 1
{
	vShowOneNum(*(pucLedNum(ul_Number)+uc_DisCount),uc_DisCount);	   //��LED����ʾ1λ���֡�

	if(uc_DisCount<5)
		uc_DisCount++;						//��ʱ��0��ÿ�α�����ʱ���ı�LED��ʾ��
	else uc_DisCount=0;						//�ӵ�һλ������λѭ����ʾ��

	TH0=TIME0H;		   						//�ָ���ʱ��0��ʼֵ��
	TL0=TIME0L;
}