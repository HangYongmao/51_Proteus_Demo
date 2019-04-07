//*************************************************************************************************
//*																								  *
//*		**************************************显示介绍！*************************************	  *
//*																								  *
//*************************************************************************************************
#include "SMC1602.h"

//在使用介绍时，注意：b_Introduce必须和vIntroduce（）配合使用。

bit b_Introduce=1;					//用于关闭介绍。1--滚动介绍；0--退出介绍。

extern unsigned char uca_CharBox[];
extern unsigned char uc_CharPointer;
extern bit b_CapStatus;
extern bit b_InputMode;

void vIntroduce()
{
	unsigned int uiCount;											 //循环滚动显示:
	unsigned char ucCount;											 //  Hello.Sir! I
	unsigned char ucaIntroduce[5][16]=								 //am clear ! I Can 
						{"                ","Hello. Sir! I am",		 //show what you
						 "clear!I can show","what you press !",		 //press!    ^-^
						 "       ^-^      "
						};

	vWriteCMD(0x0C);						  //改变显示模式：文字不动，光标自动右移。

	for(ucCount=0;b_Introduce==1;ucCount++)
		{
		vWriteCMD(0x80);					  //刷新第一行。
		vShowChar(ucaIntroduce[ucCount]);

		vWriteCMD(0xC0);					  //刷新第二行。
		if(ucCount==4)
			ucCount=0;
		vShowChar(ucaIntroduce[ucCount+1]);

		for(uiCount=0;uiCount<35000;uiCount++);
		}
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<结束介绍，恢复屏幕>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	vWriteCMD(0x80);						 
	vShowChar("Please Input: ");			//恢复提示信息。

	if(b_InputMode==0)
		{									//恢复状态标志。
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
	vShowChar(uca_CharBox);				  //恢复介绍前数据。

	vWriteCMD(0xC0+uc_CharPointer);		  //恢复介绍前光标位置。

	vWriteCMD(0x0F);					  //恢复显示模式：显示器开、光标开、闪烁开。

}