/**************************************************************************
					此程序有飘零编写。
			飘零工作室：http://piaoling.xpwap.com
						qq:15987353
*************************************************************************/

#include  "config.h"

/*************************clock data*************************************/
#define c_ox 63
#define c_oy 79
const char sec[]={	8,79,8,87,9,90,11,96,13,101,15,107,19,111,22,116,26,120,31,123,36,127,41,129,46,131,52,133,57,134,
					63,134,69,134,74,133,80,131,85,129,91,127,95,123,100,120,104,116,107,111,110,107,113,103,115,96,117,90,118,85,
					118,79,118,73,117,68,115,62,113,57,111,52,107,47,104,42,100,38,95,35,91,31,85,29,80,27,74,25,69,24,
					63,24,57,24,52,25,46,27,41,29,36,31,31,36,26,38,22,42,19,47,15,52,13,57,11,62,9,68,8,73};
const char min[]={	18,79,18,84,19,88,20,93,22,97,24,102,27,105,30,109,33,112,37,115,41,118,45,120,49,122,54,123,58,124,
					63,124,68,124,72,123,77,122,81,120,86,118,89,115,93,112,96,109,99,105,102,102,104,97,106,93,107,88,108,84,
					108,79,108,74,107,70,106,65,104,61,102,57,99,53,96,49,93,46,89,43,86,40,81,38,77,36,72,35,68,34,
					63,34,58,34,54,35,49,36,45,38,41,40,37,43,33,46,30,49,27,53,24,57,22,61,20,65,19,70,19,74};
const char hou[]={	33,79,33,82,34,85,34,88,36,91,37,94,39,97,41,99,43,101,45,103,48,105,51,106,54,108,57,108,60,109,
					63,109,66,109,69,108,72,108,75,106,78,105,81,103,83,101,85,99,87,97,89,94,90,91,92,88,92,85,93,82,
					93,79,93,76,92,73,92,70,90,67,89,64,87,61,85,59,83,57,81,55,78,53,75,52,72,50,69,50,66,49,
					63,49,60,49,57,50,54,50,51,52,48,53,45,55,43,57,41,59,39,61,37,64,36,67,34,70,34,73,33,76};
/***********************clock data end************************************/

/****************************************************************************
* 名称：DelayNS()
* 功能：长软件延时
* 入口参数：dly		延时参数，值越大，延时越久
* 出口参数：无
****************************************************************************/
/*void  delay(uint32  dly)
{  uint32  i;

   for(; dly>0; dly--) 
      for(i=0; i<500; i++);
}*/

__inline void enable_irq()
	{
	uint8 tmp;
	__asm
		{
		MRS tmp,CPSR
		BIC tmp,tmp,#0x80
		MSR CPSR_c,tmp
		}
	}

__inline void disable_irq()
	{
	uint8 tmp;
	__asm
		{
		MRS tmp,CPSR
		ORR tmp,tmp,#0x80
		MSR CPSR_c,tmp
		}
	}

__inline void enable_frq()
	{
	uint8 tmp;
	__asm
		{
		MRS tmp,CPSR
		BIC tmp,tmp,#0x40
		MSR CPSR_c,tmp
		}
	}

__inline void disable_frq()
	{
	uint8 tmp;
	__asm
		{
		MRS tmp,CPSR
		ORR tmp,tmp,#0x40
		MSR CPSR_c,tmp
		}
	}

//**************lcd programme start*****************************
#define wr (1<<8)
#define rd (1<<9)
#define cd (1<<10)


void delay(int c)
	{
	int j;
	while(c--)
		for(j=500;j>0;j--)
			;
	}

uint8 rd_state()	//读状态
	{
	uint8 temp;
	IODIR=0x700;
	IOSET=cd;
	IOCLR=rd;
	temp=IOPIN;
	IOSET=rd;
	return(temp);
	}

void rd_enable()	//等待可读写
	{
	uint8 temp;
	temp=rd_state();
	while((temp&0x03)!=0x03)
		temp=rd_state();
	}

void rd_auto()	//等待自动读写
	{
	uint8 temp;
	temp=rd_state();
	while((temp&0x04)!=0x04)
		temp=rd_state();
	}

