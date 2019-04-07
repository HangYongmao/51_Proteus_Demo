/*--------------------------------------------------------------------------
AT89X51.H

Header file for the low voltage Flash Atmel AT89C51 and AT89LV51.
Copyright (c) 1988-2002 Keil Elektronik GmbH and Keil Software, Inc.
All rights reserved.
--------------------------------------------------------------------------*/

#ifndef __AT89X51_H__
#define __AT89X51_H__

/*------------------------------------------------
Byte Registers
------------------------------------------------*/
sfr P0      = 0x80;
sfr SP      = 0x81;
sfr DPL     = 0x82;
sfr DPH     = 0x83;
sfr PCON    = 0x87;
sfr TCON    = 0x88;
sfr TMOD    = 0x89;
sfr TL0     = 0x8A;
sfr TL1     = 0x8B;
sfr TH0     = 0x8C;
sfr TH1     = 0x8D;
sfr P1      = 0x90;
sfr SCON    = 0x98;
sfr SBUF    = 0x99;
sfr P2      = 0xA0;
sfr IE      = 0xA8;
sfr P3      = 0xB0;
sfr IP      = 0xB8;
sfr PSW     = 0xD0;
sfr ACC     = 0xE0;
sfr B       = 0xF0;

/*------------------------------------------------
P0 Bit Registers
------------------------------------------------*/
sbit P0_0 = 0x80;
sbit P0_1 = 0x81;
sbit P0_2 = 0x82;
sbit P0_3 = 0x83;
sbit P0_4 = 0x84;
sbit P0_5 = 0x85;
sbit P0_6 = 0x86;
sbit P0_7 = 0x87;

/*------------------------------------------------
PCON Bit Values
------------------------------------------------*/
#define IDL_    0x01

#define STOP_   0x02
#define PD_     0x02    /* Alternate definition */

#define GF0_    0x04
#define GF1_    0x08

#define SMOD_   0x80

/*------------------------------------------------
TCON Bit Registers
------------------------------------------------*/
sbit IT0  = 0x88;
sbit IE0  = 0x89;
sbit IT1  = 0x8A;
sbit IE1  = 0x8B;
sbit TR0  = 0x8C;
sbit TF0  = 0x8D;
sbit TR1  = 0x8E;
sbit TF1  = 0x8F;

/*------------------------------------------------
TMOD Bit Values
------------------------------------------------*/
#define T0_M0_   0x01
#define T0_M1_   0x02
#define T0_CT_   0x04
#define T0_GATE_ 0x08
#define T1_M0_   0x10
#define T1_M1_   0x20
#define T1_CT_   0x40
#define T1_GATE_ 0x80

#define T1_MASK_ 0xF0
#define T0_MASK_ 0x0F

/*------------------------------------------------
P1 Bit Registers
------------------------------------------------*/
sbit P1_0 = 0x90;
sbit P1_1 = 0x91;
sbit P1_2 = 0x92;
sbit P1_3 = 0x93;
sbit P1_4 = 0x94;
sbit P1_5 = 0x95;
sbit P1_6 = 0x96;
sbit P1_7 = 0x97;

/*------------------------------------------------
SCON Bit Registers
------------------------------------------------*/
sbit RI   = 0x98;
sbit TI   = 0x99;
sbit RB8  = 0x9A;
sbit TB8  = 0x9B;
sbit REN  = 0x9C;
sbit SM2  = 0x9D;
sbit SM1  = 0x9E;
sbit SM0  = 0x9F;

/*------------------------------------------------
P2 Bit Registers
------------------------------------------------*/
sbit P2_0 = 0xA0;
sbit P2_1 = 0xA1;
sbit P2_2 = 0xA2;
sbit P2_3 = 0xA3;
sbit P2_4 = 0xA4;
sbit P2_5 = 0xA5;
sbit P2_6 = 0xA6;
sbit P2_7 = 0xA7;

/*------------------------------------------------
IE Bit Registers
------------------------------------------------*/
sbit EX0  = 0xA8;       /* 1=Enable External interrupt 0 */
sbit ET0  = 0xA9;       /* 1=Enable Timer 0 interrupt */
sbit EX1  = 0xAA;       /* 1=Enable External interrupt 1 */
sbit ET1  = 0xAB;       /* 1=Enable Timer 1 interrupt */
sbit ES   = 0xAC;       /* 1=Enable Serial port interrupt */
sbit ET2  = 0xAD;       /* 1=Enable Timer 2 interrupt */

sbit EA   = 0xAF;       /* 0=Disable all interrupts */

/*------------------------------------------------
P3 Bit Registers (Mnemonics & Ports)
------------------------------------------------*/
sbit P3_0 = 0xB0;
sbit P3_1 = 0xB1;
sbit P3_2 = 0xB2;
sbit P3_3 = 0xB3;
sbit P3_4 = 0xB4;
sbit P3_5 = 0xB5;
sbit P3_6 = 0xB6;
sbit P3_7 = 0xB7;

sbit RXD  = 0xB0;       /* Serial data input */
sbit TXD  = 0xB1;       /* Serial data output */
sbit INT0 = 0xB2;       /* External interrupt 0 */
sbit INT1 = 0xB3;       /* External interrupt 1 */
sbit T0   = 0xB4;       /* Timer 0 external input */
sbit T1   = 0xB5;       /* Timer 1 external input */
sbit WR   = 0xB6;       /* External data memory write strobe */
sbit RD   = 0xB7;       /* External data memory read strobe */

/*------------------------------------------------
IP Bit Registers
------------------------------------------------*/
sbit PX0  = 0xB8;
sbit PT0  = 0xB9;
sbit PX1  = 0xBA;
sbit PT1  = 0xBB;
sbit PS   = 0xBC;
sbit PT2  = 0xBD;

/*------------------------------------------------
PSW Bit Registers
------------------------------------------------*/
sbit P    = 0xD0;
sbit FL   = 0xD1;
sbit OV   = 0xD2;
sbit RS0  = 0xD3;
sbit RS1  = 0xD4;
sbit F0   = 0xD5;
sbit AC   = 0xD6;
sbit CY   = 0xD7;

/*------------------------------------------------
Interrupt Vectors:
Interrupt Address = (Number * 8) + 3
------------------------------------------------*/
#define IE0_VECTOR	0  /* 0x03 External Interrupt 0 */
#define TF0_VECTOR	1  /* 0x0B Timer 0 */
#define IE1_VECTOR	2  /* 0x13 External Interrupt 1 */
#define TF1_VECTOR	3  /* 0x1B Timer 1 */
#define SIO_VECTOR	4  /* 0x23 Serial port */

#endif



