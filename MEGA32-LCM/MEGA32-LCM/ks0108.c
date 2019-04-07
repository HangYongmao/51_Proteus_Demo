/*
KS0108 128*64 LCD C语言驱动
LCD引脚定义
1---GND 
2---VCC
3---VLCD
4---D/I
5---R/W
6---E
7到14 D0-D7
15--CS1
16--CS2
17--RESET
18--VEE
19--SW
20--NC 
*/
#include <iom16.h>
//#include <macros.h>
#include "delay.h"
unsigned char CurOffset,CurRow,CurPage,CurCol;	
#define uchar unsigned char
/*  常量定义  */
#define LCD_STATUS_BUSY 0x80
#define  START_LINE0   0xc0
#define  DISPLAY_ON    0x3f
#define  DISPLAY_OFF   0x3e
#define  PARA1         0x40
#define BIT(x)  (1<<x)
//PORTA---数据口  PORTB----控制口
volatile unsigned char *LCD_DIR_PORT = &DDRA;
volatile unsigned char *LCD_IP_PORT  = &PINA;
volatile unsigned char *LCD_OP_PORT  = &PORTA;

volatile unsigned char *LCD_EN_PORT  = &PORTB;
volatile unsigned char *LCD_CS2_PORT = &PORTB;
volatile unsigned char *LCD_CS1_PORT = &PORTB;
volatile unsigned char *LCD_RW_PORT  = &PORTB;
volatile unsigned char *LCD_DI_PORT  = &PORTB;

char LCD_EN_BIT  = BIT(4);
char LCD_CS2_BIT = BIT(3);
char LCD_CS1_BIT = BIT(2);
char LCD_RW_BIT  = BIT(1);
char LCD_DI_BIT  = BIT(0);

#define SET_LCD_E      	        *LCD_EN_PORT |= LCD_EN_BIT    //LCD使能
#define CLEAR_LCD_E       	    *LCD_EN_PORT &= ~LCD_EN_BIT   //LCD禁止

#define SET_LCD_DATA      	    *LCD_DI_PORT |= LCD_DI_BIT    //选择指令端口
#define SET_LCD_CMD       	    *LCD_DI_PORT &= ~LCD_DI_BIT   //选择数据端口

#define SET_LCD_READ      	    *LCD_RW_PORT |= LCD_RW_BIT    //读模式
#define SET_LCD_WRITE      	    *LCD_RW_PORT &= ~LCD_RW_BIT   //写模式

#define SET_LCD_CS2      	    *LCD_CS2_PORT |= LCD_CS2_BIT  //左屏选择禁止
#define CLEAR_LCD_CS2      	    *LCD_CS2_PORT &= ~LCD_CS2_BIT //左屏选择使能

#define SET_LCD_CS1      	    *LCD_CS1_PORT |= LCD_CS1_BIT  //左屏选择禁止
#define CLEAR_LCD_CS1      	    *LCD_CS1_PORT &= ~LCD_CS1_BIT //左屏选择使能

#define LEFT 0
#define RIGHT 1
#define CMD 0
#define DATA 1

void LCD_BUSY(unsigned char lr) //判断忙标志
{
    unsigned char status;
    asm("cli");
    if(lr==LEFT)
    {
        CLEAR_LCD_CS2; //cs2=0
        SET_LCD_CS1;   //cs1=1
    }
    else
    {
        SET_LCD_CS2;   //cs2=1
        CLEAR_LCD_CS1; //cs1=0
    }	
    SET_LCD_CMD;
    *LCD_DIR_PORT = 0x00;
    *LCD_OP_PORT = 0xff;		
    SET_LCD_READ;
    SET_LCD_E;					
    asm("nop");	
    asm("nop");
    asm("nop");
    asm("nop");
    while((*LCD_IP_PORT) & LCD_STATUS_BUSY)
    {
        CLEAR_LCD_E;	   		
        asm("nop");
        asm("nop");
        asm("nop");
        asm("nop");
        SET_LCD_E;
        asm("nop");
        asm("nop");
        asm("nop");
        asm("nop");
    }
    CLEAR_LCD_E;
    SET_LCD_WRITE;
    *LCD_OP_PORT = 0xff;
    asm("sei");//)asm("sei");
}

