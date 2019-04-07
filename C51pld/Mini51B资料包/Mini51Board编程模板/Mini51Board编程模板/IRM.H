#ifndef __IRM_H__
#define __IRM_H__

#define IRM_DQ M51_IRM_DQ

void extern2_init(void)
{
	EA = 1;
	IT2 = 1;//下降沿中断
	EX2 = 1;
}

unsigned char irm_code;//红外解码键值返回全局变量

//STC单片机特有的外部中断INT2实现红外解码
//解码结果由数据缓冲区返回
void IRMint(void) interrupt 6
{		
	unsigned int temp;
	unsigned char i,temp_buff[2];

	EA = 0;/*解码过程禁止其它中断发生*/
	temp = 0;
	while(!IRM_DQ) if(temp++>0x1000) goto return_main;//防止意外死机	
	if (temp < 0x0400) goto return_main;//Max=0x0457
	/*以上完成引导码9ms的低电平检测*/
	temp = 0;
	while(IRM_DQ) if(temp++>0x1000)goto return_main;
	if (temp < 0x0180) goto return_main;//Max=0x0227
	/*以上完成引导码4.5ms的高电平检测*/
	for(i=0;i<24;i++)//跳过2字节引导码
	{
		temp = 0;
		while(!IRM_DQ)if(temp++>0x1000) goto return_main;//通过编码低电平
		temp = 0;
		while(IRM_DQ) if(temp++>0x1000) goto return_main;
	}

    /*有效字节*/
	for(i=0;i<8;i++)
	{ 
		temp_buff[0]<<=1;
		temp = 0;
		while(!IRM_DQ)if(temp++>0x1000) goto return_main;//通过编码低电平
		temp = 0;
		while(IRM_DQ) if(temp++>0x1000) goto return_main;
		if(temp > 0x0080) temp_buff[0] |= 0x01;
	}

    /*校验字节*/
	for(i=0;i<8;i++)
	{ 
		temp_buff[1]<<=1;
		temp = 0;
		while(!IRM_DQ)if(temp++>0x1000) goto return_main;//通过编码低电平
		temp = 0;
		while(IRM_DQ) if(temp++>0x1000) goto return_main;
		if(temp > 0x0080) temp_buff[1] |= 0x01;
	}

    /*校验*/
	if (temp_buff[0] == ~temp_buff[1]) 
	{
		irm_code = temp_buff[0];
		BEEP_ON();
		delay_ms(100);
		BEEP_OFF();
	}	
	return_main:EA = 1;
}

#endif 	