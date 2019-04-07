
#ifndef __24c32_H__
#define __24c32_H__

#define R24C  0xa1
#define W24C  0xa0


/***********************************************************************************/
bit   W24C32(uchar Address,uchar idata *W24Ctemp,uchar QuantityByte)
{
   uchar w;
   bit  errorflag=0;			//0��ʾ�˴β���ʧЧ     
   IICStart();   
   if( IICSendByte(W24C) )
   {
      // IICSendByte((unsigned char)(Address>>8));		  //����8λ��ַ
      // IICRecAck();
     if(IICSendByte(Address))			  //����8λ��ַ
      {   
		  for (w=QuantityByte;w>0;w--)
		  {
			  IICSendByte(*W24Ctemp);
              W24Ctemp++; 			      
		  }                       
      }
     errorflag=1;               //********clr errorflag; 
	}
  IICStop();  
  return(errorflag);
}
void R24C32(uchar Address,uchar idata *R24Ctemp,uchar QuantityByte )
{
	uchar i;	
	IICStart();
	if(IICSendByte(W24C))		     /*����������ַ*/
    {
	   if(IICSendByte(Address))	 /*���������ӵ�ַ*/		
	   {		
	      IICStart();
	      IICSendByte(R24C);
	      for (i=QuantityByte-1;i>0;i--)
	      {  
	         *R24Ctemp=IICReceiveByte();
	         //delay1();
	         IICAck();
	         R24Ctemp++;			
		  }
	   }	  	   
	}
  *R24Ctemp=IICReceiveByte();   	
  IICNoAck();
  IICStop();  
}
#endif
