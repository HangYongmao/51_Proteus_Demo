#ifndef __menu_func_H__
#define __menu_func_H__

//菜单号
#define MENU_FACE							        0
#define MENU_ROOT						         	1
#define 	MENU_VIEW					         	2
#define			MENU_VIEW_1			            	3
#define			MENU_VIEW_2			            	4
#define         MENU_VIEW_3                         5
#define		MENU_OPERATION					    	6
#define			MENU_OPERATION_1	            	7
#define			MENU_OPERATION_2                	8
#define         MENU_OPERATION_3					9
#define         MENU_OPERATION_4                    10
#define		MENU_TEST						        11
#define			MENU_TEST_1			            	12
#define			MENU_TEST_2			            	13
#define         MENU_TEST_3                         14
#define         MENU_TEST_4                         15
#define		MENU_HELP						        16
#define			MENU_HELP_1			            	17
#define		    MENU_HELP_2                	        18 
//键盘编码
#define KEY_OK    0x0f
#define KEY_ESC   0x0c
#define KEY_DOWN  0x07
#define KEY_UP    0x03
#define KEY_0     0x0d
#define KEY_1     0x00
#define KEY_2     0x01
#define KEY_3     0x02
#define KEY_4     0x04
#define KEY_5     0x05
#define KEY_6     0x06
#define KEY_7     0x08
#define KEY_8     0x09
#define KEY_9     0x0a
#define KEY_shift 0x0b
#define KEY_A     0x6a
#define KEY_B     0x6b
#define KEY_C     0x6c
#define KEY_D     0x6d
#define KEY_E     0x6e
#define KEY_F     0x6f
#define KeyIO     XBYTE[0x8001]						   // 键盘 IO 口

												   
uchar iMenuID;			                       //菜单索引号
uchar TextInputTemp,NowKey,temp,temp1,Motor_speed;
bit   KeyInputTemp,NowKeyReg;
//函数声明 
extern void GetKeyInput();
extern void DispFaceBmp();
extern void DispMenu_Root();
extern void DispMenu_View();
extern void DispMenu_Operation();
extern void DispMenu_Test();
extern void DispMenu_Help();					   
extern void MenuFunction();
extern void Menu_DispTmp();
extern void Menu_Memory_WrData();
extern void Menu_Memory_ReData();
extern void DispNull(uchar x); 
extern void Menu_TextInput();
extern void JudgeHLight();
extern void MenuFunction_Help_2();
extern void DispKeyID();
extern void Menu_ADC0832();
extern void Menu_DAC0808();
extern void Menu_Back();
extern void Menu_SerialReceive_PC();
extern void Menu_SerialSend_PC();
extern void Menu_SerialReceive_MCU();
extern void Menu_SerialSend_MCU();
extern void Menu_Motor_s();

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
		{MENU_OPERATION_1,  254,              MENU_OPERATION,  MENU_OPERATION_2,     MENU_OPERATION_4,(*Menu_Motor_s)},
		{MENU_OPERATION_2,  254,              MENU_OPERATION,  MENU_OPERATION_3,     MENU_OPERATION_1,(*Menu_Memory_WrData)},
		{MENU_OPERATION_3,  254,              MENU_OPERATION,  MENU_OPERATION_4,     MENU_OPERATION_2,(*Menu_Memory_ReData)},
		{MENU_OPERATION_4,  254,              MENU_OPERATION,  MENU_OPERATION_1,     MENU_OPERATION_3,(*Menu_TextInput)},			
		{MENU_TEST,         MENU_TEST_1,      MENU_ROOT,       MENU_HELP,            MENU_OPERATION,  (*DispMenu_Test)},
		{MENU_TEST_1,       254,              MENU_TEST,       MENU_TEST_2,          MENU_TEST_4,     (*Menu_SerialReceive_PC)},
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
	  case	MENU_OPERATION_4:
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
		  case	MENU_OPERATION_4:
		         chn_fdisp(6,0,2,16,1,4,hz_operation_5);
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
  chn_disp(6,0,2,16,1,4,hz_operation_5); 
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
	  //EX0=1;
	  cs1=0;
	  cs2=1;      
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
	    //EX0=1;						 
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
      //EX0=1;    
      get_tmp();
	  if(tmp>99)
	  {   
		 num_disp(0,0,0,tmp/100);				   //显示百位
	     num_disp(0,0,8,tmp/10%10);				   //显示十位
		 num_disp(0,0,16,tmp%100%10);			   //显示个位
		 chn_disp(0,24,2,8,1,1,hz_dot);
		 num_disp(0,0,32,tmpd);			          //小数点后一位 		 
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
Timer1() interrupt 3 using 1
{
  uchar P_motor2[]={0x20,0x6f,0x40,0xc0,0x80,0x90,0x10,0x30};  
  uint timer;  
  temp1=(temp1&0x0f)|P_motor2[temp];
  PC8255=temp1;  
  temp++;
  if(temp==8) 
    temp=0;
  timer=0xffff-1250000/Motor_speed;				// 定时常数计算 
  TH1=timer>>8;
  TL1=timer&&0x00ff; 
  
}

void Menu_Motor_s()
{
  uchar P_motor1[]={0x02,0x06,0x04,0x0c,0x08,0x09,0x01,0x03};  
  uchar i=0;
  clrscr();
  Motor_speed=20;
  TMOD=0x20;  			   //T1方式2
  TH1=0x0b;				   //每分钟20转的初值
  TL1=0xdb;
  temp=0;
  num_disp(1,0,0,Motor_speed/100);
  num_disp(1,0,8,Motor_speed/10%10);
  num_disp(1,0,16,Motor_speed%10);
  COM8255=0x82;	           //B口输入，C口输出 
  temp1=0x00;
  ET1=1;
  TR1=1;   
  while(NowKey!=KEY_ESC)
  {
   //EX0=1;  
   if (NowKey==KEY_1)
   {
     TR1=0;
     temp1=(temp1&0xf0)|P_motor1[i];
	 PC8255=temp1;	 
	 delay(10);
	 i++;
	 NowKey=0xff;	 
	 if(i==8)
	 {
	   i=0;
	 }
	 TR1=1; 
   }
   if(NowKey==KEY_2)
   {
     TR1=0;
	 i--;
	 if(i>7)
	 {
	   i=7;
	 }
	 NowKey=0xff;
	 temp1=(temp1&0xf0)|P_motor1[i];
	 PC8255=temp1;	 
	 delay(10);
	 TR1=1;
   }
   if(NowKey==KEY_3)
   {
     Motor_speed++;	 
	 if(Motor_speed>200)
	     Motor_speed=200;
	 NowKey=0xff;
	 TR1=0;
	 num_disp(1,0,0,Motor_speed/100);
     num_disp(1,0,8,Motor_speed/10%10);
     num_disp(1,0,16,Motor_speed%10);
	 TR1=1;
   }
   if(NowKey==KEY_4)
   {
     Motor_speed--;
	 if(Motor_speed<20)
	    Motor_speed=20;
	 NowKey=0xff;
	 TR1=0;
	 num_disp(1,0,0,Motor_speed/100);
     num_disp(1,0,8,Motor_speed/10%10);
     num_disp(1,0,16,Motor_speed%10);
	 TR1=1;
   }
  }
  ET1=0;
  TR1=0;
  Menu_Back();
}
/*------------24CXX 按输入的起始地址读取16个字节－－－－－－－－*/
void Menu_Memory_ReData()
{
    uchar idata temp1[16];
	uint  idata  addr;
	uchar i,j,x,y;
	bit cs3;
	cs3=1;
	clrscr();
	x=0;
	y=0;
	NowKey=0xff;
	while (NowKey!=KEY_OK)
   {
      //EX0=1;
	  GetTextInput();
	  if(KeyInputTemp==1)
	  {
	    addr<<=4;
	    addr+=TextInputTemp;
	    num_disp(cs3,x,y,TextInputTemp);
	    y+=8;
        if(y==64)						   //     输出8个数字时换右屏
	    {
		  cs3=!cs3;
		  y=0;
		  j++;								  
	    }	  
	   KeyInputTemp=0; 
	  }
    }	
	R24C32(addr,temp1,16);
	x=2;
	y=0;		
	for (i=0;i<16;i++)
	{      
        num_disp(cs3,x,y,temp1[i]>>4);
	    y+=8;
		num_disp(cs3,x,y,temp1[i]&0x0f);
		y+=8;
		
        if(y==64)						   //     输出8个数字时换右屏
	    {
		  cs3=!cs3;
		  y=0;
		  j++;								  
	    }
		if(j==2)
		{
		  j=0;
		  x+=2;
		}	 
	}
   while(NowKey!=KEY_ESC);
   Menu_Back();
}
void Menu_Memory_WrData()
{
    uchar idata temp1[16];
	uint  idata  addr;
	uchar i,j,x,y;
	bit cs3;
	cs3=1;
	clrscr();
	x=0;
	y=0;
	NowKey=0xff;
	while (NowKey!=KEY_OK)
   {
      //EX0=1;
	  GetTextInput();
	  if(KeyInputTemp==1)
	  {
	    addr<<=4;
	    addr+=TextInputTemp;
	    num_disp(cs3,x,y,TextInputTemp);
	    y+=8;
        if(y==64)						   //     输出8个数字时换右屏
	    {
		  cs3=!cs3;
		  y=0;
		  j++;								  
	    }	  
	   KeyInputTemp=0; 
	  }
    }
	NowKey=0xff;
	i=0;
	j=0;
	x=2;
	y=0;
	while (NowKey!=KEY_OK)
   {
      //EX0=1;
	  GetTextInput();
	  if(KeyInputTemp==1)
	  {
	    temp1[i]<<=4;
	    temp1[i]+=TextInputTemp;		
	    num_disp(cs3,x,y,TextInputTemp);
		j++;
		if(!(j%2))
		  i++;
	    y+=8;
        if(y==64)						   //     输出8个数字时换右屏
	    {
		  cs3=!cs3;		  
		  y=0;		  								  
	    }	  
	   KeyInputTemp=0; 
	  }
    }	
	W24C32(addr,temp1,i);	
   while(NowKey!=KEY_ESC);
   Menu_Back();
}
/*-------------模数转换－－－－－－－－*/
void Menu_ADC0832()
{  
    uchar adtemp1;
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
      //EX0=1;
	  AD0809_IN0=0x00;						 //启动AD
	  delay(80);
	  adtemp1=AD0809_IN0;  
	  num_disp(1,0,32,adtemp1>>4);
	  num_disp(1,0,40,(adtemp1&0x0f));
	  AD0809_IN1=0x00;						 //启动AD
	  delay(80);
	  adtemp1=AD0809_IN1;  
	  num_disp(1,2,32,adtemp1>>4);
	  num_disp(1,2,40,(adtemp1&0x0f));
	  AD0809_IN2=0x00;						 //启动AD
	  delay(80);
	  adtemp1=AD0809_IN2;  
	  num_disp(1,4,32,adtemp1>>4);
	  num_disp(1,4,40,(adtemp1&0x0f));
	  AD0809_IN3=0x00;						 //启动AD
	  delay(80);
	  adtemp1=AD0809_IN3;  
	  num_disp(1,6,32,adtemp1>>4);
	  num_disp(1,6,40,(adtemp1&0x0f));
	  AD0809_IN4=0x00;						 //启动AD
	  delay(80);
	  adtemp1=AD0809_IN4;  
	  num_disp(0,0,32,adtemp1>>4);
	  num_disp(0,0,40,(adtemp1&0x0f));
	  AD0809_IN5=0x00;						 //启动AD
	  delay(80);
	  adtemp1=AD0809_IN5;  
	  num_disp(0,2,32,adtemp1>>4);
	  num_disp(0,2,40,(adtemp1&0x0f));
	  AD0809_IN6=0x00;						 //启动AD
	  delay(80);
	  adtemp1=AD0809_IN6;  
	  num_disp(0,4,32,adtemp1>>4);
	  num_disp(0,4,40,(adtemp1&0x0f));
	  AD0809_IN7=0x00;						 //启动AD
	  delay(80);
	  adtemp1=AD0809_IN7;  
	  num_disp(0,6,32,adtemp1>>4);
	  num_disp(0,6,40,(adtemp1&0x0f));	  
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
      //EX0=1;
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
  //EX0=1; 
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
   TH1=0xfd;									 //波特率9600
   TL1=0xfd;
   TR1=1;
   SCON=0x50;      								 //方式一，接收
   while (1)
   {          		   	
	    //EX0=1;
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
   TMOD=0x20;										//波特率9600
   TH1=0xfd;
   TL1=0xfd;
   TR1=1;											//方式一，不允许接收
   SCON=0x40;     
   while (NowKey!=KEY_ESC)
   {
      //EX0=1;
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
/*----------------多机接收----------------*/
void Menu_SerialReceive_MCU()			  
{
  uchar name,y,i=0;
  uchar  led_buff[3]={0x00,0x00,0x00};
  clrscr();
  NowKey=0xff;
  name=0;
  cs1=1;
  cs2=0;
  chn_disp(0,32,2,16,1,2,hz_test_4);
  chn_disp(2,0,2,16,1,3,hz_please);
  chn_disp(4,0,2,16,1,2,hz_test);
  chn_disp(4,32,2,16,1,1,hz_test_4+32);
  chn_disp(4,48,2,16,1,1,hz_hao);
  cs1=0;
  cs2=1;  
  chn_disp(0,0,2,16,1,2,hz_test);
  num_disp(0,4,16,1);
  num_disp(0,4,48,2);
  TMOD=0x20;
  TH1=0xfd;
  TL1=0xfd;    
  while (NowKey!=KEY_OK)
  {
     //EX0=1;
	 GetTextInput();
	 if(KeyInputTemp==1)
	 {
	    name=TextInputTemp;			
	 }
     num_disp(0,2,16,name);	  
  }
  TR1=1;
  SCON=0xf8;
  SBUF=0x10|name;
  while (!TI);
  TI=0;
  SM2=0;  
  while (NowKey!=KEY_ESC)
  {
     //EX0=1;    
     if(name==0x01)
     {
	    for(i=0;i<3;i++)
	    {
	       while (!RI);
	       RI=0;
	       led_buff[i]=SBUF;		
	    } 	  
     }
     if(name==0x02)
     {
	  
	    while (!RI);
	    RI=0;
	    led_buff[0]=SBUF;	   
     }
	 y=0;
	 for(i=0;i<3;i++)
	 { 
          
        num_disp(0,6,y,led_buff[i]>>4);		  		
        y+=8;
	    num_disp(0,6,y,led_buff[i]&0xf);
		y+=8;        
	 }
  }
  cs1=0;
  cs2=1;  
  chn_disp(0,0,2,16,1,2,hz_test);  
  Menu_Back();
}
/*----------------多机发送----------------*/
void Menu_SerialSend_MCU()				  
{
  uchar name,y,i=0,j=0;
  uchar  led_buff[3];
  clrscr();
  NowKey=0xff;
  name=0;
  cs1=1;
  cs2=0;
  chn_disp(0,32,2,16,1,2,hz_test_4);
  chn_disp(2,0,2,16,1,3,hz_please);
  chn_disp(4,0,2,16,1,2,hz_test);  
  chn_disp(4,32,2,16,1,1,hz_test_4+32);
  chn_disp(4,48,2,16,1,1,hz_hao);
  cs1=0;
  cs2=1;  
  chn_disp(0,0,2,16,1,2,hz_test);
  num_disp(0,4,16,1);
  num_disp(0,4,48,2);
  TMOD=0x20;
  TH1=0xfd;
  TL1=0xfd;      
  while (NowKey!=KEY_OK)
  {
    // EX0=1;
	 GetTextInput();
	 if(KeyInputTemp==1)
	 {
	    name=TextInputTemp;
		KeyInputTemp=0;			
	 }
     num_disp(0,2,16,name);	  
  }
  NowKey=0xff;
  cs1=1;
  cs2=0;
  chn_disp(4,0,2,16,1,4,hz_chuanshu);
  y=0;
  while (NowKey!=KEY_OK)
  {
     //EX0=1;
	 GetTextInput();
	 if(KeyInputTemp==1)
	 {
	    led_buff[i]<<=4;
		led_buff[i]+=TextInputTemp;
		num_disp(0,6,y,TextInputTemp);
		j++;
		if(!(j%2))
		   i++;		  		
		y+=8;
		if(y==48)
		  y=8;
		KeyInputTemp=0;
	 }
  }
  TR1=1;
  SCON=0xf8;
  SBUF=name;
  while (!TI);
  TI=0;
  TB8=0;    
  if(name==0x01)
  {
	 for(i=0;i<3;i++)	  
	 {
	    SBUF=led_buff[i];
	    while(!TI);
	    TI=0;
	 }
  }
  if(name==0x02)
  {
	  i=0;
	  SBUF=led_buff[i];
	  while (!TI);
	  TI=0; 	   
  }
  clrscr();
  cs1=1;
  cs2=0;
  chn_disp(0,32,2,16,1,2,hz_test_4);  
  cs1=0;
  cs2=1;  
  chn_disp(0,0,2,16,1,2,hz_test);
  //EX0=1;
  while (NowKey!=KEY_ESC);
  Menu_Back(); 
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


#endif