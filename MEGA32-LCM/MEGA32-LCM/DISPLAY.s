	.module DISPLAY.C
	.area text(rom, con, rel)
	.dbfile E:\PROTEU~1.7\User\MEGA32-LCM\MEGA32-LCM/delay.h
	.dbfunc e delay_1us _delay_1us fV
	.even
_delay_1us::
	.dbline -1
	.dbline 14
; /*
; KS0108 128*64 LCD C语言驱动
; LCD引脚定义
; 1---GND 
; 2---VCC
; 3---VLCD
; 4---D/I
; 5---R/W
; 6---E
; 7到14 D0-D7
; 15--CS1
; 16--CS2
; 17--RESET
; 18--VEE
	.dbline 15
; 19--SW
	nop
	.dbline -2
	.dbline 16
; 20--NC 
L1:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e delay_nus _delay_nus fV
;              i -> R20,R21
;              n -> R22,R23
	.even
_delay_nus::
	xcall push_gset2
	movw R22,R16
	.dbline -1
	.dbline 19
; */
; #include <iom32v.h>
; #include <macros.h>
	.dbline 20
; #include "delay.h"
	clr R20
	clr R21
	.dbline 21
; unsigned char CurOffset,CurRow,CurPage,CurCol;	
	xjmp L6
L3:
	.dbline 22
	xcall _delay_1us
L4:
	.dbline 21
	subi R20,255  ; offset = 1
	sbci R21,255
L6:
	.dbline 21
	cp R20,R22
	cpc R21,R23
	brlo L3
	.dbline -2
	.dbline 23
; #define uchar unsigned char
; /*  常量定义  */
L2:
	xcall pop_gset2
	.dbline 0 ; func end
	ret
	.dbsym r i 20 i
	.dbsym r n 22 i
	.dbend
	.dbfunc e delay_1ms _delay_1ms fV
;              i -> R16,R17
	.even
_delay_1ms::
	.dbline -1
	.dbline 26
; #define  LCD_STATUS_BUSY 0x80
; #define  START_LINE0   0xc0
; #define  DISPLAY_ON    0x3f
	.dbline 28
	clr R16
	clr R17
	xjmp L11
L8:
	.dbline 28
L9:
	.dbline 28
	subi R16,255  ; offset = 1
	sbci R17,255
L11:
	.dbline 28
; #define  DISPLAY_OFF   0x3e
; #define  PARA1         0x40
	cpi R16,116
	ldi R30,4
	cpc R17,R30
	brlo L8
	.dbline -2
	.dbline 29
; //#define  BIT(x)  (1<<x)
L7:
	.dbline 0 ; func end
	ret
	.dbsym r i 16 i
	.dbend
	.dbfunc e delay_nms _delay_nms fV
;              i -> R20,R21
;              n -> R22,R23
	.even
_delay_nms::
	xcall push_gset2
	movw R22,R16
	.dbline -1
	.dbline 32
; //PORTA---数据口  PORTB----控制口
; volatile unsigned char *LCD_DIR_PORT = &DDRA;
; volatile unsigned char *LCD_IP_PORT  = &PINA;
	.dbline 33
; volatile unsigned char *LCD_OP_PORT  = &PORTA;
	clr R20
	clr R21
	.dbline 34
; 
	xjmp L16
L13:
	.dbline 35
	.dbline 36
	xcall _delay_1ms
	.dbline 37
L14:
	.dbline 34
	subi R20,255  ; offset = 1
	sbci R21,255
L16:
	.dbline 34
	cp R20,R22
	cpc R21,R23
	brlo L13
	.dbline -2
	.dbline 38
; volatile unsigned char *LCD_EN_PORT  = &PORTB;
; volatile unsigned char *LCD_CS2_PORT = &PORTC;
; volatile unsigned char *LCD_CS1_PORT = &PORTC;
; volatile unsigned char *LCD_RW_PORT  = &PORTC;
L12:
	xcall pop_gset2
	.dbline 0 ; func end
	ret
	.dbsym r i 20 i
	.dbsym r n 22 i
	.dbend
	.area data(ram, con, rel)
	.dbfile E:\PROTEU~1.7\User\MEGA32-LCM\MEGA32-LCM/delay.h
_LCD_DIR_PORT::
	.blkb 2
	.area idata
	.word 58
	.area data(ram, con, rel)
	.dbfile E:\PROTEU~1.7\User\MEGA32-LCM\MEGA32-LCM/delay.h
	.dbfile E:\PROTEU~1.7\User\MEGA32-LCM\MEGA32-LCM\DISPLAY.C
	.dbsym e LCD_DIR_PORT _LCD_DIR_PORT pc
_LCD_IP_PORT::
	.blkb 2
	.area idata
	.word 57
	.area data(ram, con, rel)
	.dbfile E:\PROTEU~1.7\User\MEGA32-LCM\MEGA32-LCM\DISPLAY.C
	.dbsym e LCD_IP_PORT _LCD_IP_PORT pc
_LCD_OP_PORT::
	.blkb 2
	.area idata
	.word 59
	.area data(ram, con, rel)
	.dbfile E:\PROTEU~1.7\User\MEGA32-LCM\MEGA32-LCM\DISPLAY.C
	.dbsym e LCD_OP_PORT _LCD_OP_PORT pc
_LCD_EN_PORT::
	.blkb 2
	.area idata
	.word 56
	.area data(ram, con, rel)
	.dbfile E:\PROTEU~1.7\User\MEGA32-LCM\MEGA32-LCM\DISPLAY.C
	.dbsym e LCD_EN_PORT _LCD_EN_PORT pc
_LCD_CS2_PORT::
	.blkb 2
	.area idata
	.word 53
	.area data(ram, con, rel)
	.dbfile E:\PROTEU~1.7\User\MEGA32-LCM\MEGA32-LCM\DISPLAY.C
	.dbsym e LCD_CS2_PORT _LCD_CS2_PORT pc
_LCD_CS1_PORT::
	.blkb 2
	.area idata
	.word 53
	.area data(ram, con, rel)
	.dbfile E:\PROTEU~1.7\User\MEGA32-LCM\MEGA32-LCM\DISPLAY.C
	.dbsym e LCD_CS1_PORT _LCD_CS1_PORT pc
_LCD_RW_PORT::
	.blkb 2
	.area idata
	.word 53
	.area data(ram, con, rel)
	.dbfile E:\PROTEU~1.7\User\MEGA32-LCM\MEGA32-LCM\DISPLAY.C
	.dbsym e LCD_RW_PORT _LCD_RW_PORT pc
_LCD_DI_PORT::
	.blkb 2
	.area idata
	.word 53
	.area data(ram, con, rel)
	.dbfile E:\PROTEU~1.7\User\MEGA32-LCM\MEGA32-LCM\DISPLAY.C
	.dbsym e LCD_DI_PORT _LCD_DI_PORT pc
_LCD_EN_BIT::
	.blkb 1
	.area idata
	.byte 16
	.area data(ram, con, rel)
	.dbfile E:\PROTEU~1.7\User\MEGA32-LCM\MEGA32-LCM\DISPLAY.C
	.dbsym e LCD_EN_BIT _LCD_EN_BIT c
_LCD_CS2_BIT::
	.blkb 1
	.area idata
	.byte 8
	.area data(ram, con, rel)
	.dbfile E:\PROTEU~1.7\User\MEGA32-LCM\MEGA32-LCM\DISPLAY.C
	.dbsym e LCD_CS2_BIT _LCD_CS2_BIT c
_LCD_CS1_BIT::
	.blkb 1
	.area idata
	.byte 4
	.area data(ram, con, rel)
	.dbfile E:\PROTEU~1.7\User\MEGA32-LCM\MEGA32-LCM\DISPLAY.C
	.dbsym e LCD_CS1_BIT _LCD_CS1_BIT c
_LCD_RW_BIT::
	.blkb 1
	.area idata
	.byte 32
	.area data(ram, con, rel)
	.dbfile E:\PROTEU~1.7\User\MEGA32-LCM\MEGA32-LCM\DISPLAY.C
	.dbsym e LCD_RW_BIT _LCD_RW_BIT c
_LCD_DI_BIT::
	.blkb 1
	.area idata
	.byte 16
	.area data(ram, con, rel)
	.dbfile E:\PROTEU~1.7\User\MEGA32-LCM\MEGA32-LCM\DISPLAY.C
	.dbsym e LCD_DI_BIT _LCD_DI_BIT c
	.area text(rom, con, rel)
	.dbfile E:\PROTEU~1.7\User\MEGA32-LCM\MEGA32-LCM\DISPLAY.C
	.dbfunc e LCD_BUSY _LCD_BUSY fV
;         status -> <dead>
;             lr -> R16
	.even
_LCD_BUSY::
	.dbline -1
	.dbline 68
; volatile unsigned char *LCD_DI_PORT  = &PORTC;
; 
; char LCD_EN_BIT  = BIT(4);
; char LCD_CS2_BIT = BIT(3);
; char LCD_CS1_BIT = BIT(2);
; char LCD_RW_BIT  = BIT(5);
; char LCD_DI_BIT  = BIT(4);
; 
; #define SET_LCD_E      	        *LCD_EN_PORT |= LCD_EN_BIT    //LCD使能
; #define CLEAR_LCD_E       	    *LCD_EN_PORT &= ~LCD_EN_BIT   //LCD禁止
; 
; #define SET_LCD_DATA      	    *LCD_DI_PORT |= LCD_DI_BIT    //选择指令端口
; #define SET_LCD_CMD       	    *LCD_DI_PORT &= ~LCD_DI_BIT   //选择数据端口
; 
; #define SET_LCD_READ      	    *LCD_RW_PORT |= LCD_RW_BIT    //读模式
; #define SET_LCD_WRITE      	    *LCD_RW_PORT &= ~LCD_RW_BIT   //写模式
; 
; #define SET_LCD_CS2      	    *LCD_CS2_PORT |= LCD_CS2_BIT  //左屏选择禁止
; #define CLEAR_LCD_CS2      	    *LCD_CS2_PORT &= ~LCD_CS2_BIT //左屏选择使能
; 
; #define SET_LCD_CS1      	    *LCD_CS1_PORT |= LCD_CS1_BIT  //左屏选择禁止
; #define CLEAR_LCD_CS1      	    *LCD_CS1_PORT &= ~LCD_CS1_BIT //左屏选择使能
; 
; #define LEFT 0
; #define RIGHT 1
; #define CMD 0
; #define DATA 1
; 
; void LCD_BUSY(unsigned char lr) //判断忙标志
; {
	.dbline 70
;     unsigned char status;
;     _CLI();
	cli
	.dbline 71
;     if(lr==LEFT)
	tst R16
	brne L18
	.dbline 72
;     {
	.dbline 73
;         CLEAR_LCD_CS2; //cs2=0
	lds R2,_LCD_CS2_BIT
	com R2
	lds R30,_LCD_CS2_PORT
	lds R31,_LCD_CS2_PORT+1
	ldd R3,z+0
	and R3,R2
	std z+0,R3
	.dbline 74
;         SET_LCD_CS1;   //cs1=1
	lds R2,_LCD_CS1_BIT
	lds R30,_LCD_CS1_PORT
	lds R31,_LCD_CS1_PORT+1
	ldd R3,z+0
	or R3,R2
	std z+0,R3
	.dbline 75
;     }
	xjmp L19
L18:
	.dbline 77
;     else
;     {
	.dbline 78
;         SET_LCD_CS2;   //cs2=1
	lds R2,_LCD_CS2_BIT
	lds R30,_LCD_CS2_PORT
	lds R31,_LCD_CS2_PORT+1
	ldd R3,z+0
	or R3,R2
	std z+0,R3
	.dbline 79
;         CLEAR_LCD_CS1; //cs1=0
	lds R2,_LCD_CS1_BIT
	com R2
	lds R30,_LCD_CS1_PORT
	lds R31,_LCD_CS1_PORT+1
	ldd R3,z+0
	and R3,R2
	std z+0,R3
	.dbline 80
;     }	
L19:
	.dbline 81
;     SET_LCD_CMD;
	lds R2,_LCD_DI_BIT
	com R2
	lds R30,_LCD_DI_PORT
	lds R31,_LCD_DI_PORT+1
	ldd R3,z+0
	and R3,R2
	std z+0,R3
	.dbline 82
;     *LCD_DIR_PORT = 0x00;
	clr R2
	lds R30,_LCD_DIR_PORT
	lds R31,_LCD_DIR_PORT+1
	std z+0,R2
	.dbline 83
;     *LCD_OP_PORT = 0xff;		
	ldi R24,255
	lds R30,_LCD_OP_PORT
	lds R31,_LCD_OP_PORT+1
	std z+0,R24
	.dbline 84
;     SET_LCD_READ;
	lds R2,_LCD_RW_BIT
	lds R30,_LCD_RW_PORT
	lds R31,_LCD_RW_PORT+1
	ldd R3,z+0
	or R3,R2
	std z+0,R3
	.dbline 85
;     SET_LCD_E;					
	lds R2,_LCD_EN_BIT
	lds R30,_LCD_EN_PORT
	lds R31,_LCD_EN_PORT+1
	ldd R3,z+0
	or R3,R2
	std z+0,R3
	.dbline 86
;     _NOP();	
	nop
	.dbline 87
;     _NOP();
	nop
	.dbline 88
;     _NOP();
	nop
	.dbline 89
;     _NOP();
	nop
	xjmp L21
L20:
	.dbline 91
	.dbline 92
	lds R2,_LCD_EN_BIT
	com R2
	lds R30,_LCD_EN_PORT
	lds R31,_LCD_EN_PORT+1
	ldd R3,z+0
	and R3,R2
	std z+0,R3
	.dbline 93
	nop
	.dbline 94
	nop
	.dbline 95
	nop
	.dbline 96
	nop
	.dbline 97
	lds R2,_LCD_EN_BIT
	or R3,R2
	std z+0,R3
	.dbline 98
	nop
	.dbline 99
	nop
	.dbline 100
	nop
	.dbline 101
	nop
	.dbline 102
L21:
	.dbline 90
;     while((*LCD_IP_PORT) & LCD_STATUS_BUSY)
	lds R30,_LCD_IP_PORT
	lds R31,_LCD_IP_PORT+1
	ldd R2,z+0
	sbrc R2,7
	rjmp L20
	.dbline 103
;     {
;         CLEAR_LCD_E;	   		
;         _NOP();
;         _NOP();
;         _NOP();
;         _NOP();
;         SET_LCD_E;
;         _NOP();
;         _NOP();
;         _NOP();
;         _NOP();
;     }
;     CLEAR_LCD_E;
	lds R2,_LCD_EN_BIT
	com R2
	lds R30,_LCD_EN_PORT
	lds R31,_LCD_EN_PORT+1
	ldd R3,z+0
	and R3,R2
	std z+0,R3
	.dbline 104
;     SET_LCD_WRITE;
	lds R2,_LCD_RW_BIT
	com R2
	lds R30,_LCD_RW_PORT
	lds R31,_LCD_RW_PORT+1
	ldd R3,z+0
	and R3,R2
	std z+0,R3
	.dbline 105
;     *LCD_OP_PORT = 0xff;
	ldi R24,255
	lds R30,_LCD_OP_PORT
	lds R31,_LCD_OP_PORT+1
	std z+0,R24
	.dbline 106
;     asm("sei");//)asm("sei");
	sei
	.dbline -2
	.dbline 107
; }
L17:
	.dbline 0 ; func end
	ret
	.dbsym l status 1 c
	.dbsym r lr 16 c
	.dbend
	.dbfunc e write_LCD _write_LCD fV
