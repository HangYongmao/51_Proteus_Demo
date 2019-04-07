#ifndef __DS18B20_H__
#define __DS18B20_H__

sbit DQ = P1^1;   //定义通信端口 
unsigned char flag_Negative_number = 0;//负数标志

//晶振22MHz  
void delay_18B20(unsigned int i)
{
 	while(i--);
}

//初始化函数
Init_DS18B20(void) 
{
	 unsigned char x=0;
	 DQ = 1;          //DQ复位
	 delay_18B20(4);  //稍做延时
	 DQ = 0;          //单片机将DQ拉低
	 delay_18B20(100); //精确延时 大于 480us
	 DQ = 1;          //拉高总线
	 delay_18B20(40);	 
}

//读一个字节  
ReadOneChar(void)
{
	unsigned char i=0;
	unsigned char dat = 0;
	for (i=8;i>0;i--)
	 {
		  DQ = 0; // 给脉冲信号
		  dat>>=1;
		  DQ = 1; // 给脉冲信号
		  if(DQ)
		  dat|=0x80;
		  delay_18B20(10);
	 }
 	return(dat);
}

//写一个字节  
WriteOneChar(unsigned char dat)
{
 unsigned char i=0;
 for (i=8; i>0; i--)
 {
  DQ = 0;
  DQ = dat&0x01;
  delay_18B20(10);
  DQ = 1;
  dat>>=1;
 }
}

//读取温度
ReadTemperature(void)
{
	unsigned char a=0;
	unsigned char b=0;
	unsigned int t=0;
	//EA = 0;		 
	Init_DS18B20();
	WriteOneChar(0xCC); //跳过读序号列号的操作
	WriteOneChar(0xBE); //读取温度寄存器等（共可读9个寄存器） 前两个就是温度
	a=ReadOneChar();
	b=ReadOneChar();

	//启动下一次温度转换
	Init_DS18B20();
	WriteOneChar(0xCC); // 跳过读序号列号的操作
	WriteOneChar(0x44); // 启动温度转换
		
	t=b;
	t<<=8;
	t=t|a;

	flag_Negative_number = 0;

	if(t>0x0fff) 
	{
		t=~t+1;
		flag_Negative_number = 0xff;
	}


	//18b20：t=d*0.0625	
	//t=t*6.25; //有效位到小数点后2位，适用Proteus6.9版本和实物版
	t = t*5; //有效位到小数点后2位，适用Proteus7以上版本
	//EA = 1;
	return(t);
}
#endif
