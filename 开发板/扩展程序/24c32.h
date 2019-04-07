
#ifndef __24c32_H__
#define __24c32_H__

#define R24C  0xa1
#define W24C  0xa0


/***********************************************************************************/
bit   W24C32(uchar Address,uchar idata *W24Ctemp,uchar QuantityByte)
{
   uchar w;
   bit  errorflag=0;			//0表示此次操作失效     
   IICStart();   
   if( IICSendByte(W24C) )
   {
      // IICSendByte((unsigned char)(Address>>8));		  //发高8位地址
      // IICRecAck();
     if(IICSendByte(Address))			  //发低8位地址
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
	if(IICSendByte(W24C))		     /*发送器件地址*/
    {
	   if(IICSendByte(Address))	 /*发送器件子地址*/		
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