;           data -> y+4
;             cd -> R20
;             lr -> R22
	.even
_write_LCD::
	xcall push_gset2
	mov R20,R18
	mov R22,R16
	.dbline -1
	.dbline 110
; 
; void write_LCD(unsigned char lr,unsigned char cd,unsigned char data) /*写入指令或数据*/
; {	
	.dbline 111
;     _CLI();//_CLI();
	cli
	.dbline 112
;     LCD_BUSY(lr);
	mov R16,R22
	xcall _LCD_BUSY
	.dbline 113
;     if(cd==CMD)
	tst R20
	brne L24
	.dbline 114
;     {
	.dbline 115
;         SET_LCD_CMD;
	lds R2,_LCD_DI_BIT
	com R2
	lds R30,_LCD_DI_PORT
	lds R31,_LCD_DI_PORT+1
	ldd R3,z+0
	and R3,R2
	std z+0,R3
	.dbline 116
;     }
	xjmp L25
L24:
	.dbline 118
;     else
;     {
	.dbline 119
;         SET_LCD_DATA;
	lds R2,_LCD_DI_BIT
	lds R30,_LCD_DI_PORT
	lds R31,_LCD_DI_PORT+1
	ldd R3,z+0
	or R3,R2
	std z+0,R3
	.dbline 120
;     }
L25:
	.dbline 121
;     SET_LCD_WRITE; 
	lds R2,_LCD_RW_BIT
	com R2
	lds R30,_LCD_RW_PORT
	lds R31,_LCD_RW_PORT+1
	ldd R3,z+0
	and R3,R2
	std z+0,R3
	.dbline 122
;     SET_LCD_E;
	lds R2,_LCD_EN_BIT
	lds R30,_LCD_EN_PORT
	lds R31,_LCD_EN_PORT+1
	ldd R3,z+0
	or R3,R2
	std z+0,R3
	.dbline 123
;     *LCD_DIR_PORT = 0xff;
	ldi R24,255
	lds R30,_LCD_DIR_PORT
	lds R31,_LCD_DIR_PORT+1
	std z+0,R24
	.dbline 124
;     *LCD_OP_PORT = data;
	lds R30,_LCD_OP_PORT
	lds R31,_LCD_OP_PORT+1
	ldd R0,y+4
	std z+0,R0
	.dbline 125
;     _NOP();
	nop
	.dbline 126
;     _NOP();
	nop
	.dbline 127
;     _NOP();
	nop
	.dbline 128
;     _NOP();
	nop
	.dbline 129
;     CLEAR_LCD_E;
	com R2
	lds R30,_LCD_EN_PORT
	lds R31,_LCD_EN_PORT+1
	ldd R3,z+0
	and R3,R2
	std z+0,R3
	.dbline 130
;     *LCD_OP_PORT = 0xff;
	lds R30,_LCD_OP_PORT
	lds R31,_LCD_OP_PORT+1
	std z+0,R24
	.dbline 131
;     _SEI();
	sei
	.dbline -2
	.dbline 132
; }
L23:
	xcall pop_gset2
	.dbline 0 ; func end
	ret
	.dbsym l data 4 c
	.dbsym r cd 20 c
	.dbsym r lr 22 c
	.dbend
	.dbfunc e read_LCD _read_LCD fc
;           data -> R20
;             lr -> R22
	.even
_read_LCD::
	xcall push_gset2
	mov R22,R16
	.dbline -1
	.dbline 134
; unsigned char read_LCD(unsigned char lr)	  /*  读显示数据 */
; {
	.dbline 136
;     unsigned char data;
;     _CLI();
	cli
	.dbline 137
;     LCD_BUSY(lr);
	mov R16,R22
	xcall _LCD_BUSY
	.dbline 138
;     SET_LCD_DATA;
	lds R2,_LCD_DI_BIT
	lds R30,_LCD_DI_PORT
	lds R31,_LCD_DI_PORT+1
	ldd R3,z+0
	or R3,R2
	std z+0,R3
	.dbline 139
;     *LCD_DIR_PORT = 0x00;
	clr R2
	lds R30,_LCD_DIR_PORT
	lds R31,_LCD_DIR_PORT+1
	std z+0,R2
	.dbline 140
;     *LCD_OP_PORT = 0xff;
	ldi R24,255
	lds R30,_LCD_OP_PORT
	lds R31,_LCD_OP_PORT+1
	std z+0,R24
	.dbline 141
;     SET_LCD_READ;
	lds R2,_LCD_RW_BIT
	lds R30,_LCD_RW_PORT
	lds R31,_LCD_RW_PORT+1
	ldd R3,z+0
	or R3,R2
	std z+0,R3
	.dbline 142
;     SET_LCD_E;
	lds R2,_LCD_EN_BIT
	lds R30,_LCD_EN_PORT
	lds R31,_LCD_EN_PORT+1
	ldd R3,z+0
	or R3,R2
	std z+0,R3
	.dbline 143
;     _NOP();
	nop
	.dbline 144
;     _NOP();
	nop
	.dbline 145
;     _NOP();
	nop
	.dbline 146
;     _NOP();
	nop
	.dbline 147
;     data=*LCD_IP_PORT;
	lds R30,_LCD_IP_PORT
	lds R31,_LCD_IP_PORT+1
	ldd R20,z+0
	.dbline 148
;     CLEAR_LCD_E;
	com R2
	lds R30,_LCD_EN_PORT
	lds R31,_LCD_EN_PORT+1
	ldd R3,z+0
	and R3,R2
	std z+0,R3
	.dbline 149
;     SET_LCD_WRITE;
	lds R2,_LCD_RW_BIT
	com R2
	lds R30,_LCD_RW_PORT
	lds R31,_LCD_RW_PORT+1
	ldd R3,z+0
	and R3,R2
	std z+0,R3
	.dbline 150
;     LCD_BUSY(lr);
	mov R16,R22
	xcall _LCD_BUSY
	.dbline 151
;     SET_LCD_DATA; 
	lds R2,_LCD_DI_BIT
	lds R30,_LCD_DI_PORT
	lds R31,_LCD_DI_PORT+1
	ldd R3,z+0
	or R3,R2
	std z+0,R3
	.dbline 152
;     *LCD_DIR_PORT = 0x00;
	clr R2
	lds R30,_LCD_DIR_PORT
	lds R31,_LCD_DIR_PORT+1
	std z+0,R2
	.dbline 153
;     *LCD_OP_PORT = 0xff;
	ldi R24,255
	lds R30,_LCD_OP_PORT
	lds R31,_LCD_OP_PORT+1
	std z+0,R24
	.dbline 154
;     SET_LCD_READ; 
	lds R2,_LCD_RW_BIT
	lds R30,_LCD_RW_PORT
	lds R31,_LCD_RW_PORT+1
	ldd R3,z+0
	or R3,R2
	std z+0,R3
	.dbline 155
;     SET_LCD_E;
	lds R2,_LCD_EN_BIT
	lds R30,_LCD_EN_PORT
	lds R31,_LCD_EN_PORT+1
	ldd R3,z+0
	or R3,R2
	std z+0,R3
	.dbline 156
;     _NOP();	
	nop
	.dbline 157
;     _NOP();
	nop
	.dbline 158
;     _NOP();
	nop
	.dbline 159
;     _NOP();
	nop
	.dbline 160
;     data=*LCD_IP_PORT;
	lds R30,_LCD_IP_PORT
	lds R31,_LCD_IP_PORT+1
	ldd R20,z+0
	.dbline 161
;     CLEAR_LCD_E;
	com R2
	lds R30,_LCD_EN_PORT
	lds R31,_LCD_EN_PORT+1
	ldd R3,z+0
	and R3,R2
	std z+0,R3
	.dbline 162
;     SET_LCD_WRITE;
	lds R2,_LCD_RW_BIT
	com R2
	lds R30,_LCD_RW_PORT
	lds R31,_LCD_RW_PORT+1
	ldd R3,z+0
	and R3,R2
	std z+0,R3
	.dbline 164
; 
;     _SEI();
	sei
	.dbline 165
;     return data;
	mov R16,R20
	.dbline -2
L26:
	xcall pop_gset2
	.dbline 0 ; func end
	ret
	.dbsym r data 20 c
	.dbsym r lr 22 c
	.dbend
	.dbfunc e set_start_line_L _set_start_line_L fV
;           line -> R20
	.even
_set_start_line_L::
	xcall push_gset1
	mov R20,R16
	sbiw R28,1
	.dbline -1
	.dbline 169
; }
; 
; void set_start_line_L(unsigned char line) /*设置显示起始行*/ //0-63
; {
	.dbline 170
;     write_LCD(LEFT,CMD,0xc0|line); 
	mov R24,R20
	ori R24,192
	std y+0,R24
	clr R18
	clr R16
	xcall _write_LCD
	.dbline -2
	.dbline 171
; }
L27:
	adiw R28,1
	xcall pop_gset1
	.dbline 0 ; func end
	ret
	.dbsym r line 20 c
	.dbend
	.dbfunc e set_start_line_R _set_start_line_R fV
;           line -> R20
	.even
_set_start_line_R::
	xcall push_gset1
	mov R20,R16
	sbiw R28,1
	.dbline -1
	.dbline 174
; 
; void set_start_line_R(unsigned char line) /*设置显示起始行*/ //0-63
; {
	.dbline 175
;     write_LCD(RIGHT,CMD,0xc0|line); 
	mov R24,R20
	ori R24,192
	std y+0,R24
	clr R18
	ldi R16,1
	xcall _write_LCD
	.dbline -2
	.dbline 176
; }
L28:
	adiw R28,1
	xcall pop_gset1
	.dbline 0 ; func end
	ret
	.dbsym r line 20 c
	.dbend
	.dbfunc e set_page_L _set_page_L fV
;           page -> R20
	.even
_set_page_L::
	xcall push_gset1
	mov R20,R16
	sbiw R28,1
	.dbline -1
	.dbline 179
; 
; void set_page_L(unsigned char page)	/*设置X地址 设置页*/  //0-7
; {
	.dbline 180
;     write_LCD(LEFT,CMD,0xb8|page);                     
	mov R24,R20
	ori R24,184
	std y+0,R24
	clr R18
	clr R16
	xcall _write_LCD
	.dbline -2
	.dbline 181
; }
L29:
	adiw R28,1
	xcall pop_gset1
	.dbline 0 ; func end
	ret
	.dbsym r page 20 c
	.dbend
	.dbfunc e set_page_R _set_page_R fV
;           page -> R20
	.even
_set_page_R::
	xcall push_gset1
	mov R20,R16
	sbiw R28,1
	.dbline -1
	.dbline 183
; void set_page_R(unsigned char page)	/*设置X地址 设置页*/ //0-7
; {
	.dbline 184
;     write_LCD(RIGHT,CMD,0xb8|page);                     
	mov R24,R20
	ori R24,184
	std y+0,R24
	clr R18
	ldi R16,1
	xcall _write_LCD
	.dbline -2
	.dbline 185
; }
L30:
	adiw R28,1
	xcall pop_gset1
	.dbline 0 ; func end
	ret
	.dbsym r page 20 c
	.dbend
	.dbfunc e set_col_addr_L _set_col_addr_L fV
;            col -> R20
	.even
_set_col_addr_L::
	xcall push_gset1
	mov R20,R16
	sbiw R28,1
	.dbline -1
	.dbline 188
; 
; void set_col_addr_L(unsigned char col) /*设置Y地址*/ //0-63
; {
	.dbline 189
;     write_LCD(LEFT,CMD,0x40|col);                     
	mov R24,R20
	ori R24,64
	std y+0,R24
	clr R18
	clr R16
	xcall _write_LCD
	.dbline -2
	.dbline 190
; }
L31:
	adiw R28,1
	xcall pop_gset1
	.dbline 0 ; func end
	ret
	.dbsym r col 20 c
	.dbend
	.dbfunc e set_col_addr_R _set_col_addr_R fV
;            col -> R20
	.even
_set_col_addr_R::
	xcall push_gset1
	mov R20,R16
	sbiw R28,1
	.dbline -1
	.dbline 193
; 
; void set_col_addr_R(unsigned char col) /*设置Y地址*/ //0-63
; {
	.dbline 194
;     write_LCD(RIGHT,CMD,0x40|col);                     
	mov R24,R20
	ori R24,64
	std y+0,R24
	clr R18
	ldi R16,1
	xcall _write_LCD
	.dbline -2
	.dbline 195
; }
L32:
	adiw R28,1
	xcall pop_gset1
	.dbline 0 ; func end
	ret
	.dbsym r col 20 c
	.dbend
	.dbfunc e init_lcd _init_lcd fV
	.even
_init_lcd::
	sbiw R28,1
	.dbline -1
	.dbline 198
