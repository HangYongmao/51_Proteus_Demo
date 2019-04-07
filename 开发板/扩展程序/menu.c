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
//#include <ADC0832.h>
#include <menu_func.h>  

/*void delay10ms (  uint t )			 //��ʱ 10 MS
   {    uint i;
        for (i=0;i<t;i++)
		{
		   TMOD=0x01;
		   TH0=0x0D8;
		   TL0=0X0F0;
		   TR0=1;
		   while(TF0!=1);
		   TF0=0;
		   TR0=0;
		 }	   

   }*/

/*--------------����ɨ�躯��----------------*/
KeyInt() interrupt 0 using 0
{
   EA=0;
   COM8255=0x82;
   NowKey=KeyIO&0x0f;
   NowKeyReg=1;
   EA=1;   
}

/*---------------������--------------*/
main()
{
  init_lcd();
  clrscr();	                              //         ����
  iMenuID=MENU_ROOT;                  	  //          ���ó�ʼID
  DispFaceBmp();
  EA=1;	                                  // �����ж�   
  IT0=1;	                              // �½����ж�
  while(1)
  {
	EX0=1;	                              // ����int0�ж�
    if(NowKeyReg==1)
    { 
      NowKeyReg=0;
      GetKeyInput();
	 }	 	 
  }
}
