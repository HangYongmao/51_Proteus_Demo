#include <at89x52.h>
#include <stdio.h>
#include <absacc.h>
#include <intrins.h>
#include <xbyte.h>
#include <lcd_code.h>
#include <ocm12864.h>
#include <iic.h>
#include <pca9555.h>
#include <18b20.H>
#include <24c32.h>
#include <menu_func.h>

typedef xdata struct  
	{
	    uchar KeyTab_MenuIndex;	         	//当前状态索引号	   
        uchar KeyTab_PressOk;           	//按下"回车"键时转向的状态索引号	  
        uchar KeyTab_PressEsc;	        	//按下"返回"键时转向的状态索引号	  
        uchar KeyTab_PressDown;    	        //按下"向下"键时转向的状态索引号	  
        uchar KeyTab_PressUp;           	//按下"向上"键时转向的状态索引号	  
     	void      ( code *CurrentOperate)();   //当前状态应该执行的功能操作
	}KeyTabStruct;
void  ( code *KeyFuncPtr)();                       //按键功能指针
//CurMenuID=本菜单ID 
//OkMenuID=子菜单层所对应的菜单ID,ID=254已经到底了		 
//EscMenuID=父菜单层所对应的菜单ID,ID=254为菜单已经到顶了			 
//DownMenuID=弟菜单层所对应的菜单ID,ID=254为菜单是独生子		   
//UpMenuID=兄菜单层所对应的菜单ID,ID=254 单是独生子			   
//CurFunction=本菜单所对应的菜单函数指针
KeyTabStruct xdata KeyTab[]=
	{
		//CurMenuID,        OkMenuID,         EscMenuID,       DownMenuID,           UpMenuID,        CurFunction
		{MENU_FACE, 	    MENU_ROOT,        254,             254,                  254,             (*DispFaceBmp)},
		{MENU_ROOT,	        MENU_VIEW,        254,             254,                  254,             (*DispMenu_Root)},
		{MENU_VIEW,	        MENU_VIEW_1,      MENU_ROOT,       MENU_OPERATION,       MENU_HELP,       (*DispMenu_View)},
		{MENU_VIEW_1,       254,              MENU_VIEW,       MENU_VIEW_2,	         MENU_VIEW_3,     (*Menu_DispTmp)},
		{MENU_VIEW_2,       254,              MENU_VIEW,       MENU_VIEW_3,	         MENU_VIEW_1,     (*Menu_DAC0808)},
		{MENU_VIEW_3,       254,              MENU_VIEW,       MENU_VIEW_1,          MENU_VIEW_2,     (*Menu_ADC0832)},
		{MENU_OPERATION,	MENU_OPERATION_1, MENU_ROOT,   	   MENU_TEST,            MENU_VIEW,       (*DispMenu_Operation)},
		{MENU_OPERATION_1,  254,              MENU_OPERATION,  MENU_OPERATION_2,     MENU_OPERATION_3,(*Menu_Motor_s)},
		{MENU_OPERATION_2,  254,              MENU_OPERATION,  MENU_OPERATION_3,     MENU_OPERATION_1,(*MenuFunction)},
		{MENU_OPERATION_3,  254,              MENU_OPERATION,  MENU_OPERATION_1,     MENU_OPERATION_2,(*Menu_MemoryData)},			
		{MENU_TEST,         MENU_TEST_1,      MENU_ROOT,       MENU_HELP,            MENU_OPERATION,  (*DispMenu_Test)},
		{MENU_TEST_1,       254,              MENU_TEST,       MENU_TEST_2,          MENU_TEST_3,     (*Menu_SerialReceive_PC)},
		{MENU_TEST_2,    	254,              MENU_TEST,       MENU_TEST_3,          MENU_TEST_1,     (*Menu_SerialSend_PC)},
		{MENU_TEST_3,    	254,              MENU_TEST,       MENU_TEST_4,          MENU_TEST_2,     (*Menu_SerialReceive_MCU)},
		{MENU_TEST_4,    	254,              MENU_TEST,       MENU_TEST_1,          MENU_TEST_3,     (*Menu_SerialSend_MCU)},
		{MENU_HELP,         MENU_HELP_1,      MENU_ROOT,       MENU_VIEW,            MENU_TEST,       (*DispMenu_Help)},
		{MENU_HELP_1,       254,              MENU_HELP,       MENU_HELP_2,          MENU_HELP_2,     (*MenuFunction)},
		{MENU_HELP_2,	    254,              MENU_HELP,       MENU_HELP_1,          MENU_HELP_1, 	  (*MenuFunction_Help_2)},
	};