; 
; void init_lcd(void) /*初始化函数*/
; {
	.dbline 199
;     set_start_line_L(0); /*显示起始行为0*/
	clr R16
	xcall _set_start_line_L
	.dbline 200
;     set_start_line_R(0); /*显示起始行为0*/
	clr R16
	xcall _set_start_line_R
	.dbline 201
;     write_LCD(LEFT,CMD,DISPLAY_ON); /*  开显示  */
	ldi R24,63
	std y+0,R24
	clr R18
	clr R16
	xcall _write_LCD
	.dbline 202
;     write_LCD(RIGHT,CMD,DISPLAY_ON); /*  开显示  */
	ldi R24,63
	std y+0,R24
	clr R18
	ldi R16,1
	xcall _write_LCD
	.dbline -2
	.dbline 203
; }
L33:
	adiw R28,1
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e clr_lcd _clr_lcd fV
;          pages -> R20
;              i -> R22
	.even
_clr_lcd::
	xcall push_gset2
	sbiw R28,1
	.dbline -1
	.dbline 206
; 
; void clr_lcd(void) /*清屏函数*/
; {
	.dbline 208
;     unsigned char pages,i;
;     for(pages=0;pages<8;pages++)
	clr R20
	xjmp L38
L35:
	.dbline 209
;     {
	.dbline 210
;         set_page_L(pages);  /* X 页地址 */
	mov R16,R20
	xcall _set_page_L
	.dbline 211
;         set_page_R(pages);  /* X 页地址 */
	mov R16,R20
	xcall _set_page_R
	.dbline 212
;         for(i=0;i<64;i++)   
	clr R22
	xjmp L42
L39:
	.dbline 213
	.dbline 214
	mov R16,R22
	xcall _set_col_addr_L
	.dbline 215
	mov R16,R22
	xcall _set_col_addr_R
	.dbline 216
	clr R2
	std y+0,R2
	ldi R18,1
	clr R16
	xcall _write_LCD
	.dbline 217
	clr R2
	std y+0,R2
	ldi R18,1
	ldi R16,1
	xcall _write_LCD
	.dbline 218
L40:
	.dbline 212
	inc R22
L42:
	.dbline 212
	cpi R22,64
	brlo L39
	.dbline 219
L36:
	.dbline 208
	inc R20
L38:
	.dbline 208
	cpi R20,8
	brlo L35
	.dbline -2
	.dbline 220
;         {
;             set_col_addr_L(i);//Y
;             set_col_addr_R(i);//Y
;             write_LCD(LEFT,DATA,0x0);
;             write_LCD(RIGHT,DATA,0x0);
;         }
;     }
; }
L34:
	adiw R28,1
	xcall pop_gset2
	.dbline 0 ; func end
	ret
	.dbsym r pages 20 c
	.dbsym r i 22 c
	.dbend
	.area lit(rom, con, rel)
_ASC_16::
	.byte 49
	.byte 0,0
	.byte 8,8
	.byte 252,0
	.byte 0,0
	.byte 0,0
	.byte 4,4
	.byte 7,4
	.byte 4,0
	.byte 50
	.byte 0,0
	.byte 8,4
	.byte 132,'D
	.byte 56,0
	.byte 0,0
	.byte 6,5
	.byte 4,4
	.byte 4,0
	.byte 51
	.byte 0,0
	.byte 8,4
	.byte 'D,'D
	.byte 184,0
	.byte 0,0
	.byte 2,4
	.byte 4,4
	.byte 3,0
	.byte 52
	.byte 0,0
	.byte 128,96
	.byte 24,252
	.byte 0,0
	.byte 0,0
	.byte 1,1
	.byte 5,7
	.byte 5,0
	.byte 53
	.byte 0,0
	.byte 124,'D
	.byte 'D,'D
	.byte 132,0
	.byte 0,0
	.byte 2,4
	.byte 4,4
	.byte 3,0
	.byte 54
	.byte 0,0
	.byte 240,'H
	.byte 'D,'D
	.byte 128,0
	.byte 0,0
	.byte 3,4
	.byte 4,4
	.byte 3,0
	.byte 55
	.byte 0,0
	.byte 12,4
	.byte 132,'d
	.byte 28,0
	.byte 0,0
	.byte 0,6
	.byte 1,0
	.byte 0,0
	.byte 56
	.byte 0,0
	.byte 184,'D
	.byte 'D,'D
	.byte 184,0
	.byte 0,0
	.byte 3,4
	.byte 4,4
	.byte 3,0
	.byte 57
	.byte 0,0
	.byte 56,'D
	.byte 'D,'D
	.byte 248,0
	.byte 0,0
	.byte 0,4
	.byte 4,2
	.byte 1,0
	.byte 48
	.byte 0,0
	.byte 248,4
	.byte 4,4
	.byte 248,0
	.byte 0,0
	.byte 3,4
	.byte 4,4
	.byte 3,0
	.byte 46
	.byte 0,0
	.byte 0,0
	.byte 0,0
	.byte 0,0
	.byte 0,0
	.byte 0,0
	.byte 4,0
	.byte 0,0
	.byte 44
	.byte 0,0
	.byte 0,0
	.byte 0,0
	.byte 0,0
	.byte 0,0
	.byte 0,8
	.byte 4,0
	.byte 0,0
	.byte 58
	.byte 0,0
	.byte 0,0
	.byte 32,0
	.byte 0,0
	.byte 0,0
	.byte 0,0
	.byte 4,0
	.byte 0,0
	.byte 59
	.byte 0,0
	.byte 0,0
	.byte 32,0
	.byte 0,0
	.byte 0,0
	.byte 0,8
	.byte 4,0
	.byte 0,0
	.byte 45
	.byte 0,128
	.byte 128,128
	.byte 128,128
	.byte 128,128
	.byte 0,0
	.byte 0,0
	.byte 0,0
	.byte 0,0
	.byte 95
	.byte 0,0
	.byte 0,0
	.byte 0,0
	.byte 0,0
	.byte 16,16
	.byte 16,16
	.byte 16,16
	.byte 16,16
	.byte 'A
	.byte 0,0
	.byte 128,'d
	.byte 28,96
	.byte 128,0
	.byte 0,4
	.byte 7,5
	.byte 1,5
	.byte 7,4
	.byte 'B
	.byte 0,4
	.byte 252,'D
	.byte 'D,'D
	.byte 'D,184
	.byte 0,4
	.byte 7,4
	.byte 4,4
	.byte 4,3
	.byte 'C
	.byte 0,240
	.byte 8,4
	.byte 4,4
	.byte 4,8
	.byte 0,1
	.byte 2,4
	.byte 4,4
	.byte 4,2
	.byte 'D
	.byte 0,4
	.byte 252,4
	.byte 4,4
	.byte 8,240
	.byte 0,4
	.byte 7,4
	.byte 4,4
	.byte 2,1
	.byte 'E
	.byte 0,4
	.byte 252,'D
	.byte 'D,228
	.byte 4,12
	.byte 0,4
	.byte 7,4
	.byte 4,4
	.byte 4,6
	.byte 'F
	.byte 0,4
	.byte 252,'D
	.byte 'D,228
	.byte 4,12
	.byte 0,4
	.byte 7,4
	.byte 4,0
	.byte 0,0
	.byte 32
	.byte 0,0
	.byte 0,0
	.byte 0,0
	.byte 0,0
	.byte 0,0
	.byte 0,0
	.byte 0,0
	.byte 0,0
	.byte 61
	.byte 0,0
	.byte 160,160
	.byte 160,160
	.byte 160,0
	.byte 0,0
	.byte 0,0
	.byte 0,0
	.byte 0,0
	.byte 40
	.byte 0,0
	.byte 0,224
	.byte 24,4
	.byte 0,0
	.byte 0,0
	.byte 0,3
	.byte 12,16
	.byte 0,0
	.byte 41
	.byte 0,0
	.byte 0,4
	.byte 24,224
	.byte 0,0
	.byte 0,0
	.byte 0,16
	.byte 12,3
	.byte 0,0
	.byte 'V
	.byte 0,4
	.byte 60,196
	.byte 0,196
	.byte 60,4
	.byte 0,0
	.byte 0,1
	.byte 6,1
	.byte 0,0
	.byte 'm
	.byte 0,32
	.byte 224,32
	.byte 192,32
	.byte 192,0
	.byte 0,4
	.byte 7,0
	.byte 7,0
	.byte 7,4
	.byte 'H
	.byte 0,4
	.byte 252,'D
	.byte 64,'D
	.byte 252,4
	.byte 0,4
	.byte 7,4
	.byte 0,4
	.byte 7,4
	.byte 42
	.byte 144,144
	.byte 96,252
	.byte 96,144
	.byte 144,0
	.byte 0,0
	.byte 0,3
	.byte 0,0
	.byte 0,0
	.dbstruct 0 17 typFNT_ASC16
	.dbfield 0 Index A[1:1]c
	.dbfield 1 Msk A[16:16]c
	.dbend
	.dbsym e ASC_16 _ASC_16 A[510:30]kS[typFNT_ASC16]
_GB_16::
	.byte 191,198
	.byte 138,'j
	.byte 254,41
	.byte 'I,128
	.byte 146,164
	.byte 128,255
	.byte 64,0
	.byte 1,0
	.byte 7,0
	.byte 0,0
	.byte 0,0
	.byte 0,7
	.byte 0,0
	.byte 188,188
	.byte 'D,'D
	.byte 255,36
	.byte 0,'d
	.byte 164,63
	.byte 164,'d
	.byte 4,0
	.byte 4,4
	.byte 7,0
	.byte 4,4
	.byte 2,1
	.byte 2,4
	.byte 4,0
	.byte 211,208
	.byte 'B,34
	.byte 18,250
	.byte 'N,'K
	.byte 'J,'J
	.byte 250,2
	.byte 2,0
	.byte 0,0
	.byte 0,7
	.byte 1,1
	.byte 1,5
	.byte 7,0
	.byte 0,0
	.byte 207,222
	.byte 255,129
	.byte 153,231
	.byte 0,255
	.byte 37,229
	.byte 37,191
	.byte 64,0
	.byte 7,0
	.byte 0,0
	.byte 0,7
	.byte 4,2
	.byte 1,2
	.byte 4,0
	.byte 185,171
	.byte 32,16
	.byte 8,7
	.byte 192,48
	.byte 131,12
	.byte 16,32
	.byte 32,0
	.byte 0,4
	.byte 6,5
	.byte 4,4
	.byte 2,3
	.byte 6,0
	.byte 0,0
	.byte 203,190
	.byte 8,9
	.byte 233,41
	.byte 41,41
	.byte 237,9
	.byte 1,255
	.byte 0,0
	.byte 0,0
	.byte 1,1
	.byte 1,1
	.byte 1,4
	.byte 4,7
	.byte 0,0
	.byte 210,186
	.byte 25,226
	.byte 20,'B
	.byte 242,46
	.byte 'r,143
	.byte 170,'z
	.byte 2,0
	.byte 1,7
	.byte 0,0
	.byte 7,4
	.byte 4,2
	.byte 1,2
	.byte 4,0
	.byte 190,167
	.byte 0,192
	.byte 64,95
	.byte 213,21
	.byte 213,'U
	.byte 95,64
	.byte 192,0
	.byte 0,7
	.byte 5,5
	.byte 7,0
	.byte 7,5
	.byte 5,5
	.byte 7,0
	.byte 207,212
	.byte 0,64
	.byte 159,21
	.byte 213,21
	.byte 213,21
	.byte 31,192
	.byte 0,0
	.byte 4,4
	.byte 5,4
	.byte 7,4
	.byte 7,6
	.byte 5,4
	.byte 4,0
	.byte 202,190
	.byte 16,18
	.byte 146,'R
	.byte 18,242
	.byte 18,18
	.byte 'S,146
	.byte 16,0
	.byte 2,1
	.byte 0,4
	.byte 4,7
	.byte 0,0
	.byte 0,0
	.byte 3,0
	.byte 181,196
	.byte 252,'D
	.byte 'F,'E
	.byte 252,16
	.byte 44,199
	.byte 4,4
	.byte 252,0
	.byte 7,2
	.byte 2,2
	.byte 7,0
	.byte 0,4
	.byte 4,4
	.byte 3,0
	.byte 181,218
	.byte 4,234
	.byte 171,174
	.byte 170,252
	.byte 170,171
	.byte 174,186
	.byte 130,0
	.byte 4,4
	.byte 2,1
	.byte 0,7
	.byte 0,2
	.byte 2,2
	.byte 1,0
	.byte 210,187
	.byte 32,32
	.byte 32,32
	.byte 32,32
	.byte 32,32
	.byte 32,48
	.byte 32,0
	.byte 0,0
	.byte 0,0
	.byte 0,0
	.byte 0,0
	.byte 0,0
	.byte 0,0
	.byte 208,208
	.byte 'H,36
	.byte 243,8
	.byte 9,9
	.byte 9,9
	.byte 249,9
	.byte 8,0
	.byte 0,0
	.byte 7,0
	.byte 0,4
	.byte 4,4
	.byte 7,0
	.byte 0,0
	.byte 182,254
	.byte 0,4
	.byte 4,4
	.byte 4,4
	.byte 4,4
	.byte 6,4
	.byte 0,0
	.byte 2,2
	.byte 2,2
	.byte 2,2
	.byte 2,2
	.byte 2,2
	.byte 2,0
	.byte 200,253
	.byte 0,2
	.byte 34,34
	.byte 34,34
	.byte 34,34
	.byte 35,2
	.byte 0,0
	.byte 4,4
	.byte 4,4
	.byte 4,4
	.byte 4,4
	.byte 4,6
	.byte 4,0
	.byte 203,196
	.byte 0,255
	.byte 129,'A
	.byte 63,1
	.byte 1,255
	.byte 129,129
	.byte 255,0
	.byte 0,7
	.byte 2,2
	.byte 2,2
	.byte 2,2
	.byte 2,2
	.byte 7,0
	.byte 206,229
	.byte 0,17
	.byte 17,145
	.byte 127,17
	.byte 17,17
	.byte 241,1
	.byte 0,0
	.byte 4,4
	.byte 4,7
	.byte 4,4
	.byte 4,4
	.byte 7,4
	.byte 4,0
	.dbstruct 0 26 typFNT_GB16
	.dbfield 0 Index A[2:2]c
	.dbfield 2 Msk A[24:24]c
	.dbend
	.dbsym e GB_16 _GB_16 A[468:18]kS[typFNT_GB16]
	.area text(rom, con, rel)
	.dbfile E:\PROTEU~1.7\User\MEGA32-LCM\MEGA32-LCM\DISPLAY.C
	.dbfunc e GetPage _GetPage fc
	.even
