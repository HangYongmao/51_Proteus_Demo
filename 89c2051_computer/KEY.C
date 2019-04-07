#include <REG2051.H>
#include <intrins.h>
#include <stdlib.h>

#define Uchar unsigned char
#define Uint  unsigned int
#define Ulong unsigned long

Uchar bdata flag;
sbit addflag=flag^0;   //�ӱ�־λ
sbit subflag=flag^1;   //����־λ
sbit mulflag=flag^2;   //�˱�־λ
sbit  divflag=flag^3;	//����־λ
sbit offflag=flag^4;   //�ؿ���
sbit equflag=flag^5;	//���ڼ�

Ulong progrm(Ulong ,Ulong);	//�����ӳ���

Uchar get_ch(void);		//����ֵ
Uchar *get_str(Uchar *str,Uint len); //�����ַ���
bit kb_hit(void);  //�������
void delay(int x); //��ʱ
void initflag(void); //��־������ʼ��

//������
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
	                                                 TI=0;   //	   �Ӵ��ڷ���ȥ.
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
		                  TI=0;   //	   �Ӵ��ڷ���ȥ.
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
     return(0);                       /*�޼����£����벻�ɹ�������0*/
/*�����������ڵ��к�*/
  P1=mask;
  
  while((P3&0x3f)==0x3f&&mask>0x7f)
        {
              ++col;
              mask=_crol_(mask,1);
             
			 P1=mask;

        }
  /*�����������ڵ��к�*/
  
  pic=P3&0x3f;
  mask=0x4;
  while(pic&mask)
        {
             ++row;
             mask=_crol_(mask,1);
        }
/*�ȴ������ͷ�*/
  
    while((P3&0x3f)!=0x3f);
	P1=0xff;
    /*���㰴����Ų�����ת����ASCII��ֵ���ء�*/
  pic=row*4+col;
  if(pic<10)
    pic+=0x30;
  else
    pic+=0x31;
  return (pic);
}

//---------------------------------------------------------
//
//     ���ް�������	  bit kb_hit(void)  
//       �� retrun 0
//
//----------------------------------------------------------
bit kb_hit(void)
{
   
   P1=0x0F;                                /*������������ߡ��͵͵�ƽ*/
   if((P3&0x3f)==0x3f)                     /*���벢�������״̬*/
       return((bit)0);
   delay(16);                             /*��ʱ8MS����*/
   if((P3&0x3f)==0x3f)                    /*�ٴ����벢�������״̬*/
        return((bit)0);                    /*����Ϊ�ߵ�ƽʱ����0*/
   
   return((bit)1);
   
}

//---------------------------------------------------------------
//
//	  void delay(int x)
//	  ��ʱ����
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
       ����ԭ�� *get_str(Uchar *str,Uchar len);
������ ���ܣ�  �Ӿ���������볤��ΪLEN���ַ�����������洢����ָ��STR��ָ��Ĵ�
               �����ռ䣬�����ظ�ָ�롣�������ͬʱ������ʾ��������ַ�
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
		 
	   switch (temp_ch)		//��������
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
	TI=0;   //	   �Ӵ��ڷ���ȥ.
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
    str=ptr;/*�������̻������е����봮*/
  return(str);
}
//-----------------------------------------------------------------------
void initflag(void)
{
  addflag=0;   //�ӱ�־λ
  subflag=0;   //����־λ
  mulflag=0;   //�˱�־λ
  divflag=0;	//����־λ
  offflag=0;   //�ؿ���
  equflag=0;	//���ڼ�
  
   PCON=0x80 ;
   SCON=0x40 ;
   TMOD=0x20 ;	  
   TL1=0xF9	 ; 
   TH1=0xF9  ;
   EA=0; //��ֹ�ж�
   TR1=1;//T1����
	
}