void write_LCD(unsigned char lr,unsigned char cd,unsigned char data) /*写入指令或数据*/
{	
    asm("cli");//)asm("cli");
    LCD_BUSY(lr);
    if(cd==CMD)
    {
        SET_LCD_CMD;
    }
    else
    {
        SET_LCD_DATA;
    }
    SET_LCD_WRITE; 
    SET_LCD_E;
    *LCD_DIR_PORT = 0xff;
    *LCD_OP_PORT = data;
    asm("nop");
    asm("nop");
    asm("nop");
    asm("nop");
    CLEAR_LCD_E;
    *LCD_OP_PORT = 0xff;
    asm("sei");
}
unsigned char read_LCD(unsigned char lr)	  /*  读显示数据 */
{
    unsigned char data;
    asm("cli");
    LCD_BUSY(lr);
    SET_LCD_DATA;
    *LCD_DIR_PORT = 0x00;
    *LCD_OP_PORT = 0xff;
    SET_LCD_READ;
    SET_LCD_E;
    asm("nop");
    asm("nop");
    asm("nop");
    asm("nop");
    data=*LCD_IP_PORT;
    CLEAR_LCD_E;
    SET_LCD_WRITE;
    LCD_BUSY(lr);
    SET_LCD_DATA; 
    *LCD_DIR_PORT = 0x00;
    *LCD_OP_PORT = 0xff;
    SET_LCD_READ; 
    SET_LCD_E;
    asm("nop");	
    asm("nop");
    asm("nop");
    asm("nop");
    data=*LCD_IP_PORT;
    CLEAR_LCD_E;
    SET_LCD_WRITE;

    asm("sei");
    return data;
}

void set_start_line_L(unsigned char line) /*设置显示起始行*/ //0-63
{
    write_LCD(LEFT,CMD,0xc0|line); 
}

void set_start_line_R(unsigned char line) /*设置显示起始行*/ //0-63
{
    write_LCD(RIGHT,CMD,0xc0|line); 
}

void set_page_L(unsigned char page)	/*设置X地址 设置页*/  //0-7
{
    write_LCD(LEFT,CMD,0xb8|page);                     
}
void set_page_R(unsigned char page)	/*设置X地址 设置页*/ //0-7
{
    write_LCD(RIGHT,CMD,0xb8|page);                     
}

void set_col_addr_L(unsigned char col) /*设置Y地址*/ //0-63
{
    write_LCD(LEFT,CMD,0x40|col);                     
}

void set_col_addr_R(unsigned char col) /*设置Y地址*/ //0-63
{
    write_LCD(RIGHT,CMD,0x40|col);                     
}

void init_lcd(void) /*初始化函数*/
{
    set_start_line_L(0); /*显示起始行为0*/
    set_start_line_R(0); /*显示起始行为0*/
    write_LCD(LEFT,CMD,DISPLAY_ON); /*  开显示  */
    write_LCD(RIGHT,CMD,DISPLAY_ON); /*  开显示  */
}

void clr_lcd(void) /*清屏函数*/
{
    unsigned char pages,i;
    for(pages=0;pages<8;pages++)
    {
        set_page_L(pages);  /* X 页地址 */
        set_page_R(pages);  /* X 页地址 */
        for(i=0;i<64;i++)   
        {
            set_col_addr_L(i);//Y
            set_col_addr_R(i);//Y
            write_LCD(LEFT,DATA,0x0);
            write_LCD(RIGHT,DATA,0x0);
        }
    }
}

//ASCII 字模宽度及高度
#define ASC_CHR_WIDTH	8
#define ASC_CHR_HEIGHT	12