_GetPage::
	.dbline -1
	.dbline 295
; 
; //ASCII 字模宽度及高度
; #define ASC_CHR_WIDTH	8
; #define ASC_CHR_HEIGHT	12
; 
; typedef struct typFNT_ASC16	/* 汉字字模显示数据结构 */
; {
;     char Index[1];
;     char Msk[16];
; };
; const struct typFNT_ASC16  ASC_16[] = 
; {	/* 显示为8*16  Curier 10 常规*/
; "1",0x00,0x00,0x08,0x08,0xFC,0x00,0x00,0x00,0x00,0x00,0x04,0x04,0x07,0x04,0x04,0x00,
; "2",0x00,0x00,0x08,0x04,0x84,0x44,0x38,0x00,0x00,0x00,0x06,0x05,0x04,0x04,0x04,0x00,
; "3",0x00,0x00,0x08,0x04,0x44,0x44,0xB8,0x00,0x00,0x00,0x02,0x04,0x04,0x04,0x03,0x00,
; "4",0x00,0x00,0x80,0x60,0x18,0xFC,0x00,0x00,0x00,0x00,0x01,0x01,0x05,0x07,0x05,0x00,
; "5",0x00,0x00,0x7C,0x44,0x44,0x44,0x84,0x00,0x00,0x00,0x02,0x04,0x04,0x04,0x03,0x00,
; "6",0x00,0x00,0xF0,0x48,0x44,0x44,0x80,0x00,0x00,0x00,0x03,0x04,0x04,0x04,0x03,0x00,
; "7",0x00,0x00,0x0C,0x04,0x84,0x64,0x1C,0x00,0x00,0x00,0x00,0x06,0x01,0x00,0x00,0x00,
; "8",0x00,0x00,0xB8,0x44,0x44,0x44,0xB8,0x00,0x00,0x00,0x03,0x04,0x04,0x04,0x03,0x00,
; "9",0x00,0x00,0x38,0x44,0x44,0x44,0xF8,0x00,0x00,0x00,0x00,0x04,0x04,0x02,0x01,0x00,
; "0",0x00,0x00,0xF8,0x04,0x04,0x04,0xF8,0x00,0x00,0x00,0x03,0x04,0x04,0x04,0x03,0x00,
; ".",0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x04,0x00,0x00,0x00,
; ",",0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x08,0x04,0x00,0x00,0x00,
; ":",0x00,0x00,0x00,0x00,0x20,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x04,0x00,0x00,0x00,
; ";",0x00,0x00,0x00,0x00,0x20,0x00,0x00,0x00,0x00,0x00,0x00,0x08,0x04,0x00,0x00,0x00,
; "-",0x00,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
; "_",0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x10,0x10,0x10,0x10,0x10,0x10,0x10,0x10,
; "A",0x00,0x00,0x80,0x64,0x1C,0x60,0x80,0x00,0x00,0x04,0x07,0x05,0x01,0x05,0x07,0x04,
; "B",0x00,0x04,0xFC,0x44,0x44,0x44,0x44,0xB8,0x00,0x04,0x07,0x04,0x04,0x04,0x04,0x03,
; "C",0x00,0xF0,0x08,0x04,0x04,0x04,0x04,0x08,0x00,0x01,0x02,0x04,0x04,0x04,0x04,0x02,
; "D",0x00,0x04,0xFC,0x04,0x04,0x04,0x08,0xF0,0x00,0x04,0x07,0x04,0x04,0x04,0x02,0x01,
; "E",0x00,0x04,0xFC,0x44,0x44,0xE4,0x04,0x0C,0x00,0x04,0x07,0x04,0x04,0x04,0x04,0x06,
; "F",0x00,0x04,0xFC,0x44,0x44,0xE4,0x04,0x0C,0x00,0x04,0x07,0x04,0x04,0x00,0x00,0x00,
; " ",0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
; "=",0x00,0x00,0xA0,0xA0,0xA0,0xA0,0xA0,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
; "(",0x00,0x00,0x00,0xE0,0x18,0x04,0x00,0x00,0x00,0x00,0x00,0x03,0x0C,0x10,0x00,0x00,
; ")",0x00,0x00,0x00,0x04,0x18,0xE0,0x00,0x00,0x00,0x00,0x00,0x10,0x0C,0x03,0x00,0x00,
; "V",0x00,0x04,0x3C,0xC4,0x00,0xC4,0x3C,0x04,0x00,0x00,0x00,0x01,0x06,0x01,0x00,0x00,
; "m",0x00,0x20,0xE0,0x20,0xC0,0x20,0xC0,0x00,0x00,0x04,0x07,0x00,0x07,0x00,0x07,0x04,
; "H",0x00,0x04,0xFC,0x44,0x40,0x44,0xFC,0x04,0x00,0x04,0x07,0x04,0x00,0x04,0x07,0x04,
; "*",0x90,0x90,0x60,0xFC,0x60,0x90,0x90,0x00,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x00,
; };
; 
; #define ASC_HZ_WIDTH	12
; //#define ASC_HZ_HEIGHT	12
; 
; typedef struct typFNT_GB16	/*12*16 汉字字模显示数据结构 */
; {
; 	char Index[2];
; 	char Msk[24];
; };
; const struct typFNT_GB16  GB_16[] = {	/* 宋体 9 显示为12*16 */
; "科",0x8A,0x6A,0xFE,0x29,0x49,0x80,0x92,0xA4,0x80,0xFF,0x40,0x00,0x01,0x00,0x07,0x00,0x00,0x00,0x00,0x00,0x00,0x07,0x00,0x00,
; "技",0x44,0x44,0xFF,0x24,0x00,0x64,0xA4,0x3F,0xA4,0x64,0x04,0x00,0x04,0x04,0x07,0x00,0x04,0x04,0x02,0x01,0x02,0x04,0x04,0x00,
; "有",0x42,0x22,0x12,0xFA,0x4E,0x4B,0x4A,0x4A,0xFA,0x02,0x02,0x00,0x00,0x00,0x00,0x07,0x01,0x01,0x01,0x05,0x07,0x00,0x00,0x00,
; "限",0xFF,0x81,0x99,0xE7,0x00,0xFF,0x25,0xE5,0x25,0xBF,0x40,0x00,0x07,0x00,0x00,0x00,0x00,0x07,0x04,0x02,0x01,0x02,0x04,0x00,
; "公",0x20,0x10,0x08,0x07,0xC0,0x30,0x83,0x0C,0x10,0x20,0x20,0x00,0x00,0x04,0x06,0x05,0x04,0x04,0x02,0x03,0x06,0x00,0x00,0x00,
; "司",0x08,0x09,0xE9,0x29,0x29,0x29,0xED,0x09,0x01,0xFF,0x00,0x00,0x00,0x00,0x01,0x01,0x01,0x01,0x01,0x04,0x04,0x07,0x00,0x00,
; "液",0x19,0xE2,0x14,0x42,0xF2,0x2E,0x72,0x8F,0xAA,0x7A,0x02,0x00,0x01,0x07,0x00,0x00,0x07,0x04,0x04,0x02,0x01,0x02,0x04,0x00,
; "晶",0x00,0xC0,0x40,0x5F,0xD5,0x15,0xD5,0x55,0x5F,0x40,0xC0,0x00,0x00,0x07,0x05,0x05,0x07,0x00,0x07,0x05,0x05,0x05,0x07,0x00,
; "显",0x00,0x40,0x9F,0x15,0xD5,0x15,0xD5,0x15,0x1F,0xC0,0x00,0x00,0x04,0x04,0x05,0x04,0x07,0x04,0x07,0x06,0x05,0x04,0x04,0x00,
; "示",0x10,0x12,0x92,0x52,0x12,0xF2,0x12,0x12,0x53,0x92,0x10,0x00,0x02,0x01,0x00,0x04,0x04,0x07,0x00,0x00,0x00,0x00,0x03,0x00,
; "的",0xFC,0x44,0x46,0x45,0xFC,0x10,0x2C,0xC7,0x04,0x04,0xFC,0x00,0x07,0x02,0x02,0x02,0x07,0x00,0x00,0x04,0x04,0x04,0x03,0x00,
; "第",0x04,0xEA,0xAB,0xAE,0xAA,0xFC,0xAA,0xAB,0xAE,0xBA,0x82,0x00,0x04,0x04,0x02,0x01,0x00,0x07,0x00,0x02,0x02,0x02,0x01,0x00,
; "一",0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x30,0x20,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
; "行",0x48,0x24,0xF3,0x08,0x09,0x09,0x09,0x09,0xF9,0x09,0x08,0x00,0x00,0x00,0x07,0x00,0x00,0x04,0x04,0x04,0x07,0x00,0x00,0x00,
; "二",0x00,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x06,0x04,0x00,0x00,0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x00,
; "三",0x00,0x02,0x22,0x22,0x22,0x22,0x22,0x22,0x23,0x02,0x00,0x00,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x06,0x04,0x00,
; "四",0x00,0xFF,0x81,0x41,0x3F,0x01,0x01,0xFF,0x81,0x81,0xFF,0x00,0x00,0x07,0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x07,0x00,
; "五",0x00,0x11,0x11,0x91,0x7F,0x11,0x11,0x11,0xF1,0x01,0x00,0x00,0x04,0x04,0x04,0x07,0x04,0x04,0x04,0x04,0x07,0x04,0x04,0x00,
; };
; 
; unsigned char GetPage(void) /*得到当前页*/
; {
	.dbline 296
; 	return CurPage;
	lds R16,_CurPage
	.dbline -2
L43:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e GetCol _GetCol fc
	.even
_GetCol::
	.dbline -1
	.dbline 300
; }
; 
; unsigned char GetCol(void) /*得到当前列*/
; {
	.dbline 301
; 	return CurCol;
	lds R16,_CurCol
	.dbline -2
L44:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e SetPageCol _SetPageCol fV
;           ucol -> R20
;          upage -> R22
	.even
_SetPageCol::
	xcall push_gset2
	mov R20,R18
	mov R22,R16
	.dbline -1
	.dbline 305
; }
; 
; void SetPageCol(unsigned char upage, unsigned char ucol) /* 设置液晶的页和列 */
; {
	.dbline 306
; 	CurPage = upage;
	sts _CurPage,R22
	.dbline 307
; 	CurCol = ucol;
	sts _CurCol,R20
	.dbline 308
; 	if(ucol<64)
	cpi R20,64
	brsh L46
	.dbline 309
; 	{
	.dbline 310
; 		set_page_L(upage);
	mov R16,R22
	xcall _set_page_L
	.dbline 311
; 		set_col_addr_L(ucol);
	mov R16,R20
	xcall _set_col_addr_L
	.dbline 312
; 	}
	xjmp L47
L46:
	.dbline 314
	.dbline 315
	mov R16,R22
	xcall _set_page_R
	.dbline 316
	mov R16,R20
	subi R16,64
	xcall _set_col_addr_R
	.dbline 317
L47:
	.dbline -2
	.dbline 318
; 	else
; 	{
; 		set_page_R(upage);
; 		set_col_addr_R(ucol-64);
; 	}
; }
L45:
	xcall pop_gset2
	.dbline 0 ; func end
	ret
	.dbsym r ucol 20 c
	.dbsym r upage 22 c
	.dbend
	.dbfunc e SetRowCol _SetRowCol fV
;           page -> R20
;           ucol -> R22
;           urow -> R20
	.even
_SetRowCol::
	xcall push_gset2
	mov R22,R18
	mov R20,R16
	.dbline -1
	.dbline 322
; 
; /* 设置当前显示的页和列 */
; void SetRowCol(unsigned char urow, unsigned char ucol) 
; {
	.dbline 324
; 	unsigned char page;
; 	CurRow = urow;
	sts _CurRow,R20
	.dbline 325
; 	CurCol = ucol;
	sts _CurCol,R22
	.dbline 327
; 	
; 	switch(urow)
	clr R21
	cpi R20,1
	ldi R30,0
	cpc R21,R30
	breq L52
	cpi R20,2
	ldi R30,0
	cpc R21,R30
	breq L53
	cpi R20,3
	ldi R30,0
	cpc R21,R30
	breq L54
	cpi R20,4
	ldi R30,0
	cpc R21,R30
	breq L55
	cpi R20,5
	ldi R30,0
	cpc R21,R30
	breq L56
	xjmp L49
X0:
	.dbline 328
; 	{
L52:
	.dbline 330
; 		case 1:
; 			page=0;
	clr R20
	.dbline 331
; 			CurOffset=1;
	ldi R24,1
	sts _CurOffset,R24
	.dbline 332
; 			break;
	xjmp L50
L53:
	.dbline 334
; 		case 2:
; 			page=1;
	ldi R20,1
	.dbline 335
; 			CurOffset=2;
	ldi R24,2
	sts _CurOffset,R24
	.dbline 336
; 			break;
	xjmp L50
L54:
	.dbline 338
; 		case 3:
; 			page=3;
	ldi R20,3
	.dbline 339
; 			CurOffset=1;
	ldi R24,1
	sts _CurOffset,R24
	.dbline 340
; 			break;
	xjmp L50
L55:
	.dbline 342
; 		case 4:
; 			page=4;
	ldi R20,4
	.dbline 343
; 			CurOffset=2;
	ldi R24,2
	sts _CurOffset,R24
	.dbline 344
; 			break;
	xjmp L50
L56:
	.dbline 346
; 		case 5:
; 			page=6;
	ldi R20,6
	.dbline 347
; 			CurOffset=1;
	ldi R24,1
	sts _CurOffset,R24
	.dbline 348
; 			break;
L49:
L50:
	.dbline 350
; 	}
; 	SetPageCol(page,ucol);
	mov R18,R22
	mov R16,R20
	xcall _SetPageCol
	.dbline -2
	.dbline 351
; }
L48:
	xcall pop_gset2
	.dbline 0 ; func end
	ret
	.dbsym r page 20 c
	.dbsym r ucol 22 c
	.dbsym r urow 20 c
	.dbend
	.dbfunc e disp_ch _disp_ch fV
