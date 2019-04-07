#ifndef __pca9555_H__
#define __pca9555_H__

#define W9555 	        0x42					  //9555Ð´
#define R9555 		    0x43					  //9555¶Á
#define Cmd_ip0  	    0x00
#define Cmd_ip1  	    0x01
#define Cmd_op0  	    0x02
#define Cmd_op1  	    0x03
#define Cmd_polarity0  	0x04
#define Cmd_polarity1  	0x05
#define Cmd_cfg0     	0x06
#define Cmd_cfg1  	    0x07

/*-----------Ð´pca9555Êä³ö¼Ä´æÆ÷---------------*/
void W9555output(uchar input1,uchar input2)
{
	IICStart();
	IICSendByte(W9555);
	IICSendByte(Cmd_op0);
	IICSendByte(input1);
	IICSendByte(input2);
	IICStop();
}
/*------------Ð´pca9555ÅäÖÃ¼Ä´æÆ÷------------*/
void W9555cfg(uchar input1,uchar input2)
{
	IICStart();
	IICSendByte(W9555);
	IICSendByte(Cmd_cfg0);
	IICSendByte(input1);
	IICSendByte(input2);
	IICStop();
}
void pca9555_init(void)
{
	 W9555cfg(0x00,0x00);     //ÉèÖÃI/O×´Ì¬
	 W9555output(0x00,0x00);  //
}
void Opt9555(uchar cmd,uchar data_1) 		
{
    pca9555_init();
	IICStart();
	IICSendByte(W9555);
	IICSendByte(cmd);	
    IICSendByte(data_1);	
	IICStart();
}
/*
void Ipt9555(uchar idata *i9555temp)
{	
    
    pca9555_init();
	IICStart();
	IICSendByte(W9555);
	IICSendByte(Cmd_ip0);
	IICStart();
	IICSendByte(R9555);
	*i9555temp=IICReceiveByte();
	IICAck();
	i9555temp++;
	*i9555temp=IICReceiveByte();
	IICNoAck();
	
} */
//


#endif