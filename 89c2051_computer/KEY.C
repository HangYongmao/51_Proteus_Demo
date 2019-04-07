#include <REG2051.H>
#include <intrins.h>
#include <stdlib.h>

#define Uchar unsigned char
#define Uint  unsigned int
#define Ulong unsigned long

Uchar bdata flag;
sbit addflag=flag^0;   //加标志位
sbit subflag=flag^1;   //减标志位
sbit mulflag=flag^2;   //乘标志位
sbit  divflag=flag^3;	//除标志位
sbit offflag=flag^4;   //关开键
sbit equflag=flag^5;	//等于键

Ulong progrm(Ulong ,Ulong);	//运算子程序

Uchar get_ch(void);		//按键值
Uchar *get_str(Uchar *str,Uint len); //按键字符串
bit kb_hit(void);  //按键检测
void delay(int x); //延时
void initflag(void); //标志变量初始化

//主函数
void main(void)
{
     Uchar i;
	 Uchar str[14];
	 Uchar xy[6],ab[6];
	 Uint temp,temp_data,temp_data_a;
	 Uchar pos=0;
	 Uchar pos_a=0;
	 initflag();
	 
	 while(1){
	           if(!get_str(str,14))	  //
				   continue;
			   for(i=0;i<6;i++)
			     {
				   	if(str[i]<0x40)
					 {
					   ++pos;
				       xy[i]=str[i];
					  }
					 else
					  {
					     xy[pos++]=0;
						 break;
					   }

				  }

				for(i=0;i<6;i++)
				  {
				     if(str[i+pos]<0x40)
					   {
					      ++pos_a;
						  ab[i]=str[i+pos];
						} 
					   else
					     {
						    ab[pos_a]=0;
							break;
				          }
					}
			  	 temp_data=atoi(xy);
				 temp_data_a=atoi(ab);
				 if(temp_data<0||temp_data_a<0)
				   continue;
//----------------------------------------------------------------------
				  temp_data=2;
	              temp_data_a=3;
	  			  if(equflag)
                        {
                          	 equflag=0;
							 temp= progrm(temp_data,temp_data_a);
   
					            for(i=0;i<4;i++)
					                    {	
					 
					
					                              temp_data=temp&0xf000;
						                          SBUF=temp_data>>=12;
												  while(!TI);
	                                                 TI=0;   //	   从串口发出去.
					                                 temp<<=4;
						
					                        }
	 						   while(1);
	                      }
//----------------------------------------------------------------------------------	 
				 		 
				 if(equflag)
				  {
			        equflag=0;
					temp= progrm(temp_data,temp_data_a);
					//temp=0x8;
					if(temp)
					{
					  for(i=0;i<4;i++)
					  {	
					    temp_data=temp&0xf000;
						SBUF=temp_data>>=12;
						while(!TI);
		                  TI=0;   //	   从串口发出去.
						temp<<=4;
						
					  }
					}

				   }
	         }
	
}
Ulong progrm(Ulong x ,Ulong y)
{
   Uint temp=0;
   
	      if(addflag)
		    {
		      temp=x+y;
		      return temp;
			 }
          if(subflag)
		   {
		       if(x<y)
			       return 0;
			  temp=x-y;
			  return temp;
		    }
		 if(mulflag)
		  {
		     temp=x*y;
		     return temp;
		  }
		  if(divflag)
		   {
		      	if((x<y)||(y==0))
				return 0;
			    temp=  x/y;
			  return(temp);
		    }
	 //return 0 ;
	   
}
//------------------------------------------------------------------------------------
Uchar get_ch()
{
  Uchar row=0,col=0;
  Uchar mask=0xef;
  Uchar pic;
    if(!kb_hit())
     return(0);                       /*无键按下，输入不成功，返回0*/
/*分析按键所在的列号*/
  P1=mask;
  
  while((P3&0x3f)==0x3f&&mask>0x7f)
        {
              ++col;
              mask=_crol_(mask,1);
             
			 P1=mask;

        }
  /*分析按键所在的行号*/
  
  pic=P3&0x3f;
  mask=0x4;
  while(pic&mask)
        {
             ++row;
             mask=_crol_(mask,1);
        }
/*等待按键释放*/
  
    while((P3&0x3f)!=0x3f);
	P1=0xff;
    /*计算按键序号并将其转换成ASCII码值返回　*/
  pic=row*4+col;
  if(pic<10)
    pic+=0x30;
  else
    pic+=0x31;
  return (pic);
}