;          width -> R22
;            len -> R22
;          uPage -> y+2
;           ch_r -> R10
;           uCol -> y+1
;           ch_w -> R14
;              k -> R20
;              j -> R12
;              c -> R10
	.even
_disp_ch::
	xcall push_gset5
	mov R10,R16
	sbiw R28,3
	.dbline -1
	.dbline 354
; 
; void disp_ch(unsigned char c)
; {
	.dbline 358
; 	unsigned char k,j,uPage,uCol,ch_r,ch_w;
; 	unsigned char width;
; 	unsigned char len;
; 	uPage = GetPage();
	xcall _GetPage
	std y+2,R16
	.dbline 359
; 	uCol = GetCol();
	xcall _GetCol
	std y+1,R16
	.dbline 360
; 	len=sizeof(ASC_16)/sizeof(ASC_16[0]);
	ldi R22,30
	.dbline 361
; 	for(k=0;k<len;k++)
	clr R20
	xjmp L61
L58:
	.dbline 362
; 	{
	.dbline 363
; 		if(c == ASC_16[k].Index[0] ) break;
	ldi R24,17
	mul R24,R20
	movw R30,R0
	ldi R24,<_ASC_16
	ldi R25,>_ASC_16
	add R30,R24
	adc R31,R25
	lpm R30,Z
	cp R10,R30
	brne L62
	.dbline 363
	xjmp L60
L62:
	.dbline 364
L59:
	.dbline 361
	inc R20
L61:
	.dbline 361
	cp R20,R22
	brlo L58
L60:
	.dbline 365
; 	}
; 	if(k<len)
	cp R20,R22
	brlo X1
	xjmp L64
X1:
	.dbline 366
; 	{
	.dbline 368
; 		
; 		if(c=='-'||c==':') 
	mov R24,R10
	cpi R24,45
	breq L68
	cpi R24,58
	brne L66
L68:
	.dbline 369
; 			width=ASC_CHR_WIDTH-2;
	ldi R22,6
	xjmp L67
L66:
	.dbline 370
; 		else if(c=='|')
	mov R24,R10
	cpi R24,124
	brne L69
	.dbline 371
; 			width=ASC_HZ_WIDTH-ASC_CHR_WIDTH;
	ldi R22,4
	xjmp L70
L69:
	.dbline 373
; 		else 
; 			width=ASC_CHR_WIDTH;
	ldi R22,8
L70:
L67:
	.dbline 375
; 		
; 		if(CurOffset==1) //下半部是写半个字节
	lds R24,_CurOffset
	cpi R24,1
	breq X2
	xjmp L71
X2:
	.dbline 376
; 		{
	.dbline 377
; 			for(j=0;j<width;j++)
	clr R12
	xjmp L76
L73:
	.dbline 378
; 			{
	.dbline 379
; 				SetPageCol(uPage,uCol+j);
	ldd R18,y+1
	add R18,R12
	ldd R16,y+2
	xcall _SetPageCol
	.dbline 380
; 				ch_w=ASC_16[k].Msk[j];
	ldi R24,17
	mul R24,R20
	movw R2,R0
	ldi R24,<_ASC_16+1
	ldi R25,>_ASC_16+1
	add R2,R24
	adc R3,R25
	mov R30,R12
	clr R31
	add R30,R2
	adc R31,R3
	lpm R14,Z
	.dbline 381
; 				if(uCol+j<64)	write_LCD(LEFT,DATA,ch_w); 
	ldd R24,y+1
	add R24,R12
	cpi R24,64
	brsh L78
	.dbline 381
	std y+0,R14
	ldi R18,1
	clr R16
	xcall _write_LCD
	xjmp L79
L78:
	.dbline 382
; 				else write_LCD(RIGHT,DATA,ch_w);
	std y+0,R14
	ldi R18,1
	ldi R16,1
	xcall _write_LCD
L79:
	.dbline 383
L74:
	.dbline 377
	inc R12
L76:
	.dbline 377
	cp R12,R22
	brlo L73
	.dbline 384
; 			}
; 			SetPageCol(uPage+1,uCol);
	ldd R18,y+1
	ldd R16,y+2
	subi R16,255    ; addi 1
	xcall _SetPageCol
	.dbline 386
; 			
; 			for(j=0;j<width;j++)
	clr R12
	xjmp L83
L80:
	.dbline 387
; 			{
	.dbline 388
; 				SetPageCol(uPage+1,uCol+j);
	ldd R18,y+1
	add R18,R12
	ldd R16,y+2
	subi R16,255    ; addi 1
	xcall _SetPageCol
	.dbline 389
; 				if(uCol+j<64) ch_r=read_LCD(LEFT);
	ldd R24,y+1
	add R24,R12
	cpi R24,64
	brsh L84
	.dbline 389
	clr R16
	xcall _read_LCD
	mov R10,R16
	xjmp L85
L84:
	.dbline 390
; 				else ch_r=read_LCD(RIGHT);
	ldi R16,1
	xcall _read_LCD
	mov R10,R16
L85:
	.dbline 391
; 				ch_r&=0xf0;
	mov R24,R10
	andi R24,240
	mov R10,R24
	.dbline 392
; 				ch_w=ASC_16[k].Msk[ASC_CHR_WIDTH+j]&0x0f; 
	ldi R24,17
	mul R24,R20
	movw R2,R0
	ldi R24,<_ASC_16+1
	ldi R25,>_ASC_16+1
	add R2,R24
	adc R3,R25
	mov R30,R12
	clr R31
	adiw R30,8
	add R30,R2
	adc R31,R3
	lpm R30,Z
	andi R30,15
	mov R14,R30
	.dbline 393
; 				ch_w|=ch_r;
	or R14,R10
	.dbline 394
; 				SetPageCol(uPage+1,uCol+j);
	ldd R18,y+1
	add R18,R12
	ldd R16,y+2
	subi R16,255    ; addi 1
	xcall _SetPageCol
	.dbline 395
; 				if(uCol+j<64)	write_LCD(LEFT,DATA,ch_w); 
	ldd R24,y+1
	add R24,R12
	cpi R24,64
	brsh L87
	.dbline 395
	std y+0,R14
	ldi R18,1
	clr R16
	xcall _write_LCD
	xjmp L88
L87:
	.dbline 396
; 				else write_LCD(RIGHT,DATA,ch_w); 
	std y+0,R14
	ldi R18,1
	ldi R16,1
	xcall _write_LCD
L88:
	.dbline 397
L81:
	.dbline 386
	inc R12
L83:
	.dbline 386
	cp R12,R22
	brsh X3
	xjmp L80
X3:
	.dbline 398
; 			}
; 		}
	xjmp L72
L71:
	.dbline 400
; 		else //上半部是写半个字节
; 		{
	.dbline 401
; 			for(j=0;j<width;j++)
	clr R12
	xjmp L92
L89:
	.dbline 402
; 			{
	.dbline 403
; 				SetPageCol(uPage,uCol+j);
	ldd R18,y+1
	add R18,R12
	ldd R16,y+2
	xcall _SetPageCol
	.dbline 404
; 				if(uCol+j<64) ch_r=read_LCD(LEFT);
	ldd R24,y+1
	add R24,R12
	cpi R24,64
	brsh L93
	.dbline 404
	clr R16
	xcall _read_LCD
	mov R10,R16
	xjmp L94
L93:
	.dbline 405
; 				else ch_r=read_LCD(RIGHT);
	ldi R16,1
	xcall _read_LCD
	mov R10,R16
L94:
	.dbline 406
; 				ch_r&=0x0f;
	mov R24,R10
	andi R24,15
	mov R10,R24
	.dbline 407
; 				ch_w=ASC_16[k].Msk[j];
	ldi R24,17
	mul R24,R20
	movw R2,R0
	ldi R24,<_ASC_16+1
	ldi R25,>_ASC_16+1
	add R2,R24
	adc R3,R25
	mov R30,R12
	clr R31
	add R30,R2
	adc R31,R3
	lpm R14,Z
	.dbline 408
; 				ch_w=ch_w<<4;
	mov R24,R14
	andi R24,#0x0F
	swap R24
	mov R14,R24
	.dbline 409
; 				ch_w|=ch_r;
	or R14,R10
	.dbline 410
; 				SetPageCol(uPage,uCol+j);
	ldd R18,y+1
	add R18,R12
	ldd R16,y+2
	xcall _SetPageCol
	.dbline 411
; 				if(uCol+j<64)	write_LCD(LEFT,DATA,ch_w); 
	ldd R24,y+1
	add R24,R12
	cpi R24,64
	brsh L96
	.dbline 411
	std y+0,R14
	ldi R18,1
	clr R16
	xcall _write_LCD
	xjmp L97
L96:
	.dbline 412
; 				else write_LCD(RIGHT,DATA,ch_w); 
	std y+0,R14
	ldi R18,1
	ldi R16,1
	xcall _write_LCD
L97:
	.dbline 413
L90:
	.dbline 401
	inc R12
L92:
	.dbline 401
	cp R12,R22
	brsh X4
	xjmp L89
X4:
	.dbline 414
; 			}
; 			SetPageCol(uPage+1,uCol);
	ldd R18,y+1
	ldd R16,y+2
	subi R16,255    ; addi 1
	xcall _SetPageCol
	.dbline 415
; 			for(j=0;j<width;j++)
	clr R12
	xjmp L101
L98:
	.dbline 416
; 			{
	.dbline 417
; 				SetPageCol(uPage+1,uCol+j);
	ldd R18,y+1
	add R18,R12
	ldd R16,y+2
	subi R16,255    ; addi 1
	xcall _SetPageCol
	.dbline 419
; 				
; 				ch_r=ASC_16[k].Msk[j];
	ldi R24,17
	mul R24,R20
	movw R2,R0
	ldi R24,<_ASC_16+1
	ldi R25,>_ASC_16+1
	add R2,R24
	adc R3,R25
	mov R30,R12
	clr R31
	add R30,R2
	adc R31,R3
	lpm R10,Z
	.dbline 420
; 				ch_w=ASC_16[k].Msk[ASC_CHR_WIDTH+j];
	ldi R24,17
	mul R24,R20
	movw R2,R0
	ldi R24,<_ASC_16+1
	ldi R25,>_ASC_16+1
	add R2,R24
	adc R3,R25
	mov R30,R12
	clr R31
	adiw R30,8
	add R30,R2
	adc R31,R3
	lpm R14,Z
	.dbline 421
; 				ch_r=ch_r>>4;
	mov R24,R10
	swap R24
	andi R24,#0x0F
	mov R10,R24
	.dbline 422
; 				ch_w=ch_w<<4; 
	mov R24,R14
	andi R24,#0x0F
	swap R24
	mov R14,R24
	.dbline 423
; 				ch_w|=ch_r;
	or R14,R10
	.dbline 424
; 				SetPageCol(uPage+1,uCol+j);
	ldd R18,y+1
	add R18,R12
	ldd R16,y+2
	subi R16,255    ; addi 1
	xcall _SetPageCol
	.dbline 425
; 				if(uCol+j<64)	write_LCD(LEFT,DATA,ch_w); 
	ldd R24,y+1
	add R24,R12
	cpi R24,64
	brsh L104
	.dbline 425
	std y+0,R14
	ldi R18,1
	clr R16
	xcall _write_LCD
	xjmp L105
L104:
	.dbline 426
; 				else write_LCD(RIGHT,DATA,ch_w); 
	std y+0,R14
	ldi R18,1
	ldi R16,1
	xcall _write_LCD
L105:
	.dbline 427
L99:
	.dbline 415
	inc R12
L101:
	.dbline 415
	cp R12,R22
	brsh X5
	xjmp L98
X5:
	.dbline 428
; 			}
; 		}
L72:
	.dbline 429
; 	}
L64:
	.dbline 430
; 	SetPageCol(uPage,uCol+width);
	ldd R18,y+1
	add R18,R22
	ldd R16,y+2
	xcall _SetPageCol
	.dbline -2
	.dbline 431
; }
L57:
	adiw R28,3
	xcall pop_gset5
	.dbline 0 ; func end
	ret
	.dbsym r width 22 c
	.dbsym r len 22 c
	.dbsym l uPage 2 c
	.dbsym r ch_r 10 c
	.dbsym l uCol 1 c
	.dbsym r ch_w 14 c
	.dbsym r k 20 c
	.dbsym r j 12 c
	.dbsym r c 10 c
	.dbend
	.dbfunc e disp_hz _disp_hz fV
;          uPage -> y+1
;           ch_r -> R22
;              k -> R10
;           uCol -> R12
;           ch_w -> R14
;              j -> R20
;             hz -> R20,R21
	.even
_disp_hz::
	xcall push_gset5
	movw R20,R16
	sbiw R28,2
	.dbline -1
	.dbline 435
