/***************************************
����:2008���˻ᵹ��ʱ
***************************************/
#include<reg51.h>
#include<absacc.h>
#include<intrins.h>
#include "delay.h"
#define clock_segment XBYTE[0xBFFF] //ʱ�Ӷ����ַ
#define clock_sel XBYTE[0x7FFF]     //ʱ��λ���ַ
#define year_segment XBYTE[0xEFFF]  //���������ַ
#define year_sel XBYTE[0xDFFF]      //����λ���ַ
#define retime_segment XBYTE[0xFBFF]//����ʱ�����ַ
#define retime_sel XBYTE[0xF7FF]    //����ʱλ���ַ

unsigned char time_num=0;//��ʱһ�����
unsigned char shi_num=24;//Сʱλ����
unsigned char miao_ge=0; //���λ
unsigned char miao_shi=0;//��ʮλ
unsigned char fen_ge=0;//�ָ�λ
unsigned char fen_shi=4;//��ʮλ
unsigned char shi_ge=8;//ʱ��λ
unsigned char shi_shi=0;//ʱʮλ
unsigned char year_thousand=2;
unsigned char year_hundred=0;
unsigned char year_decade=0;
unsigned char year_unit=7;
unsigned char month_decade=0;
unsigned char month_unit=6;
unsigned char day_decade=2;
unsigned char day_unit=6;
unsigned char retime_unit=0;
unsigned char retime_decade=1;
unsigned char retime_hundred=4;
unsigned char retime_thousand=0;

