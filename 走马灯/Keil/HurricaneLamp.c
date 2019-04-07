#include <REG52.H>

unsigned char RunMode;
//**********************************System Fuction*************************************************
void Delay1ms(unsigned int count)
{
	unsigned int i,j;
	for(i=0;i<count;i++)
	for(j=0;j<120;j++);
}

unsigned char code LEDDisplayCode[] = { 0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8,	//0~7
                          				0x80,0x90,0x88,0x83,0xC6,0xA1,0x86,0x8E,0xFF};

void Display(unsigned char Value)
{
	P3 = LEDDisplayCode[Value];
}

void LEDFlash(unsigned char Count)
{
	unsigned char i;
	bit Flag;
	for(i = 0; i<Count;i++)
	{
		Flag = !Flag;
		if(Flag)
			Display(RunMode);
		else
			Display(0x10);
		Delay1ms(100);
	}
	Display(RunMode);
}

unsigned char GetKey(void)
{
	unsigned char KeyTemp,CheckValue,Key = 0x00;
	CheckValue = P2&0x32;
	if(CheckValue==0x32)
		return 0x00;
	
	Delay1ms(10);
	KeyTemp = P2&0x32;
	if(KeyTemp==CheckValue)
		return 0x00;

	if(!(CheckValue&0x02))
		Key|=0x01;
	if(!(CheckValue&0x10))
		Key|=0x02;
	if(!(CheckValue&0x20))
		Key|=0x04;
	return Key;
}

unsigned int TimerCount,SystemSpeed,SystemSpeedIndex;
void InitialTimer2(void)
{
	T2CON  = 0x00;			//16 Bit Auto-Reload Mode
 	TH2 = RCAP2H = 0xFC;  	//重装值,初始值	TL2 = RCAP2L = 0x18;
	ET2=1;					//定时器 2 中断允许
	TR2 = 1;				//定时器 2 启动
	EA=1;
}

unsigned int code SpeedCode[]={   1,   2,   3,   5,   8,  10,  14,  17,  20,  30,
							     40,  50,  60,  70,  80,  90, 100, 120, 140, 160,
								180, 200, 300, 400, 500, 600, 700, 800, 900,1000};//30
void SetSpeed(unsigned char Speed)
{
	SystemSpeed =SpeedCode[Speed];
}

void LEDShow(unsigned int LEDStatus)
{
	P1 = ~(LEDStatus&0x00FF);
	P0 = ~((LEDStatus>>8)&0x00FF);
}

void InitialCPU(void)
{
	RunMode = 0x00;
	TimerCount = 0;
	SystemSpeedIndex = 10;

	P1 = 0x00;
	P0 = 0x00;
	P2 = 0xFF;
	P3 = 0x00;
	Delay1ms(500);
	P1 = 0xFF;
	P0 = 0xFF;
	P2 = 0xFF;
	P3 = 0xFF;
	SetSpeed(SystemSpeedIndex);
	Display(RunMode);
}

//Mode 0
unsigned int LEDIndex = 0;
bit LEDDirection = 1,LEDFlag = 1;
void Mode_0(void)
{
	LEDShow(0x0001<<LEDIndex);
	LEDIndex = (LEDIndex+1)%16;
}
//Mode 1
void Mode_1(void)
{
	LEDShow(0x8000>>LEDIndex);
	LEDIndex = (LEDIndex+1)%16;
}
//Mode 2
void Mode_2(void)
{
	if(LEDDirection)
		LEDShow(0x0001<<LEDIndex);
	else
		LEDShow(0x8000>>LEDIndex);
	if(LEDIndex==15)
		LEDDirection = !LEDDirection;
   LEDIndex = (LEDIndex+1)%16;
}
//Mode 3
void Mode_3(void)
{
	if(LEDDirection)
		LEDShow(~(0x0001<<LEDIndex));
	else
		LEDShow(~(0x8000>>LEDIndex));
	if(LEDIndex==15)
		LEDDirection = !LEDDirection;
   LEDIndex = (LEDIndex+1)%16;
}