typedef struct typFNT_ASC16	/* 汉字字模显示数据结构 */
{
    char Index[1];
    char Msk[16];
};
__flash struct typFNT_ASC16  ASC_16[] = 
{	/* 显示为8*16  Curier 10 常规*/
"1",0x00,0x00,0x08,0x08,0xFC,0x00,0x00,0x00,0x00,0x00,0x04,0x04,0x07,0x04,0x04,0x00,
"2",0x00,0x00,0x08,0x04,0x84,0x44,0x38,0x00,0x00,0x00,0x06,0x05,0x04,0x04,0x04,0x00,
"3",0x00,0x00,0x08,0x04,0x44,0x44,0xB8,0x00,0x00,0x00,0x02,0x04,0x04,0x04,0x03,0x00,
"4",0x00,0x00,0x80,0x60,0x18,0xFC,0x00,0x00,0x00,0x00,0x01,0x01,0x05,0x07,0x05,0x00,
"5",0x00,0x00,0x7C,0x44,0x44,0x44,0x84,0x00,0x00,0x00,0x02,0x04,0x04,0x04,0x03,0x00,
"6",0x00,0x00,0xF0,0x48,0x44,0x44,0x80,0x00,0x00,0x00,0x03,0x04,0x04,0x04,0x03,0x00,
"7",0x00,0x00,0x0C,0x04,0x84,0x64,0x1C,0x00,0x00,0x00,0x00,0x06,0x01,0x00,0x00,0x00,
"8",0x00,0x00,0xB8,0x44,0x44,0x44,0xB8,0x00,0x00,0x00,0x03,0x04,0x04,0x04,0x03,0x00,
"9",0x00,0x00,0x38,0x44,0x44,0x44,0xF8,0x00,0x00,0x00,0x00,0x04,0x04,0x02,0x01,0x00,
"0",0x00,0x00,0xF8,0x04,0x04,0x04,0xF8,0x00,0x00,0x00,0x03,0x04,0x04,0x04,0x03,0x00,
".",0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x04,0x00,0x00,0x00,
",",0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x08,0x04,0x00,0x00,0x00,
":",0x00,0x00,0x00,0x00,0x20,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x04,0x00,0x00,0x00,
";",0x00,0x00,0x00,0x00,0x20,0x00,0x00,0x00,0x00,0x00,0x00,0x08,0x04,0x00,0x00,0x00,
"-",0x00,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
"_",0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x10,0x10,0x10,0x10,0x10,0x10,0x10,0x10,
"A",0x00,0x00,0x80,0x64,0x1C,0x60,0x80,0x00,0x00,0x04,0x07,0x05,0x01,0x05,0x07,0x04,
"B",0x00,0x04,0xFC,0x44,0x44,0x44,0x44,0xB8,0x00,0x04,0x07,0x04,0x04,0x04,0x04,0x03,
"C",0x00,0xF0,0x08,0x04,0x04,0x04,0x04,0x08,0x00,0x01,0x02,0x04,0x04,0x04,0x04,0x02,
"D",0x00,0x04,0xFC,0x04,0x04,0x04,0x08,0xF0,0x00,0x04,0x07,0x04,0x04,0x04,0x02,0x01,
"E",0x00,0x04,0xFC,0x44,0x44,0xE4,0x04,0x0C,0x00,0x04,0x07,0x04,0x04,0x04,0x04,0x06,
"F",0x00,0x04,0xFC,0x44,0x44,0xE4,0x04,0x0C,0x00,0x04,0x07,0x04,0x04,0x00,0x00,0x00,
" ",0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
"=",0x00,0x00,0xA0,0xA0,0xA0,0xA0,0xA0,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
"(",0x00,0x00,0x00,0xE0,0x18,0x04,0x00,0x00,0x00,0x00,0x00,0x03,0x0C,0x10,0x00,0x00,
")",0x00,0x00,0x00,0x04,0x18,0xE0,0x00,0x00,0x00,0x00,0x00,0x10,0x0C,0x03,0x00,0x00,
"V",0x00,0x04,0x3C,0xC4,0x00,0xC4,0x3C,0x04,0x00,0x00,0x00,0x01,0x06,0x01,0x00,0x00,
"m",0x00,0x20,0xE0,0x20,0xC0,0x20,0xC0,0x00,0x00,0x04,0x07,0x00,0x07,0x00,0x07,0x04,
"H",0x00,0x04,0xFC,0x44,0x40,0x44,0xFC,0x04,0x00,0x04,0x07,0x04,0x00,0x04,0x07,0x04,
"*",0x90,0x90,0x60,0xFC,0x60,0x90,0x90,0x00,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x00,
};