; 
; 
; void disp_hz(unsigned char *hz)
; {
	.dbline 437
; 	unsigned char k,j,uPage,uCol,ch_r,ch_w;
; 	uPage = GetPage();
	xcall _GetPage
	std y+1,R16
	.dbline 438
; 	uCol = GetCol();
	xcall _GetCol
	mov R12,R16
	.dbline 439
; 	for(k=0;k<sizeof(GB_16)/sizeof(GB_16[0]);k++)
	clr R10
	xjmp L110
L107:
	.dbline 440
; 	{
	.dbline 441
; 		if(hz[0] == GB_16[k].Index[0] && hz[1] == GB_16[k].Index[1])
	ldi R24,26
	mul R24,R10
	movw R2,R0
	ldi R24,<_GB_16
	ldi R25,>_GB_16
	movw R30,R2
	add R30,R24
	adc R31,R25
	lpm R30,Z
	movw R26,R20
	ld R4,x
	cp R4,R30
	brne L111
	ldi R24,<_GB_16+1
	ldi R25,>_GB_16+1
	movw R30,R2
	add R30,R24
	adc R31,R25
	lpm R30,Z
	adiw R26,1
	ld R2,x
	cp R2,R30
	brne L111
	.dbline 442
; 			break;
	xjmp L109
L111:
	.dbline 443
L108:
	.dbline 439
	inc R10
L110:
	.dbline 439
	mov R24,R10
	cpi R24,18
	brlo L107
L109:
	.dbline 445
; 	}
; 
; 	if(CurOffset==1) 
	lds R24,_CurOffset
	cpi R24,1
	breq X6
	xjmp L114
X6:
	.dbline 446
; 	{
	.dbline 447
; 	for(j=0;j<ASC_HZ_WIDTH;j++)
	clr R20
	xjmp L119
L116:
	.dbline 448
; 	{
	.dbline 449
; 		SetPageCol(uPage,uCol+j);
	mov R18,R12
	add R18,R20
	ldd R16,y+1
	xcall _SetPageCol
	.dbline 450
; 		ch_w=GB_16[k].Msk[j];
	ldi R24,26
	mul R24,R10
	movw R2,R0
	ldi R24,<_GB_16+2
	ldi R25,>_GB_16+2
	add R2,R24
	adc R3,R25
	mov R30,R20
	clr R31
	add R30,R2
	adc R31,R3
	lpm R14,Z
	.dbline 451
; 		if(uCol+j<64)	write_LCD(LEFT,DATA,ch_w);
	mov R24,R12
	add R24,R20
	cpi R24,64
	brsh L121
	.dbline 451
	std y+0,R14
	ldi R18,1
	clr R16
	xcall _write_LCD
	xjmp L122
L121:
	.dbline 452
; 		else write_LCD(RIGHT,DATA,ch_w);
	std y+0,R14
	ldi R18,1
	ldi R16,1
	xcall _write_LCD
L122:
	.dbline 453
L117:
	.dbline 447
	inc R20
L119:
	.dbline 447
	cpi R20,12
	brlo L116
	.dbline 454
; 	}
; 	SetPageCol(uPage+1,uCol);
	mov R18,R12
	ldd R16,y+1
	subi R16,255    ; addi 1
	xcall _SetPageCol
	.dbline 456
; 
; 	for(j=0;j<ASC_HZ_WIDTH;j++)
	clr R20
	xjmp L126
L123:
	.dbline 457
; 	{
	.dbline 458
; 		SetPageCol(uPage+1,uCol+j);
	mov R18,R12
	add R18,R20
	ldd R16,y+1
	subi R16,255    ; addi 1
	xcall _SetPageCol
	.dbline 459
; 		if(uCol+j<64) ch_r=read_LCD(LEFT);
	mov R24,R12
	add R24,R20
	cpi R24,64
	brsh L127
	.dbline 459
	clr R16
	xcall _read_LCD
	mov R22,R16
	xjmp L128
L127:
	.dbline 460
; 		else ch_r=read_LCD(RIGHT);
	ldi R16,1
	xcall _read_LCD
	mov R22,R16
L128:
	.dbline 461
; 		ch_r&=0xf0;
	andi R22,240
	.dbline 462
; 		ch_w=GB_16[k].Msk[ASC_HZ_WIDTH+j]&0x0f; 
	ldi R24,26
	mul R24,R10
	movw R2,R0
	ldi R24,<_GB_16+2
	ldi R25,>_GB_16+2
	add R2,R24
	adc R3,R25
	mov R30,R20
	clr R31
	adiw R30,12
	add R30,R2
	adc R31,R3
	lpm R30,Z
	andi R30,15
	mov R14,R30
	.dbline 463
; 		ch_w|=ch_r;
	or R14,R22
	.dbline 464
; 		SetPageCol(uPage+1,uCol+j);
	mov R18,R12
	add R18,R20
	ldd R16,y+1
	subi R16,255    ; addi 1
	xcall _SetPageCol
	.dbline 465
; 		if(uCol+j<64)	write_LCD(LEFT,DATA,ch_w); 
	mov R24,R12
	add R24,R20
	cpi R24,64
	brsh L130
	.dbline 465
	std y+0,R14
	ldi R18,1
	clr R16
	xcall _write_LCD
	xjmp L131
L130:
	.dbline 466
; 		else write_LCD(RIGHT,DATA,ch_w);
	std y+0,R14
	ldi R18,1
	ldi R16,1
	xcall _write_LCD
L131:
	.dbline 467
L124:
	.dbline 456
	inc R20
L126:
	.dbline 456
	cpi R20,12
	brsh X7
	xjmp L123
X7:
	.dbline 468
; 	}
; 	SetPageCol(uPage,uCol+ASC_HZ_WIDTH);
	mov R18,R12
	subi R18,244    ; addi 12
	ldd R16,y+1
	xcall _SetPageCol
	.dbline 469
; 	}
	xjmp L115
L114:
	.dbline 472
; 
; 	else //汉字上半部是写半个字节
; 	{
	.dbline 473
; 	for(j=0;j<ASC_HZ_WIDTH;j++)
	clr R20
	xjmp L135
L132:
	.dbline 474
; 	{
	.dbline 475
; 		SetPageCol(uPage,uCol+j);
	mov R18,R12
	add R18,R20
	ldd R16,y+1
	xcall _SetPageCol
	.dbline 476
; 		if(uCol+j<64) ch_r=read_LCD(LEFT);
	mov R24,R12
	add R24,R20
	cpi R24,64
	brsh L136
	.dbline 476
	clr R16
	xcall _read_LCD
	mov R22,R16
	xjmp L137
L136:
	.dbline 477
; 		else ch_r=read_LCD(RIGHT);
	ldi R16,1
	xcall _read_LCD
	mov R22,R16
L137:
	.dbline 478
; 		ch_r&=0x0f;
	andi R22,15
	.dbline 479
; 		ch_w=GB_16[k].Msk[j];
	ldi R24,26
	mul R24,R10
	movw R2,R0
	ldi R24,<_GB_16+2
	ldi R25,>_GB_16+2
	add R2,R24
	adc R3,R25
	mov R30,R20
	clr R31
	add R30,R2
	adc R31,R3
	lpm R14,Z
	.dbline 480
; 		ch_w=ch_w<<4;
	mov R24,R14
	andi R24,#0x0F
	swap R24
	mov R14,R24
	.dbline 481
; 		ch_w|=ch_r;
	or R14,R22
	.dbline 482
; 		SetPageCol(uPage,uCol+j);
	mov R18,R12
	add R18,R20
	ldd R16,y+1
	xcall _SetPageCol
	.dbline 483
; 		if(uCol+j<64)	write_LCD(LEFT,DATA,ch_w); 
	mov R24,R12
	add R24,R20
	cpi R24,64
	brsh L139
	.dbline 483
	std y+0,R14
	ldi R18,1
	clr R16
	xcall _write_LCD
	xjmp L140
L139:
	.dbline 484
; 		else write_LCD(RIGHT,DATA,ch_w); 
	std y+0,R14
	ldi R18,1
	ldi R16,1
	xcall _write_LCD
L140:
	.dbline 485
L133:
	.dbline 473
	inc R20
L135:
	.dbline 473
	cpi R20,12
	brsh X8
	xjmp L132
X8:
	.dbline 486
; 	}
; 	SetPageCol(uPage+1,uCol);
	mov R18,R12
	ldd R16,y+1
	subi R16,255    ; addi 1
	xcall _SetPageCol
	.dbline 487
; 	for(j=0;j<ASC_HZ_WIDTH;j++)
	clr R20
	xjmp L144
L141:
	.dbline 488
; 	{
	.dbline 489
; 		SetPageCol(uPage+1,uCol+j);
	mov R18,R12
	add R18,R20
	ldd R16,y+1
	subi R16,255    ; addi 1
	xcall _SetPageCol
	.dbline 491
; 
; 		ch_r=GB_16[k].Msk[j];
	ldi R24,26
	mul R24,R10
	movw R2,R0
	ldi R24,<_GB_16+2
	ldi R25,>_GB_16+2
	add R2,R24
	adc R3,R25
	mov R30,R20
	clr R31
	add R30,R2
	adc R31,R3
	lpm R22,Z
	.dbline 492
; 		ch_w=GB_16[k].Msk[ASC_HZ_WIDTH+j];
	ldi R24,26
	mul R24,R10
	movw R2,R0
	ldi R24,<_GB_16+2
	ldi R25,>_GB_16+2
	add R2,R24
	adc R3,R25
	mov R30,R20
	clr R31
	adiw R30,12
	add R30,R2
	adc R31,R3
	lpm R14,Z
	.dbline 493
; 		ch_r=ch_r>>4;
	mov R24,R22
	swap R24
	andi R24,#0x0F
	mov R22,R24
	.dbline 494
; 		ch_w=ch_w<<4; 
	mov R24,R14
	andi R24,#0x0F
	swap R24
	mov R14,R24
	.dbline 495
; 		ch_w|=ch_r;
	or R14,R22
	.dbline 496
; 		SetPageCol(uPage+1,uCol+j);
	mov R18,R12
	add R18,R20
	ldd R16,y+1
	subi R16,255    ; addi 1
	xcall _SetPageCol
	.dbline 497
; 		if(uCol+j<64)	write_LCD(LEFT,DATA,ch_w); 
	mov R24,R12
	add R24,R20
	cpi R24,64
	brsh L147
	.dbline 497
	std y+0,R14
	ldi R18,1
	clr R16
	xcall _write_LCD
	xjmp L148
L147:
	.dbline 498
; 		else write_LCD(RIGHT,DATA,ch_w); 
	std y+0,R14
	ldi R18,1
	ldi R16,1
	xcall _write_LCD
L148:
	.dbline 499
L142:
	.dbline 487
	inc R20
L144:
	.dbline 487
	cpi R20,12
	brsh X9
	xjmp L141
X9:
	.dbline 500
	mov R18,R12
	subi R18,244    ; addi 12
	ldd R16,y+1
	xcall _SetPageCol
	.dbline 501
L115:
	.dbline -2
	.dbline 502
; 	}
; 	SetPageCol(uPage,uCol+ASC_HZ_WIDTH);
; 	}
; }
L106:
	adiw R28,2
	xcall pop_gset5
	.dbline 0 ; func end
	ret
	.dbsym l uPage 1 c
	.dbsym r ch_r 22 c
	.dbsym r k 10 c
	.dbsym r uCol 12 c
	.dbsym r ch_w 14 c
	.dbsym r j 20 c
	.dbsym r hz 20 pc
	.dbend
	.dbfunc e disp_str _disp_str fV
;              i -> R20
;              p -> R22,R23
	.even
_disp_str::
	xcall push_gset2
	movw R22,R16
	.dbline -1
	.dbline 505
; 
; void disp_str(unsigned char *p)
; {
	.dbline 506
; 	unsigned char i=0;
	clr R20
	xjmp L151
L150:
	.dbline 508
; 	while(p[i]>0)
; 	{
	.dbline 509
; 		if(p[i] < 128)
	mov R30,R20
	clr R31
	add R30,R22
	adc R31,R23
	ldd R24,z+0
	cpi R24,128
	brsh L153
	.dbline 510
; 		{	/* ASCII */
	.dbline 511
; 			disp_ch(p[i]);
	mov R30,R20
	clr R31
	add R30,R22
	adc R31,R23
	ldd R16,z+0
	xcall _disp_ch
	.dbline 512
; 		}
	xjmp L154
L153:
	.dbline 514
; 		else
; 		{	/* 中文 */
	.dbline 515
; 			disp_hz(&p[i]);
	mov R16,R20
	clr R17
	add R16,R22
	adc R17,R23
	xcall _disp_hz
	.dbline 516
; 			i++;
	inc R20
	.dbline 517
; 		}
L154:
	.dbline 518
	inc R20
	.dbline 519
L151:
	.dbline 507
	mov R30,R20
	clr R31
	add R30,R22
	adc R31,R23
	ldd R2,z+0
	clr R3
	cp R3,R2
	brlo L150
	.dbline -2
	.dbline 520
; 		i++;
; 	}
; }
L149:
	xcall pop_gset2
	.dbline 0 ; func end
	ret
	.dbsym r i 20 c
	.dbsym r p 22 pc
	.dbend
	.dbfunc e pixel _pixel fV
;             ch -> R22,R23
;              y -> R20,R21
;           flag -> R10
;             yy -> R14
;             xx -> R12
	.even
_pixel::
	xcall push_gset5
	mov R14,R18
	mov R12,R16
	sbiw R28,1
	ldd R10,y+11
	.dbline -1
	.dbline 527
