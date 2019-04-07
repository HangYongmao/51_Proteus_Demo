////////////////////////////////////////////////////////////////////////////////
// ICC-AVR application builder : 2006-6-25 ���� 06:02:39
// Target : M8
// Crystal: 3.6864Mhz
// Author:  Anwarye
// Title:   Detcetaphone
////////////////////////////////////////////////////////////////////////////////

#include <iom8v.h>
#include <macros.h>
#include "var.h"

#define XTAL == 3.6864M

////////////////////////////////////////////////////////////////////////////////
#pragma interrupt_handler uart0_rx_isr:12
void uart0_rx_isr(void)
{
    unsigned char i,j;
    if(UDR == 0x0A)
    { 
       return;		 // �յ�0x0Aֱ�Ӷ���
    }
	
	i = RxIndex;
	j = RxIndex-1;
    if((RxBuf[0] == 0x30) && (RxBuf[1] == 0x0D))
    {
        RxIndexTail = RxIndex;              // ������ջ���ָ��β
        RxIndex = 0;	  		 			// ���ջ���ָ�����
	    RxStatus = 1;						// ������ɱ�־��λ
		OkFlag = 1;
		error = 0;
		return; 
	}
    if((RxBuf[0] == 0x32) && (RxBuf[1] == 0x0D))  // �յ������źţ������־��λ
    {
        CallInFlag = 1;	                    // �õ绰�����־
	    RxIndex = 0;
		RxStatus = 1;
		OkFlag = 1;
		return;  
    }
    else if((RxBuf[0] == 0x33) && (RxBuf[1] == 0x0D))  // ���к���æ ���߹һ� ���йһ�
    {
        BusyFlag = 1;	                               // �õ绰�����־
	    RxIndex = 0;
		RxStatus = 1;
		OkFlag = 1;
		return;  
    }      
    else if((RxBuf[0] == 0x37) && (RxBuf[1] == 0x0D))  // �յ������źţ������־��λ
    {
        NoCarrierFlag = 1;	                           // �õ绰�����־  NO CARRIER
	    RxIndex = 0;
		RxStatus = 1;
		OkFlag = 1;
		return;
    }
    else if((RxBuf[0] == 0x34) && (RxBuf[1] == 0x0D))  // �յ������źţ������־��λ
    {
	    RxIndex = 0;
		RxStatus = 1;
		OkFlag = 1;
		error = 1;
		return;	
	}
	else 
    {
    
    RxBuf[RxIndex++] = UDR;                 // �����������ݷ�����ջ���
	RxStatus = 0;                         // ���ڽ�����
//	return;		  		  	   		      // �������գ�ֱ������
	}
}

////////////////////////////////////////////////////////////////////////////////
#pragma interrupt_handler uart0_tx_isr:14
void uart0_tx_isr(void)
{
    
    if(!TxStatus)                                   // ��֡����δ���꣬���������  
	{
	    //while ( !(UCSRA & (1<<UDRE)) );             // �ȴ�UDR��
	    UDR = TxBuf[TxIndex];		
	}
	if((TxBuf[TxIndex] == 0x0D) || (TxBuf[TxIndex] == 0x1A))  // ��֡���ݷ��ͽ���
	{
		TxStatus = 1;                          // �������״̬��־��λ
		TxIndex = 0;                           // ���ͻ�����ָ�����
		UCSRB &= ~((1<<TXCIE));//|(1<<TXEN));  // �ط����ж�
		return;
	}
	TxIndex++;                              
}
unsigned char CheckRx(void)
{
    unsigned char i,j;
	i = RxIndex;
	j = RxIndex - 1;
    if(( RxBuf[j] == 0x30) && (RxBuf[i] == 0x0D))
	{
	    RxIndex = 0;
		return (1);
	}
	else
	{
	    return (0);
	}
}
/*-----------------------------------------------------------------------*/
///////////////////////////  ������ջ���  ////////////////////////////////
/*-----------------------------------------------------------------------*/
void ClearRxBuf(void)
{
    unsigned char i;
	for(i=0;i<128;i++)
	{
	    RxBuf[i] = 0;
	}
}
/*-----------------------------------------------------------------------*/
///////////////////////////  ���ڷ���ʹ��  ////////////////////////////////
/*-----------------------------------------------------------------------*/
void TxEnable(void)
{
    //RxIndex = 0;
    UDR = TxBuf[0];                            // ���ͻ���ͷ���봮�ڷ��ͼĴ��������ʼ����
	UCSRB |= ((1<<TXCIE));//|(1<<TXEN));
}
/*-----------------------------------------------------------------------*/
/////////////////////////////  ����AT���� /////////////////////////////////
/*-----------------------------------------------------------------------*/
void Put_AT_command(const unsigned char *atc, unsigned char atlen)
{
    unsigned char count;
	
	for(count = 0;count < atlen;count++)      // AT��������뷢�ͻ���
	{
	    TxBuf[count] = atc[count];
	}
	
	TxBuf[atlen] = 0x0D;                      // ���ͻ���ܽ�β�ӡ��س���
	TxBuf[atlen + 1] = 0x00;                  // ���ͻ���ܽ�������

	OkFlag = 0;
    TxStatus = 0;
	TxIndex = 1;                              // ����ָ��ƫ��1
	TxEnable();                               // �����
    while(!TxStatus);                         // �ȴ����ͽ���,���ͻ���ָ��Ϊ������Է���
	DelayMs(20);
	while(!OkFlag);                           // �յ�ģ�鷵��OK,�������
	OkFlag = 0;

}

