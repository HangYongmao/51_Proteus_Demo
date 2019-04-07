/*
使用者只要根据不同型号IC，确定地址范围即可
89C51/52    :0x2000～0x2fff
89C54/55/58 :0x8000～0xf3ff
扇区大小512字节，每次读写都要控制在同一扇区

以下5个函数选择使用
字节读出 uchar byte_read(uint byte_addr)
字节写入 uchar byte_write(uint addr, uchar wdata)
扇区擦除 sector_erase(uint sector_addr)
数组写入 uchar array_write(uint begin_addr, uint len, uchar *array)
数组读出 void array_read(uint begin_addr, uchar len,uchar *array)
*/

#ifndef __STC_EEPROM_H__
#define __STC_EEPROM_H__

#include <intrins.h>

#define	uchar	unsigned char
#define uint	unsigned int

#define EEPROM51 0x2000 
#define EEPROM52 0x2000 
#define EEPROM54 0x8000 
#define EEPROM58 0x8000 


/* --------------- 命令定义 --------------- */
#define ReadCommand		0x01	/* 字节读 	*/
#define PrgCommand		0x02	/* 字节写 	*/
#define EraseCommand	0x03	/* 扇区擦除 */

/*----------------定义常量------------------*/
#define Error   1
#define Ok      0

/* 定义Flash对应于20MHz晶振系统的操作等待时间 */
/* 时钟倍频时WaitTime用 0x00*/
#define WaitTime	0x01
/* ------------- 定义扇区大小 ------------- */
#define PerSector		512

/* ================ 打开 ISP,IAP 功能 ================= */
void ISP_IAP_enable(void)
{
	EA	=	0;							/* 关中断 		*/
	ISP_CONTR =	ISP_CONTR & 0x18;       /* 0001,1000	*/
	ISP_CONTR =	ISP_CONTR | WaitTime;	/* 写入硬件延时	*/
	ISP_CONTR =	ISP_CONTR | 0x80;       /* ISPEN=1		*/
}

/* =============== 关闭 ISP,IAP 功能 ================== */
void ISP_IAP_disable(void)
{
	ISP_CONTR	=	ISP_CONTR & 0x7f;	/* ISPEN = 0 */
	ISP_TRIG	=	0x00;
	EA			=   1;			/* 开中断 */
}
/* ================ 公用的触发代码 ==================== */
void ISPgoon(void)
{
	ISP_IAP_enable();			/* 打开 ISP,IAP 功能	*/
	ISP_TRIG	=	0x46;		/* 触发ISP_IAP命令字节1	*/
	ISP_TRIG	=	0xb9;		/* 触发ISP_IAP命令字节2	*/
	_nop_();
}

/* ==================== 字节读 ======================== */
uchar byte_read(uint byte_addr)
{
	ISP_ADDRH = (uchar)(byte_addr >> 8);	/* 地址赋值	*/
	ISP_ADDRL = (uchar)(byte_addr & 0x00ff);

	ISP_CMD   = ISP_CMD	& 0xf8;			/* 清除低3位 	*/
	ISP_CMD   = ISP_CMD	| ReadCommand;	/* 写入读命令	*/

	ISPgoon();							/* 触发执行		*/
	ISP_IAP_disable();				    /* 关闭ISP,IAP功能	*/

	return (ISP_DATA);				    /* 返回读到的数据	*/
}

/* ===================== 字节写 ===================== */
uchar byte_write(uint addr, uchar wdata)
{
	ISP_IAP_enable();					/* 打开IAP功能	*/
	ISP_ADDRH = (uchar)(addr >> 8);
	ISP_ADDRL = (uchar)(addr & 0x00ff);
	ISP_DATA  = wdata;			    	/* 取数据	*/
	ISP_CMD   = ISP_CMD & 0xf8;			/* 清低3位 	*/
	ISP_CMD   = ISP_CMD | PrgCommand;	/* 写命令2 	*/

	ISP_TRIG  = 0x46;		/* 触发ISP_IAP命令字节1 */
	ISP_TRIG  = 0xb9;		/* 触发ISP_IAP命令字节2 */
	_nop_();

	/* 读回来 */
	ISP_DATA	=	0x00;

	ISP_CMD  = ISP_CMD & 0xf8;			/* 清低3位 	*/
	ISP_CMD  = ISP_CMD | ReadCommand;	/* 读命令1 	*/

	ISP_TRIG = 0x46;		/* 触发ISP_IAP命令字节1 */
	ISP_TRIG = 0xb9;		/* 触发ISP_IAP命令字节2 */
	_nop_();

	/*  比较对错 */
	if(ISP_DATA != wdata)
	{
		ISP_IAP_disable();
		return Error;
	}	

	ISP_IAP_disable();
	return	Ok;
}


