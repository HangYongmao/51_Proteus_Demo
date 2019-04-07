#include <reg51.h>
#include <intrins.h>

#define HIGH 1
#define LOW 0
#define FALSE 0
#define TRUE ~FALSE
#define uchar unsigned char

sbit SCL = P0^4;
sbit SDA = P0^3;

//��ʱ����
void delay(void)
{
	_nop_();
	_nop_();
	_nop_();
	_nop_();
}

//�ṩI2C���߹���ʱ���е���ʼλ
void I_start(void)
{
	SDA = HIGH;
	delay();
	SCL = HIGH;
	delay();
	SDA = LOW;//��SCLΪ��ʱ��SDA��һ���½�����Ϊ��ʼλ
	delay();
	SCL = LOW;
	delay();
}
//�ṩI2C���߹���ʱ���е�ֹͣλ
void I_stop(void)
{
	SDA = LOW;
	delay();
	SCL = HIGH;
	delay();
	SDA = HIGH;//��SCLΪ��ʱ��SDA��һ����������Ϊֹͣλ
	delay();
	SCL = LOW;
	delay();
}
//I2C���߳�ʼ��
void I_init(void)
{
	SCL = LOW;
	I_stop();
}
//�ṩI2C���ߵ�ʱ���źţ�������ʱ�ӵ�ƽΪ���ڼ�SDA�ź�����״̬
bit I_clock(void)
{
	bit sample;
	SCL = HIGH;
	delay();
	sample = SDA;
	SCL = LOW;
	delay();
	return (sample);
}
//��I2C���߷���8λ���ݣ�������һ��Ӧ���ź�ACK������յ�ACKӦ���򷵻�1�����򷵻�0��
bit I_send(uchar I_data)
{
	register uchar i;
	/*����8λ����*/
	for(i=0;i<8;i++)
	{
		SDA = (bit)(I_data & 0x80);
		I_data <<= 1;
		I_clock();
	}
	/*����Ӧ���ź�ACK*/
	SDA = HIGH;
	delay();
	return(~I_clock());
}
//��I2C�����Ͻ���8λ�����źţ��������յ���8λ������Ϊһ���ֽڷ��أ�������Ӧ���źš�
//�������ڵ��ñ�����֮ǰӦ��֤SDA�ź��ߴ��ڸ���״̬��SDA��1.
uchar I_receive(void)
{
	uchar I_data = 0;
	register uchar i;
	for(i=0;i<8;i++)
	{
		I_data*=2;
		if(I_clock())I_data++;
	}
	return (I_data);
}
//��I2C���߷���һ��Ӧ���ź�ACK��һ�������������ݶ�ȡʱ
void I_Ack(void)
{
	SDA = LOW;
	I_clock();
	SDA = HIGH;
}