unsigned char year_thoustore; //������ǧλ����
unsigned char year_hundstore; //�������λ����
unsigned char year_decastore; //������ʮλ����
unsigned char year_unitstore; //�������λ����
unsigned char month_unitstore;//�����¸�λ����
unsigned char month_decastore;//������ʮλ����
unsigned char day_unitstore;  //�����ո�λ����
unsigned char day_decastore;  //������ʮλ����
unsigned char year_unitstore2;//�������λ����
unsigned char year_decastore2;//��λ����ӳ�����������������
unsigned char year_hundstore2;
unsigned char year_thoustore2;
unsigned char retime_ustore;  //���浹��ʱ��λ����
unsigned char retime_dstore;
unsigned char retime_hstore;
unsigned char retime_tstore;
unsigned char day_numj=31;  //������31��
unsigned char day_numo=30;  //ż����30��
unsigned char day_numooo=30;
unsigned char day_numoo;
unsigned char month_num=12;
unsigned int year_jointed; //���λ�����һ��,�Ա���������ж�
unsigned int year_help1;
unsigned int year_help2;
unsigned char xiaoshi_ge;//��˸ʱ��Сʱ��λ
unsigned char xiaoshi_shi;//��˸ʱ��Сʱʮλ
unsigned char fenzhong_ge;//��˸ʱ����Ӹ�λ
unsigned char fenzhong_shi;//��˸ʱ�����ʮλ
unsigned char cort=0;//�жϵڼ��ΰ���ȷ�ϼ�
sbit key_sure=P1^0;//��ʱ��ȷ�ϼ�
sbit key_dec=P1^2;//��ʱ����
bit first_sure=0; //��һ�ΰ���ȷ�ϼ�
bit second_sure=0;//�ڶ��ΰ���ȷ�ϼ�
bit third_sure=0; //�����ΰ���ȷ�ϼ�
bit fourth_sure=0;//���Ĵΰ���ȷ�ϼ�
bit fifth_sure=0; //����ΰ���ȷ�ϼ�
bit sixth_sure=0; //�����ΰ���ȷ�ϼ�
bit seventh_sure=0;//���ߴΰ���ȷ�ϼ�
unsigned code table[]={0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x07,0x7f,0x6f,0x00};//�����
/************��������*************/
void shannum_jian(void);
void inc_key(void);
void dec_key(void);
void dis_dingshi(void);
void hour_shanshuo(void);
void min_shanshuo(void);
void kbscan(void);
void display(void);
void year_joint(void);
unsigned char judgement_leap(void);
void retime_flash(void);
/********************************
��ʾ�ӳ���
*********************************/
void display(void)
{
    clock_sel=0xdf; 
    clock_segment=table[miao_ge];        //�����λ��λ��
    delay(3);
    clock_sel=0xef;
    clock_segment=table[miao_shi];       //����ʮλ��λ��
    delay(3);
    clock_sel=0xf7; 
    clock_segment=table[fen_ge]|0x80;    //�ͷָ�λ��λ��
    delay(3);
    clock_sel=0xfb;
    clock_segment=table[fen_shi];        //�ͷ�ʮλ��λ��
    delay(3);
    clock_sel=0xfd;
    clock_segment=table[shi_ge]|0x80;    //��ʱ��λ��λ��
    delay(3);
    clock_sel=0xfe;
    clock_segment=table[shi_shi];        //��ʱʮλ��λ��
    delay(3);
    year_sel=0x7f;
    year_segment=table[day_unit];        //���ո�λ��λ��
    delay(3);
    year_sel=0xbf;
    year_segment=table[day_decade];      //����ʮλ��λ��
    delay(3);
    year_sel=0xdf;
    year_segment=table[month_unit]|0x80; //���¸�λ��λ��
    delay(3);
    year_sel=0xef;
    year_segment=table[month_decade];    //����ʮλ��λ��
    delay(3);
    year_sel=0xf7;
    year_segment=table[year_unit]|0x80;  //�����λ��λ��
    delay(3);
    year_sel=0xfb;
    year_segment=table[year_decade];     //����ʮλ��λ��
    delay(3);
    year_sel=0xfd;
    year_segment=table[year_hundred];    //�����λ��λ��
    delay(3);
    year_sel=0xfe;
    year_segment=table[year_thousand];   //����ǧλ��λ��
    delay(3);
    retime_sel=0xf7;
    retime_segment=table[retime_unit];   //�͵���ʱ��λ��λ��
    delay(3);
    retime_sel=0xfb;
    retime_segment=table[retime_decade]; //�͵���ʱʮλ��λ��
    delay(3);
    retime_sel=0xfd;
    retime_segment=table[retime_hundred];//�͵���ʱ��λ��λ��
    delay(3);
    retime_sel=0xfe;
    retime_segment=table[retime_thousand];//�͵���ʱǧλ��λ��
    delay(3);

}
/**********************************
�ж������ӳ���
***********************************/
unsigned char judgement_leap(void)
{
    year_joint();       //�������λ����ӳ���
    if((year_jointed%4==0&&year_jointed%100!=0)||(year_jointed%100==0&&year_jointed%400==0))return(29); //���������29��
    else return(28);    //��ƽ�����28��	
}
/**********************************
����ɨ���ӳ���
***********************************/
void kbscan(void)
{
    unsigned char sccode;
    P1=0xff;
    if((P1&0xff)!=0xff)
    {
        //delay(5); 
        display();
        display();
        display();
            		
        if((P1&0xff)!=0xff)
    	{
             sccode=P1;
             //while((P1&0xff)!=0xff)     //����������
        	 //{
        	 //	;
        	// }
             switch(sccode)
        	 {
                case 0xfe:shannum_jian();break;
                case 0xfd:inc_key();	 break;
                case 0xfb:dec_key();	 break;
                default:			 	 break;
        	 }
    	}
    }
}
/********************************
ȷ�ϼ����������ӳ���
********************************/
void shannum_jian(void)
{   
    cort++;
    if(cort==1)          //��һ�ΰ���ȷ�ϼ�
    {
        first_sure=1;
        second_sure=0;
        third_sure=0;
        fourth_sure=0;
        fifth_sure=0;
        sixth_sure=0;
        seventh_sure=0;
    	
    }
    else if(cort==2)    //�ڶ��ΰ���ȷ�ϼ�
    {	
        first_sure=0;
        second_sure=1;
        third_sure=0;
        fourth_sure=0;
        fifth_sure=0;
        sixth_sure=0;
        seventh_sure=0;
    	
    }
    else if(cort==3)    //�����ΰ���ȷ�ϼ�
    {
        first_sure=0;
        second_sure=0;
        third_sure=1;
        fourth_sure=0;
        fifth_sure=0;
        sixth_sure=0;
        seventh_sure=0;
    	
    }
    else if(cort==4)   //���Ĵΰ���ȷ�ϼ�
    {
        first_sure=0;
        second_sure=0;
        third_sure=0;
        fourth_sure=1;
        fifth_sure=0;
        sixth_sure=0;
        seventh_sure=0;
    		
    }
    else if(cort==5)   //����ΰ���ȷ�ϼ�
    {
        first_sure=0;
        second_sure=0;
        third_sure=0;
        fourth_sure=0;
        fifth_sure=1;
        sixth_sure=0;
        seventh_sure=0;
    		
    }
    else if(cort==6)   //�����ΰ���ȷ�ϼ�
    {
     	
        first_sure=0;
        second_sure=0;
        third_sure=0;
        fourth_sure=0;
        fifth_sure=0;
        sixth_sure=1;
        seventh_sure=0;
    		
    }
    else if(cort==7)  //���ߴΰ���ȷ�ϼ�
    {
        cort=0;
        first_sure=0;
        second_sure=0;
        third_sure=0;
        fourth_sure=0;
        fifth_sure=0;
        sixth_sure=0;
        seventh_sure=1;
    }		

}
/*******************************
��һ���ӳ���
*******************************/
void dec_key(void)
{
    if(first_sure)                          //��һ�ΰ���ȷ�ϼ�,Сʱλ��
    {
        if(shi_num!=24)
    	{
            ++shi_num;
            if((--xiaoshi_ge)==255)
    		{
                xiaoshi_ge=9;
                if((--xiaoshi_shi)==255)
        		{
                    xiaoshi_shi=2;
                    xiaoshi_ge=3;
        		}
        	}	
    	}
        else if(shi_num==24)
    	{
            shi_num=1;
            xiaoshi_ge=3;
            xiaoshi_shi=2;
    	}
    }
    else if(second_sure)                         //�ڶ��ΰ���ȷ�ϼ�,����λ��
    {
        if((--fenzhong_ge)==255)
    	{
            fenzhong_ge=9;
            if((--fenzhong_shi)==255)
    		{
                fenzhong_shi=5;
    		}
    	}
    }
    else if(third_sure)                           //�����ΰ���ȷ�ϼ�,��λ��
    {
        if((--year_unitstore)==255)
    	{
            year_unitstore=9;
            if((--year_decastore)==255)
    		{
                year_decastore=9;
                if((--year_hundstore)==255)
        		{
                    year_hundstore=9;
                    if((--year_thoustore)==255)
        			{
                        year_thoustore=9;
        			}
        		}
    		}
    	}
    }
    else if(fourth_sure)                        //���Ĵΰ���ȷ�ϼ�,��λ��
    {
        if(month_num!=12)
    	{
              ++month_num;
              if((--month_unitstore)==255)
        	  {
                    month_unitstore=9;
                    --month_decastore;
        	  }
    	}
        else if(month_num==12)
    	{
            month_num=1;
            month_unitstore=2;
            month_decastore=1;
    	}
    }
    else if(fifth_sure)                         //����ΰ���ȷ�ϼ�,��λ��
    {           										 
        if((month_unitstore|0xfe)==0xff)        //��������,��Ϊ31��
         {	
            if((day_numj)!=31)
    		{
                ++day_numj;
                if((--day_unitstore)==255)
        		{
                    day_unitstore=9;
                    --day_decastore;
        		}
    		}
            else if(day_numj==31)
    		{
                day_numj=1;
                day_unitstore=1;
                day_decastore=3;
    		}
    	}
        else if((month_unitstore|0xfe)!=0xff)      //��ż����,��Ϊ30��
    	{
    		
        	if(
    		
            month_unitstore==2)         	   //�Ƕ���
        	{	
                        if(day_numo!=day_numoo)
        				{	
                    		++day_numo;
                            if((--day_unitstore)==255)
        					{
                        	day_unitstore=9;
                        	--day_decastore;
        					}
        				}
    			
                        else if(day_numo==day_numoo)
        				{
                            if(day_numoo==28)
            				{	
                    			day_numo=1;
                        		day_unitstore=8;
                        		day_decastore=2;
        					}
                            else if(day_numoo==29)
        					{
                        	   	day_numo=1;
                        		day_unitstore=9;
                        		day_decastore=2;
        					}
    			
        				}
    		}
            else if(month_unitstore!=2)     		//���Ƕ���
        	{	
                if(day_numooo!=30)
        		{
                    ++day_numooo;
                    day_numo=day_numooo;
                    if((--day_unitstore)==255)
        			{
                        day_unitstore=9;
                        --day_decastore;
                        day_numo=day_numooo;
        			}
        		}
                else if(day_numooo==30)
        		{
        	 	
                    	day_numooo=1;
                        day_unitstore=0;
                        day_decastore=3;
                        day_numo=day_numooo;
    			
        		}
    		}
    	}
    }
    else if(sixth_sure)                         //�����ΰ���ȷ�ϼ�,����ʱλ��
    {
         if((--retime_ustore)==255)
    	 {
               retime_ustore=9;
               if((--retime_dstore)==255)
        	   {
                     retime_dstore=9;
                     if((--retime_hstore)==255)
        			 {
                        	retime_hstore=9;
                            if((--retime_tstore)==255)retime_tstore=9;
        			 }
        	   }
    	 }
    }
}
/*******************************

��λ��˸�ӳ���

*******************************/
void year_flash(void)
{
    unsigned char i;
    if(third_sure)
    {
         year_thoustore=year_thousand;
         year_hundstore=year_hundred;
         year_decastore=year_decade;
         year_unitstore=year_unit;
         while(third_sure)
    	 {
            for(i=0;i<18;i++)       //��λ����ʾ,����λ����ʾ
    		{
                year_thousand=10;
                year_hundred=10;
                year_decade=10;
                year_unit=10;
                fen_ge=fenzhong_ge;
                fen_shi=fenzhong_shi;
                display();
                kbscan();
                if(!third_sure)i=51;   //�����������������
    		}
            if(third_sure)
    		{
                for(i=0;i<18;i++)      //��λ������λ����ʾ
        		{
                     year_thousand=year_thoustore;
                     year_hundred=year_hundstore;
                     year_decade=year_decastore;
                     year_unit=year_unitstore;
                     fen_ge=fenzhong_ge;
                     fen_shi=fenzhong_shi;
                	 display();
                	 kbscan();
                     if(!third_sure)i=51;   //�����������������
        		}
    		}
    	 }
    }
}
/*******************************
��λ��˸�ӳ���
*******************************/
void month_flash(void)
{
    unsigned char i;
    if(TR0==0)                                  //Ϊ��λ��ƽ�����������׼��
    {
            day_numo=judgement_leap();
            day_numoo=day_numo;
    }
    if(fourth_sure)
    {
        month_unitstore=month_unit;
        month_decastore=month_decade;
        while(fourth_sure)
    	{
            for(i=0;i<18;i++)
    		{
                 month_unit=10;
                 month_decade=10;
                 year_thousand=year_thoustore;    //��ԭʼ���ݱ���ȡ������ʾ����
                 year_hundred=year_hundstore;
                 year_decade=year_decastore;
                 year_unit=year_unitstore;
                 display();
                 kbscan();
                 if(!fourth_sure)i=51;
    		}
            if(fourth_sure)
    		{
                 for(i=0;i<18;i++)
        		 {	
                    month_unit=month_unitstore;
                    month_decade=month_decastore;//��ԭʼ���ݱ���ȡ������ʾ����
                    year_thousand=year_thoustore;
                    year_hundred=year_hundstore;
                    year_decade=year_decastore;
                    year_unit=year_unitstore;
                	display();
                	kbscan();
                    if(!fourth_sure)i=51;
        		}
    		}
    	}

    }
}
/*******************************
��λ��˸�ӳ���
******************************/
void day_flash(void)
{
    unsigned char i;
    if(fifth_sure)
    {
        day_unitstore=day_unit;
        day_decastore=day_decade;
        while(fifth_sure)
    	{
            for(i=0;i<18;i++)
    		{
                day_unit=10;
                day_decade=10;
                month_unit=month_unitstore;       //��ԭʼ���ݱ���ȡ������ʾ����
                month_decade=month_decastore;
                year_thousand=year_thoustore;
                year_hundred=year_hundstore;
                year_decade=year_decastore;
                year_unit=year_unitstore;
                display();
                kbscan();
                if(!fifth_sure)i=51;
    		}
            if(fifth_sure)
    		{
                for(i=0;i<18;i++)
        		{
                     day_unit=day_unitstore;
                     day_decade=day_decastore;
                     month_unit=month_unitstore;     //��ԭʼ���ݱ���ȡ������ʾ����
                     month_decade=month_decastore;
                     year_thousand=year_thoustore;
                     year_hundred=year_hundstore;
                     year_decade=year_decastore;
                     year_unit=year_unitstore;
                	 display();
                	 kbscan();
                     if(!fifth_sure)i=51;
        		}
    		}
    	}
    }
}
/*******************************
����ʱλ��˸�ӳ���
*******************************/
void retime_flash(void)
{
    unsigned char i;
    if(sixth_sure)
    {
        retime_ustore=retime_unit;
        retime_dstore=retime_decade;
        retime_hstore=retime_hundred;
        retime_tstore=retime_thousand;
        while(sixth_sure)
    	{
             for(i=0;i<18;i++)
        	 {
                retime_unit=10;
                retime_decade=10;
                retime_hundred=10;
                retime_thousand=10;
                day_unit=day_unitstore;
                day_decade=day_decastore;
                display();
                kbscan();
                if(!sixth_sure)i=51;
        	 }
             if(sixth_sure)
        	 {
                for(i=0;i<18;i++)
        		{
                   retime_unit=retime_ustore;
                   retime_decade=retime_dstore;
                   retime_hundred=retime_hstore;
                   retime_thousand=retime_tstore;
                   day_unit=day_unitstore;
                   day_decade=day_decastore;
                   display();
                   kbscan();
                   if(!sixth_sure)i=51;
        		}
        	 }
    	}
        if(seventh_sure)                 //�ڰ˴�ȷ�ϼ�����,������ʱ��,����λ������ȫ������,ʱ��������ʾ
    	{
            seventh_sure=0;
            fen_ge=fenzhong_ge;					
            fen_shi=fenzhong_shi;
            shi_ge=xiaoshi_ge;  
            shi_shi=xiaoshi_shi;
            year_unit=year_unitstore;
            year_decade=year_decastore;
            year_hundred=year_hundstore;
            year_thousand=year_thoustore;
            month_unit=month_unitstore;
            month_decade=month_decastore;
            day_unit=day_unitstore;
            day_decade=day_decastore;
            retime_unit=retime_ustore;
            retime_decade=retime_dstore;
            retime_hundred=retime_hstore;
            retime_thousand=retime_tstore;
            TR0=1;					
    	}
    }
}
/*******************************
Сʱλ��˸�ӳ���
*******************************/
void hour_flash(void)
{   
    unsigned char i;
    if(first_sure)
    {	
        TR0=0;                //�ض�ʱ��,������˸ 
        xiaoshi_ge=shi_ge;    //����ʱ��λ��ʾ������
        xiaoshi_shi=shi_shi;  //����ʱʮλ��ʾ������
        while(first_sure)     //��һ��ȷ�ϼ�����,��Сʱλ��˸
    	{	
            for(i=0;i<18;i++) //Сʱλ����ʾ,����λ��ʾ
        	{	
                shi_ge=10;
                shi_shi=10;
                display();
                kbscan();
                if(!first_sure)i=51;
    		}
            if(first_sure)
    		{
                for(i=0;i<18;i++)//Сʱλ������λ����ʾ
        		{	
                    shi_ge=xiaoshi_ge;
                    shi_shi=xiaoshi_shi;
                	display();
                	kbscan();
                    if(!first_sure)i=51;
        		}
        	}  
    	}
    }
}
/******************************
����λ��˸�ӳ���
*******************************/
void min_flash(void)    
{   
    unsigned char i;
    if(second_sure)
    {	
            fenzhong_ge=fen_ge;     //����ָ�λ��ʾ������
            fenzhong_shi=fen_shi;   //�����ʮλ��ʾ������
            while(second_sure)      //�ڶ���ȷ�ϼ�����,�ڷ���λ��˸
    		{
                for(i=0;i<18;i++)//����λ����ʾ������λ����ʾ
        		{
                	fen_ge=10;
                	fen_shi=10;
                    shi_ge=xiaoshi_ge;  //��Сʱ��λ��ԭʼ����,�������Сʱ��λ����ʾʱ������
                    shi_shi=xiaoshi_shi;//��Сʱʮλ��ԭʼ����,�������Сʱʮλ����ʾʱ������
                	display();
                	kbscan();
                    if(!second_sure)i=51;
        		}
                if(second_sure)
        		{
                    for(i=0;i<18;i++)      //����λ������λ����ʾ
        			{
                        fen_ge=fenzhong_ge;
                        fen_shi=fenzhong_shi;
                        shi_ge=xiaoshi_ge;  //��Сʱ��λ��ԭʼ����,�������Сʱ��λ����ʾʱ������
                        shi_shi=xiaoshi_shi;//��Сʱʮλ��ԭʼ����,�������Сʱʮλ����ʾʱ������
                		display();
                		kbscan();
                        if(!second_sure)i=51;
        			}
        		}	
    		}
    }
}
/******************************
��λ����ӳ���
********************************/
void year_joint(void)
{   
    year_unitstore2=year_unitstore;       //�������λ����
    year_decastore2=year_decastore;
    year_hundstore2=year_hundstore;
    year_thoustore2=year_thoustore;
    year_jointed=year_unitstore;
    year_decastore=year_decastore<<4;
    year_decastore=year_decastore&0xf0;
    year_jointed=year_jointed+year_decastore;       //�õ���ĵ�8λ
    year_jointed=year_jointed<<8;               //����ĵ�8�͸�8����
    year_jointed=year_jointed+year_hundstore;
    year_thoustore=year_thoustore<<4;
    year_thoustore=year_thoustore&0xf0;
    year_jointed=year_jointed+year_thoustore;   //�õ���,�轫����и�8���8����
    year_help1=year_jointed&0xff00;
    year_help1=year_help1>>8;               	//�õ����8λ
    year_help2=year_jointed&0x00ff;
    year_help2=year_help2<<8;               	//�õ����8λ
    year_jointed=year_help1+year_help2;         // �õ���λ
    year_unitstore=year_unitstore2;
    year_decastore=year_decastore2;
    year_hundstore=year_hundstore2;
    year_thoustore=year_thoustore2;             //�������λ����
}

