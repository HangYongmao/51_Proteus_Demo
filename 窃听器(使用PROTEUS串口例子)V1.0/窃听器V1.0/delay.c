////////////////////////////////////////////////////////////////////////////////
// ICC-AVR application builder : 2006-6-25 ���� 06:02:39
// Target : M8
// Crystal: 3.6864Mhz
// Author:  Anwarye
// Title:   Detcetaphone
////////////////////////////////////////////////////////////////////////////////

#include <iom8v.h>
#include <macros.h>
//#include "define.h"

extern volatile unsigned char          PhoneNum[12]; 


void DelayMs(unsigned int ms)
{
    unsigned int i;
    while(ms--)
	{
	    for(i=0;i<450;i++)   // 3.6864MHz  =  450  ,7.3728MHz = 900
	    {
	        asm("NOP");
		}
	}
}

void Write_EEPROM(unsigned char Data,unsigned int Address)
{
    if(EECR&0x20) DelayMs(8);
    EEARH=Address>>8;
    EEARL=Address&0x00ff;
    EEDR=Data;
    EECR=EECR|0x04;
    EECR=EECR|0x02;
    DelayMs(8);
}

unsigned char Read_EEPROM(unsigned int Address)
{
    unsigned char i;
	
    if(EECR&0x01) DelayMs(8);
    EEARH=Address>>8;
    EEARL=Address&0x00ff;
    EECR=EECR|0x01;
    DelayMs(10);
    i=EEDR;
    return(i);
}

void PhoneNum_to_EEPROM(void)
{
    unsigned char n,ch;
	for(n=0;n<12;n++)
	{
	    ch = PhoneNum[n];
	    Write_EEPROM(ch,n);
	}
}

void EEPROM_to_PhoneNum(void)
{
    unsigned char n,ch;
	for(n=0;n<12;n++)
	{
	    ch = Read_EEPROM(n);
	    PhoneNum[n] = ch;
	}
}