void wr_auto()	//等待自动写
	{
	uint8 temp;
	temp=rd_state();
	while((temp&0x08)!=0x08)
		temp=rd_state();
	}

/*写命令、写数据命令*********************
数据1、数据2、命令、参数个数
写单个数据时，请将数据放在数据二的位置
*****************************************/
void wr_data(char data1,char data2,char cmd,char num)
	{
	char temp;
	temp=num;
	if(temp==2)
		{
		rd_enable();
		IODIR=0x7ff;
		IOCLR=cd;
		IOCLR=0xff;
		IOSET=data1;
		IOCLR=wr;
		IOSET=wr;
		}
	 if(temp==2||temp==1)
	 	{
		rd_enable();
		IODIR=0x7ff;
		IOCLR=cd;
		IOCLR=0xff;
		IOSET=data2;
		IOCLR=wr;
		IOSET=wr;
		}
	rd_enable();
	IODIR=0x7ff;
	IOSET=cd;
	IOCLR=0xff;
	IOSET=cmd;
	IOCLR=wr;
	IOSET=wr;
	}

char rd_data()	//读数据
	{
	char temp;
	rd_enable();
	IODIR=0x700;
	IOCLR=cd;
	IOCLR=rd;
	temp=IOPIN;
	IOSET=rd;
	return(temp);
	}



void lcd_init()
	{
	IODIR=cd|rd|wr;
	IOSET=cd|rd|wr;
	wr_data(0x00,0x00,0x40,0x02);	//设置文本显示首地址:低字节、高字节、命令、参数个数
	wr_data(0x14,0x00,0x41,0x02);	//设置文本显示宽度
	wr_data(0x40,0x01,0x42,0x02);	//设置图形显示首地址:低字节、高字节、命令、参数个数
	wr_data(0x14,0x00,0x43,0x02);	//设置图形显示宽度
	wr_data(0x00,0x00,0xa1,0x00);	//光标形状设置
	wr_data(0x00,0x00,0x81,0x00);	//显示方式设置，“或”
	wr_data(0x00,0x00,0x9c,0x00);	//显示开关设置
	}
	
/******************字符写函数******************************************
次函数约定屏幕的左上角为坐标原点
x行坐标：取值范围：0--15，共16行
y列坐标：取值范围：0--19，共20列
data：要发送的数据，其中发送0x00是将该单元清零
***********************************************************************/	
void wr_char(unsigned char x,unsigned char y,char data)
	{
	unsigned int temp;
	char addrh,addrl;
	temp=x*20+y;
	addrl=temp;
	addrh=temp>>8;
	wr_data(addrl,addrh,0x24,0x02);	//设置写地址
	wr_data(0x00,data,0xc4,1);
	}

/******************画点函数******************************************
次函数约定屏幕的左上角为坐标原点
x行坐标：取值范围：0--127，共16行
y列坐标：取值范围：0--159，共20列
on：画圆为1，删除为0。
***********************************************************************/
void wr_point(int x,int y,unsigned char on)
	{
	char addrh,addrl,point;
	int temp;
	if((x+1>0)&(x<128)&(y+1>0)&(y<160))
		{
		temp=x*20+(y>>3)+0x0140;
		addrl=temp;
		addrh=temp>>8;
		point=0xf7-y%8;
		if(on)
			point|=0xf8;
		else
			point&=0xf7;
		wr_data(addrl,addrh,0x24,0x02);	//设置写地址
		wr_data(0,0,point,0);
		}				
	}
	
/************************************************/
/*画圆。数学方程(X-Ox)^2+(Y-Oy)^2=Rx^2          */
/************************************************/
void wr_circle(int Ox,int Oy,unsigned char Rx,unsigned char draw)
	{
    int xx,rr,xt,yt,rs;
    int col,row;
    yt=Rx;
    rr=Rx*Rx+1;                     //补偿 1 修正方形
    rs=(yt+(yt>>1))>>1;             //(*0.75)分开1/8圆弧来画
    for (xt=0;xt<=rs;xt++)
    	{
        xx=xt*xt;
        while ((yt*yt)>(rr-xx))yt--;
        col=Ox+xt;              //第一象限
        row=Oy-yt;
        wr_point(col,row,draw);
        col=Ox-xt;              //第二象限
        wr_point(col,row,draw);
        row=Oy+yt;              //第三象限
        wr_point(col,row,draw);
        col=Ox+xt;              //第四象限
        wr_point(col,row,draw);

		/***************45度镜象画另一半***************/

        col=Ox+yt;              //第一象限
        row=Oy-xt;
        wr_point(col,row,draw);
        col=Ox-yt;              //第二象限
        wr_point(col,row,draw);
        row=Oy+xt;              //第三象限
        wr_point(col,row,draw);
        col=Ox+yt;              //第四象限
        wr_point(col,row,draw);
        }
	}