#define ASC_HZ_WIDTH	12
//#define ASC_HZ_HEIGHT	12

typedef struct typFNT_GB16	/*12*16 汉字字模显示数据结构 */
{
	char Index[2];
	char Msk[24];
};
__flash struct typFNT_GB16  GB_16[] = {	/* 宋体 9 显示为12*16 */
"科",0x8A,0x6A,0xFE,0x29,0x49,0x80,0x92,0xA4,0x80,0xFF,0x40,0x00,0x01,0x00,0x07,0x00,0x00,0x00,0x00,0x00,0x00,0x07,0x00,0x00,
"技",0x44,0x44,0xFF,0x24,0x00,0x64,0xA4,0x3F,0xA4,0x64,0x04,0x00,0x04,0x04,0x07,0x00,0x04,0x04,0x02,0x01,0x02,0x04,0x04,0x00,
"有",0x42,0x22,0x12,0xFA,0x4E,0x4B,0x4A,0x4A,0xFA,0x02,0x02,0x00,0x00,0x00,0x00,0x07,0x01,0x01,0x01,0x05,0x07,0x00,0x00,0x00,
"限",0xFF,0x81,0x99,0xE7,0x00,0xFF,0x25,0xE5,0x25,0xBF,0x40,0x00,0x07,0x00,0x00,0x00,0x00,0x07,0x04,0x02,0x01,0x02,0x04,0x00,
"公",0x20,0x10,0x08,0x07,0xC0,0x30,0x83,0x0C,0x10,0x20,0x20,0x00,0x00,0x04,0x06,0x05,0x04,0x04,0x02,0x03,0x06,0x00,0x00,0x00,
"司",0x08,0x09,0xE9,0x29,0x29,0x29,0xED,0x09,0x01,0xFF,0x00,0x00,0x00,0x00,0x01,0x01,0x01,0x01,0x01,0x04,0x04,0x07,0x00,0x00,
"液",0x19,0xE2,0x14,0x42,0xF2,0x2E,0x72,0x8F,0xAA,0x7A,0x02,0x00,0x01,0x07,0x00,0x00,0x07,0x04,0x04,0x02,0x01,0x02,0x04,0x00,
"晶",0x00,0xC0,0x40,0x5F,0xD5,0x15,0xD5,0x55,0x5F,0x40,0xC0,0x00,0x00,0x07,0x05,0x05,0x07,0x00,0x07,0x05,0x05,0x05,0x07,0x00,
"显",0x00,0x40,0x9F,0x15,0xD5,0x15,0xD5,0x15,0x1F,0xC0,0x00,0x00,0x04,0x04,0x05,0x04,0x07,0x04,0x07,0x06,0x05,0x04,0x04,0x00,
"示",0x10,0x12,0x92,0x52,0x12,0xF2,0x12,0x12,0x53,0x92,0x10,0x00,0x02,0x01,0x00,0x04,0x04,0x07,0x00,0x00,0x00,0x00,0x03,0x00,
"的",0xFC,0x44,0x46,0x45,0xFC,0x10,0x2C,0xC7,0x04,0x04,0xFC,0x00,0x07,0x02,0x02,0x02,0x07,0x00,0x00,0x04,0x04,0x04,0x03,0x00,
"第",0x04,0xEA,0xAB,0xAE,0xAA,0xFC,0xAA,0xAB,0xAE,0xBA,0x82,0x00,0x04,0x04,0x02,0x01,0x00,0x07,0x00,0x02,0x02,0x02,0x01,0x00,
"一",0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x30,0x20,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
"行",0x48,0x24,0xF3,0x08,0x09,0x09,0x09,0x09,0xF9,0x09,0x08,0x00,0x00,0x00,0x07,0x00,0x00,0x04,0x04,0x04,0x07,0x00,0x00,0x00,
"二",0x00,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x06,0x04,0x00,0x00,0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x00,
"三",0x00,0x02,0x22,0x22,0x22,0x22,0x22,0x22,0x23,0x02,0x00,0x00,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x06,0x04,0x00,
"四",0x00,0xFF,0x81,0x41,0x3F,0x01,0x01,0xFF,0x81,0x81,0xFF,0x00,0x00,0x07,0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x07,0x00,
"五",0x00,0x11,0x11,0x91,0x7F,0x11,0x11,0x11,0xF1,0x01,0x00,0x00,0x04,0x04,0x04,0x07,0x04,0x04,0x04,0x04,0x07,0x04,0x04,0x00,
};

