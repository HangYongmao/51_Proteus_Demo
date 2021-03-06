#include <AT89x51.h>

#define uint       unsigned int
#define uchar      unsigned char
#define disp_off   0x3e
#define disp_on    0x3f
#define disp_x     0xb8
#define disp_z     0xc0
#define disp_y     0x40
#define comm       0
#define dat        1
#define data_ora   P0       //MCU P1<------> LCM

sbit di = P2^2; //Data or Instrument Select,H:写数据,L:写指令
sbit rw = P2^1;  //Write or Read,H:read,L:write
sbit e  = P2^0;  //读写使能
sbit cs1= P2^3;  //cs1=H,选择左半屏
sbit cs2= P2^4;  //cs2=H,选择右半屏
sbit rst= P2^5;  //Lcm reset,低有效
sbit bf = P0^7;
sbit res= P0^4;

void chk_busy (void);	
uchar code  gongjiao[]={
/*--  文字:  公  --*/
/*--  隶书12;  此字体下对应的点阵为：宽x高=16x16   --*/
0x00,0x80,0x80,0xC0,0x40,0x60,0x20,0x80,0x00,0x20,0x60,0xC0,0xC0,0x80,0x80,0x80,
0x00,0x01,0x01,0x08,0x0C,0x1C,0x13,0x13,0x13,0x1E,0x0C,0x08,0x01,0x01,0x01,0x00,

/*--  文字:  交  --*/
/*--  隶书12;  此字体下对应的点阵为：宽x高=16x16   --*/
0x00,0x00,0x00,0x20,0xA0,0xE0,0x60,0x30,0x30,0x60,0xE0,0xA0,0x20,0x20,0x00,0x00,
0x00,0x10,0x10,0x11,0x10,0x19,0x0B,0x0E,0x06,0x07,0x0C,0x18,0x39,0x30,0x10,0x00,

/*--  文字:  自  --*/
/*--  隶书12;  此字体下对应的点阵为：宽x高=16x16   --*/
0x00,0x00,0x40,0xE0,0x40,0x40,0x70,0x50,0x40,0x40,0x40,0xC0,0xC0,0x00,0x00,0x00,
0x00,0x00,0x00,0x3F,0x15,0x15,0x15,0x15,0x15,0x15,0x15,0x3F,0x1F,0x00,0x00,0x00,

/*--  文字:  动  --*/
/*--  隶书12;  此字体下对应的点阵为：宽x高=16x16   --*/
0x00,0x80,0x80,0xA0,0xA0,0xA0,0xA0,0xA0,0xC0,0x40,0x40,0xC0,0xF0,0x70,0xC0,0x00,
0x00,0x01,0x04,0x06,0x09,0x0A,0x16,0x14,0x18,0x1C,0x26,0x33,0x18,0x0E,0x03,0x00,};
uchar code baozhan[]={

/*--  文字:  报  --*/
/*--  隶书12;  此字体下对应的点阵为：宽x高=16x16   --*/
0x00,0x40,0x40,0x40,0xF0,0x40,0x40,0xF0,0x10,0x10,0x90,0x70,0x30,0x00,0x00,0x00,
0x00,0x12,0x13,0x13,0x1F,0x01,0x01,0x3F,0x10,0x0B,0x0D,0x0F,0x0B,0x18,0x10,0x00,

/*--  文字:  站  --*/
/*--  隶书12;  此字体下对应的点阵为：宽x高=16x16   --*/
0x00,0xC0,0xC0,0x40,0x70,0xC0,0x40,0x00,0x00,0xE0,0xF0,0x40,0x40,0x40,0x40,0x00,
0x10,0x18,0x19,0x0F,0x08,0x0F,0x04,0x1E,0x1E,0x13,0x13,0x12,0x12,0x1E,0x00,0x00,

/*--  文字:  系  --*/
/*--  隶书12;  此字体下对应的点阵为：宽x高=16x16   --*/
0x00,0x00,0x20,0xA0,0xA0,0xE0,0xE0,0xA0,0xA0,0x50,0x50,0x10,0x10,0x00,0x00,0x00,
0x00,0x10,0x10,0x18,0x1A,0x2F,0x23,0x3E,0x3E,0x03,0x05,0x09,0x1A,0x18,0x10,0x00,

/*--  文字:  统  --*/
/*--  隶书12;  此字体下对应的点阵为：宽x高=16x16   --*/
0x00,0x80,0xC0,0xA0,0xB0,0xD0,0x40,0x40,0xA0,0x70,0x20,0xC0,0x40,0x00,0x00,0x00,
0x10,0x18,0x1A,0x0B,0x1E,0x15,0x10,0x19,0x0F,0x01,0x0F,0x18,0x31,0x30,0x10,0x00, };

