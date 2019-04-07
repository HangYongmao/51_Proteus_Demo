    sbit  ADclk=P2^6;
    sbit  ADcs=P2^5;
    sbit  ADdo=P2^7;
	uchar bdata ADCtemp,ADCtemp1;
	sbit ADCtemp_0 = ADCtemp^0;
	sbit ADCtemp1_7 = ADCtemp1^7;
#ifndef __adc0832_H__
#define __adc0832_H__ 
void adcck(void) 
{ 
	ADclk=1; 
	delay(1); 
	ADclk=0; 
	delay(1); 
}  
bit ADC0832()    
{	
    uchar i;
	ADdo=1;
	delay(1);
	ADcs=0;			      //开始转换
	adcck();
	ADdo=1;				  //通道选择 CH0
	adcck();
	ADdo=0;
	adcck();
	ADdo=1;
	delay(1);
    for(i=8;i>0;i--)	  //接收高8位
    { 	  
	  ADCtemp <<= 1;	  
	  ADCtemp_0=ADdo;	  
	  adcck();  	  	  	  
	 }
		 
	for (i=8;i>0;i--)
	{	 
	  ADCtemp1_7=ADdo;	  //接收低8位
	  ADCtemp1>>=1;	  
	  adcck();
	 }
	if (ADCtemp==ADCtemp1)
	     i=1; 	
   	ADcs=1;
	ADclk=0;
	return i;
}
#endif