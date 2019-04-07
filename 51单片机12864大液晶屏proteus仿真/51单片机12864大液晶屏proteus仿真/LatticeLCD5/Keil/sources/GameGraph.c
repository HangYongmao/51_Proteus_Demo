//*************************************************************************************************
//*																								  *
//*			 ******************************��Ϸͼ�������**************************			  *
//*																								  *
//*************************************************************************************************
#include "at89x51.h"
#include "LCD12864.h"

#define FRAMELEFT 38				   //�߿�Χ��ucLine��36~127��
									


//*************************************************************************************************
//*																								  *
//*			 ******************************��Ϸ����߿���ƺ���**************************		  *
//*																								  *
//*************************************************************************************************
void vShowFrame()
{
	unsigned char ucCount;
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<���������>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	CS1=1;
	CS2=0;
	vWriteCMD(LCDPAGE);
	vWriteCMD(LCDLINE+FRAMELEFT);
	for(ucCount=FRAMELEFT;ucCount<64;ucCount++)
		vWriteData(0xC0);

	for(ucCount=1;ucCount<7;ucCount++)
		{
		vWriteCMD(LCDPAGE+ucCount);
		vWriteCMD(LCDLINE+FRAMELEFT);
		vWriteData(0xFF);
		vWriteData(0xFF);
		}

	vWriteCMD(LCDPAGE+7);
	vWriteCMD(LCDLINE+FRAMELEFT);
	for(ucCount=FRAMELEFT;ucCount<64;ucCount++)
		vWriteData(0x03);
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<�����Ұ���>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	CS1=0;
	CS2=1;
	vWriteCMD(LCDPAGE);
	vWriteCMD(LCDLINE);
	for(ucCount=0;ucCount<62;ucCount++)
		vWriteData(0xC0);

	for(ucCount=1;ucCount<7;ucCount++)
		{
		vWriteCMD(LCDPAGE+ucCount);
		vWriteCMD(LCDLINE+60);
		vWriteData(0xFF);
		vWriteData(0xFF);
		}

	vWriteCMD(LCDPAGE+7);
	vWriteCMD(LCDLINE);
	for(ucCount=0;ucCount<62;ucCount++)
		vWriteData(0x03);
}