//---------------------------------------------------------
//
//     有无按键按下	  bit kb_hit(void)  
//       无 retrun 0
//
//----------------------------------------------------------
bit kb_hit(void)
{
   
   P1=0x0F;                                /*往矩阵键盘列线　送低电平*/
   if((P3&0x3f)==0x3f)                     /*输入并检测行线状态*/
       return((bit)0);
   delay(16);                             /*延时8MS消颤*/
   if((P3&0x3f)==0x3f)                    /*再次输入并检测行线状态*/
        return((bit)0);                    /*行线为高电平时返回0*/
   
   return((bit)1);
   
}

//---------------------------------------------------------------
//
//	  void delay(int x)
//	  延时程序
//---------------------------------------------------------------
void delay(int x)
{
   Uchar i,y;
   while(x--)
   {
       i=3;
	   while(i--)
	   {  y=40;
	      while(y--);
		}
    }
}

/*******************************************************************************
       函数原型 *get_str(Uchar *str,Uchar len);
　　　 功能：  从矩阵键盘输入长度为LEN的字符串，并将其存储在由指针STR所指向的存
               储器空间，并返回该指针。在输入的同时滚动显示所输入的字符
********************************************************************************/

Uchar *get_str(Uchar *str,Uint len)		 
{
   Uchar data i;
   Uchar data ch=0,temp_ch;
   Uchar data keyboard_buf[14];
   Uchar data *ptr;

   Uchar  data keybuf_pos=0;
  while(keybuf_pos<len)
  {
	  temp_ch=get_ch();
		 if(!temp_ch)
		    return 0;
		 
	   switch (temp_ch)		//按键分析
	         {
	   case 0x30:addflag=1;
	             ch=0x41;break;
	   case 0x34:subflag=1;
	            ch=0x42;break;
	   case 0x38:mulflag=1;
	            ch=0x43;break;
	   case  0x3d:divflag=1;
	            ch=0x44;break;
	   case 0x33:offflag=~offflag;
			    ch=0x46;
			    break;
	   case 0x31:equflag=1;
	            ch=0x45;break;

	   case 0x32:ch=0; break;
	   case 0x35:ch=3; break;
	   case 0x36:ch=2; break;
	   case 0x37:ch=1; break;

	   case 0x39:ch=6;	break;
	   case 0x3b:ch=5;   break;
	   case 0x3c:ch=4;   break;
	  
	   case 0x3e:ch=9;   break;
	   case 0x3f:ch=8;   break;
	   case 0x40:ch=7;   break;
	   
	   default:     break; 
	}
	if(!offflag)
	  
	    return 0;
	SBUF=ch;
	while(!TI);
	TI=0;   //	   从串口发出去.
	if(ch!=0x46)
	   {
	      if(ch<10)
	          keyboard_buf[keybuf_pos++]=ch+0x30;
		   else
		      keyboard_buf[keybuf_pos++]=ch;
	   }
	//ch=0;
	if(equflag)
	  break;

  }
   
  ptr=str;
  for(i=0;i<keybuf_pos;i++)
   {
     *str=keyboard_buf[i];
	  str++;
	}
    str=ptr;/*拷贝键盘缓冲区中的输入串*/
  return(str);
}
//-----------------------------------------------------------------------
void initflag(void)
{
  addflag=0;   //加标志位
  subflag=0;   //减标志位
  mulflag=0;   //乘标志位
  divflag=0;	//除标志位
  offflag=0;   //关开键
  equflag=0;	//等于键
  
   PCON=0x80 ;
   SCON=0x40 ;
   TMOD=0x20 ;	  
   TL1=0xF9	 ; 
   TH1=0xF9  ;
   EA=0; //禁止中断
   TR1=1;//T1启动
	
}