unsigned char GetPage(void) /*得到当前页*/
{
	return CurPage;
}

unsigned char GetCol(void) /*得到当前列*/
{
	return CurCol;
}

void SetPageCol(unsigned char upage, unsigned char ucol) /* 设置液晶的页和列 */
{
	CurPage = upage;
	CurCol = ucol;
	if(ucol<64)
	{
		set_page_L(upage);
		set_col_addr_L(ucol);
	}
	else
	{
		set_page_R(upage);
		set_col_addr_R(ucol-64);
	}
}

/* 设置当前显示的页和列 */
void SetRowCol(unsigned char urow, unsigned char ucol) 
{
	unsigned char page;
	CurRow = urow;
	CurCol = ucol;
	
	switch(urow)
	{
		case 1:
			page=0;
			CurOffset=1;
			break;
		case 2:
			page=1;
			CurOffset=2;
			break;
		case 3:
			page=3;
			CurOffset=1;
			break;
		case 4:
			page=4;
			CurOffset=2;
			break;
		case 5:
			page=6;
			CurOffset=1;
			break;
	}
	SetPageCol(page,ucol);
}

void disp_ch(unsigned char c)
{
	unsigned char k,j,uPage,uCol,ch_r,ch_w;
	unsigned char width;
	unsigned char len;
	uPage = GetPage();
	uCol = GetCol();
	len=sizeof(ASC_16)/sizeof(ASC_16[0]);
	for(k=0;k<len;k++)
	{
		if(c == ASC_16[k].Index[0] ) break;
	}
	if(k<len)
	{
		
		if(c=='-'||c==':') 
			width=ASC_CHR_WIDTH-2;
		else if(c=='|')
			width=ASC_HZ_WIDTH-ASC_CHR_WIDTH;
		else 
			width=ASC_CHR_WIDTH;
		
		if(CurOffset==1) //下半部是写半个字节
		{
			for(j=0;j<width;j++)
			{
				SetPageCol(uPage,uCol+j);
				ch_w=ASC_16[k].Msk[j];
				if(uCol+j<64)	write_LCD(LEFT,DATA,ch_w); 
				else write_LCD(RIGHT,DATA,ch_w);
			}
			SetPageCol(uPage+1,uCol);
			
			for(j=0;j<width;j++)
			{
				SetPageCol(uPage+1,uCol+j);
				if(uCol+j<64) ch_r=read_LCD(LEFT);
				else ch_r=read_LCD(RIGHT);
				ch_r&=0xf0;
				ch_w=ASC_16[k].Msk[ASC_CHR_WIDTH+j]&0x0f; 
				ch_w|=ch_r;
				SetPageCol(uPage+1,uCol+j);
				if(uCol+j<64)	write_LCD(LEFT,DATA,ch_w); 
				else write_LCD(RIGHT,DATA,ch_w); 
			}
		}
		else //上半部是写半个字节
		{
			for(j=0;j<width;j++)
			{
				SetPageCol(uPage,uCol+j);
				if(uCol+j<64) ch_r=read_LCD(LEFT);
				else ch_r=read_LCD(RIGHT);
				ch_r&=0x0f;
				ch_w=ASC_16[k].Msk[j];
				ch_w=ch_w<<4;
				ch_w|=ch_r;
				SetPageCol(uPage,uCol+j);
				if(uCol+j<64)	write_LCD(LEFT,DATA,ch_w); 
				else write_LCD(RIGHT,DATA,ch_w); 
			}
			SetPageCol(uPage+1,uCol);
			for(j=0;j<width;j++)
			{
				SetPageCol(uPage+1,uCol+j);
				
				ch_r=ASC_16[k].Msk[j];
				ch_w=ASC_16[k].Msk[ASC_CHR_WIDTH+j];
				ch_r=ch_r>>4;
				ch_w=ch_w<<4; 
				ch_w|=ch_r;
				SetPageCol(uPage+1,uCol+j);
				if(uCol+j<64)	write_LCD(LEFT,DATA,ch_w); 
				else write_LCD(RIGHT,DATA,ch_w); 
			}
		}
	}
	SetPageCol(uPage,uCol+width);
}