/* ================== 扇区擦除 ======================== */
void sector_erase(uint sector_addr)
{
	uint iSectorAddr;
	iSectorAddr = (sector_addr & 0xfe00); /* 取扇区地址 */
	ISP_ADDRH = (uchar)(iSectorAddr >> 8);
	ISP_ADDRL = 0x00;

	ISP_CMD	= ISP_CMD & 0xf8;			/* 清空低3位 	*/
	ISP_CMD	= ISP_CMD | EraseCommand;	/* 擦除命令3 	*/

	ISPgoon();							/* 触发执行		*/
	ISP_IAP_disable();				/* 关闭ISP,IAP功能	*/

}

/* ===================== 数组写入 ===================== */
uchar array_write(uint begin_addr, uint len, uchar *array)
{
	uint	i;
	uint	in_addr;

	/* 判是否是有效范围,此函数不允许跨扇区操作 */
	if(len > PerSector)
		return Error;
	in_addr = begin_addr & 0x01ff;	 	/* 扇区内偏移量 */
	if((in_addr + len) > PerSector)
		return Error;

	in_addr = begin_addr;
	/* 逐个写入并校对 */
	ISP_IAP_enable();					/* 打开IAP功能	*/
	for(i = 0; i< len; i++)
	{
		/* 写一个字节 */
		ISP_ADDRH = (uchar)(in_addr >> 8);
		ISP_ADDRL = (uchar)(in_addr & 0x00ff);
		ISP_DATA  = array[i];				/* 取数据	*/
		ISP_CMD   = ISP_CMD & 0xf8;			/* 清低3位 	*/
		ISP_CMD   = ISP_CMD | PrgCommand;	/* 写命令2 	*/
		ISP_TRIG  = 0x46;		/* 触发ISP_IAP命令字节1 */
		ISP_TRIG  = 0xb9;		/* 触发ISP_IAP命令字节2 */
		_nop_();			  
		/* 读回来 */
		ISP_DATA	=	0x00; 
		ISP_CMD  = ISP_CMD & 0xf8;			/* 清低3位 	*/
		ISP_CMD  = ISP_CMD | ReadCommand;		/* 读命令1 	*/

		ISP_TRIG = 0x46;		/* 触发ISP_IAP命令字节1 */
		ISP_TRIG = 0xb9;		/* 触发ISP_IAP命令字节2 */
		_nop_();														  
		/*  比较对错 */
		if(ISP_DATA != array[i])
		{
			ISP_IAP_disable();
			return Error;
		}
		in_addr++;					/* 指向下一个字节	*/
	}
	ISP_IAP_disable();
	return	Ok;
}

/* ========================= 数组读出 ========================= */
/* 程序对地址没有作有效性判断，请调用方事先保证他在规定范围内	*/
void array_read(uint begin_addr, uchar len,uchar *array)
{
	uint iSectorAddr;
	uint i;
	iSectorAddr = begin_addr;	
	ISP_IAP_enable();
	for(i = 0; i < len; i++)
	{
		ISP_ADDRH =	(uchar)(iSectorAddr >> 8);
		ISP_ADDRL =	(uchar)(iSectorAddr & 0x00ff);
		ISP_CMD  = ISP_CMD	& 0xf8;				/* 清低3位 	*/
		ISP_CMD  = ISP_CMD	| ReadCommand;		/* 读命令1 	*/
		ISP_DATA = 0;
		ISP_TRIG = 0x46;			/* 触发ISP_IAP命令字节1 */
		ISP_TRIG = 0xb9;			/* 触发ISP_IAP命令字节2 */
		_nop_();
		array[i] = ISP_DATA;
		iSectorAddr++;
	}
	ISP_IAP_disable(); /* 关闭IAP功能*/
} 

#endif
