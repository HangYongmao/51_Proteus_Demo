/*基于DS1302和LCD1602的万年历*/
/*具有光标显示，按键调时功能*/
/*作者：田开坤*/
/*key0：模式选择*/
/*key1：减操作*/
/*key2：加操作*/
/*key0：返回*/
/*2007.04.09*/
#include "STC89C51RC.H"
#include "LCD1602.h"
#include "DS1302.h"
#include <absacc.h>

#define UP 0xff
#define DOWN 0x0
#define uchar unsigned char
#define uint unsigned int

sbit  key3 = P3^5;
sbit  key2 = P3^4;//Up
sbit  key1 = P3^3;//Down
sbit  key0 = P3^2;//Modle

//1302调时函数
void data_change(uchar data_name,uchar up_down,uchar max,uchar n)
{
        uchar tmp;
        uchar tmp1;
        
        tmp1 = Read1302(data_name);
        tmp = ((tmp1>>4)&0x0f)*10 + (tmp1 & 0x0f);

        if (up_down){
                if(tmp < max){
                        tmp+=n;
                        tmp1=(((tmp/10)<<4) | (tmp%10));
                        Write1302(data_name,tmp1);                                              
                }
        }
        else{
                if(tmp >= n){
                        tmp-=n;
                        tmp1=(((tmp/10)<<4) | (tmp%10));
                        Write1302(data_name,tmp1);
                }
        }
}



main()
{
        uint loop_count=0;      
        uint key0_count=0;
        uint key1_count=0;
        uint key2_count=0;
        uchar modle_flag=0;
        uchar cursor_line=2;    
        uchar cursor_conumn=10; 
        uchar nset_time=1;

        SYSTEMTIME CurrentTime;
        Initial_DS1302();
        LCD_Init();
        LCD_SET_CURSOR(1,1);
        Print("Date:",5);       
        LCD_SET_CURSOR(2,1);
        Print("Time:",5);

        while(1){               
                if(loop_count++>10000){
                        DS1302_GetTime(&CurrentTime);   
                        DateToStr(&CurrentTime);
                        TimeToStr(&CurrentTime);

                        LCD_CURSOR_ONOFF(1);//关闭光标
                        LCD_SET_CURSOR(1,6);
                        Print(CurrentTime.DateString,8);
                                                
                        LCD_SET_CURSOR(2,6);
                        Print(CurrentTime.TimeString,8);

                        loop_count = 0;
                        if(nset_time) LCD_CURSOR_ONOFF(1);
                        else{
                                LCD_CURSOR_ONOFF(2);//显示光标
                                LCD_SET_CURSOR(cursor_line,cursor_conumn);
                        } 
                }

                if(key0==0)     {  
                        if(key0_count++>25000)  {
                                nset_time = 0;
                                modle_flag++;
                                switch(modle_flag) {
                                        case 1:
                                                cursor_line = 2;
                                                cursor_conumn = 10;
                                                break;
                                        
                                        case 2:
                                                cursor_line = 2;
                                                cursor_conumn = 9;                                      
                                                break;
                                        case 3:
                                                cursor_line = 2;
                                                cursor_conumn = 7;
                                                break;
                                        
                                        case 4:
                                                cursor_line = 2;
                                                cursor_conumn = 6;                                      
                                                break;
                                        case 5:
                                                cursor_line = 1;
                                                cursor_conumn = 13;
                                                break;
                                        
                                        case 6:
                                                cursor_line = 1;
                                                cursor_conumn = 12;                                     
                                                break;
                                        case 7:
                                                cursor_line = 1;
                                                cursor_conumn = 10;
                                                break;
                                        
                                        case 8:
                                                cursor_line = 1;
                                                cursor_conumn = 9;                                      
                                                break;
        
                                        case 9:
                                                cursor_line = 1;
                                                cursor_conumn = 7;
                                                break;
                                        
                                        case 10:
                                                cursor_line = 1;
                                                cursor_conumn = 6;                                      
                                                break;
        
                                        default: 
                                                modle_flag=0;
                                                nset_time = 1;
                                                break;                  
                                }
                                key0_count=0;
                        }
                }

                if(key1==0)     {
                        if(key1_count++>20000){
                                switch(modle_flag){
                                        case 1:
                                                data_change(DS1302_MINUTE,DOWN,59,1);
                                                break;                                                                                  
                                        case 2:
                                                data_change(DS1302_MINUTE,DOWN,59,10);
                                                break;

                                        case 3:
                                                data_change(DS1302_HOUR,DOWN,23,1);
                                                break;
                                        
                                        case 4:
                                                data_change(DS1302_HOUR,DOWN,23,10);
                                                break;

                                        case 5:
                                                data_change(DS1302_DAY,DOWN,30,1);
                                                break;
                                                                                        
                                        case 6:
                                                data_change(DS1302_DAY,DOWN,30,10);
                                                break;

                                        case 7:
                                                data_change(DS1302_MONTH,DOWN,11,1);
                                                break;
                                        
                                        case 8:
                                                data_change(DS1302_MONTH,DOWN,11,10);
                                                break;
        
                                        case 9:
                                                data_change(DS1302_YEAR,DOWN,99,1);
                                                break;
                                        
                                        case 10:
                                                data_change(DS1302_YEAR,DOWN,99,10);
                                                break;
        
                                        default: break;                 
                                }       
                                key1_count = 0;                 
                        }
                }
        
                if(key2==0){
                        if(key2_count++>20000){
                                switch(modle_flag){
                                        case 1:
                                                data_change(DS1302_MINUTE,UP,59,1);
                                                break;                                                                                  
                                        case 2:
                                                data_change(DS1302_MINUTE,UP,59,10);
                                                break;
        
                                        case 3:
                                                data_change(DS1302_HOUR,UP,23,1);
                                                break;
                                        
                                        case 4:
                                                data_change(DS1302_HOUR,UP,23,10);
                                                break;
        
                                        case 5:
                                                data_change(DS1302_DAY,UP,30,1);
                                                break;
                                                                                        
                                        case 6:
                                                data_change(DS1302_DAY,UP,30,10);
                                                break;
        
                                        case 7:
                                                data_change(DS1302_MONTH,UP,11,1);
                                                break;
                                        
                                        case 8:
                                                data_change(DS1302_MONTH,UP,11,10);
                                                break;
                
                                        case 9:
                                                data_change(DS1302_YEAR,UP,99,1);
                                                break;
                                        
                                        case 10:
                                                data_change(DS1302_YEAR,UP,99,10);
                                                break;
                
                                        default: break;                 
                                }       
                                key2_count = 0;         
                        }
                }

                if(key3==0){
                        nset_time = 1;
                        modle_flag = 0;
                        }                               
        }       

}
