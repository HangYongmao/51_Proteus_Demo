//*************************************************************************************************
//*																								  *
//*		**************************************��ʾ���ܣ�*************************************	  *
//*																								  *
//*************************************************************************************************
#include "SMC1602.h"

//��ʹ�ý���ʱ��ע�⣺b_Introduce�����vIntroduce�������ʹ�á�

bit b_Introduce=1;					//���ڹرս��ܡ�1--�������ܣ�0--�˳����ܡ�

extern unsigned char uca_CharBox[];
extern unsigned char uc_CharPointer;
extern bit b_CapStatus;
extern bit b_InputMode;

void vIntroduce()
{
	unsigned int uiCount;											 //ѭ��������ʾ:
	unsigned char ucCount;											 //  Hello.Sir! I
	unsigned char ucaIntroduce[5][16]=								 //am clear ! I Can 
						{"                ","Hello. Sir! I am",		 //show what you
						 "clear!I can show","what you press !",		 //press!    ^-^
						 "       ^-^      "
						};

	vWriteCMD(0x0C);						  //�ı���ʾģʽ�����ֲ���������Զ����ơ�

	for(ucCount=0;b_Introduce==1;ucCount++)
		{
		vWriteCMD(0x80);					  //ˢ�µ�һ�С�
		vShowChar(ucaIntroduce[ucCount]);

		vWriteCMD(0xC0);					  //ˢ�µڶ��С�
		if(ucCount==4)
			ucCount=0;
		vShowChar(ucaIntroduce[ucCount+1]);

		for(uiCount=0;uiCount<35000;uiCount++);
		}
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<�������ܣ��ָ���Ļ>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	vWriteCMD(0x80);						 
	vShowChar("Please Input: ");			//�ָ���ʾ��Ϣ��

	if(b_InputMode==0)
		{									//�ָ�״̬��־��
		vWriteCMD(0x8E);
		vShowChar(" N");
		}
	else
		{
		vWriteCMD(0x8E);
		if(b_CapStatus==0)
			vShowChar("BC");
		else
			vShowChar("SC");
		}

	vWriteCMD(0xC0);
	vShowChar(uca_CharBox);				  //�ָ�����ǰ���ݡ�

	vWriteCMD(0xC0+uc_CharPointer);		  //�ָ�����ǰ���λ�á�

	vWriteCMD(0x0F);					  //�ָ���ʾģʽ����ʾ��������꿪����˸����

}