void disp_hz(unsigned char *hz)
{
	unsigned char k,j,uPage,uCol,ch_r,ch_w;
	uPage = GetPage();
	uCol = GetCol();
	for(k=0;k<sizeof(GB_16)/sizeof(GB_16[0]);k++)
	{
		if(hz[0] == GB_16[k].Index[0] && hz[1] == GB_16[k].Index[1])
			break;
	}

	if(CurOffset==1) 
	{
	for(j=0;j<ASC_HZ_WIDTH;j++)
	{
		SetPageCol(uPage,uCol+j);
		ch_w=GB_16[k].Msk[j];
		if(uCol+j<64)	write_LCD(LEFT,DATA,ch_w);
		else write_LCD(RIGHT,DATA,ch_w);
	}
	SetPageCol(uPage+1,uCol);

	for(j=0;j<ASC_HZ_WIDTH;j++)
	{
		SetPageCol(uPage+1,uCol+j);
		if(uCol+j<64) ch_r=read_LCD(LEFT);
		else ch_r=read_LCD(RIGHT);
		ch_r&=0xf0;
		ch_w=GB_16[k].Msk[ASC_HZ_WIDTH+j]&0x0f; 
		ch_w|=ch_r;
		SetPageCol(uPage+1,uCol+j);
		if(uCol+j<64)	write_LCD(LEFT,DATA,ch_w); 
		else write_LCD(RIGHT,DATA,ch_w);
	}
	SetPageCol(uPage,uCol+ASC_HZ_WIDTH);
	}

	else //汉字上半部是写半个字节
	{
	for(j=0;j<ASC_HZ_WIDTH;j++)
	{
		SetPageCol(uPage,uCol+j);
		if(uCol+j<64) ch_r=read_LCD(LEFT);
		else ch_r=read_LCD(RIGHT);
		ch_r&=0x0f;
		ch_w=GB_16[k].Msk[j];
		ch_w=ch_w<<4;
		ch_w|=ch_r;
		SetPageCol(uPage,uCol+j);
		if(uCol+j<64)	write_LCD(LEFT,DATA,ch_w); 
		else write_LCD(RIGHT,DATA,ch_w); 
	}
	SetPageCol(uPage+1,uCol);
	for(j=0;j<ASC_HZ_WIDTH;j++)
	{
		SetPageCol(uPage+1,uCol+j);

		ch_r=GB_16[k].Msk[j];
		ch_w=GB_16[k].Msk[ASC_HZ_WIDTH+j];
		ch_r=ch_r>>4;
		ch_w=ch_w<<4; 
		ch_w|=ch_r;
		SetPageCol(uPage+1,uCol+j);
		if(uCol+j<64)	write_LCD(LEFT,DATA,ch_w); 
		else write_LCD(RIGHT,DATA,ch_w); 
	}
	SetPageCol(uPage,uCol+ASC_HZ_WIDTH);
	}
}

void disp_str(unsigned char *p)
{
	unsigned char i=0;
	while(p[i]>0)
	{
		if(p[i] < 128)
		{	/* ASCII */
			disp_ch(p[i]);
		}
		else
		{	/* 中文 */
			disp_hz(&p[i]);
			i++;
		}
		i++;
	}
}