uchar code  sheji[]={
/*--  文字:  设  --*/
/*--  隶书12;  此字体下对应的点阵为：宽x高=16x16   --*/
0x00,0x80,0x80,0xB0,0xA0,0x00,0x80,0x80,0x60,0x20,0x20,0xE0,0x80,0x80,0x80,0x00,
0x01,0x01,0x00,0x1F,0x19,0x08,0x10,0x11,0x13,0x0D,0x0F,0x0B,0x18,0x30,0x30,0x00,

/*--  文字:  计  --*/
/*--  隶书12;  此字体下对应的点阵为：宽x高=16x16   --*/
0x00,0x80,0x00,0xB0,0xA0,0x00,0x80,0x80,0x80,0x90,0xF0,0x80,0x80,0x80,0x80,0x80,
0x01,0x01,0x01,0x1D,0x1F,0x18,0x09,0x00,0x00,0x00,0x3F,0x00,0x00,0x01,0x01,0x00, 

/*--  文字:  :  --*/
/*--  隶书12;  此字体下对应的点阵为：宽x高=16x16   --*/
0x00,0x00,0x00,0xC0,0xC0,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x30,0x30,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,};

uchar code fwt[]={
/*--  文字:  冯  --*/
/*--  隶书12;  此字体下对应的点阵为：宽x高=16x16   --*/
0x00,0x40,0x40,0x40,0x40,0x40,0x20,0xF0,0x50,0x20,0x20,0xE0,0xE0,0x00,0x00,0x00,
0x00,0x06,0x06,0x02,0x02,0x0E,0x08,0x0B,0x0A,0x1A,0x2A,0x2B,0x2B,0x3E,0x0E,0x00,

/*--  文字:  玩  --*/
/*--  隶书12;  此字体下对应的点阵为：宽x高=16x16   --*/
0x00,0x00,0x20,0xE0,0xE0,0x20,0x80,0xA0,0xA0,0xA0,0xA0,0xA0,0x80,0x80,0x00,0x00,
0x00,0x0C,0x0D,0x17,0x17,0x15,0x1C,0x0C,0x07,0x04,0x0F,0x18,0x18,0x30,0x18,0x08,

/*--  文字:  童  --*/
/*--  楷体_GB231212;  此字体下对应的点阵为：宽x高=16x16   --*/
0x00,0x40,0x40,0x40,0x48,0xA8,0xB8,0xA5,0x56,0x5C,0xD4,0x10,0x10,0x10,0x00,0x00,
0x00,0x00,0x40,0x40,0x43,0x54,0x55,0x3F,0x2B,0x2A,0x21,0x20,0x20,0x00,0x00,0x00, };

/*--  文字:     --*/
/*--  隶书12;  此字体下对应的点阵为：宽x高=16x16   --*/
//0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
//0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,

