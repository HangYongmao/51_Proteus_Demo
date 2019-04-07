#ifndef __ocm12864_H__
#define __ocm12864_H__


#define disp_off   0x3e
#define disp_on    0x3f
#define disp_x     0xb8
#define disp_z     0xc0
#define disp_y     0x40
#define comm       0
#define dat        1
#define data_ora   XBYTE[0x8000]      //MCU P1<------> LCM

sbit di = P1^2; //Data or Instrument Select,H:д����,L:дָ��
sbit rw = P1^1;  //Write or Read,H:read,L:write
sbit e  = P1^0;  //��дʹ��
//sbit bf = P0^7;
//sbit res= P0^4;
sbit cs1= P1^4;  //cs1=H,ѡ�������
sbit cs2= P1^5;  //cs2=H,ѡ���Ұ���
//extern void chk_busy (void);
extern void clrscr();
extern void delay (uchar us);
extern void wr_lcd (uchar dat_comm,uchar content);
extern void lat_disp (uchar data1);
extern void img_disp (uchar code *img,uchar l,uchar r);
extern void chn_disp (uchar x,uchar y,uchar xl,uchar yl,uchar row_xl,uchar row_yl,uchar code *chn);
extern void init_lcd (void);
extern void chn_fdisp (uchar x,uchar y,uchar xl,uchar yl,uchar row_xl,uchar row_yl,uchar code *chn);
extern void num_disp(bit cs,uchar x,uchar y,uchar Num);

void delay (uchar us)
{
  while(us--);
}
/*--------------дLCD----------*/
void wr_lcd (uchar dat_comm,uchar content)
{
  //chk_busy ();
  COM8255=0x80;				  //PA�����PB���
  if (dat_comm==1)            //di=dat_comm;	//DI=PB5
   {
     PB8255=0x2f;              //di=1  rw=0  e=1
	 data_ora=content; 
	 PB8255=0x6f;
	 ;
	 ;
	 PB8255=0X2f;
	}
  else 
    { 
      PB8255=0x0f;		      //di=0 rw=0 e=1	//RW=PB4
      data_ora=content;  
      PB8255=0x4f;                           //e=1;			//e=PB6
	  ;
      ;
      PB8255&=0x0f;               //e=0;
	}
  
}  
/*void chk_busy (void)
{
  data_ora=0xff;
  di=0;
  rw=1;
  ;
  e=1;
 // while(bf||res==1);
  e=0;
}

/*--------------��LCD����---------------
uchar rd_lcd ()
{
  uchar rddata;
  chk_busy ();
  di=1;
  rw=1;
  e=1;
  ;
  rddata=data_ora;
  e=0;
  return rddata;
} */

/*--------------д����------------------*/
void lat_disp (uchar data1)
{
  uchar i,j;
  cs1=1;cs2=1;
  wr_lcd (comm,disp_on);
  for(j=0;j<8;j++)
  {
    wr_lcd (comm,disp_x+j);
    //wr_lcd (comm,disp_z);
    wr_lcd (comm,disp_y);
    for(i=0;i<64;i++)
    {
      wr_lcd (dat,data1);
    //  wr_lcd (dat,data2);
    }
  }
}
 /*--------------��ʾͼƬ----------------
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
} */

/*---------------ָ��λ��(x,y)��ʾrow_xl��(ÿ��row_yl��)����(��Сxl*yl)--------------*/		   

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
        //wr_lcd (comm,disp_z);
        wr_lcd (comm,disp_y+y+k*yl);
        a=l*xl*yl*row_yl+k*xl*yl+j*yl;
        for(i=0;i<yl;i++)
          wr_lcd (dat,chn[a+i]);
      }
    }
  }
} 
/*------------------��ʼ��-----------------*/
void init_lcd (void)
{
  delay(20);
  cs1=1;
  cs2=1;
  //wr_lcd (comm,disp_off);
  wr_lcd (comm,disp_on);
}
/*---------------����-----------------*/
void clrscr()
{
  lat_disp(0x00);
}
/*-----------------���׷�ʽ��ʾ����------------------*/
void chn_fdisp (uchar x,uchar y,uchar xl,uchar yl,uchar row_xl,uchar row_yl,uchar code *chn)
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
        //wr_lcd (comm,disp_z);
        wr_lcd (comm,disp_y+y+k*yl);
        a=l*xl*yl*row_yl+k*xl*yl+j*yl;
        for(i=0;i<yl;i++)
          wr_lcd (dat,~chn[a+i]);
      }
    }
  }
}
/*-------- �� CS����(X ,Y )λ����ʾ���� Num----------*/  
void num_disp(bit cs,uchar x,uchar y,uchar Num)
{ 
   cs1=cs;
   cs2=~cs;
   switch(Num)
	    { 
		  case 0: { chn_disp(x,y,2,8,1,1,hz_zero); }     break; 
		  case 1: { chn_disp(x,y,2,8,1,1,hz_one); }      break;   
		  case 2: { chn_disp(x,y,2,8,1,1,hz_two); }      break;
		  case 3: { chn_disp(x,y,2,8,1,1,hz_three);}     break;
		  case 4: { chn_disp(x,y,2,8,1,1,hz_four);}      break;
		  case 5: { chn_disp(x,y,2,8,1,1,hz_five);}      break;
		  case 6: { chn_disp(x,y,2,8,1,1,hz_six);}       break;
		  case 7: { chn_disp(x,y,2,8,1,1,hz_seven);}     break;
		  case 8: { chn_disp(x,y,2,8,1,1,hz_eight);}     break;
		  case 9: { chn_disp(x,y,2,8,1,1,hz_nine);}      break; 
		  case 10: { chn_disp(x,y,2,8,1,1,hz_A);}        break;
		  case 11: { chn_disp(x,y,2,8,1,1,hz_B);}        break;
		  case 12: { chn_disp(x,y,2,8,1,1,hz_C);}        break;
		  case 13: { chn_disp(x,y,2,8,1,1,hz_D);}        break;
		  case 14: { chn_disp(x,y,2,8,1,1,hz_E);}        break;
		  case 15: { chn_disp(x,y,2,8,1,1,hz_F);}        break; 		  
		 }
} 

#endif