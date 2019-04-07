//*************************************************************************************************
//*																								  *
//*		***************************�ӣͣã���������������*************************				  *
//*																								  *
//*************************************************************************************************


//*************************************************************************************************
//*																								  *
//*			 ******************************ͷ�ļ����궨��**************************				  *
//*																								  *
//*************************************************************************************************
#include <at89x51.h>

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<�˿����ú궨��>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#define LCDRS P3_5								   //�Ĵ���ѡ���źţ�
												   //		0--���ݼĴ�����
												   //		1--ָ��Ĵ�����

#define LCDRW P3_6								   //��д�źţ�
												   //		1--��LCD��
												   //		0--дLCD��

#define LCDE P3_7								   //Ƭѡ�źţ��������½����ź�ʱ��
												   //ִ��ָ��������ݡ�

#define LCDPORT P0								   //LCD���ݽӿڡ�



//*************************************************************************************************
//*																								  *
//*			 ******************************��ʱ����*****************************				  *
//*																								  *
//*************************************************************************************************
void vDelay()
{
	unsigned int uiCount;
	for(uiCount=0;uiCount<250;uiCount++);
}


//*************************************************************************************************
//*																								  *
//*			 **************************��1������д��LCD*************************				  *
//*																								  *
//*************************************************************************************************
void vWriteCMD(unsigned char ucCommand)					  
{
	vDelay();				//����ʱ��

	LCDE=1;					//Ȼ��ѣ̣ãĸ�Ϊд������״̬��
	LCDRS=0;
	LCDRW=0;

	LCDPORT=ucCommand;		//��������

	LCDE=0;					//���ִ�����
}


//*************************************************************************************************
//*																								  *
//*			 ***************************��1������д��LCD************************				  *
//*																								  *
//*************************************************************************************************
void vWriteData(unsigned char ucData)					  
{
	vDelay();			   //����ʱ��

	LCDE=1;				   //Ȼ��ѣ̣ãĸ�Ϊд������״̬��
	LCDRS=1;
	LCDRW=0;

	LCDPORT=ucData;		   //��������ݡ�

	LCDE=0;				   //�����ʾ���ݡ�
}



//*************************************************************************************************
//*																								  *
//*			 **********************��1���ַ���ʾ����ǰ��괦*********************				  *
//*																								  *
//*************************************************************************************************
void vShowOneChar(unsigned char ucChar)
{
	switch(ucChar)
		{
		case ' ': vWriteData(0x20);break;
		case '!': vWriteData(0x21);break;
		case '"': vWriteData(0x22);break;
		case '#': vWriteData(0x23);break;
		case '$': vWriteData(0x24);break;
		case '%': vWriteData(0x25);break;
		case '&': vWriteData(0x26);break;
		case '>': vWriteData(0x27);break;
		case '(': vWriteData(0x28);break;
		case ')': vWriteData(0x29);break;
		case '*': vWriteData(0x2A);break;
		case '+': vWriteData(0x2B);break;
		case '-': vWriteData(0x2D);break;
		case '.': vWriteData(0x2E);break;
		case '/': vWriteData(0x2F);break;
		case '=': vWriteData(0x3D);break;
		case '<': vWriteData(0x3E);break;
		case '?': vWriteData(0x3F);break;
		case '^': vWriteData(0x5E);break;
		case ':': vWriteData(0x3A);break;

		case '0': vWriteData(0x30);break;
		case '1': vWriteData(0x31);break;
		case '2': vWriteData(0x32);break;
		case '3': vWriteData(0x33);break;
		case '4': vWriteData(0x34);break;
		case '5': vWriteData(0x35);break;
		case '6': vWriteData(0x36);break;
		case '7': vWriteData(0x37);break;
		case '8': vWriteData(0x38);break;
		case '9': vWriteData(0x39);break;

		case 'A': vWriteData(0x41);break;
		case 'B': vWriteData(0x42);break;
		case 'C': vWriteData(0x43);break;
		case 'D': vWriteData(0x44);break;
		case 'E': vWriteData(0x45);break;
		case 'F': vWriteData(0x46);break;
		case 'G': vWriteData(0x47);break;
		case 'H': vWriteData(0x48);break;
		case 'I': vWriteData(0x49);break;
		case 'J': vWriteData(0x4A);break;
		case 'K': vWriteData(0x4B);break;
		case 'L': vWriteData(0x4C);break;
		case 'M': vWriteData(0x4D);break;
		case 'N': vWriteData(0x4E);break;
		case 'O': vWriteData(0x4F);break;
		case 'P': vWriteData(0x50);break;
		case 'Q': vWriteData(0x51);break;
		case 'R': vWriteData(0x52);break;
		case 'S': vWriteData(0x53);break;
		case 'T': vWriteData(0x54);break;
		case 'U': vWriteData(0x55);break;
		case 'V': vWriteData(0x56);break;
		case 'W': vWriteData(0x57);break;
		case 'X': vWriteData(0x58);break;
		case 'Y': vWriteData(0x59);break;
		case 'Z': vWriteData(0x5A);break;

		case 'a': vWriteData(0x61);break;
		case 'b': vWriteData(0x62);break;
		case 'c': vWriteData(0x63);break;
		case 'd': vWriteData(0x64);break;
		case 'e': vWriteData(0x65);break;
		case 'f': vWriteData(0x66);break;
		case 'g': vWriteData(0x67);break;
		case 'h': vWriteData(0x68);break;
		case 'i': vWriteData(0x69);break;
		case 'j': vWriteData(0x6A);break;
		case 'k': vWriteData(0x6B);break;
		case 'l': vWriteData(0x6C);break;
		case 'm': vWriteData(0x6D);break;
		case 'n': vWriteData(0x6E);break;
		case 'o': vWriteData(0x6F);break;
		case 'p': vWriteData(0x70);break;
		case 'q': vWriteData(0x71);break;
		case 'r': vWriteData(0x72);break;
		case 's': vWriteData(0x73);break;
		case 't': vWriteData(0x74);break;
		case 'u': vWriteData(0x75);break;
		case 'v': vWriteData(0x76);break;
		case 'w': vWriteData(0x77);break;
		case 'x': vWriteData(0x78);break;
		case 'y': vWriteData(0x79);break;
		case 'z': vWriteData(0x7A);break;

		default: break;
		}
}

//*************************************************************************************************
//*																								  *
//*			 *********************��1���ַ�����ʾ����ǰ��괦*******************				  *
//*																								  *
//*************************************************************************************************
void vShowChar(unsigned char ucaChar[])
{
	unsigned char ucCount;
	for(ucCount=0;;ucCount++)
		{
		vShowOneChar(ucaChar[ucCount]);
		if(ucaChar[ucCount+1]=='\0')
			break;
		}
}



/*
//*************************************************************************************************
//*																								  *
//*			 *********************��1��3λ������ʾ����ǰ��괦*******************				  *
//*																								  *
//*************************************************************************************************
void vShowNumber(unsigned int uiNumber)
{
	unsigned char ucaNumber[3],ucCount;

	if(uiNumber>999)					
		uiNumber=999;

	ucaNumber[0]=uiNumber/100;								//�Ѽ������ֵ�ÿ��λ�������顣
	ucaNumber[1]=(uiNumber-100*(int)ucaNumber[0])/10;							
	ucaNumber[2]=uiNumber-100*(int)ucaNumber[0]-10*ucaNumber[1];

	for(ucCount=0;ucCount<3;ucCount++)
		{
		vShowOneChar(ucaNumber[ucCount]+48);				//����λ��ĩλ��һ�����
		}

}
*/