uchar code hjl[]={
/*--  文字:  胡  --*/
/*--  隶书12;  此字体下对应的点阵为：宽x高=16x16   --*/
0x00,0x40,0x40,0x40,0xF0,0x70,0x40,0x40,0x80,0xF0,0x90,0x90,0xF0,0xF0,0x00,0x00,
0x00,0x00,0x0F,0x0B,0x09,0x09,0x2F,0x30,0x1C,0x0F,0x02,0x02,0x3F,0x3F,0x00,0x00,

/*--  文字:  建  --*/
/*--  隶书12;  此字体下对应的点阵为：宽x高=16x16   --*/
0x00,0x00,0x20,0xA0,0xE0,0x20,0xC0,0x40,0xA0,0xF0,0xA0,0xA0,0xE0,0x40,0x00,0x00,
0x00,0x10,0x12,0x0E,0x07,0x05,0x07,0x07,0x0B,0x0F,0x1B,0x1B,0x33,0x30,0x10,0x00,

/*--  文字:  龙  --*/
/*--  隶书12;  此字体下对应的点阵为：宽x高=16x16   --*/
0x00,0x00,0x40,0x40,0x40,0x40,0xF0,0x70,0xC0,0x60,0x60,0x40,0x40,0x40,0x00,0x00,
0x00,0x18,0x18,0x08,0x0C,0x02,0x05,0x04,0x0F,0x1A,0x19,0x19,0x38,0x38,0x18,0x08, };


uchar code lhb[]={
/*--  文字:  罗  --*/
/*--  隶书12;  此字体下对应的点阵为：宽x高=16x16   --*/
0x00,0x00,0x00,0xF0,0x90,0x90,0x70,0x90,0x90,0x70,0x70,0x90,0x90,0x70,0x00,0x00,
0x00,0x10,0x32,0x32,0x12,0x12,0x13,0x0F,0x0D,0x0D,0x05,0x05,0x03,0x03,0x00,0x00,

/*--  文字:  红  --*/
/*--  隶书12;  此字体下对应的点阵为：宽x高=16x16   --*/
0x00,0x80,0xC0,0x60,0xB0,0xD0,0x00,0x40,0x40,0xC0,0xC0,0x40,0x40,0x00,0x00,0x00,
0x10,0x1A,0x1E,0x0B,0x0A,0x1A,0x18,0x10,0x10,0x1F,0x1F,0x10,0x10,0x10,0x10,0x00,

/*--  文字:  波  --*/
/*--  隶书12;  此字体下对应的点阵为：宽x高=16x16   --*/
0x00,0x80,0x20,0x20,0x40,0x40,0xE0,0x20,0x20,0xF0,0x30,0x20,0x20,0xC0,0x00,0x00,
0x00,0x19,0x09,0x0D,0x14,0x18,0x27,0x31,0x13,0x0D,0x0D,0x1B,0x18,0x30,0x30,0x10, };
uchar code zb[]={
/*--  文字:  周  --*/
/*--  隶书12;  此字体下对应的点阵为：宽x高=16x16   --*/
0x00,0x00,0x00,0xE0,0xE0,0x60,0x60,0xF0,0xF0,0x60,0x60,0x60,0xF0,0x20,0x00,0x00,
0x00,0x10,0x18,0x0F,0x01,0x05,0x1D,0x15,0x15,0x1D,0x1D,0x01,0x3F,0x38,0x00,0x00,

/*--  文字:  波  --*/
/*--  隶书12;  此字体下对应的点阵为：宽x高=16x16   --*/
0x00,0x80,0x20,0x20,0x40,0x40,0xE0,0x20,0x20,0xF0,0x30,0x20,0x20,0xC0,0x00,0x00,
0x00,0x19,0x09,0x0D,0x14,0x18,0x27,0x31,0x13,0x0D,0x0D,0x1B,0x18,0x30,0x30,0x10,

/*--  文字:  指  --*/
/*--  隶书12;  此字体下对应的点阵为：宽x高=16x16   --*/
0x00,0x00,0x40,0x40,0xF0,0x50,0x40,0x00,0xF0,0xA0,0xA0,0xA0,0xB0,0x80,0x80,0x00,
0x10,0x10,0x32,0x33,0x1F,0x09,0x01,0x00,0x3E,0x2A,0x2A,0x2A,0x3E,0x3F,0x00,0x00,

/*--  文字:  导  --*/
/*--  隶书12;  此字体下对应的点阵为：宽x高=16x16   --*/
0x00,0x00,0x00,0xF0,0x50,0x50,0x50,0x50,0x50,0x50,0x70,0x80,0x80,0x00,0x00,0x00,
0x00,0x06,0x02,0x02,0x13,0x27,0x2F,0x2B,0x33,0x3F,0x03,0x03,0x06,0x06,0x06,0x02,};