/*-----------------------------------------------------------------------*/
/////////////////////////  ���ڴ淢��AT���  ////////////////////////////
/*-----------------------------------------------------------------------*/
void Put_AT_String(unsigned char *atc, unsigned char atlen)
{
    unsigned char count;
		
	for(count = 0;count < atlen;count++)
	{
	    TxBuf[count] = *(atc+count);
	}
	
	TxBuf[atlen] = 0x0D;                      // ���ͻ���ܽ�β�ӡ��س���
	TxBuf[atlen + 1] = 0x00;                  // ���ͻ���ܽ�������

    OkFlag = 0;
    TxStatus = 0;
	TxIndex = 1;                              // ����ָ��ƫ��1
	TxEnable();                               // �����
    while(!TxStatus);                         // �ȴ����ͽ���,���ͻ���ָ��Ϊ������Է���
	DelayMs(20);
	while(!OkFlag);                           // �յ�ģ�鷵��OK,�������
	OkFlag = 0;
}
/*-----------------------------------------------------------------------*/
/////////////////////////  �򴮿ڷ���һ������  ////////////////////////////
/*-----------------------------------------------------------------------*/
void PutString(unsigned char *str, unsigned char length,unsigned char retflag)
{
    unsigned char count;

	for(count = 0;count < length;count++)
	{
	    TxBuf[count] = *(str+count);
	}
	
	TxBuf[length] = 0x0D;                     // ���ͻ���ܽ�β�ӡ��س���
	TxBuf[length+ 1] = 0x00;                  // ���ͻ���ܽ�������
	
    TxStatus = 0;
	TxIndex = 1;                              // ����ָ��ƫ��1
	OkFlag = 0;
	TxEnable();
	                                          // �����
    while(!TxStatus);                         // �ȴ����ͽ���,���ͻ���ָ��Ϊ������Է���
	DelayMs(20);
    if(retflag)
    {	
        while(!OkFlag);                       // �յ�ģ�鷵��OK,�������
		OkFlag = 0;
	}
	else
	{
        DelayMs(200);
		OkFlag = 0;
	}
}
////////////////////////////////////////////////////////////////////////////////

/*-----------------------------------------------------------------------*/
//////////////////////////         ����         ///////////////////////////
/*-----------------------------------------------------------------------*/
void DialNum(void)
{
    unsigned char i,count=0,length=0;

	while ((PhoneNum[count++] != 0))                  // ����绰���볤��
	{
	    length++;
	}
	
	TxBuf[0] = 'A';
	TxBuf[1] = 'T';
	TxBuf[2] = 'D';
	
	i = 3;
    for(count=0;count<length;count++)
	{
	    TxBuf[i++] = PhoneNum[count];
	}
    
	TxBuf[length+3] = ';';
	TxBuf[length+4] = 0x0D;
	
    OkFlag = 0;
    TxStatus = 0;
	TxIndex = 1;                              // ����ָ��ƫ��1
	TxEnable();                               // �����
    while(!TxStatus);                         // �ȴ����ͽ���,���ͻ���ָ��Ϊ������Է���
	DelayMs(20);
	//while(!OkFlag);                           // �յ�ģ�鷵��OK,�������	
    OkFlag = 0;
} 