/*************************************/
/*             绘点函数              */
/*************************************/
/* XX--(0-128) YY--(0-63) FLAG=1绘点   FLAG=0 清点 */
void pixel(unsigned char xx,unsigned char yy,unsigned char flag)
{
	unsigned int y,ch;
	ch=yy%8;  //余数

	y=1;
	for(;ch!=0;)
		{
			y=y*2;
			ch--;
		}
	if(xx<64)
		{
			set_page_L(yy/8);
			set_col_addr_L(xx);	
			ch=read_LCD(LEFT);
			set_col_addr_L(xx);
			if(flag)
				write_LCD(LEFT,DATA,ch|y);
			else
			{
				y=~y;
				ch&=y;
				write_LCD(LEFT,DATA,ch|y);
			}
		}
	else
		{
			set_page_R(yy/8);
			set_col_addr_R(xx-64);	
			ch=read_LCD(RIGHT);
			set_col_addr_R(xx-64);	
			if(flag)
				write_LCD(RIGHT,DATA,ch|y);
			else
			{
				y=~y;
				ch&=y;
				write_LCD(RIGHT,DATA,ch|y);
			}
		}
}
/*void point(void) 
{ 
   uchar   x1, y1, y; 

   x1 = CurCol; 
   y1 = CurRow; 
   CurRow = y1 >> 3;      //取Y方向分页地址   
   Rddata();               // get cbyte on screen 
   y = y1 & 0x07;     //字节内位置计算  
   Wrdata(cbyte | (1 << y));   //画上屏幕    /
   CurCol = x1;         ///恢复xy坐标     /
   CurRow = y1; 
} */

/************************************************/ 
/*画圆。数学方程(X-Ox)^2+(Y-Oy)^2=Rx^2      */ 
/************************************************/ 

/*void circle(uchar Ox, uchar Oy, uchar Rx) 
{ 
   unsigned int xx, rr, xt, yt, rs; 
    
    yt = Rx; 
   rr = Rx * Rx + 1;         //补偿 1 修正方形 
   rs = (yt + (yt >> 1)) >> 1;      //(*0.75)分开1/8圆弧来画 
   for (xt = 0; xt <= rs; xt++) 
   { 
      xx = xt * xt; 
      while ((yt * yt) > (rr - xx)) 
            yt--; 
      col = Ox + xt;      //第一象限 
      row=Oy-yt; 
      point(); 
      col = Ox - xt;      //第二象限 
      point(); 
      row = Oy + yt;      //第三象限 
      point(); 
      col = Ox + xt;      //第四象限 
      point(); 

// ***************45度镜象画另一半*************** 

      col = Ox + yt;      //第一象限 
      row = Oy - xt; 
      point(); 
      col = Ox - yt;      //第二象限 
      point(); 
      row = Oy + xt;      //第三象限 
      point(); 
      col = Ox + yt;      //第四象限 
      point(); 
   } 
} 
*/
             
/************************************************/ 
/*画线。任意方向的斜线,直线数学方程 aX+bY=1   */ 
/************************************************/ 