; 
; /*************************************/
; /*             绘点函数              */
; /*************************************/
; /* XX--(0-128) YY--(0-63) FLAG=1绘点   FLAG=0 清点 */
; void pixel(unsigned char xx,unsigned char yy,unsigned char flag)
; {
	.dbline 529
; 	unsigned int y,ch;
; 	ch=yy%8;  //余数
	ldi R18,8
	ldi R19,0
	mov R16,R14
	clr R17
	xcall mod16s
	movw R22,R16
	.dbline 531
; 
; 	y=1;
	ldi R20,1
	ldi R21,0
	.dbline 532
; 	for(;ch!=0;)
	xjmp L159
L156:
	.dbline 533
	.dbline 534
	ldi R16,2
	ldi R17,0
	movw R18,R20
	xcall empy16s
	movw R20,R16
	.dbline 535
	subi R22,1
	sbci R23,0
	.dbline 536
L157:
	.dbline 532
L159:
	.dbline 532
	cpi R22,0
	cpc R22,R23
	brne L156
X10:
	.dbline 537
; 		{
; 			y=y*2;
; 			ch--;
; 		}
; 	if(xx<64)
	mov R24,R12
	cpi R24,64
	brsh L160
	.dbline 538
; 		{
	.dbline 539
; 			set_page_L(yy/8);
	mov R16,R14
	lsr R16
	lsr R16
	lsr R16
	xcall _set_page_L
	.dbline 540
; 			set_col_addr_L(xx);	
	mov R16,R12
	xcall _set_col_addr_L
	.dbline 541
; 			ch=read_LCD(LEFT);
	clr R16
	xcall _read_LCD
	mov R22,R16
	clr R23
	.dbline 542
; 			set_col_addr_L(xx);
	mov R16,R12
	xcall _set_col_addr_L
	.dbline 543
; 			if(flag)
	tst R10
	breq L162
	.dbline 544
; 				write_LCD(LEFT,DATA,ch|y);
	movw R2,R22
	or R2,R20
	or R3,R21
	std y+0,R2
	ldi R18,1
	clr R16
	xcall _write_LCD
	xjmp L161
L162:
	.dbline 546
; 			else
; 			{
	.dbline 547
; 				y=~y;
	com R20
	com R21
	.dbline 548
; 				ch&=y;
	and R22,R20
	and R23,R21
	.dbline 549
; 				write_LCD(LEFT,DATA,ch|y);
	movw R2,R22
	or R2,R20
	or R3,R21
	std y+0,R2
	ldi R18,1
	clr R16
	xcall _write_LCD
	.dbline 550
; 			}
	.dbline 551
; 		}
	xjmp L161
L160:
	.dbline 553
; 	else
; 		{
	.dbline 554
; 			set_page_R(yy/8);
	mov R16,R14
	lsr R16
	lsr R16
	lsr R16
	xcall _set_page_R
	.dbline 555
; 			set_col_addr_R(xx-64);	
	mov R16,R12
	subi R16,64
	xcall _set_col_addr_R
	.dbline 556
; 			ch=read_LCD(RIGHT);
	ldi R16,1
	xcall _read_LCD
	mov R22,R16
	clr R23
	.dbline 557
; 			set_col_addr_R(xx-64);	
	mov R16,R12
	subi R16,64
	xcall _set_col_addr_R
	.dbline 558
; 			if(flag)
	tst R10
	breq L164
	.dbline 559
; 				write_LCD(RIGHT,DATA,ch|y);
	movw R2,R22
	or R2,R20
	or R3,R21
	std y+0,R2
	ldi R18,1
	ldi R16,1
	xcall _write_LCD
	xjmp L165
L164:
	.dbline 561
; 			else
; 			{
	.dbline 562
; 				y=~y;
	com R20
	com R21
	.dbline 563
; 				ch&=y;
	and R22,R20
	and R23,R21
	.dbline 564
; 				write_LCD(RIGHT,DATA,ch|y);
	movw R2,R22
	or R2,R20
	or R3,R21
	std y+0,R2
	ldi R18,1
	ldi R16,1
	xcall _write_LCD
	.dbline 565
; 			}
L165:
	.dbline 566
L161:
	.dbline -2
	.dbline 567
; 		}
; }
L155:
	adiw R28,1
	xcall pop_gset5
	.dbline 0 ; func end
	ret
	.dbsym r ch 22 i
	.dbsym r y 20 i
	.dbsym r flag 10 c
	.dbsym r yy 14 c
	.dbsym r xx 12 c
	.dbend
	.dbfunc e Linexy _Linexy fV
;           incy -> y+9
;           incx -> y+7
;        delta_y -> y+5
;        delta_x -> y+3
;           uCol -> y+1
;           uRow -> R20,R21
;           yerr -> R22,R23
;           xerr -> R10,R11
;       distance -> R12,R13
;              t -> R14
;              s -> y+25
;             yt -> y+23
;             xt -> y+21
;             y0 -> R12
;             x0 -> R20
	.even
_Linexy::
	xcall push_gset5
	mov R12,R18
	mov R20,R16
	sbiw R28,11
	.dbline -1
	.dbline 693
; /*void point(void) 
; { 
;    uchar   x1, y1, y; 
; 
;    x1 = CurCol; 
;    y1 = CurRow; 
;    CurRow = y1 >> 3;      //取Y方向分页地址   
;    Rddata();               // get cbyte on screen 
;    y = y1 & 0x07;     //字节内位置计算  
;    Wrdata(cbyte | (1 << y));   //画上屏幕    /
;    CurCol = x1;         ///恢复xy坐标     /
;    CurRow = y1; 
; } */
; 
; /************************************************/ 
; /*画圆。数学方程(X-Ox)^2+(Y-Oy)^2=Rx^2      */ 
; /************************************************/ 
; 
; /*void circle(uchar Ox, uchar Oy, uchar Rx) 
; { 
;    unsigned int xx, rr, xt, yt, rs; 
;     
;     yt = Rx; 
;    rr = Rx * Rx + 1;         //补偿 1 修正方形 
;    rs = (yt + (yt >> 1)) >> 1;      //(*0.75)分开1/8圆弧来画 
;    for (xt = 0; xt <= rs; xt++) 
;    { 
;       xx = xt * xt; 
;       while ((yt * yt) > (rr - xx)) 
;             yt--; 
;       col = Ox + xt;      //第一象限 
;       row=Oy-yt; 
;       point(); 
;       col = Ox - xt;      //第二象限 
;       point(); 
;       row = Oy + yt;      //第三象限 
;       point(); 
;       col = Ox + xt;      //第四象限 
;       point(); 
; 
; // ***************45度镜象画另一半*************** 
; 
;       col = Ox + yt;      //第一象限 
;       row = Oy - xt; 
;       point(); 
;       col = Ox - yt;      //第二象限 
;       point(); 
;       row = Oy + xt;      //第三象限 
;       point(); 
;       col = Ox + yt;      //第四象限 
;       point(); 
;    } 
; } 
; */
;              
; /************************************************/ 
; /*画线。任意方向的斜线,直线数学方程 aX+bY=1   */ 
; /************************************************/ 
; 
; /*void Linexy(uchar x0,uchar y0,uchar xt,uchar yt) 
; { 
;    uchar t; 
;    int xerr = 0, yerr = 0, delta_x, delta_y, distance; 
;    int incx, incy; 
; 
;    delta_x = xt - x0;            // 计算坐标增量 
;    delta_y = yt - y0; 
;    col = x0; 
;    row = y0; 
;     
;     if (delta_x > 0)  
;     { 
;         incx = 1;         // 水平+方向 
;     } 
;    else if (delta_x == 0 )  
;         { 
;             incx = 0;      // 垂直线 
;         } 
;       else  
;         { 
;             incx =- 1;  //水平负方向 
;             delta_x =- delta_x; 
;         } 
;      
;    if (delta_y > 0)  
;     { 
;         incy = 1;       // 垂直+方向 
;     } 
;    else  
;         if (delta_y == 0)  
;         { 
;             incy = 0;      // 水平线 
;         } 
;       else  
;         { 
;             incy =- 1;      //垂直-方向 
;             delta_y =- delta_y; 
;         } 
;   
; 
;    if (delta_x > delta_y)    
;         distance = delta_x; //选取基本增量坐标轴 
;    else  
;         distance = delta_y; 
; 
;    for (t = 0; t <= distance + 1; t++)    
;     {   // 画线输出 
;       point();         // 画点 
;       xerr +=   delta_x; 
;       yerr +=   delta_y; 
;        
;       if (xerr > distance)  
;         { 
;          xerr -= distance; 
;          col += incx; 
;       } 
;       if (yerr > distance)  
;         { 
;          yerr -= distance; 
;          row += incy; 
;       } 
;    } 
; } 
; */
; void Linexy(uchar x0,uchar y0,uchar xt,uchar yt,uchar s)
; {
	.dbline 695
; 	register uchar t;
; 	int xerr=0,yerr=0,delta_x,delta_y,distance;
	clr R10
	clr R11
	.dbline 695
	clr R22
	clr R23
	.dbline 698
; 	int incx,incy,uRow,uCol;
; 
; 	delta_x = xt-x0;				//计算坐标增量
	mov R2,R20
	clr R3
	ldd R4,y+21
	clr R5
	sub R4,R2
	sbc R5,R3
	std y+4,R5
	std y+3,R4
	.dbline 699
; 	delta_y = yt-y0;
	mov R2,R12
	clr R3
	ldd R4,y+23
	clr R5
	sub R4,R2
	sbc R5,R3
	std y+6,R5
	std y+5,R4
	.dbline 700
; 	uRow = x0;
	clr R21
	.dbline 701
; 	uCol = y0;
	clr R3
	std y+2,R3
	std y+1,R2
	.dbline 702
; 	if(delta_x>0) incx=1;				//设置单步方向
	clr R2
	ldd R4,y+3
	ldd R5,y+4
	cp R2,R4
	cpc R3,R5
	brge L167
	.dbline 702
	ldi R24,1
	ldi R25,0
	std y+8,R25
	std y+7,R24
	xjmp L168
L167:
	.dbline 703
; 	else if( delta_x==0 ) incx=0;			//垂直线
	ldd R2,y+3
	ldd R3,y+4
	tst R2
	brne L169
	tst R3
	brne L169
X11:
	.dbline 703
	clr R2
	clr R3
	std y+8,R3
	std y+7,R2
	xjmp L170
L169:
	.dbline 704
; 		else {incx=-1;delta_x=-delta_x;}
	.dbline 704
	ldi R24,-1
	ldi R25,-1
	std y+8,R25
	std y+7,R24
	.dbline 704
	ldd R24,y+3
	ldd R25,y+4
	com R24
	com R25
	subi R24,0xFF
	sbci R25,0xFF
	std y+4,R25
	std y+3,R24
	.dbline 704
L170:
L168:
	.dbline 706
; 
; 	if(delta_y>0) incy=1;
	clr R2
	clr R3
	ldd R4,y+5
	ldd R5,y+6
	cp R2,R4
	cpc R3,R5
	brge L171
	.dbline 706
	ldi R24,1
	ldi R25,0
	std y+10,R25
	std y+9,R24
	xjmp L172
L171:
	.dbline 707
; 	else if( delta_y==0 ) incy=0;			//水平线
	ldd R2,y+5
	ldd R3,y+6
	tst R2
	brne L173
	tst R3
	brne L173
X12:
	.dbline 707
	clr R2
	clr R3
	std y+10,R3
	std y+9,R2
	xjmp L174
L173:
	.dbline 708
; 		else {incy=-1;delta_y=-delta_y;}
	.dbline 708
	ldi R24,-1
	ldi R25,-1
	std y+10,R25
	std y+9,R24
	.dbline 708
	ldd R24,y+5
	ldd R25,y+6
	com R24
	com R25
	subi R24,0xFF
	sbci R25,0xFF
	std y+6,R25
	std y+5,R24
	.dbline 708
L174:
L172:
	.dbline 710
; 
; 	if( delta_x > delta_y )	distance=delta_x;	//选取基本增量坐标轴
	ldd R2,y+5
	ldd R3,y+6
	ldd R4,y+3
	ldd R5,y+4
	cp R2,R4
	cpc R3,R5
	brge L175
	.dbline 710
	movw R12,R4
	xjmp L176
L175:
	.dbline 711
; 	else distance=delta_y;
	ldd R12,y+5
	ldd R13,y+6
L176:
	.dbline 713
; 
; 	for( t=0;t <= distance+1; t++ )
	clr R14
	xjmp L180
L177:
	.dbline 714
;         	{					//画线输出
	.dbline 715
; 		pixel(uRow,uCol,s);			//画点
	ldd R0,y+25
	std y+0,R0
	ldd R18,y+1
	mov R16,R20
	xcall _pixel
	.dbline 716
; 		xerr +=	delta_x	;
	ldd R2,y+3
	ldd R3,y+4
	add R10,R2
	adc R11,R3
	.dbline 717
; 		yerr +=	delta_y	;
	ldd R2,y+5
	ldd R3,y+6
	add R22,R2
	adc R23,R3
	.dbline 719
; 		
; 		if( xerr > distance )
	cp R12,R10
	cpc R13,R11
	brge L181
	.dbline 720
;                 	{
	.dbline 721
; 			xerr-=distance;
	sub R10,R12
	sbc R11,R13
	.dbline 722
; 			uRow+=incx;
	ldd R2,y+7
	ldd R3,y+8
	add R20,R2
	adc R21,R3
	.dbline 723
; 			}
L181:
	.dbline 724
; 		if( yerr > distance )
	cp R12,R22
	cpc R13,R23
	brge L183
	.dbline 725
;                 	{
	.dbline 726
; 			yerr-=distance;
	sub R22,R12
	sbc R23,R13
	.dbline 727
; 			uCol+=incy;
	ldd R2,y+9
	ldd R3,y+10
	ldd R4,y+1
	ldd R5,y+2
	add R4,R2
	adc R5,R3
	std y+2,R5
	std y+1,R4
	.dbline 728
; 			}
L183:
	.dbline 729
L178:
	.dbline 713
	inc R14
L180:
	.dbline 713
	movw R24,R12
	adiw R24,1
	mov R2,R14
	clr R3
	cp R24,R2
	cpc R25,R3
	brge L177
	.dbline -2
	.dbline 730
; 		}
; }
L166:
	adiw R28,11
	xcall pop_gset5
	.dbline 0 ; func end
	ret
	.dbsym l incy 9 I
	.dbsym l incx 7 I
	.dbsym l delta_y 5 I
	.dbsym l delta_x 3 I
	.dbsym l uCol 1 I
	.dbsym r uRow 20 I
	.dbsym r yerr 22 I
	.dbsym r xerr 10 I
	.dbsym r distance 12 I
	.dbsym r t 14 c
	.dbsym l s 25 c
	.dbsym l yt 23 c
	.dbsym l xt 21 c
	.dbsym r y0 12 c
	.dbsym r x0 20 c
	.dbend
	.dbfunc e circle _circle fV
;             rs -> y+1
;             xt -> R20,R21
;             rr -> R22,R23
;             xx -> R14,R15
;            col -> R12,R13
;            row -> R10,R11
;             yt -> y+3
;              s -> y+21
;             Rx -> y+19
;             Oy -> y+17
;             Ox -> y+15
	.even
_circle::
	xcall push_arg4
	xcall push_gset5
	sbiw R28,5
	.dbline -1
	.dbline 736
