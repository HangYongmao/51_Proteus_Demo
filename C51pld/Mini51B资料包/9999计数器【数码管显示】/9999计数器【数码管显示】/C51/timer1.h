#ifndef _timer1_h_
#define _timer1_h_

//��ʱ��1��ʼ��,���ڲ����ʳ�ʼ��
//�Զ�ISP����ģ��
void timer1_init(void)
{
 //��ʱ��1������ģʽ2��8Bit�Զ���װ��ģʽ
 TMOD = (TMOD & 0X0F) | 0X20;  
 SCON = 0x50;
 PCON |= 0x80;//�����ʷ���
 TH1 = 0xff;
 TL1 = 0xff; 
 TR1 =1;
 ES = 1;
 EA = 1; 
}

void delay(unsigned int time)
{
	while(--time);
}

//�Զ�ISP���ܺ���
void ISP_Check(unsigned char tmp)
{
    static isp_counter=0;
    unsigned char code isp_comm[16]={0x12,0x34,0x56,0x78,0x90,0xab,0xcd,0xef,0x12,0x34,0x56,0x78,0x90,0xab,0xcd,0xef};
    if(tmp != isp_comm[isp_counter++]) {
    	isp_counter = 0;  
    	return;
    }
    else if (isp_counter > 15) {
      EA = 0;
	  delay(10000);
      ISP_CONTR = 0x60; //��λ����ISP����ģʽ   
    }   
}

//���ڽ����ж�
void Serial_int(void) interrupt 4 using 1
{ 
    unsigned char tmp;
	unsigned char xdata *pbuf;
//	static unsigned int i = 0;

	pbuf = 0;
	if (RI) 
    {
      tmp = SBUF;
	  ISP_Check(tmp); 
 /*
	  if(riflag==0x7e)
	  {
	  	*(pbuf+i)=tmp;
		if((++i)>640) i=0 ;
	  }	  
*/
	  //USER������
      RI = 0;
    }
}

#endif 