//Mode 4
void Mode_4(void)
{
	if(LEDDirection)
	{
		if(LEDFlag)
			LEDShow(0xFFFE<<LEDIndex);
	   	else
			LEDShow(~(0x7FFF>>LEDIndex));
	}
	else
	{
		if(LEDFlag)
			LEDShow(0x7FFF>>LEDIndex);
		else
			LEDShow(~(0xFFFE<<LEDIndex));
	}
	if(LEDIndex==15)
	{
		LEDDirection = !LEDDirection;
		if(LEDDirection)	LEDFlag = !LEDFlag;
	}
   	LEDIndex = (LEDIndex+1)%16;
}

//Mode 5
void Mode_5(void)
{
	if(LEDDirection)
		LEDShow(0x000F<<LEDIndex);
	else
		LEDShow(0xF000>>LEDIndex);
	if(LEDIndex==15)
		LEDDirection = !LEDDirection;
    LEDIndex = (LEDIndex+1)%16;
}

//Mode 6
void Mode_6(void)
{
	if(LEDDirection)
		LEDShow(~(0x000F<<LEDIndex));
	else
		LEDShow(~(0xF000>>LEDIndex));
	if(LEDIndex==15)
		LEDDirection = !LEDDirection;
   	LEDIndex = (LEDIndex+1)%16;
}

//Mode 7
void Mode_7(void)
{
	if(LEDDirection)
		LEDShow(0x003F<<LEDIndex);
	else
		LEDShow(0xFC00>>LEDIndex);
	if(LEDIndex==9)
		LEDDirection = !LEDDirection;
    LEDIndex = (LEDIndex+1)%10;
}

//Mode 8
void Mode_8(void)
{
	LEDShow(++LEDIndex);
}

void TimerEventRun(void)
{
	if(RunMode==0x00)
	{
		Mode_0();	
	}
	else if(RunMode ==0x01)
	{
		Mode_1();
	}
	else if(RunMode ==0x02)
	{
		Mode_2();
	}
	else if(RunMode ==0x03)
	{
		Mode_3();
	}
	else if(RunMode ==0x04)
	{
		Mode_4();
	}
	else if(RunMode ==0x05)
	{
		Mode_5();
	}
	else if(RunMode ==0x06)
	{
		Mode_6();
	}
	else if(RunMode ==0x07)
	{
		Mode_7();
	}
	else if(RunMode ==0x08)
	{
		Mode_8();
	}
}

void Timer2(void) interrupt 5 using 3
{
	TF2 = 0; 	//中断标志清除( Timer2 必须软件清标志!)
	if(++TimerCount>=SystemSpeed)
	{
		TimerCount = 0;
		TimerEventRun();
   	}
}
unsigned char MusicIndex = 0;
void KeyDispose(unsigned char Key)
{
	if(Key&0x01)
	{
		LEDDirection = 1;
		LEDIndex = 0;
		LEDFlag = 1;
		RunMode = (RunMode+1)%9;
		Display(RunMode);
	}
	if(Key&0x02)
	{
		if(SystemSpeedIndex>0)
		{
			--SystemSpeedIndex;
			SetSpeed(SystemSpeedIndex);
		}
		else
		{
			LEDFlash(6);
		}
	}
	if(Key&0x04)
	{
		if(SystemSpeedIndex<28)
		{
			++SystemSpeedIndex;
			SetSpeed(SystemSpeedIndex);
		}
		else
		{
			LEDFlash(6);
		}
	}	
}

//***********************************************************************************
main()
{
	unsigned char Key;
	InitialCPU();
	InitialTimer2();

	while(1)
	{
		Key = GetKey();
		if(Key!=0x00)
		{
			KeyDispose(Key);
		}
	}
}