/*void Linexy(uchar x0,uchar y0,uchar xt,uchar yt) 
{ 
   uchar t; 
   int xerr = 0, yerr = 0, delta_x, delta_y, distance; 
   int incx, incy; 

   delta_x = xt - x0;            // 计算坐标增量 
   delta_y = yt - y0; 
   col = x0; 
   row = y0; 
    
    if (delta_x > 0)  
    { 
        incx = 1;         // 水平+方向 
    } 
   else if (delta_x == 0 )  
        { 
            incx = 0;      // 垂直线 
        } 
      else  
        { 
            incx =- 1;  //水平负方向 
            delta_x =- delta_x; 
        } 
     
   if (delta_y > 0)  
    { 
        incy = 1;       // 垂直+方向 
    } 
   else  
        if (delta_y == 0)  
        { 
            incy = 0;      // 水平线 
        } 
      else  
        { 
            incy =- 1;      //垂直-方向 
            delta_y =- delta_y; 
        } 
  

   if (delta_x > delta_y)    
        distance = delta_x; //选取基本增量坐标轴 
   else  
        distance = delta_y; 

   for (t = 0; t <= distance + 1; t++)    
    {   // 画线输出 
      point();         // 画点 
      xerr +=   delta_x; 
      yerr +=   delta_y; 
       
      if (xerr > distance)  
        { 
         xerr -= distance; 
         col += incx; 
      } 
      if (yerr > distance)  
        { 
         yerr -= distance; 
         row += incy; 
      } 
   } 
} 
*/
void Linexy(uchar x0,uchar y0,uchar xt,uchar yt,uchar s)
{
	register uchar t;
	int xerr=0,yerr=0,delta_x,delta_y,distance;
	int incx,incy,uRow,uCol;

	delta_x = xt-x0;				//计算坐标增量
	delta_y = yt-y0;
	uRow = x0;
	uCol = y0;
	if(delta_x>0) incx=1;				//设置单步方向
	else if( delta_x==0 ) incx=0;			//垂直线
		else {incx=-1;delta_x=-delta_x;}

	if(delta_y>0) incy=1;
	else if( delta_y==0 ) incy=0;			//水平线
		else {incy=-1;delta_y=-delta_y;}

	if( delta_x > delta_y )	distance=delta_x;	//选取基本增量坐标轴
	else distance=delta_y;

	for( t=0;t <= distance+1; t++ )
        	{					//画线输出
		pixel(uRow,uCol,s);			//画点
		xerr +=	delta_x	;
		yerr +=	delta_y	;
		
		if( xerr > distance )
                	{
			xerr-=distance;
			uRow+=incx;
			}
		if( yerr > distance )
                	{
			yerr-=distance;
			uCol+=incy;
			}
		}
}

/************************************************/
/*画圆。数学方程(X-Ox)^2+(Y-Oy)^2=Rx^2			*/
/************************************************/
void circle(uchar Ox,uchar Oy,uchar Rx,uchar s)
{
	unsigned int xx,rr,xt,yt,rs,row,col;
	yt=Rx;
	rr=Rx*Rx+1;			//补偿 1 修正方形
	rs=(yt+(yt>>1))>>1;		//(*0.75)分开1/8圆弧来画
	for (xt=0;xt<=rs;xt++)
	{
		xx=xt*xt;
		while ((yt*yt)>(rr-xx))yt--;
		row=Ox+xt;		//第一象限
		col=Oy-yt;
		pixel(row,col,s);
		row=Ox-xt;		//第二象限
		pixel(row,col,s);
		col=Oy+yt;		//第三象限
		pixel(row,col,s);
		row=Ox+xt;		//第四象限
		pixel(row,col,s);

/***************45度镜象画另一半***************/

		row=Ox+yt;		//第一象限
		col=Oy-xt;
		pixel(row,col,s);
		row=Ox-yt;		//第二象限
		pixel(row,col,s);
		col=Oy+xt;		//第三象限
		pixel(row,col,s);
		row=Ox+yt;		//第四象限
		pixel(row,col,s);
	}
}
void delay(int tt)
{
 	 int i;
	 int j;
	 while((j++)>1000000)	
	 {
	     for(i=0;i<tt;i++)
	     {
	         NOP();
	     }	 
	}
}

void main() 
{ 
unsigned int i;
//init_port();//自己加,主要是控制线所在端口为输出
DDRB = 0xff; 
init_lcd(); 

SetRowCol(1,0);
disp_str("液晶显示的第1行");
SetRowCol(2,0);
disp_str("液晶显示的第2行");
SetRowCol(3,0);
disp_str("液晶显示的第3行");
SetRowCol(4,0);
disp_str("液晶显示的第4行");
SetRowCol(5,0);
disp_str("液晶显示的第5行");
//clr_lcd();
//for(i=0;i<64;i++) pixel(127,i,1);
//for(i=0;i<64;i++) pixel(0,i,1);
//for(i=0;i<128;i++) pixel(i,0,1);
//for(i=0;i<128;i++) pixel(i,63,1);
//for(i=0;i<40;i++)
//{
//circle(20,45,i,1);				// 画圆
//}
while(1);


} 

