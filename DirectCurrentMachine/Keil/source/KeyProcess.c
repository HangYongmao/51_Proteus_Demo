//*************************************************************************************************
//*																								  *
//*			 ******************************���봦�����**************************				  *
//*																								  *
//*************************************************************************************************


//*************************************************************************************************
//*																								  *
//*			 ******************************ͷ�ļ����궨��**************************				  *
//*																								  *
//*************************************************************************************************
#include "at89x51.h"
#include "SMC1602.h"

#define MOTORPORT P1		  //����ӿڡ�

#define MO_COMMON 0x09		  //����
#define MO_OPPOSE 0x06		  //����
#define MO_CUTOFF 0x00		  //�жϡ�
#define MO_STOP 0x0A		  //ֹͣ��
//*************************************************************************************************
//*																								  *
//*			  *******************************ȫ�ֱ���*****************************				  *
//*																								  *
//*************************************************************************************************

extern unsigned char uc_MoChange;



//*************************************************************************************************
//*																								  *
//*			  *******************************���봦�����**************************				  *
//*																								  *
//*************************************************************************************************
void vKeyProcess(unsigned char ucKeyCode)
{
	switch(ucKeyCode)
		{
		case 14:
				MOTORPORT=MO_COMMON;

				vWriteCMD(0xC4);
				vShowChar("Common");
				uc_MoChange=255;
				break;

											  
		case 24:
				MOTORPORT=MO_OPPOSE;

				vWriteCMD(0xC4);
				vShowChar("Oppose");
				uc_MoChange=0;
				break;

											 
		case 34:
				MOTORPORT=MO_STOP;

				vWriteCMD(0xC4);
				vShowChar("Stop   ");
				uc_MoChange=128;
				break;

											 
		case 44:
				MOTORPORT=MO_CUTOFF;

				vWriteCMD(0xC4);
				vShowChar("CutOff");
				uc_MoChange=128;
				break;

				
		case 13:
				if(uc_MoChange<251)
					uc_MoChange+=5;

				break;


		case 23:
				if(uc_MoChange>4)
					uc_MoChange-=5;

				break;
		case 33:
				if(uc_MoChange<255)
					uc_MoChange++;

				break;


		case 43:
				if(uc_MoChange>0)
					uc_MoChange--;

				break;
											 

		default:break;
		}

	vWriteCMD(0xCC);
	vShowNumber(uc_MoChange);
}