/*----------------------接收菜单功能键－－－－－－－－－*/
void GetKeyInput()
{
       	switch(NowKey)			 
			{
			  case	KEY_OK://   KEY_OK,		KEY_UP,		KEY_ESC,
				   	
				          if(KeyTab[iMenuID].KeyTab_PressOk!=254)		    //   按下OK键时的状态
						  {
						     iMenuID=KeyTab[iMenuID].KeyTab_PressOk;
						     JudgeHLight();	 					 	 				  		
						  }
				     	else											    //已经到底层
						  {
						     KeyFuncPtr=KeyTab[iMenuID].CurrentOperate;					 							 
    			             ( *KeyFuncPtr)();			 				    //      执行当前ID的功能函数
						  }	   
						     				
					break;			
		     case	KEY_ESC:
					
					if(KeyTab[iMenuID].KeyTab_PressEsc!=254)
						{					      
						   iMenuID=KeyTab[iMenuID].KeyTab_PressEsc;         //     按下ESC键时的状态  	  
						   JudgeHLight();	   		 		
						}
					break;
			 case	KEY_DOWN:
					if(KeyTab[iMenuID].KeyTab_PressDown!=254)
						{												//     按下DOWN键时的状态
						  iMenuID=KeyTab[iMenuID].KeyTab_PressDown;
						  JudgeHLight();					
						}
					break;
		     case	KEY_UP:
					if(KeyTab[iMenuID].KeyTab_PressUp!=254)
						{												 //       按下UP键时的状态
					    	iMenuID=KeyTab[iMenuID].KeyTab_PressUp;	
					     	JudgeHLight();						
						}
					break; 		
					 					
			 default:
					break; 		
		}

}





/*-----------显示当前的菜单----------*/
void JudgeHLight()
{
   switch(iMenuID)
	{
	  case	MENU_FACE:
			DispFaceBmp();
			break;
      case	MENU_ROOT:
			DispFaceBmp();
			break;
	  case	MENU_VIEW:
			DispMenu_Root();
			break;
	  case	MENU_VIEW_1:
	  case	MENU_VIEW_2:
	  case  MENU_VIEW_3:	
			DispMenu_View();
			break;
	  case	MENU_OPERATION:
			DispMenu_Root();
			break;
	  case	MENU_OPERATION_1:
	  case	MENU_OPERATION_2:
	  case	MENU_OPERATION_3:
			DispMenu_Operation();
			break;
	  case	MENU_TEST:
			DispMenu_Root();
			break;
	  case	MENU_TEST_1:
	  case	MENU_TEST_2:
	  case  MENU_TEST_3:
	  case  MENU_TEST_4:
			DispMenu_Test();
			break;
	  case	MENU_HELP:
			DispMenu_Root();
			break;
	  case	MENU_HELP_1:
	  case  MENU_HELP_2:        
			DispMenu_Help();
			break; 		
	  default:
			break;
	}

//////////////////////////反百显示当前按钮//////////////////////
	switch (iMenuID)								 
	  {   
	      case  MENU_VIEW: 
				  
				   chn_fdisp(0,0,2,16,1,2,hz_view);					  
			
				break;
		  case  MENU_VIEW_1: 
				  
				    chn_fdisp(0,0,2,16,1,2,hz_view_1); 
				   
				break;
		  case  MENU_VIEW_2:		          
				    chn_fdisp(2,0,2,16,1,2,hz_view_2);				   
				break;
		  case  MENU_VIEW_3:
		            chn_fdisp(4,0,2,16,1,1,hz_view_2+32); 
                    chn_fdisp(4,16,2,16,1,1,hz_view_2);
		        break;
		  case  MENU_OPERATION: 

				   chn_fdisp(2,0,2,16,1,2,hz_operation);
				break;
		  case  MENU_OPERATION_1: 

				   chn_fdisp(0,0,2,16,1,4,hz_operation_1);
				break;
		  case  MENU_OPERATION_2:   
				   chn_fdisp(2,0,2,16,1,2,hz_operation_2);	//数据
                   chn_fdisp(2,32,2,16,1,2,hz_operation_3);	//存储
				break;
		  case  MENU_OPERATION_3:   
				   
				 chn_fdisp(4,0,2,16,1,2,hz_operation_2);    //数据
                 chn_fdisp(4,32,2,16,1,2,hz_operation_4);	//读取 
				break;
		  case  MENU_TEST: 
				   
				   chn_fdisp(4,0,2,16,1,2,hz_test);
				  
				break;
		  case  MENU_TEST_1:			  
				   
				    chn_fdisp(0,0,2,16,1,2,hz_test_1);
                    chn_fdisp(0,32,2,16,1,2,hz_test_2);	
				  				
				break;
		  case  MENU_TEST_2: 			   				   
                  
				   chn_fdisp(2,0,2,16,1,2,hz_test_1);
                   chn_fdisp(2,32,2,16,1,2,hz_test_3);				
				  
				break;
		  case  MENU_TEST_3:
		         chn_fdisp(4,0,2,16,1,2,hz_test_4);
                 chn_fdisp(4,32,2,16,1,2,hz_test_2);
		        break;
		  case  MENU_TEST_4:
		          chn_fdisp(6,0,2,16,1,2,hz_test_4);
                  chn_fdisp(6,32,2,16,1,2,hz_test_3); 
		        break;
		  case  MENU_HELP:	       
				   chn_fdisp(6,0,2,16,1,2,hz_help);				
				break;		  
		  case  MENU_HELP_1: 			   
				   chn_fdisp(0,0,2,16,1,2,hz_help);
                   num_disp(1,0,32,1); 			 
				break;
		  case  MENU_HELP_2:
				   chn_fdisp(2,0,2,16,1,2,hz_about);
				break;
		  default: 
				break;    
	  }

}