/*-----------------------------------------------------------------------*/
/////////////////////////////  �Ƚ������� /////////////////////////////////
/*-----------------------------------------------------------------------*/
unsigned char StringCompare(volatile unsigned char *str1,const unsigned char *str2,unsigned char strlen)
{
    while(strlen--)
	{
	    if(*str1++ != *str2++) return(FALSE);    // ����������ȷ��ؼ�
	}
	return(TRUE);
}

/*-----------------------------------------------------------------------*/
/////////////////////////////    ɾ������    //////////////////////////////
/*-----------------------------------------------------------------------*/
void Delete_SMS(unsigned char num)     // ɾ��SMS��=0ɾ������SMS
{
    unsigned char count;

	for(count = 0;count < AtcmgdLen;count++)      // AT��������뷢�ͻ���
	{
	    TmpBuf[count] = Atcmgd[count];
	}
		
	if(num == ALL)
	{
	   for(count = 1; count < 10; count++)
	   {
	       TmpBuf[AtcmgdLen] = count + 0x30;
	       Put_AT_String((unsigned char*)TmpBuf,(AtcmgdLen+1));

		}
	   TmpBuf[AtcmgdLen] = 0x31;
       for(count = 0; count < 10; count++)
	   {
	       TmpBuf[AtcmgdLen+1] = count + 0x30;
	       Put_AT_String((unsigned char*)TmpBuf,(AtcmgdLen+2));

	    }

	}
	else
	{
	    TmpBuf[AtcmgdLen] = num + 0x30;
	    Put_AT_String((unsigned char*)TmpBuf,(AtcmgdLen+1));

	}
}

/*-----------------------------------------------------------------------*/
///////////////////////////  ���SMS����  //////////////////////////////
/*-----------------------------------------------------------------------*/
unsigned char CheckSMS_in(void)
{
	while(!RxStatus);                            // �ȴ��������
	DelayMs(100);

	if(StringCompare(RxBuf,SMSin,SMSinLen))      // ����յ�OK���    +CMTI: "SM", 1
	{
		return (OK);
	}
	else
	{
	    return (ERROR);
	}

}
/*-----------------------------------------------------------------------*/
///////////////              �����ú�������ڴ�           /////////////////
/*-----------------------------------------------------------------------*/
void CheckSMS(void)
{
    unsigned char i=0,j=0,index,numlen=0;
	for(;i<12;i++)
	{
	    PhoneNum[i] = 0;
	}
/*    do
	{
	    i++;
		j=i+1;
	}
	//while((Pdu[i] == 'G') && (Pdu[j] == 'H'));
	
	index = j+1;
	i = index;
	while(Pdu[i++] == '+')numlen++;
	
	j = 79; */
	
	index = 79;
	for(i=0;i<11;i++)
	{
	    PhoneNum[i] = Pdu[index++];
		PhoneNum_to_EEPROM();
    }
	
}	
unsigned char CheckPhoneNum(void)
{
    unsigned char i;
	for(i=0;i<12;i++)
	{
	    if( PhoneNum != 0) return (FALSE);
	}
	return (TRUE);
}
/*-----------------------------------------------------------------------*/
//////////////////////////    ���մ������Ϣ    ///////////////////////////
/*-----------------------------------------------------------------------*/
void RecSMS(void)
{
    unsigned char count,i=0,j=0,x,y;
	
    Put_AT_String("AT+CMGR=1",9);
	
    while(RxBuf[i] != 0x0D)
	{
	    i++;
	}
	i = 76;
	j = i;
	if((RxBuf[i] == 'G') && (RxBuf[j+1] == 'H'))
    {	
        count = 0;
	    while(1)
	    {
	        Pdu[count] = RxBuf[count];
			x = count;
			y = count;
		    if((RxBuf[x-2] == 0x30) && (RxBuf[y-1] == 0x0D)) 
		    {
		    break;
	        }
		    count++;
	    }
		CheckSMS();
		Delete_SMS(1);
		
    }
	else 
	{
	    Delete_SMS(1);
	}
}

unsigned char DetQEITING(void)
{
    volatile unsigned char tmp;
	
    if(!(DetQT()))
    {
	    release = 0;
	    DelayMs(10);
		
		if(!(DetQT())) {DettqFlag = 1;}
    }
	else 
	{
	    release = 1;
	}
			
	if(release && DettqFlag)
	{
	    DettqFlag = 0;
		CplLED();

		return (TRUE);
		
	}
	return (FALSE);
}