/************************************************/
/*直线函数。       */
//**********************************************************
void line(unsigned int x1,unsigned int y1,unsigned int x2,unsigned int y2,unsigned char draw)
	{
	unsigned int i1,j1,k1,l1;
	int n1=0;
	unsigned char temp=0;
	if(y2<y1)
		{
		i1=x1;
		l1=y1;
		x1=x2;
		y1=y2;
		x2=i1;
		y2=l1;
		}
	k1=y2-y1;
	if(k1==0)
		{
		if(x1>x2)
			{
			i1=x1;
			x1=x2;
			x2=i1;
			}
		for (i1=x1;i1<=x2;i1++)
			wr_point(i1,y1,draw);
		}
	else
		{
		if(x2>=x1)
			{
			temp=1;
			j1=x2-x1;
			}
		else
			j1=x1-x2;
		i1=x1;
		l1=y1;
		wr_point(i1,l1,draw);
		if(temp&&(k1<=j1))
			while(i1!=x2)
				{
				if(n1<0)
					{
					i1=i1+1;
					n1=n1+(y2-l1);
					}
				else
					{
					i1=i1+1;
					l1=l1+1;
					n1=n1+(y2-l1)-(x2-i1);
					}
				wr_point(i1,l1,draw);
				}
		else if(temp&&(k1>j1))
			while(l1!=y2)
				{
				j1=x2-i1;
				k1=y2-l1;
				if(n1<0)
					{
					i1=i1+1;
					l1=l1+1;
					n1=n1+k1-j1;
					}
				else 
					{
					l1=l1+1;n1=n1-j1;
					}
				wr_point(i1,l1,draw);}
		else if(!temp&&(k1<=j1))
			while(i1!=x2)
				{
				j1=i1-x2;
				k1=y2-l1; 
				if(n1<0)
					{
					i1=i1-1;
					n1=n1+k1;
					}
				else 
					{
					i1=i1-1;
					l1=l1+1;
					n1=n1+k1-j1;
					}
				wr_point(i1,l1,draw);}
		else if(!temp &&(k1>j1))
			while(l1!=y2)
				{
				j1=i1-x2;
				k1=y2-l1;
				if(n1<0)
					{
					i1=i1-1;
					l1=l1+1;
					n1=n1+k1-j1;
					}
				else 
					{
					l1=l1+1;
					n1=n1-j1;
					}
				wr_point(i1,l1,draw);
			}
		}
	}

//******************lcd programme end*******************************

//************************clock init****************************************
void c_init()
	{
	wr_char(3,5,0x50);//p
	wr_char(3,6,0x49);//i
	wr_char(3,7,0x41);//a
	wr_char(3,8,0x4f);//o
	wr_char(3,11,0x4c);//l
	wr_char(3,12,0x49);//i
	wr_char(3,13,0x4e);//n
	wr_char(3,14,0x47);//g
	
	wr_char(5,4,0x31);//q
	wr_char(5,5,0x31);//q
	wr_char(5,6,0x1a);//:
	wr_char(5,8,0x10+1);//1
	wr_char(5,9,0x10+5);
	wr_char(5,10,0x10+9);
	wr_char(5,11,0x10+8);
	wr_char(5,12,0x10+7);
	wr_char(5,13,0x10+3);
	wr_char(5,14,0x10+5);
	wr_char(5,15,0x10+3);
	
	wr_circle(123,79,1,1);
	wr_circle(123,79,2,1);
	wr_circle(63,139,1,1);
	wr_circle(63,139,2,1);
	wr_circle(3,79,1,1);
	wr_circle(3,79,2,1);
	wr_circle(63,19,1,1);
	wr_circle(63,19,2,1);
	
	wr_circle(115,109,1,1);
	wr_circle(93,131,1,1);
	wr_circle(33,131,1,1);
	wr_circle(11,109,1,1);
	wr_circle(11,49,1,1);
	wr_circle(33,27,1,1);
	wr_circle(93,27,1,1);
	wr_circle(115,49,1,1);
	
	wr_point(c_ox,c_oy,1);
	wr_circle(c_ox,c_oy,2,1);
	wr_circle(c_ox,c_oy,60,1);
	}