void MenuFunction()
{    
}

/*-------显示开机画面-------*/
void DispFaceBmp()
{  
   clrscr();
   cs1=1;
   cs2=0;
   chn_disp(0,0,2,16,1,4,hz_face);
   chn_disp(4,0,2,16,1,3,hz_make);
   chn_disp(6,32,2,8,1,4,hz_me);
   cs1=0;
   cs2=1;
   chn_disp(0,0,2,16,1,4,(hz_face+128));
   chn_disp(6,0,2,8,1,8,(hz_me+64));
     
}
/*---------显示主目录-----------*/
void DispMenu_Root()
{
   clrscr();
   cs1=1;
   cs2=0;
   chn_disp(0,0,2,16,1,2,hz_view);
   chn_disp(2,0,2,16,1,2,hz_operation);
   chn_disp(4,0,2,16,1,2,hz_test);
   chn_disp(6,0,2,16,1,2,hz_help);
} 
/*-----------显示查看子目录----------*/
void DispMenu_View()
{
   clrscr();
   cs1=1;
   cs2=0;	   
   chn_disp(0,0,2,16,1,2,hz_view_1);  		  //温度
   chn_disp(2,0,2,16,1,2,hz_view_2);		  //数模
   chn_disp(4,0,2,16,1,1,hz_view_2+32); 	  //模数
   chn_disp(4,16,2,16,1,1,hz_view_2); 
}
/*-----------显示工具子目录----------*/
void DispMenu_Operation()
{
  clrscr();
  cs1=1;
  cs2=0;
  chn_disp(0,0,2,16,1,4,hz_operation_1);
  chn_disp(2,0,2,16,1,2,hz_operation_2);	//数据
  chn_disp(2,32,2,16,1,2,hz_operation_3);	//存储
  chn_disp(4,0,2,16,1,2,hz_operation_2);    //数据
  chn_disp(4,32,2,16,1,2,hz_operation_4);	//读取 
}
/*-----------显示通信子目录------------*/
void DispMenu_Test()
{
  clrscr(); 
  cs1=1;
  cs2=0; 
  chn_disp(0,0,2,16,1,2,hz_test_1);
  chn_disp(0,32,2,16,1,2,hz_test_2);
  chn_disp(2,0,2,16,1,2,hz_test_1);
  chn_disp(2,32,2,16,1,2,hz_test_3);
  chn_disp(4,0,2,16,1,2,hz_test_4);
  chn_disp(4,32,2,16,1,2,hz_test_2);
  chn_disp(6,0,2,16,1,2,hz_test_4);
  chn_disp(6,32,2,16,1,2,hz_test_3);  
}
/*--------------显示帮助子目录----------*/
void DispMenu_Help()
{  
   clrscr();	   
   num_disp(1,0,32,1);
   chn_disp(0,0,2,16,1,2,hz_help);   
   chn_disp(2,0,2,16,1,2,hz_about);	
}
/*-------------------输出文本-------------------------*/
void GetTextInput()
{
   while(NowKey==KEY_shift)					  //2ND上当键判断
   {
	  EX0=1;
	  cs1=0;
	  //cs2=1;      
	  chn_disp(6,48,2,16,1,1,hz_shift);
	  if (NowKey==KEY_1)
	       NowKey=KEY_A;
	  if (NowKey==KEY_2)
	       NowKey=KEY_B;
	  if (NowKey==KEY_3)
	       NowKey=KEY_C;
	  if (NowKey==KEY_4)
	       NowKey=KEY_D;
	  if (NowKey==KEY_5)
	       NowKey=KEY_E;
	  if (NowKey==KEY_6)
	       NowKey=KEY_F;
   }
   chn_disp(6,48,2,16,1,1,hz_null);							 
	if (NowKeyReg)				              //    判断当前按键有无变化
		{  
		   KeyInputTemp=1;
		   if (NowKey==KEY_0)				  //    查当前按键的键对应的数字
		        TextInputTemp=0;
		   else if(NowKey==KEY_1)
		        TextInputTemp=1;
		   else if(NowKey==KEY_2)
		        TextInputTemp=2;
		   else if(NowKey==KEY_3)
		        TextInputTemp=3;
		   else if(NowKey==KEY_4)
		        TextInputTemp=4;
		   else if(NowKey==KEY_5)
		        TextInputTemp=5;
		   else if(NowKey==KEY_6)
		        TextInputTemp=6;
		   else if(NowKey==KEY_7)
		        TextInputTemp=7;
		   else if(NowKey==KEY_8)
		        TextInputTemp=8;
		   else if(NowKey==KEY_9)
		        TextInputTemp=9;
		   else if(NowKey==KEY_A)
		        TextInputTemp=10;
		   else if(NowKey==KEY_B)
		        TextInputTemp=11;
		   else if(NowKey==KEY_C)
		        TextInputTemp=12;
		   else if(NowKey==KEY_D)
		        TextInputTemp=13;
		   else if(NowKey==KEY_E)
		        TextInputTemp=14;
		   else if(NowKey==KEY_F)
		        TextInputTemp=15;
		   else   KeyInputTemp=0; 	 
		   NowKeyReg=0;
	    }
	 
}
/*---------------------------文本输入------------------------------*/
void Menu_TextInput()
{
	 uchar x,y,j;
	 bit cs3=1;	 
	 clrscr();	 	 
	 KeyInputTemp=0;
	 	 
	 while (NowKey!=KEY_ESC)	   			       //   按ESC键退出
	 {
	    EX0=1;						 
		GetTextInput();
		if (KeyInputTemp==1)					   //    输出数字
		 { 
		       num_disp(cs3,x,y,TextInputTemp);			   
			   y+=8;
			   if(y==64)						   //     输出8个数字时换右屏
			   {
			     cs3=!cs3;
				 y=0;
				 j++;								  
			   }
			   if(j==2)							   //      输出16个数字时换行
			   {
			     x+=2;
				 j=0;
			   }
			   if(x==8)
			   { 
			      x=0;
				  clrscr();
			   }
			   KeyInputTemp=0;			   
		 }
	  	 
	 }
	 
   Menu_Back();

}