void delay (uint us)
{
  while(us--);
}
void delay1 (uchar ms)
{
  uchar i;
  uint j;
  for(i=ms;i>0;i--)
  for(j=1000;j>0;j--)
  ;
} 
void wr_lcd (uchar dat_comm,uchar content)
{
  chk_busy ();
  di=dat_comm;
  rw=0;
  data_ora=content;
  e=1;
  ;
  e=0;
}  
void chk_busy (void)
{
  data_ora=0xff;
  di=0;
  rw=1;
  ;
  e=1;
  ;
  
  e=0;
  
  
}
/*--------------写点阵------------------*/
void lat_disp (uchar data1,uchar data2)
{
  uchar i,j;
  cs1=1;cs2=1;
  wr_lcd (comm,disp_on);
  for(j=0;j<8;j++)
  {
    wr_lcd (comm,disp_x+j);
    wr_lcd (comm,disp_z);
    wr_lcd (comm,disp_y);
    for(i=0;i<32;i++)
    {
      wr_lcd (dat,data1);
      wr_lcd (dat,data2);
    }
  }
}
 /*--------------显示图片----------------*/
void img_disp (uchar code *img,uchar l,uchar r)
{
  uchar i,j;
  for(j=0;j<8;j++)
  {	
    cs1=l;cs2=r;
    wr_lcd (comm,disp_on);
    wr_lcd (comm,disp_x+j);
    wr_lcd (comm,disp_z);
    wr_lcd (comm,disp_y);
    for(i=0;i<64;i++)
      wr_lcd (dat,img[j*64+i]);
	    
   
  }
}
/*---指定位置(x,y)显示row_xl行(每行row_yl个)汉字(大小xl*yl)---*/		   

void chn_disp (uchar x,uchar y,uchar xl,uchar yl,uchar row_xl,uchar row_yl,uchar code *chn)
{
  uchar i,j,k,l,a;
  wr_lcd (comm,disp_on);
  for(l=0;l<row_xl;l++)
  {
    for(k=0;k<row_yl;k++)
    {
      for(j=0;j<xl;j++)
      {
        wr_lcd (comm,disp_x+x+l*xl+j);
        wr_lcd (comm,disp_z);
        wr_lcd (comm,disp_y+y+k*yl);
        a=l*xl*yl*row_yl+k*xl*yl+j*yl;
        for(i=0;i<yl;i++)
          wr_lcd (dat,chn[a+i]);
      }
    }
  }
} 
/*------------------初始化-----------------*/
void init_lcd (void)
{
  rst=0;
  delay(50);
  rst=1;
  cs1=1;cs2=1;
  wr_lcd (comm,disp_off);
  wr_lcd (comm,disp_on);
}
/*---------------显示1-----------------*/


  void  disp1()
{ cs1=1;cs2=0;
  chn_disp(0,0,2,16,1,4,gongjiao);
  chn_disp(2,0,2,16,1,3,sheji);
  chn_disp(6,0,2,16,1,4,zb);
  cs1=0;cs2=1;
  chn_disp(0,0,2,16,1,4,baozhan);
  chn_disp(2,16,2,16,1,3,fwt);
  chn_disp(4,16,2,16,1,3,hjl);
  chn_disp(6,16,2,16,1,3,lhb);  

}
 
  	    
 


/*------------------主程序--------------------*/
void main ()
{
  init_lcd (); 
  lat_disp (0x00,0x00); 
  while (1)
  {	  
   	disp1(); 	
	
  }
}
