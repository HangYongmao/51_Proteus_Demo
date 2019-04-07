#ifndef __DS18B20_H__
#define __DS18B20_H__

sbit DQ = P1^1;   //����ͨ�Ŷ˿� 
unsigned char flag_Negative_number = 0;//������־

//����22MHz  
void delay_18B20(unsigned int i)
{
 	while(i--);
}

//��ʼ������
Init_DS18B20(void) 
{
	 unsigned char x=0;
	 DQ = 1;          //DQ��λ
	 delay_18B20(4);  //������ʱ
	 DQ = 0;          //��Ƭ����DQ����
	 delay_18B20(100); //��ȷ��ʱ ���� 480us
	 DQ = 1;          //��������
	 delay_18B20(40);	 
}

//��һ���ֽ�  
ReadOneChar(void)
{
	unsigned char i=0;
	unsigned char dat = 0;
	for (i=8;i>0;i--)
	 {
		  DQ = 0; // �������ź�
		  dat>>=1;
		  DQ = 1; // �������ź�
		  if(DQ)
		  dat|=0x80;
		  delay_18B20(10);
	 }
 	return(dat);
}

//дһ���ֽ�  
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

//��ȡ�¶�
ReadTemperature(void)
{
	unsigned char a=0;
	unsigned char b=0;
	unsigned int t=0;
	//EA = 0;		 
	Init_DS18B20();
	WriteOneChar(0xCC); //����������кŵĲ���
	WriteOneChar(0xBE); //��ȡ�¶ȼĴ����ȣ����ɶ�9���Ĵ����� ǰ���������¶�
	a=ReadOneChar();
	b=ReadOneChar();

	//������һ���¶�ת��
	Init_DS18B20();
	WriteOneChar(0xCC); // ����������кŵĲ���
	WriteOneChar(0x44); // �����¶�ת��
		
	t=b;
	t<<=8;
	t=t|a;

	flag_Negative_number = 0;

	if(t>0x0fff) 
	{
		t=~t+1;
		flag_Negative_number = 0xff;
	}


	//18b20��t=d*0.0625	
	//t=t*6.25; //��Чλ��С�����2λ������Proteus6.9�汾��ʵ���
	t = t*5; //��Чλ��С�����2λ������Proteus7���ϰ汾
	//EA = 1;
	return(t);
}
#endif