/*******************************
��ʱ��0�ж��ӳ���
********************************/
void timer0(void) interrupt 1 using 1
{
    TH0=0x3c;
    TL0=0xb0;
    if((++time_num)==20)
    	{
            time_num=0;
            ++miao_ge;   //��ʱһ�뵽,���λ��һ
    	}
}   		
/******************************
 �����λ�ӵ�9ʱ��һ��
����
*******************************/    
void dis_dingshi(void)  
{   
    if(miao_ge==10)    			
    {
        miao_ge=0;
        if((++miao_shi)==6)		
    	{	
            miao_shi=0;
            if((++fen_ge)==10)		
    		{
                fen_ge=0;
                if((++fen_shi)==6)
        		{
                	fen_shi=0;
                    if((--shi_num)!=0)
        			{
                        if((++shi_ge)==10)
        				{
                			shi_ge=0;
                    		++shi_shi;
        				}
        			}
                    else if(shi_num==0)
        			{
                    	shi_num=24;
                		shi_ge=0;
                		shi_shi=0;
                            if(retime_unit==0&retime_decade==0&retime_hundred==0&retime_thousand==0)//����ʱ��һ
        					{
            					;
        					}
            				else 
        					{
                                 if((--retime_unit)==10)
            					 {
                            	  	retime_unit=0;
                                    if((--retime_decade)==10)
            						{
                            		 	retime_decade=0;
                                    	if((--retime_hundred)==10)
            							{
                                		 	retime_hundred=0;
                                        	if((--retime_thousand)==10)
            								{
                                			 	retime_thousand=0;
            								}
            							}
            						}
            					 }
        					}

                        if((month_unit|0xfe)==0xff)     //��������,��Ϊ31��
        				{	
                                    if((--day_numj)!=0)			//31��û��
                				    {	
                                		if((++day_unit)==10)
            							{
                         					day_unit=0;
                        					++day_decade;
            							}
            						}
                                    else if(day_numj==0)			//31�쵽��
            						{
                               			day_numj=31;
                        	   			day_unit=1;
                               			day_decade=0;
            							
                                        if((--month_num)!=0)		 //12����û��
                			   			{	
                                    			if((++month_unit)==10)
                			   					{
                            						month_unit=0;
                            						++month_decade;
                			   					}
            							}
                                        else if(month_num==0)	 //12���µ���
            							{
                        					month_num=12;
                        					month_unit=1;
                            				month_decade=0;
                                            if((++year_unit)==10)	//���λ�Ƿ�9
            								{
                            		 	 		year_unit=0;
                                    	 		if((++year_decade)==10)
                						 		{
                            			 			year_decade=0;
                                        			if((++year_hundred)==10)
                									{
                                			 			year_hundred=0;
                                                        if((++year_thousand)==10)year_thousand=0;
                									}
                						 		}
            								}
            							}
            						}
        				}
                        else if((month_unit|0xfe)!=0xff)    //��ż����,��Ϊ30��
        				{
                            if((--day_numo)!=0)			//30��û��
            				{	
                            	if((++day_unit)==10)
            					{
                         			day_unit=0;
                        			++day_decade;
            					}
        					}
                            else if(day_numo==0)			//30�쵽��
        					{
                               	if(month_unit==2)
            					{	
                            		if(day_numoo==28)
            						{	
                        				day_numo=28;
                        				day_unit=1;
                        				day_decade=0;
            						}
                                	else if(day_numoo==29)
            						{
                        				day_numo=29;
                        				day_unit=1;
                        				day_decade=0;
            						}
            					}			
                				else 
            					{	
                        			day_numj=30;
                        	   		day_unit=1;
                               		day_decade=0;
            					}
                               if((--month_num)!=0)		 //12����û��
            				   {	
                                	if((++month_unit)==10)
                			   		{
                        				month_unit=0;
                            			++month_decade;
                			   		}
            					}
                                else if(month_num==0)	 //12���µ���
            					{
                        			month_num=12;
                        			month_unit=1;
                        			month_decade=0;
                                    if((++year_unit)==10)	//���λ�Ƿ�9
            						{
                        			 	 year_unit=0;
                                    	 if((++year_decade)==10)
            							 {
                            			 	year_decade=0;

                                    		if((++year_hundred)==10)
            								{
                            				 	year_hundred=0;
                                                if((++year_thousand)==10)year_thousand=0;
            								}
            							 }
            						}
            					}
        					}
        				}
        			}
        		}
    		}
    	}
    }
}   
/*************������**************/
void main(void)
{  
    TMOD=0x01;
    TH0=0x3c;
    TL0=0xb0;
    EA=1;
    ET0=1;
    TR0=1;
    while(1)
    {   
        kbscan();       //������ɨ��
        display();      //�����������ʾ
        hour_flash();   //��Сʱλ��˸
        min_flash();    //������λ��˸
        year_flash();   //����˸
        month_flash();  //����˸
        day_flash();    //����˸
        retime_flash();
        dis_dingshi();  //��һ���һ����һ�ּ�һ����һСʱ��һ����24������
    }
}
