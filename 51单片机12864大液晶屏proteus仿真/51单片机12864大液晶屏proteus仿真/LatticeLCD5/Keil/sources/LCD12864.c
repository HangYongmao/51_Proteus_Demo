//*************************************************************************************************
//*																								  *
//*			 ******************************LCD12864��������**************************			  *
//*																								  *
//*************************************************************************************************

//*************************************************************************************************
//*																								  *
//*			 ******************************ͷ�ļ����궨��**************************				  *
//*																								  *
//*************************************************************************************************
#include <at89x51.h>

#define	RST P2_0
#define	E P2_1
#define	RW P2_2
#define	DI P2_3
#define	CS1 P2_5
#define	CS2	P2_4
#define	LCDPORT P0


#define BUSYSTATUS P0_7				  //æ״̬λ��
//#define DISONSTATUS P0_5			  //��ʾ����״̬λ��
//#define RSTSTATUS P0_4			  //��λ״̬λ��


#define LCDSTARTROW 0xC0			  //������ʼ��ָ�
#define LCDPAGE 0xB8				  //����ҳָ�
#define LCDLINE 0x40				  //������ָ�




//*************************************************************************************************
//*																								  *
//*			 ********************************��æ��־λ*********************************		  *
//*																								  *
//*************************************************************************************************
bit bCheckBusy()
{
	LCDPORT=0xFF;
	RW=1;
	DI=0;
	E=1;
	E=0;
	return BUSYSTATUS; 
}

//*************************************************************************************************
//*																								  *
//*			 ********************************д����*********************************			  *
//*																								  *
//*************************************************************************************************
void vWriteData(unsigned char ucData)
{
	while(bCheckBusy());
	LCDPORT=0xFF;

	RW=0;
	DI=1;
	LCDPORT=ucData;
	E=1;
	E=0;
}

//*************************************************************************************************
//*																								  *
//*			 ********************************дָ��*********************************			  *
//*																								  *
//*************************************************************************************************
void vWriteCMD(unsigned char ucCMD)
{
	while(bCheckBusy());
	LCDPORT=0xFF;

	RW=0;
	DI=0;
	LCDPORT=ucCMD;
	E=1;
	E=0;
}

//*************************************************************************************************
//*																								  *
//*			 ********************************LCD��ʼ������*******************************		  *
//*																								  *
//*************************************************************************************************
void vLCDInitialize()
{
	CS1=1;
	CS2=1;
	vWriteCMD(0x38);		//8λ��ʽ�������ַ���
	vWriteCMD(0x0F);		//����ʾ��
	vWriteCMD(0x01);		//������
	vWriteCMD(0x06);		//���治����������ơ�
	vWriteCMD(LCDSTARTROW);	//������ʼ�С�
}

//*************************************************************************************************
//*																								  *
//*			 ******************************��ʾ�Զ�����*********************************		  *
//*																								  *
//*************************************************************************************************
//��8��128�ĸ�������ʾ�Զ��峤�ȵ�һ��
void vShowCustomRow(unsigned char ucPage,unsigned char ucLine,unsigned char ucWidth,unsigned char *ucaRow)
{
	unsigned char ucCount;				   //ȡֵ��Χ��ucPage:0��7��ucLine:0��127��
	if(ucLine<64)						   //ucWidth:0��127��ucLine+ucWidth<1128��
		{
		CS1=1;
		CS2=0;
		vWriteCMD(LCDPAGE+ucPage);
		vWriteCMD(LCDLINE+ucLine);
		if((ucLine+ucWidth)<64)
			{
			for(ucCount=0;ucCount<ucWidth;ucCount++)
				vWriteData(*(ucaRow+ucCount));
			}
		else
			{
			for(ucCount=0;ucCount<64-ucLine;ucCount++)
				vWriteData(*(ucaRow+ucCount));

			CS1=0;
			CS2=1;
			vWriteCMD(LCDPAGE+ucPage);
			vWriteCMD(LCDLINE);
			for(ucCount=64-ucLine;ucCount<ucWidth;ucCount++)
				vWriteData(*(ucaRow+ucCount));
			}
		}
	else
		{
		CS1=0;
		CS2=1;
		vWriteCMD(LCDPAGE+ucPage);
		vWriteCMD(LCDLINE+ucLine-64);
		for(ucCount=0;ucCount<ucWidth;ucCount++)
			vWriteData(*(ucaRow+ucCount));
		}
}
//*************************************************************************************************
//*																								  *
//*			 *****************************������ʾ����***********************************		  *
//*																								  *
//*************************************************************************************************
//�˺�����16��16������ʾ��8��128�ĸ����
void vShowOneChin(unsigned char ucPage,unsigned char ucLine,unsigned char *ucaChinMap)
{
	vShowCustomRow(ucPage,ucLine,16,ucaChinMap);
	vShowCustomRow(ucPage+1,ucLine,16,ucaChinMap+16);

}
//*************************************************************************************************
//*																								  *
//*			 *****************************�ַ���ʾ����***********************************		  *
//*																								  *
//*************************************************************************************************
//�˺�����8��16�ַ���ʾ��8��128�ĸ����
void vShowOneChar(unsigned char ucPage,unsigned char ucLine,unsigned char *ucaCharMap)
{
	vShowCustomRow(ucPage,ucLine,8,ucaCharMap);
	vShowCustomRow(ucPage+1,ucLine,8,ucaCharMap+8);

}


//*************************************************************************************************
//*																								  *
//*			 **********************************��ʾͼƬ***********************************		  *
//*																								  *
//*************************************************************************************************
void vShowGraph(unsigned char ucPage,unsigned char ucLine,unsigned char ucWidth,unsigned char ucHigh,unsigned char * ucaGraph)
{
	unsigned char ucCount;
	for(ucCount=0;ucCount<ucHigh;ucCount++)
		vShowCustomRow(ucPage+ucCount,ucLine,ucWidth,ucaGraph+ucCount*ucWidth);
}