void IGT(unsigned char n)
{
    if(n)
	{
	    PORTD &= ~(1<<PD6);
		DDRD |= (1<<PD6);
	}
	else
	{
	    DDRD &= ~(1<<PD6);
	}
}
			
void work(void)
{
    while(1)
	{
	    if(CheckSMS_in())
		{
		    RecSMS();
	    }
		if(CallInFlag) 
		{
		    Put_AT_command(Ata,AtaLen);
		    CallInFlag = 0;
		}
		if((BusyFlag) || (NoCarrierFlag))  
		{
		    Put_AT_command(Ath,AthLen);
			CallOut = 0;
			BusyFlag = 0;
			NoCarrierFlag = 0;
		}
		if(DetQEITING() && (!CallOut))
		{
		    CallOut = 1;
		    DialNum();
		}
	}
}
/*-----------------------------------------------------------------------*/
/////////////////////////////  ��ʼ��MC55    //////////////////////////////
/*-----------------------------------------------------------------------*/
void InitMC55(void)
{
 	unsigned char tmp;
    IGT(OFF);                                   
    DelayMs(500);  	   			   			  // �õ�MC55 IGT�� 200mS ������MC55ģ��
	IGT(ON);
    DelayMs(500);
    IGT(OFF);                                   


//	DelayMs(1000);                             // �ȴ�ģ������
	

	ClrRTS();
    DelayMs(50);                              // ����MC55����
	SetRTS();
	DelayMs(50);
	ClrRTS();
    DelayMs(50);                              // ����MC55����
	SetRTS();

//	DelayMs(1000);                              // ����MC55����
		
    TxIndex = 0;
    RxIndex = 0;
	
	while(!DetQEITING());
	
	PutString("AT",2,0);

	DelayMs(500);      
  
	PutString("AT",2,1);
	
	PutString("ATV0",4,1);

	PutString("ATE0",4,1);

	PutString("AT+CNMI=2,1",11,1);

	PutString("AT+CMGF=1",9,1);

	Delete_SMS(ALL);
	
	PhoneNum_to_EEPROM();
	
	EEPROM_to_PhoneNum();

}

/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////

/*
#pragma interrupt_handler int0_isr:2
void int0_isr(void)
{
 //external interupt on INT0
 DialNum();
 
}

#pragma interrupt_handler int1_isr:3
void int1_isr(void)
{
 //external interupt on INT1
}
*/
////////////////////////////////////////////////////////////////////////////////

void port_init(void)
{
 PORTB = 0x01;
 DDRB  = 0x01;
 PORTC = 0x00; //m103 output only
 DDRC  = 0x02;
 PORTD = 0x0C;
 DDRD  = 0x50;
}

//UART0 initialize
// desired baud rate: 19200
// actual: baud rate:19200 (0.0%)
// char size: 8 bit
// parity: Disabled
//#ifdef XTAL == 3.6864
 
void uart0_init(void)
{
 UCSRB = 0x00; //disable while setting baud rate
 UCSRA = 0x00;
 UCSRC = BIT(URSEL) | 0x06;
 UBRRL = 0x0B; //set baud rate lo
 UBRRH = 0x00; //set baud rate hi
 UCSRB = 0xD8;
}
//#endif

//#ifdef XTAL == 7.3728
/*void uart0_init(void)
{
 UCSRB = 0x00; //disable while setting baud rate
 UCSRA = 0x00;
 UCSRC = BIT(URSEL) | 0x06;
 UBRRL = 0x17; //set baud rate lo
 UBRRH = 0x00; //set baud rate hi
 UCSRB = 0xD8;
}*/
//#endif

//call this routine to initialize all peripherals
void init_devices(void)
{
 //stop errant interrupts until set up
 CLI(); //disable all interrupts
 port_init();
 uart0_init();

 MCUCR = 0x00;
 GICR  = 0x00; //0xC0;
 TIMSK = 0x00; //timer interrupt sources
 SEI(); //re-enable interrupts
 
 InitMC55();
}



//
void main(void)
{
DelayMs(1000); 
 init_devices();
 work();
/* 
while(1)
 {
    DetQEITING();
 }*/

}

