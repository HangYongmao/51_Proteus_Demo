#include <intrins.h>
#include <reg51.h>
#include <stdio.h>

#define ulong unsigned long
#define uint unsigned int
#define uchar unsigned char
uchar k,i,j;
float l;
sbit sw=P3^0;      //159ѡͨ����
sbit ADCS =P3^1;  //ADC0832 chip seclect
sbit ADDI =P3^3;  //ADC0832 k in
sbit ADDO =P3^3;  //ADC0832 k out
sbit ADCLK =P3^2;  //ADC0832 clock signal

uchar dsw[20];  //���sprintfת���ַ�
uchar idata value[149]; //�����ַ�����
uchar code table[]={    //�ַ����
0x00,0x00,0x00,0x30,0x00,0x30,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,/*".",0*/

0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,

0x00,0x00,0xE0,0x0F,0x10,0x10,0x08,0x20,0x08,0x20,0x10,0x10,0xE0,0x0F,0x00,0x00,/*"0",1*/

0x00,0x00,0x10,0x20,0x10,0x20,0xF8,0x3F,0x00,0x20,0x00,0x20,0x00,0x00,0x00,0x00,/*"1",2*/

0x00,0x00,0x70,0x30,0x08,0x28,0x08,0x24,0x08,0x22,0x88,0x21,0x70,0x30,0x00,0x00,/*"2",3*/

0x00,0x00,0x30,0x18,0x08,0x20,0x88,0x20,0x88,0x20,0x48,0x11,0x30,0x0E,0x00,0x00,/*"3",4*/

0x00,0x00,0x00,0x07,0xC0,0x04,0x20,0x24,0x10,0x24,0xF8,0x3F,0x00,0x24,0x00,0x00,/*"4",5*/

0x00,0x00,0xF8,0x19,0x08,0x21,0x88,0x20,0x88,0x20,0x08,0x11,0x08,0x0E,0x00,0x00,/*"5",6*/

0x00,0x00,0xE0,0x0F,0x10,0x11,0x88,0x20,0x88,0x20,0x18,0x11,0x00,0x0E,0x00,0x00,/*"6",7*/

0x00,0x00,0x38,0x00,0x08,0x00,0x08,0x3F,0xC8,0x00,0x38,0x00,0x08,0x00,0x00,0x00,/*"7",8*/

0x00,0x00,0x70,0x1C,0x88,0x22,0x08,0x21,0x08,0x21,0x88,0x22,0x70,0x1C,0x00,0x00,/*"8",9*/

0x00,0x00,0xE0,0x00,0x10,0x31,0x08,0x22,0x08,0x22,0x10,0x11,0xE0,0x0F,0x00,0x00,/*"9",10*/

0x08,0x00,0x78,0x00,0x88,0x07,0x00,0x38,0x00,0x0E,0xC8,0x01,0x38,0x00,0x08,0x00,/*"V",11*/
};


void delay(int c)     //��ʱ��C����С��5
    {
    int i,j;
    for(i=0;i<c;i++)
        for(j=0;j<10;j++)
            ;
     }
/************
��ADC0832����
************/

//�ɼ�������
unsigned int Adc0832(unsigned char channel)     //ADת�������ؽ��
{
    uchar i=0;
    uchar j;
    uint dat=0;
    uchar ndat=0;

    if(channel==0)channel=2;
    if(channel==1)channel=3;
    ADDI=1;
    _nop_();
    _nop_();
    ADCS=0;//����CS��
    _nop_();
    _nop_();
    ADCLK=1;//����CLK��
    _nop_();
    _nop_();
    ADCLK=0;//����CLK��,�γ��½���1
    _nop_();
    _nop_();
    ADCLK=1;//����CLK��
    ADDI=channel&0x1;
    _nop_();
    _nop_();
    ADCLK=0;//����CLK��,�γ��½���2
    _nop_();
    _nop_();
    ADCLK=1;//����CLK��
    ADDI=(channel>>1)&0x1;
    _nop_();
    _nop_();
    ADCLK=0;//����CLK��,�γ��½���3
    ADDI=1;//����������� 
    _nop_();
    _nop_();
    dat=0;
    for(i=0;i<8;i++)
    {
        dat|=ADDO;//������
        ADCLK=1;
        _nop_();
        _nop_();
        ADCLK=0;//�γ�һ��ʱ������
        _nop_();
        _nop_();
        dat<<=1;
        if(i==7)dat|=ADDO;
    }  
    for(i=0;i<8;i++)
    {
        j=0;
        j=j|ADDO;//������
        ADCLK=1;
        _nop_();
        _nop_();
        ADCLK=0;//�γ�һ��ʱ������
        _nop_();
        _nop_();
        j=j<<7;
        ndat=ndat|j;
        if(i<7)ndat>>=1;
    }
    ADCS=1;//����CS��
    ADCLK=0;//����CLK��
    ADDO=1;//�������ݶ�,�ص���ʼ״̬
    dat<<=8;
    dat|=ndat;
    return(dat);            //return ad k
}
/*************************************************
            �����ַ��ɼ�����
**************************************************/

void tra(uchar *p)    //����dsp[]������ַ���ѯ���ٴ����浽��һ����ʾ����value[]
{ for(i=0;i<5;i++)
  {
      if(i<4)        //i=2ʱ����Ǿ�ţ�����3���ǵ�ѹֵ
      {
        for(j=0;j<16;j++)
        { 
          value[(i+1)*16+j]=table[(*p-0x2e)*16+j];
        }
       }
      else
      {  for(j=0;j<16;j++)      //��ѹ����V
          value[(i+1)*16+j]=table[12*16+j];
      }
      
      p++;
  }
  for(i=0;i<16;i++)           //ǰ16���ͺ�21���������ã�����ʾ
  value[i]=0;
  for(i=128;i<149;i++)
  value[i]=0;
}


void main()
    {

    unsigned int b=0,i,j;
    unsigned char a;



    while(1)
    {
    k=Adc0832(0);   //ADת�����
    l=k/255.0*5.0;
    sprintf(dsw,"%2.3f",l);  //��ѹֵת�����ַ���ʽ���棬�����׵����ϰٶȲ�һ��sprintf���������þ�����ģ���Ҳ�ǲ��
    tra(dsw);
    j=0;
    if(a>2) //�ƶ����ʱ�䣻Խ���ƶ�Խ��
        {
        a=0;
        b+=2;
        if(b>=85)  //��ʾ�����һ���֣���ͷ��ʾ
            {
            b=0;
            }   
        }
     sw=1;   //��ʾ�ַ���˳���Ǵ���ɨ���ң���16�У����ݵ�ƽ�Ǵ���1����16���ɵ͵���
     for(i=0;i<16;i++)  //sw��154ѡͨ���ء�
        {
        P1=i;
        P0=value[j+b];
        P2=value[j+b+1];
        delay(5);
        P0=0x00;
        P2=0x00;
        j+=2;
        }
     sw=0;
     for(i=0;i<16;i++)
        {
        P1=i;
        P0=value[j+b];
        P2=value[j+b+1];
        delay(5);
        P0=0x00;
        P2=0x00;
        j+=2;
        }
        a++;
     
    }
}