void move(unsigned char n)
	{
	line(c_ox,c_oy,sec[2*n],sec[2*n+1],1);
	}
//************************clock init end************************************

//***********************RTC programme start********************************
#define fpclk 2764800
unsigned char min_n;
unsigned int hou_n;
void rtc_init()
	{
	PREINT=fpclk/32768-1;
	PREFRAC=fpclk-(fpclk/32768)*32768;
	YEAR=2006;
	MONTH=2;
	DOM=3;
	HOUR=22;
	MIN=30;
	SEC=0;
	CIIR=0x01;
	ILR=0x01;
	CCR=0x01;
	}
	
void __irq rtc_int()
	{
	ILR=0x01;
	wr_char(9,6,0x10+HOUR/10);
	wr_char(9,7,0x10+HOUR%10);
	wr_char(9,8,0x1a);
	wr_char(9,9,0x10+MIN/10);
	wr_char(9,10,0x10+MIN%10);
	wr_char(9,11,0x1a);
	wr_char(9,12,0x10+SEC/10);
	wr_char(9,13,0x10+SEC%10);
	
	wr_char(11,5,0x10+YEAR/1000);
	wr_char(11,6,0x10+YEAR%1000/100);
	wr_char(11,7,0x10+YEAR%100/10);
	wr_char(11,8,0x10+YEAR%10);
	wr_char(11,9,0xf);
	wr_char(11,10,0x10+MONTH/10);
	wr_char(11,11,0x10+MONTH%10);
	wr_char(11,12,0xf);
	wr_char(11,13,0x10+DOM/10);
	wr_char(11,14,0x10+DOM%10);
	
	if(SEC==0)
		{
		line(c_ox,c_oy,sec[59*2],sec[59*2+1],0);
		line(c_ox,c_oy,sec[0],sec[1],1);
		}
	else
		{
		line(c_ox,c_oy,sec[SEC*2-2],sec[SEC*2-1],0);
		line(c_ox,c_oy,sec[SEC*2],sec[SEC*2+1],1);
		}
	if(MIN==0)
		{
		line(c_ox,c_oy,min[59*2],min[59*2+1],0);
		line(c_ox,c_oy,min[0],min[1],1);
		}
	else
		{
		line(c_ox,c_oy,min[MIN*2-2],min[MIN*2-1],0);
		line(c_ox,c_oy,min[MIN*2],min[MIN*2+1],1);
		}
	if(HOUR>11)
		hou_n=((HOUR-12)*60+MIN)/12;
	else
		hou_n=(HOUR*60+MIN)/12;
	if(hou_n==0)
		{
		line(c_ox,c_oy,hou[59*2],hou[59*2+1],0);
		line(c_ox,c_oy,hou[0],hou[1],1);
		}
	else
		{
		line(c_ox,c_oy,hou[hou_n*2-2],hou[hou_n*2-1],0);
		line(c_ox,c_oy,hou[hou_n*2],hou[hou_n*2+1],1);
		}
	wr_circle(c_ox,c_oy,2,1);
	}
//*************************RTC programme end********************************

//**************************int init****************************************
void int_init()	//中断向量初始化
	{
	VICIntSelect=0;				//设置所有中断为irq中断
	VICIntEnable=0x00002000;	//中断使能位
	VICVectCntl0=0x2d;			//中断优先级设置
	VICVectAddr0=(int)rtc_int;	//中断向量设置
	}
//**************************************************************************

/****************************************************************************
* 名称：main()
* 功能：
****************************************************************************/
int  main(void)
	{
	lcd_init();
	c_init();
	int_init();
	rtc_init();
	enable_irq();
//	move(2);
//	line(c_ox,c_oy,min[2],min[3],1);
//	line(c_ox,c_oy,hou[0],hou[1],1);
	while(1);
	}
