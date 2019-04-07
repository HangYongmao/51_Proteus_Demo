//*************************************************************************************************
//*																								  *
//*			 ******************************¼üÂë´¦Àí³ÌÐò**************************				  *
//*																								  *
//*************************************************************************************************

#include "SMC1602.h"

void vKeyProcess(unsigned char ucKeyCode)
{
	vWriteCMD(0xC7);	

	switch(ucKeyCode)
		{
		case 11:vShowOneChar('7');break;							  //'7'
		case 12:vShowOneChar('8');break;							  //'8'
		case 13:vShowOneChar('9');break;							  //'9'
		case 21:vShowOneChar('4');break;							  //'4'
		case 22:vShowOneChar('5');break;							  //'5'
		case 23:vShowOneChar('6');break;							  //'6'
		case 31:vShowOneChar('1');break;							  //'1'
		case 32:vShowOneChar('2');break;							  //'2'
		case 33:vShowOneChar('3');break;							  //'3'
		case 42:vShowOneChar('0');break;							  //'0'

		case 14:vShowOneChar('/');break;							  //'/'
		case 24:vShowOneChar('*');break;							  //'*'
		case 34:vShowOneChar('-');break;							  //'-'
		case 44:vShowOneChar('+');break;							  //'+'
							  
		case 43:vShowOneChar('=');break;							  //'='

		case 41:vShowOneChar('C');break;							  //'ON/C'

		default:break;
		}
}