; 
; /************************************************/
; /*画圆。数学方程(X-Ox)^2+(Y-Oy)^2=Rx^2			*/
; /************************************************/
; void circle(uchar Ox,uchar Oy,uchar Rx,uchar s)
; {
	.dbline 738
; 	unsigned int xx,rr,xt,yt,rs,row,col;
; 	yt=Rx;
	ldd R2,y+19
	clr R3
	std y+4,R3
	std y+3,R2
	.dbline 739
; 	rr=Rx*Rx+1;			//补偿 1 修正方形
	ldd R0,y+19
	mov R16,R0
	mul R0,R16
	movw R22,R0
	subi R22,255  ; offset = 1
	sbci R23,255
	.dbline 740
; 	rs=(yt+(yt>>1))>>1;		//(*0.75)分开1/8圆弧来画
	lsr R3
	ror R2
	ldd R4,y+3
	ldd R5,y+4
	add R4,R2
	adc R5,R3
	lsr R5
	ror R4
	std y+2,R5
	std y+1,R4
	.dbline 741
; 	for (xt=0;xt<=rs;xt++)
	clr R20
	clr R21
	xjmp L189
L186:
	.dbline 742
; 	{
	.dbline 743
; 		xx=xt*xt;
	movw R18,R20
	movw R16,R20
	xcall empy16s
	movw R14,R16
	xjmp L191
L190:
	.dbline 744
	ldd R24,y+3
	ldd R25,y+4
	sbiw R24,1
	std y+4,R25
	std y+3,R24
L191:
	.dbline 744
	movw R2,R22
	sub R2,R14
	sbc R3,R15
	ldd R18,y+3
	ldd R19,y+4
	movw R16,R18
	xcall empy16s
	cp R2,R16
	cpc R3,R17
	brlo L190
	.dbline 745
	ldd R10,y+15
	clr R11
	add R10,R20
	adc R11,R21
	.dbline 746
	ldd R12,y+17
	clr R13
	ldd R0,y+3
	ldd R1,y+4
	sub R12,R0
	sbc R13,R1
	.dbline 747
	ldd R0,y+21
	std y+0,R0
	mov R18,R12
	mov R16,R10
	xcall _pixel
	.dbline 748
	ldd R10,y+15
	clr R11
	sub R10,R20
	sbc R11,R21
	.dbline 749
	ldd R0,y+21
	std y+0,R0
	mov R18,R12
	mov R16,R10
	xcall _pixel
	.dbline 750
	ldd R12,y+17
	clr R13
	ldd R0,y+3
	ldd R1,y+4
	add R12,R0
	adc R13,R1
	.dbline 751
	ldd R0,y+21
	std y+0,R0
	mov R18,R12
	mov R16,R10
	xcall _pixel
	.dbline 752
	ldd R10,y+15
	clr R11
	add R10,R20
	adc R11,R21
	.dbline 753
	ldd R0,y+21
	std y+0,R0
	mov R18,R12
	mov R16,R10
	xcall _pixel
	.dbline 757
	ldd R10,y+15
	clr R11
	ldd R0,y+3
	ldd R1,y+4
	add R10,R0
	adc R11,R1
	.dbline 758
	ldd R12,y+17
	clr R13
	sub R12,R20
	sbc R13,R21
	.dbline 759
	ldd R0,y+21
	std y+0,R0
	mov R18,R12
	mov R16,R10
	xcall _pixel
	.dbline 760
	ldd R10,y+15
	clr R11
	ldd R0,y+3
	ldd R1,y+4
	sub R10,R0
	sbc R11,R1
	.dbline 761
	ldd R0,y+21
	std y+0,R0
	mov R18,R12
	mov R16,R10
	xcall _pixel
	.dbline 762
	ldd R12,y+17
	clr R13
	add R12,R20
	adc R13,R21
	.dbline 763
	ldd R0,y+21
	std y+0,R0
	mov R18,R12
	mov R16,R10
	xcall _pixel
	.dbline 764
	ldd R10,y+15
	clr R11
	ldd R0,y+3
	ldd R1,y+4
	add R10,R0
	adc R11,R1
	.dbline 765
	ldd R0,y+21
	std y+0,R0
	mov R18,R12
	mov R16,R10
	xcall _pixel
	.dbline 766
L187:
	.dbline 741
	subi R20,255  ; offset = 1
	sbci R21,255
L189:
	.dbline 741
	ldd R2,y+1
	ldd R3,y+2
	cp R2,R20
	cpc R3,R21
	brlo X13
	xjmp L186
X13:
	.dbline -2
	.dbline 767
; 		while ((yt*yt)>(rr-xx))yt--;
; 		row=Ox+xt;		//第一象限
; 		col=Oy-yt;
; 		pixel(row,col,s);
; 		row=Ox-xt;		//第二象限
; 		pixel(row,col,s);
; 		col=Oy+yt;		//第三象限
; 		pixel(row,col,s);
; 		row=Ox+xt;		//第四象限
; 		pixel(row,col,s);
; 
; /***************45度镜象画另一半***************/
; 
; 		row=Ox+yt;		//第一象限
; 		col=Oy-xt;
; 		pixel(row,col,s);
; 		row=Ox-yt;		//第二象限
; 		pixel(row,col,s);
; 		col=Oy+xt;		//第三象限
; 		pixel(row,col,s);
; 		row=Ox+yt;		//第四象限
; 		pixel(row,col,s);
; 	}
; }
L185:
	adiw R28,5
	xcall pop_gset5
	adiw R28,4
	.dbline 0 ; func end
	ret
	.dbsym l rs 1 i
	.dbsym r xt 20 i
	.dbsym r rr 22 i
	.dbsym r xx 14 i
	.dbsym r col 12 i
	.dbsym r row 10 i
	.dbsym l yt 3 i
	.dbsym l s 21 c
	.dbsym l Rx 19 c
	.dbsym l Oy 17 c
	.dbsym l Ox 15 c
	.dbend
	.dbfunc e delay _delay fV
;              j -> R10,R11
;              i -> R12,R13
;             tt -> R16,R17
	.even
_delay::
	xcall push_gset4
	.dbline -1
	.dbline 769
; void delay(int tt)
; {
	xjmp L195
L194:
	.dbline 773
;  	 int i;
; 	 int j;
; 	 while((j++)>1000000)	
; 	 {
	.dbline 774
; 	     for(i=0;i<tt;i++)
	clr R12
	clr R13
	xjmp L200
L197:
	.dbline 775
	.dbline 776
	nop
	.dbline 777
L198:
	.dbline 774
	movw R24,R12
	adiw R24,1
	movw R12,R24
L200:
	.dbline 774
	cp R12,R16
	cpc R13,R17
	brlt L197
	.dbline 778
L195:
	.dbline 772
	movw R2,R10
	movw R24,R2
	adiw R24,1
	movw R10,R24
	ldi R20,64
	ldi R21,66
	ldi R22,15
	ldi R23,0
	clr R4
	sbrc R3,7
	com R4
	clr R5
	sbrc R4,7
	com R5
	cp R20,R2
	cpc R21,R3
	cpc R22,R4
	cpc R23,R5
	brlt L194
	.dbline -2
	.dbline 779
; 	     {
; 	         _NOP();
; 	     }	 
; 	}
; }
L193:
	xcall pop_gset4
	.dbline 0 ; func end
	ret
	.dbsym r j 10 I
	.dbsym r i 12 I
	.dbsym r tt 16 I
	.dbend
	.dbfunc e init_port _init_port fV
	.even
_init_port::
	.dbline -1
	.dbline 782
; 
; void init_port(void)
; {
	.dbline 785
; // DDRA   = 0xFF;
; // PORTA  = 0x00;
;  DDRB     = 0xF0;
	ldi R24,240
	out 0x17,R24
	.dbline 786
;  PORTB    = 0xFF;
	ldi R24,255
	out 0x18,R24
	.dbline 787
;  DDRC     = 0xFD;
	ldi R24,253
	out 0x14,R24
	.dbline 788
;  PORTC    = 0x00;
	clr R2
	out 0x15,R2
	.dbline 789
;  DDRD     = 0xFE;
	ldi R24,254
	out 0x11,R24
	.dbline 790
;  PORTD    = 0xFF;
	ldi R24,255
	out 0x12,R24
	.dbline -2
	.dbline 791
; }
L201:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e main _main fV
;              i -> R20,R21
	.even
_main::
	sbiw R28,3
	.dbline -1
	.dbline 794
;  
; void main() 
; { 
	.dbline 796
; unsigned int i;
; init_port();//自己加,主要是控制线所在端口为输出
	xcall _init_port
	.dbline 797
; init_lcd(); 
	xcall _init_lcd
	.dbline 799
; 
; SetRowCol(1,0);
	clr R18
	ldi R16,1
	xcall _SetRowCol
	.dbline 800
; disp_str("液晶显示的第1行");
	ldi R16,<L203
	ldi R17,>L203
	xcall _disp_str
	.dbline 801
; SetRowCol(2,0);
	clr R18
	ldi R16,2
	xcall _SetRowCol
	.dbline 802
; disp_str("液晶显示的第2行");
	ldi R16,<L204
	ldi R17,>L204
	xcall _disp_str
	.dbline 803
; SetRowCol(3,0);
	clr R18
	ldi R16,3
	xcall _SetRowCol
	.dbline 804
; disp_str("液晶显示的第3行");
	ldi R16,<L205
	ldi R17,>L205
	xcall _disp_str
	.dbline 805
; SetRowCol(4,0);
	clr R18
	ldi R16,4
	xcall _SetRowCol
	.dbline 806
; disp_str("液晶显示的第4行");
	ldi R16,<L206
	ldi R17,>L206
	xcall _disp_str
	.dbline 807
; SetRowCol(5,0);
	clr R18
	ldi R16,5
	xcall _SetRowCol
	.dbline 808
; disp_str("液晶显示的第5行");
	ldi R16,<L207
	ldi R17,>L207
	xcall _disp_str
	.dbline 809
; clr_lcd();
	xcall _clr_lcd
	.dbline 810
	clr R20
	clr R21
	xjmp L211
L208:
	.dbline 810
	ldi R24,1
	std y+0,R24
	mov R18,R20
	ldi R16,127
	xcall _pixel
L209:
	.dbline 810
	subi R20,255  ; offset = 1
	sbci R21,255
L211:
	.dbline 810
; for(i=0;i<64;i++) pixel(127,i,1);
	cpi R20,64
	ldi R30,0
	cpc R21,R30
	brlo L208
	.dbline 811
	clr R20
	clr R21
	xjmp L215
L212:
	.dbline 811
	ldi R24,1
	std y+0,R24
	mov R18,R20
	clr R16
	xcall _pixel
L213:
	.dbline 811
	subi R20,255  ; offset = 1
	sbci R21,255
L215:
	.dbline 811
; for(i=0;i<64;i++) pixel(0,i,1);
	cpi R20,64
	ldi R30,0
	cpc R21,R30
	brlo L212
	.dbline 812
	clr R20
	clr R21
	xjmp L219
L216:
	.dbline 812
	ldi R24,1
	std y+0,R24
	clr R18
	mov R16,R20
	xcall _pixel
L217:
	.dbline 812
	subi R20,255  ; offset = 1
	sbci R21,255
L219:
	.dbline 812
; for(i=0;i<128;i++) pixel(i,0,1);
	cpi R20,128
	ldi R30,0
	cpc R21,R30
	brlo L216
	.dbline 813
	clr R20
	clr R21
	xjmp L223
L220:
	.dbline 813
	ldi R24,1
	std y+0,R24
	ldi R18,63
	mov R16,R20
	xcall _pixel
L221:
	.dbline 813
	subi R20,255  ; offset = 1
	sbci R21,255
L223:
	.dbline 813
; for(i=0;i<128;i++) pixel(i,63,1);
	cpi R20,128
	ldi R30,0
	cpc R21,R30
	brlo L220
	.dbline 814
; for(i=0;i<40;i++)
	clr R20
	clr R21
	xjmp L227
L224:
	.dbline 815
	.dbline 816
	ldi R24,1
	std y+2,R24
	std y+0,R20
	ldi R18,45
	ldi R16,20
	xcall _circle
	.dbline 817
L225:
	.dbline 814
	subi R20,255  ; offset = 1
	sbci R21,255
L227:
	.dbline 814
	cpi R20,40
	ldi R30,0
	cpc R21,R30
	brlo L224
L228:
	.dbline 818
L229:
	.dbline 818
	xjmp L228
X14:
	.dbline -2
	.dbline 821
; {
; circle(20,45,i,1);				// 画圆
; }
; while(1);
; 
; 
; } 
L202:
	adiw R28,3
	.dbline 0 ; func end
	ret
	.dbsym r i 20 i
	.dbend
	.area bss(ram, con, rel)
	.dbfile E:\PROTEU~1.7\User\MEGA32-LCM\MEGA32-LCM\DISPLAY.C
_CurCol::
	.blkb 1
	.dbsym e CurCol _CurCol c
_CurPage::
	.blkb 1
	.dbsym e CurPage _CurPage c
_CurRow::
	.blkb 1
	.dbsym e CurRow _CurRow c
_CurOffset::
	.blkb 1
	.dbsym e CurOffset _CurOffset c
	.area data(ram, con, rel)
	.dbfile E:\PROTEU~1.7\User\MEGA32-LCM\MEGA32-LCM\DISPLAY.C
L207:
	.blkb 16
	.area idata
	.byte 210,186,190,167,207,212,202,190,181,196,181,218,53,208,208,0
	.area data(ram, con, rel)
	.dbfile E:\PROTEU~1.7\User\MEGA32-LCM\MEGA32-LCM\DISPLAY.C
L206:
	.blkb 16
	.area idata
	.byte 210,186,190,167,207,212,202,190,181,196,181,218,52,208,208,0
	.area data(ram, con, rel)
	.dbfile E:\PROTEU~1.7\User\MEGA32-LCM\MEGA32-LCM\DISPLAY.C
L205:
	.blkb 16
	.area idata
	.byte 210,186,190,167,207,212,202,190,181,196,181,218,51,208,208,0
	.area data(ram, con, rel)
	.dbfile E:\PROTEU~1.7\User\MEGA32-LCM\MEGA32-LCM\DISPLAY.C
L204:
	.blkb 16
	.area idata
	.byte 210,186,190,167,207,212,202,190,181,196,181,218,50,208,208,0
	.area data(ram, con, rel)
	.dbfile E:\PROTEU~1.7\User\MEGA32-LCM\MEGA32-LCM\DISPLAY.C
L203:
	.blkb 16
	.area idata
	.byte 210,186,190,167,207,212,202,190,181,196,181,218,49,208,208,0
	.area data(ram, con, rel)
	.dbfile E:\PROTEU~1.7\User\MEGA32-LCM\MEGA32-LCM\DISPLAY.C