/*------------温度监测--------------*/
void Menu_DispTmp()
{
   
  clrscr();
  config_18b20();
  chn_disp(0,0,2,16,1,2,hz_view_1);  
  while(NowKey!=KEY_ESC)
  {	  
      EX0=1;    
      get_tmp();
	  if(tmp>99)
	  {   
		 num_disp(0,0,0,tmp/100);				   //显示百位
	     num_disp(0,0,8,tmp/10%10);				   //显示十位
		 num_disp(0,0,16,tmp%100%10);			   //显示个位
		 chn_disp(0,24,2,8,1,1,hz_dot);
		 num_disp(0,0,32,tmpd);			   //小数点后一位 		 
		 chn_disp(0,40,2,8,1,1,hz_oc);
	  }
	  else  
	    {
	     
		 num_disp(0,0,8,tmp/10);
		 num_disp(0,0,16,tmp%10);
		 if(tmp_f)
		  {
		   chn_disp(0,0,2,8,1,1,hz_s_);			  //显示负号
		  }
		 else chn_disp(0,0,2,8,1,1,hz_null);	  // 不显示负号
		 chn_disp(0,24,2,8,1,1,hz_dot);
		 num_disp(0,0,32,tmpd);
		// con_disp(0,0,40,tmpd%10);			  //小数点后两位
		 chn_disp(0,40,2,8,1,1,hz_oc);
	    }

  }
 Menu_Back();
}
/*--------------步进电机--------------------*/
void Menu_Motor_s()
{
  uchar P_motor[]={0x02,0x06,0x04,0x0c,0x08,0x09,0x01,0x03};
  uchar i=0;
  clrscr();
  EX0=1;
  COM8255=0x82;
  while(NowKey!=KEY_ESC)
  {
   EX0=1;
   if (NowKey==KEY_1)
   {
     PC8255=P_motor[i];
	 delay(254);
	 i++;
	 NowKey=0xff;	 
	 if(i==8)
	 {
	   i=0;
	 } 
   }
   if(NowKey==KEY_2)
   {
     i--;
	 if(i>7)
	 {
	   i=7;
	 }
	 NowKey=0xff;
	 PC8255=P_motor[i];
	 delay(254);
   }
  }
}
void Menu_MemoryData()
{
    //uchar idata temp1[]={0x02,0x04,0x99,0x76,0x47};
	uchar idata *temp2,addr=0x02;
//	uchar i,j,x,y;
//	bit cs3;
//	cs3=1;
	clrscr();
	Ipt9555(temp2);
	temp2++;	
	num_disp(1,0,0,(*temp2)>>4);
	num_disp(1,0,8,(*temp2) & 0x0f);
/*	W24C32(addr,temp1,5);
	R24C32(addr,temp2,5);	
	for (i=0;i<5;i++)
	{
	    
        con_disp(cs3,x,y,*temp2>>4);
	    y+=8;
		con_disp(cs3,x,y,*temp2&0x0f);
		y+=8;
        if(y==64)						   //     输出8个数字时换右屏
	    {
		  cs3=!cs3;
		  y=0;
		  j++;								  
	    }
	   if(j==2)							   //      输出16个数字时换行
	   {
	      x+=2;
	      j=0;
	   }
	   if(x==8)
	   { 
	      x=0;
	      clrscr();
	   }
	}*/
   while(1);
   Menu_Back();
}
/*-------------模数转换－－－－－－－－*/
void Menu_ADC0832()
{  
    uchar adtemp;
	clrscr();
	EX0=1;
	chn_disp(0,0,2,8,1,2,hz_in);		   //IN
	chn_disp(0,24,2,8,1,1,hz_mh);		   //:
	chn_disp(2,0,2,8,1,2,hz_in);           //in
	chn_disp(2,24,2,8,1,1,hz_mh);
	chn_disp(4,0,2,8,1,2,hz_in);
	chn_disp(4,24,2,8,1,1,hz_mh);
	chn_disp(6,0,2,8,1,2,hz_in);
	chn_disp(6,24,2,8,1,1,hz_mh);
	num_disp(1,0,16,0);
	num_disp(1,2,16,1);
	num_disp(1,4,16,2);
	num_disp(1,6,16,3);
	num_disp(0,0,16,4);
	num_disp(0,2,16,5);
	num_disp(0,4,16,6);
	num_disp(0,6,16,7);
	while(NowKey!=KEY_ESC) 
    {	
      AD0809_IN0=0X00;
	  delay(200);
	  adtemp=AD0809_IN0;
	  num_disp(1,0,32,(adtemp&0xf0)>>4);
	  num_disp(1,0,40,(adtemp&0x0f));
    }				
   Menu_Back();
}
/*--------------数模转换-------------------*/
void Menu_DAC0808()
{
   uchar cs3,x,y,j,ADCtemp;
   cs3=1;
   clrscr();
   NowKey=0xff;
   while (NowKey!=KEY_OK)
   {
      EX0=1;
	  GetTextInput();
	  if(KeyInputTemp==1)
	  {
	    ADCtemp<<=4;
	    ADCtemp+=TextInputTemp;
	    num_disp(cs3,x,y,TextInputTemp);
	    y+=8;
        if(y==64)						   //     输出8个数字时换右屏
	    {
		  cs3=!cs3;
		  y=0;
		  j++;								  
	    }
	   if(j==2)							   //      输出16个数字时换行
	   {
	      x+=2;
	      j=0;
	   }
	   if(x==8)
	   { 
	      x=0;
	      clrscr();
	   }
	   KeyInputTemp=0; 
	  }
   }
  Opt9555(Cmd_op0,ADCtemp);  
  while(NowKey!=KEY_ESC);
  Menu_Back();   
}
/*---------------- 与PC通信－－串口接收--------------*/
void Menu_SerialReceive_PC()
{
   uchar cs3,x,y,j;
   uchar PSerial;
   clrscr();
   cs1=1;
   cs2=0;
   chn_disp(0,0,2,16,1,2,hz_test_1);			  //显示起始行
   chn_disp(0,32,2,16,1,2,hz_test_2);   
   cs1=0;
   cs2=1;
   chn_disp(0,32,2,16,1,2,hz_test);
   chn_disp(0,0,2,16,1,2,hz_jishi);
   x=2;   
   y=0;
   cs3=1;   
   TMOD=0x20;
   TH1=0xfd;
   TL1=0xfd;
   TR1=1;
   SCON=0x50;      
   while (1)
   {          		   	
	    EX0=1;
		while(!RI)
		 if (NowKey==KEY_ESC) goto Exit_SerialReceive;
	    RI=0;
		PSerial=SBUF;	   
		num_disp(cs3,x,y,PSerial&0x0f);
		y+=8;
        if(y==64)						   //     输出8个数字时换右屏
	    {
		  cs3=!cs3;
		  y=0;
		  j++;								  
	    }
	   if(j==2)							   //      输出16个数字时换行
	   {
	      x+=2;
	      j=0;
	   }
	   if(x==8)
	   { 
	      x=2;
	      clrscr();
	   }

   }  
   Exit_SerialReceive:
   NowKeyReg=0; 
   Menu_Back();    
}
/*------------------与PC通信－－串口发送-----------------*/
void Menu_SerialSend_PC()
{
   uchar cs3,x,y,k,j;
   uchar PSerial;
   clrscr();
   cs1=1;
   cs2=0;
   chn_disp(0,0,2,16,1,2,hz_test_1);				 //显示起始行
   chn_disp(0,32,2,16,1,2,hz_test_3);   
   cs1=0;
   cs2=1;
   chn_disp(0,32,2,16,1,2,hz_test);
   chn_disp(0,0,2,16,1,2,hz_jishi);
   x=2;   
   y=0;   
   cs3=1;   
   TMOD=0x20;
   TH1=0xfd;
   TL1=0xfd;
   TR1=1;
   SCON=0x40;     
   while (NowKey!=KEY_ESC)
   {
      EX0=1;
	  GetTextInput();
	  if(KeyInputTemp==1)
	  {
	    PSerial<<=4;
	    PSerial+=TextInputTemp;
	    num_disp(cs3,x,y,TextInputTemp);
		k++;
		if(k==2)
		{ 	  
		 k=0;
		 SBUF=PSerial;    	
	     while(!TI);
	     TI=0;
		}		
	    y+=8;
        if(y==64)						   //     输出8个数字时换右屏
	    {
		  cs3=!cs3;
		  y=0;
		  j++;								  
	    }
	   if(j==2)							   //      输出16个数字时换行
	   {
	      x+=2;
	      j=0;
	   }
	   if(x==8)
	   { 
	      x=2;
	      clrscr();
	   }
	   KeyInputTemp=0; 
	  }
   }
  Menu_Back();   
}
void Menu_SerialReceive_MCU()
{
}
void Menu_SerialSend_MCU()
{
}
/*----------------返回菜单－－－－－－－－*/
void Menu_Back()
{
   NowKey=0xff;
   clrscr();
   JudgeHLight();
}
/*----------------版本说明------------*/
void MenuFunction_Help_2()
{
  DispFaceBmp();
  NowKey=0xff;
  EX0=1;   
  while(NowKey==0xff);					  // 按任意键退出  
  Menu_Back();
}


