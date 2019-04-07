
#ifndef __18b20_H__
#define __18b20_H__

sbit dq = P1^3;
bit  tmp_f; 
uchar tmp_buff[9]; 
uchar tmp;
uchar  tmpd;
/*------��ʼ��18B20-------*/
void init_18b20(void)
{
//  bit tmp_flag;
  dq=1;
  _nop_();
  dq=0;                      
  delay(100);				 // delay 530 us
  dq=1;
  delay(25);                 // delay  100 us
//  if(dq==0)
//    tmp_flag=1;                 // detect 18b20 success
//  else 
//    tmp_flag=0;                // detect 18b20 fail
  delay(20);
  dq=1;
}
/*-----д18B20,���ֽ�д��-------*/
void wr_18b20(uchar wr) 
{
  uchar i;
  for (i=0;i<8;i++)
  { 
    dq=0;
    _nop_();
    dq=wr&0x01; 
    delay(8);         //delay 45 us
    dq=1;
    wr>>=1;
  }
}
/*------�Ӷ�18b20,��1�ֽ�------*/
uchar re_byte_18b20(void)
{
  uchar i,u=0;
  for(i=0;i<8;i++)
  {  
    dq=0;
    u>>=1;
    dq=1;
    if(dq==1)
      u|=0x80;
    delay(10);
  }
  return(u);
}
/*-------��18B20�� J �ֽ�------*/
void re_bytes_18b20(uchar j)
{
  uchar i;
  for(i=0;i<j;i++)
  {
    tmp_buff[i]=re_byte_18b20();
    
  }
}
/*---------����18B20---------*/
void config_18b20(void)
{
   init_18b20();
   wr_18b20(0xcc);           //skip rom
   wr_18b20(0x4e);           //write scratchpad
   wr_18b20(0xfa);           //����
   wr_18b20(0x1a);           //����
   wr_18b20(0x7f);           //set 12 bit     
   init_18b20();
   wr_18b20(0xcc);           // skip rom 
   wr_18b20(0x48);           //�����趨ֵ
   init_18b20();
   wr_18b20(0xcc);           // skip rom
   wr_18b20(0xb8);           //�ص��趨ֵ
}

/*-------------��ȡ�¶�-------------*/
void get_tmp()
{
    uchar idata a=0,b=0,i;  	    		      
    init_18b20();
    wr_18b20(0xcc);			    // ���� ROM
    wr_18b20(0x44);				// �����¶�ת��		
    init_18b20();				
    wr_18b20(0xcc);				// ���� ROM
    wr_18b20(0xbe);        	    // ���ݴ���
    re_bytes_18b20(9);	
 	a=tmp_buff[0];
    b=tmp_buff[1];
 	
 	i=b;                           /*��iΪ1��Ϊ����   */
 	i=(i>>4);
 	if(i==0)
 	{
 		tmp_f=0;
 		tmp=((a>>4)|(b<<4));	
		tmpd=(tmp_buff[0]&0x0f)*10/16;
 	}
 	else 
 	{
 		tmp_f=1;				 		
 		tmp=~((a>>4)|(b<<4));  	    				
		tmpd=10-(tmp_buff[0]&0x0f)*10/16;
		if (tmpd==10) 
		  {
		   tmp+=1;
		   tmpd=0;
		  }			 
 	} 	
  	
}
/*-----------��ID��----------*/
/*void re_id_18b20(void)
{  
   init_18b20();
   wr_18b20(0x33);          // read rom	   
   re_bytes_18b20(8);
} */
#endif
