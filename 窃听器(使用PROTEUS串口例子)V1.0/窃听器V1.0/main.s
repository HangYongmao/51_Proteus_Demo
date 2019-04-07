	.module main.c
	.area data(ram, con, rel)
_PhoneNum::
	.blkb 12
	.area idata
	.byte 49,51,55,49,51,53,50,54,52,55,50,0
	.area data(ram, con, rel)
	.dbfile D:\MyProject\SMS-MC55\Code\窃听器delay/var.h
	.dbsym e PhoneNum _PhoneNum A[12:12]c
_RxIndexTail::
	.blkb 1
	.area idata
	.byte 0
	.area data(ram, con, rel)
	.dbfile D:\MyProject\SMS-MC55\Code\窃听器delay/var.h
	.dbsym e RxIndexTail _RxIndexTail c
_RxStatus:
	.blkb 1
	.area idata
	.byte 0
	.area data(ram, con, rel)
	.dbfile D:\MyProject\SMS-MC55\Code\窃听器delay/var.h
	.dbsym s RxStatus _RxStatus c
_TxStatus:
	.blkb 1
	.area idata
	.byte 1
	.area data(ram, con, rel)
	.dbfile D:\MyProject\SMS-MC55\Code\窃听器delay/var.h
	.dbsym s TxStatus _TxStatus c
_OkFlag:
	.blkb 1
	.area idata
	.byte 0
	.area data(ram, con, rel)
	.dbfile D:\MyProject\SMS-MC55\Code\窃听器delay/var.h
	.dbsym s OkFlag _OkFlag c
_CallInFlag:
	.blkb 1
	.area idata
	.byte 0
	.area data(ram, con, rel)
	.dbfile D:\MyProject\SMS-MC55\Code\窃听器delay/var.h
	.dbsym s CallInFlag _CallInFlag c
_NoCarrierFlag:
	.blkb 1
	.area idata
	.byte 0
	.area data(ram, con, rel)
	.dbfile D:\MyProject\SMS-MC55\Code\窃听器delay/var.h
	.dbsym s NoCarrierFlag _NoCarrierFlag c
_BusyFlag:
	.blkb 1
	.area idata
	.byte 0
	.area data(ram, con, rel)
	.dbfile D:\MyProject\SMS-MC55\Code\窃听器delay/var.h
	.dbsym s BusyFlag _BusyFlag c
_DettqFlag:
	.blkb 1
	.area idata
	.byte 0
	.area data(ram, con, rel)
	.dbfile D:\MyProject\SMS-MC55\Code\窃听器delay/var.h
	.dbsym s DettqFlag _DettqFlag c
_release:
	.blkb 1
	.area idata
	.byte 0
	.area data(ram, con, rel)
	.dbfile D:\MyProject\SMS-MC55\Code\窃听器delay/var.h
	.dbsym s release _release c
_CallOut:
	.blkb 1
	.area idata
	.byte 0
	.area data(ram, con, rel)
	.dbfile D:\MyProject\SMS-MC55\Code\窃听器delay/var.h
	.dbsym s CallOut _CallOut c
_error:
	.blkb 1
	.area idata
	.byte 0
	.area data(ram, con, rel)
	.dbfile D:\MyProject\SMS-MC55\Code\窃听器delay/var.h
	.dbsym s error _error c
_PhoneNumData:
	.blkb 1
	.area idata
	.byte 0
	.area data(ram, con, rel)
	.dbfile D:\MyProject\SMS-MC55\Code\窃听器delay/var.h
	.dbsym s PhoneNumData _PhoneNumData c
	.area lit(rom, con, rel)
_At::
	.byte 'A,'T,0
	.dbsym e At _At A[3:3]kc
_Ata::
	.byte 'A,'T,'A,0
	.dbsym e Ata _Ata A[4:4]kc
_Ath::
	.byte 'A,'T,'H,0
	.dbsym e Ath _Ath A[4:4]kc
_Ate0::
	.byte 'A,'T,'E,48,0
	.dbsym e Ate0 _Ate0 A[5:5]kc
_Atv0::
	.byte 'A,'T,'V,48,0
	.dbsym e Atv0 _Atv0 A[5:5]kc
_Atx0::
	.byte 'A,'T,'X,48,0
	.dbsym e Atx0 _Atx0 A[5:5]kc
_Atf::
	.byte 'A,'T,38,'F,0
	.dbsym e Atf _Atf A[5:5]kc
_Atclip::
	.byte 'A,'T,43,'C,'L,'I,'P,61,49,0
	.dbsym e Atclip _Atclip A[10:10]kc
_Atcsq::
	.byte 'A,'T,43,'C,'S,'Q,0
	.dbsym e Atcsq _Atcsq A[7:7]kc
_Atssyn::
	.byte 'A,'T,94,'S,'S,'Y,'N,'C,61,49,0
	.dbsym e Atssyn _Atssyn A[11:11]kc
_Atsmso::
	.byte 'A,'T,94,'S,'M,'S,'O,0
	.dbsym e Atsmso _Atsmso A[8:8]kc
_Atsnfs::
	.byte 'A,'T,94,'S,'N,'F,'S,61,52,0
	.dbsym e Atsnfs _Atsnfs A[10:10]kc
_Atsnfi::
	.byte 'A,'T,94,'S,'N,'F,'I,61,52,44,51,50,55,54,55,0
	.dbsym e Atsnfi _Atsnfi A[16:16]kc
_Atcnmi::
	.byte 'A,'T,43,'C,'N,'M,'I,61,49,44,49,44,48,44,48,44
	.byte 49,0
	.dbsym e Atcnmi _Atcnmi A[18:18]kc
_Atsnfo::
	.byte 'A,'T,94,'S,'N,'F,'O,61,51,44,49,54,51,56,52,44
	.byte 49,54,51,56,52,44,49,54,51,56,52,44,49,54,51,56
	.byte 52,44,49,54,51,56,52,44,52,44,48,0
	.dbsym e Atsnfo _Atsnfo A[44:44]kc
_Atcmgf::
	.byte 'A,'T,43,'C,'M,'G,'F,61,48,0
	.dbsym e Atcmgf _Atcmgf A[10:10]kc
_Atcmgs::
	.byte 'A,'T,43,'C,'M,'G,'S,61,0
	.dbsym e Atcmgs _Atcmgs A[9:9]kc
_Atcmgr::
	.byte 'A,'T,43,'C,'M,'G,'R,61,49,0
	.dbsym e Atcmgr _Atcmgr A[10:10]kc
_Atcmgl::
	.byte 'A,'T,43,'C,'M,'G,'L,61,48,0
	.dbsym e Atcmgl _Atcmgl A[10:10]kc
_Atcmgd::
	.byte 'A,'T,43,'C,'M,'G,'D,61,0
	.dbsym e Atcmgd _Atcmgd A[9:9]kc
_Atsnfpt::
	.byte 'A,'T,94,'S,'N,'F,'P,'T,61,48,0
	.dbsym e Atsnfpt _Atsnfpt A[11:11]kc
_Atclck1::
	.byte 'A,'T,43,'C,'L,'C,'K,61,34,'S,'C,34,44,49,44,0
	.dbsym e Atclck1 _Atclck1 A[16:16]kc
_Atcpin::
	.byte 'A,'T,43,'C,'P,'I,'N,63,0
	.dbsym e Atcpin _Atcpin A[9:9]kc
_Atclck2::
	.byte 'A,'T,43,'C,'L,'C,'K,61,34,'S,'C,34,44,50,0
	.dbsym e Atclck2 _Atclck2 A[15:15]kc
_Atcpwd::
	.byte 'A,'T,43,'C,'P,'W,'D,61,34,'S,'C,34,44,0
	.dbsym e Atcpwd _Atcpwd A[14:14]kc
_Atclck0::
	.byte 'A,'T,43,'C,'L,'C,'K,61,34,'S,'C,34,44,48,44,0
	.dbsym e Atclck0 _Atclck0 A[16:16]kc
_Atcpinc::
	.byte 'A,'T,43,'C,'P,'I,'N,61,0
	.dbsym e Atcpinc _Atcpinc A[9:9]kc
_Atsblk::
	.byte 'A,'T,94,'S,'B,'L,'K,0
	.dbsym e Atsblk _Atsblk A[8:8]kc
_Atccfc::
	.byte 'A,'T,94,'C,'C,'F,'C,61,0
	.dbsym e Atccfc _Atccfc A[9:9]kc
_SMSin::
	.byte 43,'C,'M,'T,'I,58,32,34,'S,'M,34,44,32,49,0
	.dbsym e SMSin _SMSin A[15:15]kc
_Atd::
	.byte 'A,'T,'D,0
	.dbsym e Atd _Atd A[4:4]kc
	.area vector(rom, abs)
	.org 22
	rjmp _uart0_rx_isr
	.area lit(rom, con, rel)
	.area text(rom, con, rel)
	.dbfile D:\MyProject\SMS-MC55\Code\窃听器delay/var.h
	.dbfile D:\MyProject\SMS-MC55\Code\窃听器delay\main.c
	.dbfunc e uart0_rx_isr _uart0_rx_isr fV
;              j -> R16
;              i -> R16
	.even
_uart0_rx_isr::
	st -y,R2
	st -y,R3
	st -y,R16
	st -y,R24
	st -y,R25
	st -y,R30
	st -y,R31
	in R2,0x3f
	st -y,R2
	.dbline -1
	.dbline 18
; ////////////////////////////////////////////////////////////////////////////////
; // ICC-AVR application builder : 2006-6-25 下午 06:02:39
; // Target : M8
; // Crystal: 3.6864Mhz
; // Author:  Anwarye
; // Title:   Detcetaphone
; ////////////////////////////////////////////////////////////////////////////////
; 
; #include <iom8v.h>
; #include <macros.h>
; #include "var.h"
; 
; #define XTAL == 3.6864M
; 
; ////////////////////////////////////////////////////////////////////////////////
; #pragma interrupt_handler uart0_rx_isr:12
; void uart0_rx_isr(void)
; {
	.dbline 20
;     unsigned char i,j;
;     if(UDR == 0x0A)
	in R24,0xc
	cpi R24,10
	brne L2
	.dbline 21
;     { 
	.dbline 22
;        return;		 // 收到0x0A直接丢弃
	rjmp L1
L2:
	.dbline 25
;     }
; 	
; 	i = RxIndex;
	lds R16,_RxIndex
	.dbline 26
; 	j = RxIndex-1;
	lds R16,_RxIndex
	subi R16,1
	.dbline 27
;     if((RxBuf[0] == 0x30) && (RxBuf[1] == 0x0D))
	lds R24,_RxBuf
	cpi R24,48
	brne L4
	lds R24,_RxBuf+1
	cpi R24,13
	brne L4
	.dbline 28
;     {
	.dbline 29
;         RxIndexTail = RxIndex;              // 保存接收缓冲指针尾
	lds R2,_RxIndex
	sts _RxIndexTail,R2
	.dbline 30
;         RxIndex = 0;	  		 			// 接收缓冲指针归零
	clr R2
	sts _RxIndex,R2
	.dbline 31
; 	    RxStatus = 1;						// 接收完成标志置位
	ldi R24,1
	sts _RxStatus,R24
	.dbline 32
; 		OkFlag = 1;
	sts _OkFlag,R24
	.dbline 33
; 		error = 0;
	sts _error,R2
	.dbline 34
; 		return; 
	rjmp L1
L4:
	.dbline 36
; 	}
;     if((RxBuf[0] == 0x32) && (RxBuf[1] == 0x0D))  // 收到来电信号，来电标志置位
	lds R24,_RxBuf
	cpi R24,50
	brne L7
	lds R24,_RxBuf+1
	cpi R24,13
	brne L7
	.dbline 37
;     {
	.dbline 38
;         CallInFlag = 1;	                    // 置电话呼入标志
	ldi R24,1
	sts _CallInFlag,R24
	.dbline 39
; 	    RxIndex = 0;
	clr R2
	sts _RxIndex,R2
	.dbline 40
; 		RxStatus = 1;
	sts _RxStatus,R24
	.dbline 41
; 		OkFlag = 1;
	sts _OkFlag,R24
	.dbline 42
; 		return;  
	rjmp L1
L7:
	.dbline 44
;     }
;     else if((RxBuf[0] == 0x33) && (RxBuf[1] == 0x0D))  // 被叫号码忙 或者挂机 主叫挂机
	lds R24,_RxBuf
	cpi R24,51
	brne L10
	lds R24,_RxBuf+1
	cpi R24,13
	brne L10
	.dbline 45
;     {
	.dbline 46
;         BusyFlag = 1;	                               // 置电话呼入标志
	ldi R24,1
	sts _BusyFlag,R24
	.dbline 47
; 	    RxIndex = 0;
	clr R2
	sts _RxIndex,R2
	.dbline 48
; 		RxStatus = 1;
	sts _RxStatus,R24
	.dbline 49
; 		OkFlag = 1;
	sts _OkFlag,R24
	.dbline 50
; 		return;  
	rjmp L1
L10:
	.dbline 52
;     }      
;     else if((RxBuf[0] == 0x37) && (RxBuf[1] == 0x0D))  // 收到来电信号，来电标志置位
	lds R24,_RxBuf
	cpi R24,55
	brne L13
	lds R24,_RxBuf+1
	cpi R24,13
	brne L13
	.dbline 53
;     {
	.dbline 54
;         NoCarrierFlag = 1;	                           // 置电话呼入标志  NO CARRIER
	ldi R24,1
	sts _NoCarrierFlag,R24
	.dbline 55
; 	    RxIndex = 0;
	clr R2
	sts _RxIndex,R2
	.dbline 56
; 		RxStatus = 1;
	sts _RxStatus,R24
	.dbline 57
; 		OkFlag = 1;
	sts _OkFlag,R24
	.dbline 58
; 		return;
	rjmp L1
L13:
	.dbline 60
;     }
;     else if((RxBuf[0] == 0x34) && (RxBuf[1] == 0x0D))  // 收到来电信号，来电标志置位
	lds R24,_RxBuf
	cpi R24,52
	brne L16
	lds R24,_RxBuf+1
	cpi R24,13
	brne L16
	.dbline 61
;     {
	.dbline 62
; 	    RxIndex = 0;
	clr R2
	sts _RxIndex,R2
	.dbline 63
; 		RxStatus = 1;
	ldi R24,1
	sts _RxStatus,R24
	.dbline 64
; 		OkFlag = 1;
	sts _OkFlag,R24
	.dbline 65
; 		error = 1;
	sts _error,R24
	.dbline 66
; 		return;	
	rjmp L1
L16:
	.dbline 69
; 	}
; 	else 
;     {
	.dbline 71
;     
;     RxBuf[RxIndex++] = UDR;                 // 继续接收数据放入接收缓冲
	lds R2,_RxIndex
	clr R3
	mov R24,R2
	subi R24,255    ; addi 1
	sts _RxIndex,R24
	ldi R24,<_RxBuf
	ldi R25,>_RxBuf
	mov R30,R2
	clr R31
	add R30,R24
	adc R31,R25
	in R2,0xc
	std z+0,R2
	.dbline 72
; 	RxStatus = 0;                         // 串口接收中
	clr R2
	sts _RxStatus,R2
	.dbline 74
; //	return;		  		  	   		      // 结束接收，直接跳出
; 	}
	.dbline -2
L1:
	ld R2,y+
	out 0x3f,R2
	ld R31,y+
	ld R30,y+
	ld R25,y+
	ld R24,y+
	ld R16,y+
	ld R3,y+
	ld R2,y+
	.dbline 0 ; func end
	reti
	.dbsym r j 16 c
	.dbsym r i 16 c
	.dbend
	.area vector(rom, abs)
	.org 26
	rjmp _uart0_tx_isr
	.area text(rom, con, rel)
	.dbfile D:\MyProject\SMS-MC55\Code\窃听器delay\main.c
	.dbfunc e uart0_tx_isr _uart0_tx_isr fV
	.even
_uart0_tx_isr::
	st -y,R2
	st -y,R24
	st -y,R25
	st -y,R30
	st -y,R31
	in R2,0x3f
	st -y,R2
	.dbline -1
	.dbline 80
; }
; 
; ////////////////////////////////////////////////////////////////////////////////
; #pragma interrupt_handler uart0_tx_isr:14
; void uart0_tx_isr(void)
; {
	.dbline 82
;     
;     if(!TxStatus)                                   // 本帧数据未发完，则继续发送  
	lds R2,_TxStatus
	tst R2
	brne L20
	.dbline 83
; 	{
	.dbline 85
; 	    //while ( !(UCSRA & (1<<UDRE)) );             // 等待UDR空
; 	    UDR = TxBuf[TxIndex];		
	ldi R24,<_TxBuf
	ldi R25,>_TxBuf
	lds R30,_TxIndex
	clr R31
	add R30,R24
	adc R31,R25
	ldd R2,z+0
	out 0xc,R2
	.dbline 86
; 	}
L20:
	.dbline 87
; 	if((TxBuf[TxIndex] == 0x0D) || (TxBuf[TxIndex] == 0x1A))  // 本帧数据发送结束
	ldi R24,<_TxBuf
	ldi R25,>_TxBuf
	lds R30,_TxIndex
	clr R31
	add R30,R24
	adc R31,R25
	ldd R24,z+0
	cpi R24,13
	breq L24
	ldi R24,<_TxBuf
	ldi R25,>_TxBuf
	lds R30,_TxIndex
	clr R31
	add R30,R24
	adc R31,R25
	ldd R24,z+0
	cpi R24,26
	brne L22
L24:
	.dbline 88
; 	{
	.dbline 89
; 		TxStatus = 1;                          // 发送完成状态标志置位
	ldi R24,1
	sts _TxStatus,R24
	.dbline 90
; 		TxIndex = 0;                           // 发送缓冲区指针归零
	clr R2
	sts _TxIndex,R2
	.dbline 91
; 		UCSRB &= ~((1<<TXCIE));//|(1<<TXEN));  // 关发送中断
	cbi 0xa,6
	.dbline 92
; 		return;
	rjmp L19
L22:
	.dbline 94
; 	}
; 	TxIndex++;                              
	lds R24,_TxIndex
	subi R24,255    ; addi 1
	sts _TxIndex,R24
	.dbline -2
L19:
	ld R2,y+
	out 0x3f,R2
	ld R31,y+
	ld R30,y+
	ld R25,y+
	ld R24,y+
	ld R2,y+
	.dbline 0 ; func end
	reti
	.dbend
	.dbfunc e CheckRx _CheckRx fc
;              j -> R18
;              i -> R16
	.even
_CheckRx::
	.dbline -1
	.dbline 97
; }
; unsigned char CheckRx(void)
; {
	.dbline 99
;     unsigned char i,j;
; 	i = RxIndex;
	lds R16,_RxIndex
	.dbline 100
; 	j = RxIndex - 1;
	lds R18,_RxIndex
	subi R18,1
	.dbline 101
;     if(( RxBuf[j] == 0x30) && (RxBuf[i] == 0x0D))
	ldi R24,<_RxBuf
	ldi R25,>_RxBuf
	mov R30,R18
	clr R31
	add R30,R24
	adc R31,R25
	ldd R24,z+0
	cpi R24,48
	brne L26
	ldi R24,<_RxBuf
	ldi R25,>_RxBuf
	mov R30,R16
	clr R31
	add R30,R24
	adc R31,R25
	ldd R24,z+0
	cpi R24,13
	brne L26
	.dbline 102
; 	{
	.dbline 103
; 	    RxIndex = 0;
	clr R2
	sts _RxIndex,R2
	.dbline 104
; 		return (1);
	ldi R16,1
	rjmp L25
L26:
	.dbline 107
; 	}
; 	else
; 	{
	.dbline 108
; 	    return (0);
	clr R16
	.dbline -2
L25:
	.dbline 0 ; func end
	ret
	.dbsym r j 18 c
	.dbsym r i 16 c
	.dbend
	.dbfunc e ClearRxBuf _ClearRxBuf fV
;              i -> R16
	.even
_ClearRxBuf::
	.dbline -1
	.dbline 115
; 	}
; }
; /*-----------------------------------------------------------------------*/
; ///////////////////////////  清除接收缓冲  ////////////////////////////////
; /*-----------------------------------------------------------------------*/
; void ClearRxBuf(void)
; {
	.dbline 117
;     unsigned char i;
; 	for(i=0;i<128;i++)
	clr R16
	rjmp L32
L29:
	.dbline 118
	.dbline 119
	ldi R24,<_RxBuf
	ldi R25,>_RxBuf
	mov R30,R16
	clr R31
	add R30,R24
	adc R31,R25
	clr R2
	std z+0,R2
	.dbline 120
L30:
	.dbline 117
	inc R16
L32:
	.dbline 117
	cpi R16,128
	brlo L29
	.dbline -2
L28:
	.dbline 0 ; func end
	ret
	.dbsym r i 16 c
	.dbend
	.dbfunc e TxEnable _TxEnable fV
	.even
_TxEnable::
	.dbline -1
	.dbline 126
; 	{
; 	    RxBuf[i] = 0;
; 	}
; }
; /*-----------------------------------------------------------------------*/
; ///////////////////////////  串口发送使能  ////////////////////////////////
; /*-----------------------------------------------------------------------*/
; void TxEnable(void)
; {
	.dbline 128
;     //RxIndex = 0;
;     UDR = TxBuf[0];                            // 发送缓冲头送入串口发送寄存器，激活开始发送
	lds R2,_TxBuf
	out 0xc,R2
	.dbline 129
; 	UCSRB |= ((1<<TXCIE));//|(1<<TXEN));
	sbi 0xa,6
	.dbline -2
L33:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e Put_AT_command _Put_AT_command fV
;          count -> R20
;          atlen -> R22
;            atc -> R10,R11
	.even
_Put_AT_command::
	rcall push_gset3
	mov R22,R18
	movw R10,R16
	.dbline -1
	.dbline 135
; }
; /*-----------------------------------------------------------------------*/
; /////////////////////////////  发送AT命令 /////////////////////////////////
; /*-----------------------------------------------------------------------*/
; void Put_AT_command(const unsigned char *atc, unsigned char atlen)
; {
	.dbline 138
;     unsigned char count;
; 	
; 	for(count = 0;count < atlen;count++)      // AT命令窜移入发送缓冲
	clr R20
	rjmp L38
L35:
	.dbline 139
	.dbline 140
	mov R30,R20
	clr R31
	add R30,R10
	adc R31,R11
	lpm R30,Z
	ldi R24,<_TxBuf
	ldi R25,>_TxBuf
	mov R26,R20
	clr R27
	add R26,R24
	adc R27,R25
	st x,R30
	.dbline 141
L36:
	.dbline 138
	inc R20
L38:
	.dbline 138
	cp R20,R22
	brlo L35
	.dbline 143
; 	{
; 	    TxBuf[count] = atc[count];
; 	}
; 	
; 	TxBuf[atlen] = 0x0D;                      // 发送缓冲窜结尾加“回车”
	ldi R24,<_TxBuf
	ldi R25,>_TxBuf
	mov R30,R22
	clr R31
	add R30,R24
	adc R31,R25
	ldi R24,13
	std z+0,R24
	.dbline 144
; 	TxBuf[atlen + 1] = 0x00;                  // 发送缓冲窜结束符号
	ldi R24,<_TxBuf+1
	ldi R25,>_TxBuf+1
	mov R30,R22
	clr R31
	add R30,R24
	adc R31,R25
	clr R2
	std z+0,R2
	.dbline 146
; 
; 	OkFlag = 0;
	sts _OkFlag,R2
	.dbline 147
;     TxStatus = 0;
	sts _TxStatus,R2
	.dbline 148
; 	TxIndex = 1;                              // 发送指针偏移1
	ldi R24,1
	sts _TxIndex,R24
	.dbline 149
; 	TxEnable();                               // 激活发送
	rcall _TxEnable
L40:
	.dbline 150
L41:
	.dbline 150
;     while(!TxStatus);                         // 等代发送结束,发送缓冲指针为零则可以发送
	lds R2,_TxStatus
	tst R2
	breq L40
	.dbline 151
; 	DelayMs(20);
	ldi R16,20
	ldi R17,0
	rcall _DelayMs
L43:
	.dbline 152
L44:
	.dbline 152
; 	while(!OkFlag);                           // 收到模块返回OK,命令结束
	lds R2,_OkFlag
	tst R2
	breq L43
	.dbline 153
; 	OkFlag = 0;
	clr R2
	sts _OkFlag,R2
	.dbline -2
L34:
	rcall pop_gset3
	.dbline 0 ; func end
	ret
	.dbsym r count 20 c
	.dbsym r atlen 22 c
	.dbsym r atc 10 pkc
	.dbend
	.dbfunc e Put_AT_String _Put_AT_String fV
;          count -> R20
;          atlen -> R22
;            atc -> R10,R11
	.even
_Put_AT_String::
	rcall push_gset3
	mov R22,R18
	movw R10,R16
	.dbline -1
	.dbline 161
; 
; }
; 
; /*-----------------------------------------------------------------------*/
; /////////////////////////  从内存发送AT命令串  ////////////////////////////
; /*-----------------------------------------------------------------------*/
; void Put_AT_String(unsigned char *atc, unsigned char atlen)
; {
	.dbline 164
;     unsigned char count;
; 		
; 	for(count = 0;count < atlen;count++)
	clr R20
	rjmp L50
L47:
	.dbline 165
	.dbline 166
	mov R30,R20
	clr R31
	add R30,R10
	adc R31,R11
	ldd R2,z+0
	ldi R24,<_TxBuf
	ldi R25,>_TxBuf
	mov R30,R20
	clr R31
	add R30,R24
	adc R31,R25
	std z+0,R2
	.dbline 167
L48:
	.dbline 164
	inc R20
L50:
	.dbline 164
	cp R20,R22
	brlo L47
	.dbline 169
; 	{
; 	    TxBuf[count] = *(atc+count);
; 	}
; 	
; 	TxBuf[atlen] = 0x0D;                      // 发送缓冲窜结尾加“回车”
	ldi R24,<_TxBuf
	ldi R25,>_TxBuf
	mov R30,R22
	clr R31
	add R30,R24
	adc R31,R25
	ldi R24,13
	std z+0,R24
	.dbline 170
; 	TxBuf[atlen + 1] = 0x00;                  // 发送缓冲窜结束符号
	ldi R24,<_TxBuf+1
	ldi R25,>_TxBuf+1
	mov R30,R22
	clr R31
	add R30,R24
	adc R31,R25
	clr R2
	std z+0,R2
	.dbline 172
; 
;     OkFlag = 0;
	sts _OkFlag,R2
	.dbline 173
;     TxStatus = 0;
	sts _TxStatus,R2
	.dbline 174
; 	TxIndex = 1;                              // 发送指针偏移1
	ldi R24,1
	sts _TxIndex,R24
	.dbline 175
; 	TxEnable();                               // 激活发送
	rcall _TxEnable
L52:
	.dbline 176
L53:
	.dbline 176
;     while(!TxStatus);                         // 等代发送结束,发送缓冲指针为零则可以发送
	lds R2,_TxStatus
	tst R2
	breq L52
	.dbline 177
; 	DelayMs(20);
	ldi R16,20
	ldi R17,0
	rcall _DelayMs
L55:
	.dbline 178
L56:
	.dbline 178
; 	while(!OkFlag);                           // 收到模块返回OK,命令结束
	lds R2,_OkFlag
	tst R2
	breq L55
	.dbline 179
; 	OkFlag = 0;
	clr R2
	sts _OkFlag,R2
	.dbline -2
L46:
	rcall pop_gset3
	.dbline 0 ; func end
	ret
	.dbsym r count 20 c
	.dbsym r atlen 22 c
	.dbsym r atc 10 pc
	.dbend
	.dbfunc e PutString _PutString fV
;          count -> R20
;        retflag -> R22
;         length -> R10
;            str -> R12,R13
	.even
_PutString::
	rcall push_gset4
	mov R10,R18
	movw R12,R16
	ldd R22,y+8
	.dbline -1
	.dbline 185
; }
; /*-----------------------------------------------------------------------*/
; /////////////////////////  向串口发送一串数据  ////////////////////////////
; /*-----------------------------------------------------------------------*/
; void PutString(unsigned char *str, unsigned char length,unsigned char retflag)
; {
	.dbline 188
;     unsigned char count;
; 
; 	for(count = 0;count < length;count++)
	clr R20
	rjmp L62
L59:
	.dbline 189
	.dbline 190
	mov R30,R20
	clr R31
	add R30,R12
	adc R31,R13
	ldd R2,z+0
	ldi R24,<_TxBuf
	ldi R25,>_TxBuf
	mov R30,R20
	clr R31
	add R30,R24
	adc R31,R25
	std z+0,R2
	.dbline 191
L60:
	.dbline 188
	inc R20
L62:
	.dbline 188
	cp R20,R10
	brlo L59
	.dbline 193
; 	{
; 	    TxBuf[count] = *(str+count);
; 	}
; 	
; 	TxBuf[length] = 0x0D;                     // 发送缓冲窜结尾加“回车”
	ldi R24,<_TxBuf
	ldi R25,>_TxBuf
	mov R30,R10
	clr R31
	add R30,R24
	adc R31,R25
	ldi R24,13
	std z+0,R24
	.dbline 194
; 	TxBuf[length+ 1] = 0x00;                  // 发送缓冲窜结束符号
	ldi R24,<_TxBuf+1
	ldi R25,>_TxBuf+1
	mov R30,R10
	clr R31
	add R30,R24
	adc R31,R25
	clr R2
	std z+0,R2
	.dbline 196
; 	
;     TxStatus = 0;
	sts _TxStatus,R2
	.dbline 197
; 	TxIndex = 1;                              // 发送指针偏移1
	ldi R24,1
	sts _TxIndex,R24
	.dbline 198
; 	OkFlag = 0;
	sts _OkFlag,R2
	.dbline 199
; 	TxEnable();
	rcall _TxEnable
L64:
	.dbline 201
L65:
	.dbline 201
; 	                                          // 激活发送
;     while(!TxStatus);                         // 等代发送结束,发送缓冲指针为零则可以发送
	lds R2,_TxStatus
	tst R2
	breq L64
	.dbline 202
; 	DelayMs(20);
	ldi R16,20
	ldi R17,0
	rcall _DelayMs
	.dbline 203
;     if(retflag)
	tst R22
	breq L67
	.dbline 204
;     {	
L69:
	.dbline 205
L70:
	.dbline 205
;         while(!OkFlag);                       // 收到模块返回OK,命令结束
	lds R2,_OkFlag
	tst R2
	breq L69
	.dbline 206
; 		OkFlag = 0;
	clr R2
	sts _OkFlag,R2
	.dbline 207
; 	}
	rjmp L68
L67:
	.dbline 209
	.dbline 210
	ldi R16,200
	ldi R17,0
	rcall _DelayMs
	.dbline 211
	clr R2
	sts _OkFlag,R2
	.dbline 212
L68:
	.dbline -2
L58:
	rcall pop_gset4
	.dbline 0 ; func end
	ret
	.dbsym r count 20 c
	.dbsym r retflag 22 c
	.dbsym r length 10 c
	.dbsym r str 12 pc
	.dbend
	.dbfunc e DialNum _DialNum fV
;              i -> R10
;         length -> R20
;          count -> R22
	.even
_DialNum::
	rcall push_gset3
	.dbline -1
	.dbline 220
; 	else
; 	{
;         DelayMs(200);
; 		OkFlag = 0;
; 	}
; }
; ////////////////////////////////////////////////////////////////////////////////
; 
; /*-----------------------------------------------------------------------*/
; //////////////////////////         拨号         ///////////////////////////
; /*-----------------------------------------------------------------------*/
; void DialNum(void)
; {
	.dbline 221
;     unsigned char i,count=0,length=0;
	clr R22
	.dbline 221
	clr R20
	rjmp L74
L73:
	.dbline 224
	.dbline 225
	inc R20
	.dbline 226
L74:
	.dbline 223
; 
; 	while ((PhoneNum[count++] != 0))                  // 计算电话号码长度
	mov R2,R22
	clr R3
	subi R22,255    ; addi 1
	ldi R24,<_PhoneNum
	ldi R25,>_PhoneNum
	mov R30,R2
	clr R31
	add R30,R24
	adc R31,R25
	ldd R2,z+0
	tst R2
	brne L73
	.dbline 228
; 	{
; 	    length++;
; 	}
; 	
; 	TxBuf[0] = 'A';
	ldi R24,65
	sts _TxBuf,R24
	.dbline 229
; 	TxBuf[1] = 'T';
	ldi R24,84
	sts _TxBuf+1,R24
	.dbline 230
; 	TxBuf[2] = 'D';
	ldi R24,68
	sts _TxBuf+2,R24
	.dbline 232
; 	
; 	i = 3;
	ldi R24,3
	mov R10,R24
	.dbline 233
;     for(count=0;count<length;count++)
	clr R22
	rjmp L81
L78:
	.dbline 234
	.dbline 235
	mov R2,R10
	clr R3
	mov R24,R2
	subi R24,255    ; addi 1
	mov R10,R24
	ldi R24,<_PhoneNum
	ldi R25,>_PhoneNum
	mov R30,R22
	clr R31
	add R30,R24
	adc R31,R25
	ldd R4,z+0
	ldi R24,<_TxBuf
	ldi R25,>_TxBuf
	mov R30,R2
	clr R31
	add R30,R24
	adc R31,R25
	std z+0,R4
	.dbline 236
L79:
	.dbline 233
	inc R22
L81:
	.dbline 233
	cp R22,R20
	brlo L78
	.dbline 238
; 	{
; 	    TxBuf[i++] = PhoneNum[count];
; 	}
;     
; 	TxBuf[length+3] = ';';
	ldi R24,<_TxBuf+3
	ldi R25,>_TxBuf+3
	mov R30,R20
	clr R31
	add R30,R24
	adc R31,R25
	ldi R24,59
	std z+0,R24
	.dbline 239
; 	TxBuf[length+4] = 0x0D;
	ldi R24,<_TxBuf+4
	ldi R25,>_TxBuf+4
	mov R30,R20
	clr R31
	add R30,R24
	adc R31,R25
	ldi R24,13
	std z+0,R24
	.dbline 241
; 	
;     OkFlag = 0;
	clr R2
	sts _OkFlag,R2
	.dbline 242
;     TxStatus = 0;
	sts _TxStatus,R2
	.dbline 243
; 	TxIndex = 1;                              // 发送指针偏移1
	ldi R24,1
	sts _TxIndex,R24
	.dbline 244
; 	TxEnable();                               // 激活发送
	rcall _TxEnable
L84:
	.dbline 245
L85:
	.dbline 245
;     while(!TxStatus);                         // 等代发送结束,发送缓冲指针为零则可以发送
	lds R2,_TxStatus
	tst R2
	breq L84
	.dbline 246
; 	DelayMs(20);
	ldi R16,20
	ldi R17,0
	rcall _DelayMs
	.dbline 248
; 	//while(!OkFlag);                           // 收到模块返回OK,命令结束	
;     OkFlag = 0;
	clr R2
	sts _OkFlag,R2
	.dbline -2
L72:
	rcall pop_gset3
	.dbline 0 ; func end
	ret
	.dbsym r i 10 c
	.dbsym r length 20 c
	.dbsym r count 22 c
	.dbend
	.dbfunc e StringCompare _StringCompare fc
;         strlen -> R20
;           str2 -> R18,R19
;           str1 -> R16,R17
	.even
_StringCompare::
	rcall push_gset1
	ldd R20,y+2
	.dbline -1
	.dbline 255
; } 
; 
; /*-----------------------------------------------------------------------*/
; /////////////////////////////  比较两个串 /////////////////////////////////
; /*-----------------------------------------------------------------------*/
; unsigned char StringCompare(volatile unsigned char *str1,const unsigned char *str2,unsigned char strlen)
; {
	rjmp L89
L88:
	.dbline 257
;     while(strlen--)
; 	{
	.dbline 258
; 	    if(*str1++ != *str2++) return(FALSE);    // 两个串不相等返回假
	movw R2,R18
	subi R18,255  ; offset = 1
	sbci R19,255
	movw R30,R2
	lpm R30,Z
	movw R26,R16
	ld R2,X+
	movw R16,R26
	cp R2,R30
	breq L91
	.dbline 258
	clr R16
	rjmp L87
L91:
	.dbline 259
L89:
	.dbline 256
	mov R2,R20
	clr R3
	subi R20,1
	tst R2
	brne L88
	.dbline 260
; 	}
; 	return(TRUE);
	ldi R16,1
	.dbline -2
L87:
	rcall pop_gset1
	.dbline 0 ; func end
	ret
	.dbsym r strlen 20 c
	.dbsym r str2 18 pkc
	.dbsym r str1 16 pc
	.dbend
	.dbfunc e Delete_SMS _Delete_SMS fV
;          count -> R20
;            num -> R22
	.even
_Delete_SMS::
	rcall push_gset2
	mov R22,R16
	.dbline -1
	.dbline 267
; }
; 
; /*-----------------------------------------------------------------------*/
; /////////////////////////////    删除短信    //////////////////////////////
; /*-----------------------------------------------------------------------*/
; void Delete_SMS(unsigned char num)     // 删除SMS，=0删除所有SMS
; {
	.dbline 270
;     unsigned char count;
; 
; 	for(count = 0;count < AtcmgdLen;count++)      // AT命令窜移入发送缓冲
	clr R20
	rjmp L97
L94:
	.dbline 271
	.dbline 272
	ldi R24,<_Atcmgd
	ldi R25,>_Atcmgd
	mov R30,R20
	clr R31
	add R30,R24
	adc R31,R25
	lpm R30,Z
	ldi R24,<_TmpBuf
	ldi R25,>_TmpBuf
	mov R26,R20
	clr R27
	add R26,R24
	adc R27,R25
	st x,R30
	.dbline 273
L95:
	.dbline 270
	inc R20
L97:
	.dbline 270
	cpi R20,8
	brlo L94
	.dbline 275
; 	{
; 	    TmpBuf[count] = Atcmgd[count];
; 	}
; 		
; 	if(num == ALL)
	cpi R22,255
	brne L98
	.dbline 276
; 	{
	.dbline 277
; 	   for(count = 1; count < 10; count++)
	ldi R20,1
	rjmp L103
L100:
	.dbline 278
	.dbline 279
	mov R24,R20
	subi R24,208    ; addi 48
	sts _TmpBuf+8,R24
	.dbline 280
	ldi R18,9
	ldi R16,<_TmpBuf
	ldi R17,>_TmpBuf
	rcall _Put_AT_String
	.dbline 282
L101:
	.dbline 277
	inc R20
L103:
	.dbline 277
	cpi R20,10
	brlo L100
	.dbline 283
; 	   {
; 	       TmpBuf[AtcmgdLen] = count + 0x30;
; 	       Put_AT_String((unsigned char*)TmpBuf,(AtcmgdLen+1));
; 
; 		}
; 	   TmpBuf[AtcmgdLen] = 0x31;
	ldi R24,49
	sts _TmpBuf+8,R24
	.dbline 284
;        for(count = 0; count < 10; count++)
	clr R20
	rjmp L109
L106:
	.dbline 285
	.dbline 286
	mov R24,R20
	subi R24,208    ; addi 48
	sts _TmpBuf+9,R24
	.dbline 287
	ldi R18,10
	ldi R16,<_TmpBuf
	ldi R17,>_TmpBuf
	rcall _Put_AT_String
	.dbline 289
L107:
	.dbline 284
	inc R20
L109:
	.dbline 284
	cpi R20,10
	brlo L106
	.dbline 291
; 	   {
; 	       TmpBuf[AtcmgdLen+1] = count + 0x30;
; 	       Put_AT_String((unsigned char*)TmpBuf,(AtcmgdLen+2));
; 
; 	    }
; 
; 	}
	rjmp L99
L98:
	.dbline 293
	.dbline 294
	mov R24,R22
	subi R24,208    ; addi 48
	sts _TmpBuf+8,R24
	.dbline 295
	ldi R18,9
	ldi R16,<_TmpBuf
	ldi R17,>_TmpBuf
	rcall _Put_AT_String
	.dbline 297
L99:
	.dbline -2
L93:
	rcall pop_gset2
	.dbline 0 ; func end
	ret
	.dbsym r count 20 c
	.dbsym r num 22 c
	.dbend
	.dbfunc e CheckSMS_in _CheckSMS_in fc
	.even
_CheckSMS_in::
	sbiw R28,1
	.dbline -1
	.dbline 304
; 	else
; 	{
; 	    TmpBuf[AtcmgdLen] = num + 0x30;
; 	    Put_AT_String((unsigned char*)TmpBuf,(AtcmgdLen+1));
; 
; 	}
; }
; 
; /*-----------------------------------------------------------------------*/
; ///////////////////////////  检查SMS返回  //////////////////////////////
; /*-----------------------------------------------------------------------*/
; unsigned char CheckSMS_in(void)
; {
L113:
	.dbline 305
L114:
	.dbline 305
; 	while(!RxStatus);                            // 等待接收完成
	lds R2,_RxStatus
	tst R2
	breq L113
	.dbline 306
; 	DelayMs(100);
	ldi R16,100
	ldi R17,0
	rcall _DelayMs
	.dbline 308
; 
; 	if(StringCompare(RxBuf,SMSin,SMSinLen))      // 如果收到OK完成    +CMTI: "SM", 1
	ldi R24,14
	std y+0,R24
	ldi R18,<_SMSin
	ldi R19,>_SMSin
	ldi R16,<_RxBuf
	ldi R17,>_RxBuf
	rcall _StringCompare
	tst R16
	breq L116
	.dbline 309
; 	{
	.dbline 310
; 		return (OK);
	ldi R16,1
	rjmp L112
L116:
	.dbline 313
; 	}
; 	else
; 	{
	.dbline 314
; 	    return (ERROR);
	clr R16
	.dbline -2
L112:
	adiw R28,1
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e CheckSMS _CheckSMS fV
;         numlen -> R22
;              j -> R22
;          index -> R22
;              i -> R20
	.even
_CheckSMS::
	rcall push_gset2
	.dbline -1
	.dbline 322
; 	}
; 
; }
; /*-----------------------------------------------------------------------*/
; ///////////////              将设置号码存入内存           /////////////////
; /*-----------------------------------------------------------------------*/
; void CheckSMS(void)
; {
	.dbline 323
;     unsigned char i=0,j=0,index,numlen=0;
	clr R20
	.dbline 323
	clr R22
	.dbline 323
	.dbline 324
; 	for(;i<12;i++)
	rjmp L122
L119:
	.dbline 325
	.dbline 326
	ldi R24,<_PhoneNum
	ldi R25,>_PhoneNum
	mov R30,R20
	clr R31
	add R30,R24
	adc R31,R25
	clr R2
	std z+0,R2
	.dbline 327
L120:
	.dbline 324
	inc R20
L122:
	.dbline 324
	cpi R20,12
	brlo L119
	.dbline 341
; 	{
; 	    PhoneNum[i] = 0;
; 	}
; /*    do
; 	{
; 	    i++;
; 		j=i+1;
; 	}
; 	//while((Pdu[i] == 'G') && (Pdu[j] == 'H'));
; 	
; 	index = j+1;
; 	i = index;
; 	while(Pdu[i++] == '+')numlen++;
; 	
; 	j = 79; */
; 	
; 	index = 79;
	ldi R22,79
	.dbline 342
; 	for(i=0;i<11;i++)
	clr R20
	rjmp L126
L123:
	.dbline 343
	.dbline 344
	mov R2,R22
	clr R3
	subi R22,255    ; addi 1
	ldi R24,<_Pdu
	ldi R25,>_Pdu
	mov R30,R2
	clr R31
	add R30,R24
	adc R31,R25
	ldd R2,z+0
	ldi R24,<_PhoneNum
	ldi R25,>_PhoneNum
	mov R30,R20
	clr R31
	add R30,R24
	adc R31,R25
	std z+0,R2
	.dbline 345
	rcall _PhoneNum_to_EEPROM
	.dbline 346
L124:
	.dbline 342
	inc R20
L126:
	.dbline 342
	cpi R20,11
	brlo L123
	.dbline -2
L118:
	rcall pop_gset2
	.dbline 0 ; func end
	ret
	.dbsym r numlen 22 c
	.dbsym r j 22 c
	.dbsym r index 22 c
	.dbsym r i 20 c
	.dbend
	.dbfunc e CheckPhoneNum _CheckPhoneNum fc
;              i -> R16
	.even
_CheckPhoneNum::
	.dbline -1
	.dbline 350
; 	{
; 	    PhoneNum[i] = Pdu[index++];
; 		PhoneNum_to_EEPROM();
;     }
; 	
; }	
; unsigned char CheckPhoneNum(void)
; {
	.dbline 352
;     unsigned char i;
; 	for(i=0;i<12;i++)
	clr R16
	rjmp L131
L128:
	.dbline 353
; 	{
	.dbline 354
; 	    if( PhoneNum != 0) return (FALSE);
	ldi R24,<_PhoneNum
	ldi R25,>_PhoneNum
	cpi R24,0
	cpc R24,R25
	breq L132
X0:
	.dbline 354
	clr R16
	rjmp L127
L132:
	.dbline 355
L129:
	.dbline 352
	inc R16
L131:
	.dbline 352
	cpi R16,12
	brlo L128
	.dbline 356
; 	}
; 	return (TRUE);
	ldi R16,1
	.dbline -2
L127:
	.dbline 0 ; func end
	ret
	.dbsym r i 16 c
	.dbend
	.dbfunc e RecSMS _RecSMS fV
;              j -> R20
;              y -> R10
;              x -> R12
;              i -> R22
;          count -> R14
	.even
_RecSMS::
	rcall push_gset5
	.dbline -1
	.dbline 362
; }
; /*-----------------------------------------------------------------------*/
; //////////////////////////    接收处理短信息    ///////////////////////////
; /*-----------------------------------------------------------------------*/
; void RecSMS(void)
; {
	.dbline 363
;     unsigned char count,i=0,j=0,x,y;
	clr R22
	.dbline 363
	clr R20
	.dbline 365
; 	
;     Put_AT_String("AT+CMGR=1",9);
	ldi R18,9
	ldi R16,<L135
	ldi R17,>L135
	rcall _Put_AT_String
	rjmp L137
L136:
	.dbline 368
	.dbline 369
	inc R22
	.dbline 370
L137:
	.dbline 367
; 	
;     while(RxBuf[i] != 0x0D)
	ldi R24,<_RxBuf
	ldi R25,>_RxBuf
	mov R30,R22
	clr R31
	add R30,R24
	adc R31,R25
	ldd R24,z+0
	cpi R24,13
	brne L136
	.dbline 371
; 	{
; 	    i++;
; 	}
; 	i = 76;
	ldi R22,76
	.dbline 372
; 	j = i;
	mov R20,R22
	.dbline 373
; 	if((RxBuf[i] == 'G') && (RxBuf[j+1] == 'H'))
	ldi R24,<_RxBuf
	ldi R25,>_RxBuf
	mov R30,R22
	clr R31
	add R30,R24
	adc R31,R25
	ldd R24,z+0
	cpi R24,71
	breq X1
	rjmp L139
X1:
	ldi R24,<_RxBuf+1
	ldi R25,>_RxBuf+1
	mov R30,R20
	clr R31
	add R30,R24
	adc R31,R25
	ldd R24,z+0
	cpi R24,72
	breq X2
	rjmp L139
X2:
	.dbline 374
;     {	
	.dbline 375
;         count = 0;
	clr R14
	rjmp L143
L142:
	.dbline 377
; 	    while(1)
; 	    {
	.dbline 378
; 	        Pdu[count] = RxBuf[count];
	ldi R24,<_RxBuf
	ldi R25,>_RxBuf
	mov R30,R14
	clr R31
	add R30,R24
	adc R31,R25
	ldd R2,z+0
	ldi R24,<_Pdu
	ldi R25,>_Pdu
	mov R30,R14
	clr R31
	add R30,R24
	adc R31,R25
	std z+0,R2
	.dbline 379
; 			x = count;
	mov R12,R14
	.dbline 380
; 			y = count;
	mov R10,R14
	.dbline 381
; 		    if((RxBuf[x-2] == 0x30) && (RxBuf[y-1] == 0x0D)) 
	ldi R24,<_RxBuf-2
	ldi R25,>_RxBuf-2
	mov R30,R12
	clr R31
	add R30,R24
	adc R31,R25
	ldd R24,z+0
	cpi R24,48
	brne L145
	ldi R24,<_RxBuf-1
	ldi R25,>_RxBuf-1
	mov R30,R10
	clr R31
	add R30,R24
	adc R31,R25
	ldd R24,z+0
	cpi R24,13
	brne L145
	.dbline 382
; 		    {
	.dbline 383
; 		    break;
	rjmp L144
L145:
	.dbline 385
	inc R14
	.dbline 386
L143:
	.dbline 376
	rjmp L142
L144:
	.dbline 387
; 	        }
; 		    count++;
; 	    }
; 		CheckSMS();
	rcall _CheckSMS
	.dbline 388
; 		Delete_SMS(1);
	ldi R16,1
	rcall _Delete_SMS
	.dbline 390
; 		
;     }
	rjmp L140
L139:
	.dbline 392
	.dbline 393
	ldi R16,1
	rcall _Delete_SMS
	.dbline 394
L140:
	.dbline -2
L134:
	rcall pop_gset5
	.dbline 0 ; func end
	ret
	.dbsym r j 20 c
	.dbsym r y 10 c
	.dbsym r x 12 c
	.dbsym r i 22 c
	.dbsym r count 14 c
	.dbend
	.dbfunc e DetQEITING _DetQEITING fc
;            tmp -> y+0
	.even
_DetQEITING::
	sbiw R28,1
	.dbline -1
	.dbline 398
; 	else 
; 	{
; 	    Delete_SMS(1);
; 	}
; }
; 
; unsigned char DetQEITING(void)
; {
	.dbline 401
;     volatile unsigned char tmp;
; 	
;     if(!(DetQT()))
	sbic 0x10,2
	rjmp L150
	.dbline 402
;     {
	.dbline 403
; 	    release = 0;
	clr R2
	sts _release,R2
	.dbline 404
; 	    DelayMs(10);
	ldi R16,10
	ldi R17,0
	rcall _DelayMs
	.dbline 406
; 		
; 		if(!(DetQT())) {DettqFlag = 1;}
	sbic 0x10,2
	rjmp L151
	.dbline 406
	.dbline 406
	ldi R24,1
	sts _DettqFlag,R24
	.dbline 406
	.dbline 407
;     }
	rjmp L151
L150:
	.dbline 409
; 	else 
; 	{
	.dbline 410
; 	    release = 1;
	ldi R24,1
	sts _release,R24
	.dbline 411
; 	}
L151:
	.dbline 413
; 			
; 	if(release && DettqFlag)
	lds R2,_release
	tst R2
	breq L154
	lds R2,_DettqFlag
	tst R2
	breq L154
	.dbline 414
; 	{
	.dbline 415
; 	    DettqFlag = 0;
	clr R2
	sts _DettqFlag,R2
	.dbline 416
; 		CplLED();
	ldi R24,1
	in R2,0x18
	eor R2,R24
	out 0x18,R2
	.dbline 418
; 
; 		return (TRUE);
	ldi R16,1
	rjmp L149
L154:
	.dbline 421
; 		
; 	}
; 	return (FALSE);
	clr R16
	.dbline -2
L149:
	adiw R28,1
	.dbline 0 ; func end
	ret
	.dbsym l tmp 0 c
	.dbend
	.dbfunc e IGT _IGT fV
;              n -> R16
	.even
_IGT::
	.dbline -1
	.dbline 425
; }
; 
; void IGT(unsigned char n)
; {
	.dbline 426
;     if(n)
	tst R16
	breq L157
	.dbline 427
; 	{
	.dbline 428
; 	    PORTD &= ~(1<<PD6);
	cbi 0x12,6
	.dbline 429
; 		DDRD |= (1<<PD6);
	sbi 0x11,6
	.dbline 430
; 	}
	rjmp L158
L157:
	.dbline 432
	.dbline 433
	cbi 0x11,6
	.dbline 434
L158:
	.dbline -2
L156:
	.dbline 0 ; func end
	ret
	.dbsym r n 16 c
	.dbend
	.dbfunc e work _work fV
	.even
_work::
	.dbline -1
	.dbline 438
; 	else
; 	{
; 	    DDRD &= ~(1<<PD6);
; 	}
; }
; 			
; void work(void)
; {
	rjmp L161
L160:
	.dbline 440
;     while(1)
; 	{
	.dbline 441
; 	    if(CheckSMS_in())
	rcall _CheckSMS_in
	tst R16
	breq L163
	.dbline 442
; 		{
	.dbline 443
; 		    RecSMS();
	rcall _RecSMS
	.dbline 444
; 	    }
L163:
	.dbline 445
; 		if(CallInFlag) 
	lds R2,_CallInFlag
	tst R2
	breq L165
	.dbline 446
; 		{
	.dbline 447
; 		    Put_AT_command(Ata,AtaLen);
	ldi R18,3
	ldi R16,<_Ata
	ldi R17,>_Ata
	rcall _Put_AT_command
	.dbline 448
; 		    CallInFlag = 0;
	clr R2
	sts _CallInFlag,R2
	.dbline 449
; 		}
L165:
	.dbline 450
; 		if((BusyFlag) || (NoCarrierFlag))  
	lds R2,_BusyFlag
	tst R2
	brne L169
	lds R2,_NoCarrierFlag
	tst R2
	breq L167
L169:
	.dbline 451
; 		{
	.dbline 452
; 		    Put_AT_command(Ath,AthLen);
	ldi R18,3
	ldi R16,<_Ath
	ldi R17,>_Ath
	rcall _Put_AT_command
	.dbline 453
; 			CallOut = 0;
	clr R2
	sts _CallOut,R2
	.dbline 454
; 			BusyFlag = 0;
	sts _BusyFlag,R2
	.dbline 455
; 			NoCarrierFlag = 0;
	sts _NoCarrierFlag,R2
	.dbline 456
; 		}
L167:
	.dbline 457
; 		if(DetQEITING() && (!CallOut))
	rcall _DetQEITING
	tst R16
	breq L170
	lds R2,_CallOut
	tst R2
	brne L170
	.dbline 458
; 		{
	.dbline 459
; 		    CallOut = 1;
	ldi R24,1
	sts _CallOut,R24
	.dbline 460
; 		    DialNum();
	rcall _DialNum
	.dbline 461
; 		}
L170:
	.dbline 462
L161:
	.dbline 439
	rjmp L160
X3:
	.dbline -2
L159:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e InitMC55 _InitMC55 fV
;            tmp -> <dead>
	.even
_InitMC55::
	sbiw R28,1
	.dbline -1
	.dbline 468
; 	}
; }
; /*-----------------------------------------------------------------------*/
; /////////////////////////////  初始化MC55    //////////////////////////////
; /*-----------------------------------------------------------------------*/
; void InitMC55(void)
; {
	.dbline 470
;  	unsigned char tmp;
;     IGT(OFF);                                   
	clr R16
	rcall _IGT
	.dbline 471
;     DelayMs(500);  	   			   			  // 置低MC55 IGT口 200mS ，启动MC55模块
	ldi R16,500
	ldi R17,1
	rcall _DelayMs
	.dbline 472
; 	IGT(ON);
	ldi R16,1
	rcall _IGT
	.dbline 473
;     DelayMs(500);
	ldi R16,500
	ldi R17,1
	rcall _DelayMs
	.dbline 474
;     IGT(OFF);                                   
	clr R16
	rcall _IGT
	.dbline 480
; 
; 
; //	DelayMs(1000);                             // 等待模块启动
; 	
; 
; 	ClrRTS();
	cbi 0x12,4
	.dbline 481
;     DelayMs(50);                              // 激活MC55串口
	ldi R16,50
	ldi R17,0
	rcall _DelayMs
	.dbline 482
; 	SetRTS();
	sbi 0x12,4
	.dbline 483
; 	DelayMs(50);
	ldi R16,50
	ldi R17,0
	rcall _DelayMs
	.dbline 484
; 	ClrRTS();
	cbi 0x12,4
	.dbline 485
;     DelayMs(50);                              // 激活MC55串口
	ldi R16,50
	ldi R17,0
	rcall _DelayMs
	.dbline 486
; 	SetRTS();
	sbi 0x12,4
	.dbline 490
; 
; //	DelayMs(1000);                              // 激活MC55串口
; 		
;     TxIndex = 0;
	clr R2
	sts _TxIndex,R2
	.dbline 491
;     RxIndex = 0;
	sts _RxIndex,R2
L173:
	.dbline 493
L174:
	.dbline 493
; 	
; 	while(!DetQEITING());
	rcall _DetQEITING
	tst R16
	breq L173
	.dbline 495
; 	
; 	PutString("AT",2,0);
	clr R2
	std y+0,R2
	ldi R18,2
	ldi R16,<L176
	ldi R17,>L176
	rcall _PutString
	.dbline 497
; 
; 	DelayMs(500);      
	ldi R16,500
	ldi R17,1
	rcall _DelayMs
	.dbline 499
;   
; 	PutString("AT",2,1);
	ldi R24,1
	std y+0,R24
	ldi R18,2
	ldi R16,<L176
	ldi R17,>L176
	rcall _PutString
	.dbline 501
; 	
; 	PutString("ATV0",4,1);
	ldi R24,1
	std y+0,R24
	ldi R18,4
	ldi R16,<L177
	ldi R17,>L177
	rcall _PutString
	.dbline 503
; 
; 	PutString("ATE0",4,1);
	ldi R24,1
	std y+0,R24
	ldi R18,4
	ldi R16,<L178
	ldi R17,>L178
	rcall _PutString
	.dbline 505
; 
; 	PutString("AT+CNMI=2,1",11,1);
	ldi R24,1
	std y+0,R24
	ldi R18,11
	ldi R16,<L179
	ldi R17,>L179
	rcall _PutString
	.dbline 507
; 
; 	PutString("AT+CMGF=1",9,1);
	ldi R24,1
	std y+0,R24
	ldi R18,9
	ldi R16,<L180
	ldi R17,>L180
	rcall _PutString
	.dbline 509
; 
; 	Delete_SMS(ALL);
	ldi R16,255
	rcall _Delete_SMS
	.dbline 511
; 	
; 	PhoneNum_to_EEPROM();
	rcall _PhoneNum_to_EEPROM
	.dbline 513
; 	
; 	EEPROM_to_PhoneNum();
	rcall _EEPROM_to_PhoneNum
	.dbline -2
L172:
	adiw R28,1
	.dbline 0 ; func end
	ret
	.dbsym l tmp 2 c
	.dbend
	.dbfunc e port_init _port_init fV
	.even
_port_init::
	.dbline -1
	.dbline 540
; 
; }
; 
; /////////////////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////////////
; 
; /*
; #pragma interrupt_handler int0_isr:2
; void int0_isr(void)
; {
;  //external interupt on INT0
;  DialNum();
;  
; }
; 
; #pragma interrupt_handler int1_isr:3
; void int1_isr(void)
; {
;  //external interupt on INT1
; }
; */
; ////////////////////////////////////////////////////////////////////////////////
; 
; void port_init(void)
; {
	.dbline 541
;  PORTB = 0x01;
	ldi R24,1
	out 0x18,R24
	.dbline 542
;  DDRB  = 0x01;
	out 0x17,R24
	.dbline 543
;  PORTC = 0x00; //m103 output only
	clr R2
	out 0x15,R2
	.dbline 544
;  DDRC  = 0x02;
	ldi R24,2
	out 0x14,R24
	.dbline 545
;  PORTD = 0x0C;
	ldi R24,12
	out 0x12,R24
	.dbline 546
;  DDRD  = 0x50;
	ldi R24,80
	out 0x11,R24
	.dbline -2
L181:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e uart0_init _uart0_init fV
	.even
_uart0_init::
	.dbline -1
	.dbline 557
; }
; 
; //UART0 initialize
; // desired baud rate: 19200
; // actual: baud rate:19200 (0.0%)
; // char size: 8 bit
; // parity: Disabled
; //#ifdef XTAL == 3.6864
;  
; void uart0_init(void)
; {
	.dbline 558
;  UCSRB = 0x00; //disable while setting baud rate
	clr R2
	out 0xa,R2
	.dbline 559
;  UCSRA = 0x00;
	out 0xb,R2
	.dbline 560
;  UCSRC = BIT(URSEL) | 0x06;
	ldi R24,134
	out 0x20,R24
	.dbline 561
;  UBRRL = 0x0B; //set baud rate lo
	ldi R24,11
	out 0x9,R24
	.dbline 562
;  UBRRH = 0x00; //set baud rate hi
	out 0x20,R2
	.dbline 563
;  UCSRB = 0xD8;
	ldi R24,216
	out 0xa,R24
	.dbline -2
L182:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e init_devices _init_devices fV
	.even
_init_devices::
	.dbline -1
	.dbline 581
; }
; //#endif
; 
; //#ifdef XTAL == 7.3728
; /*void uart0_init(void)
; {
;  UCSRB = 0x00; //disable while setting baud rate
;  UCSRA = 0x00;
;  UCSRC = BIT(URSEL) | 0x06;
;  UBRRL = 0x17; //set baud rate lo
;  UBRRH = 0x00; //set baud rate hi
;  UCSRB = 0xD8;
; }*/
; //#endif
; 
; //call this routine to initialize all peripherals
; void init_devices(void)
; {
	.dbline 583
;  //stop errant interrupts until set up
;  CLI(); //disable all interrupts
	cli
	.dbline 584
;  port_init();
	rcall _port_init
	.dbline 585
;  uart0_init();
	rcall _uart0_init
	.dbline 587
; 
;  MCUCR = 0x00;
	clr R2
	out 0x35,R2
	.dbline 588
;  GICR  = 0x00; //0xC0;
	out 0x3b,R2
	.dbline 589
;  TIMSK = 0x00; //timer interrupt sources
	out 0x39,R2
	.dbline 590
;  SEI(); //re-enable interrupts
	sei
	.dbline 592
;  
;  InitMC55();
	rcall _InitMC55
	.dbline -2
L183:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e main _main fV
	.even
_main::
	.dbline -1
	.dbline 599
; }
; 
; 
; 
; //
; void main(void)
; {
	.dbline 600
; DelayMs(1000); 
	ldi R16,1000
	ldi R17,3
	rcall _DelayMs
	.dbline 601
;  init_devices();
	rcall _init_devices
	.dbline 602
;  work();
	rcall _work
	.dbline -2
L184:
	.dbline 0 ; func end
	ret
	.dbend
	.area bss(ram, con, rel)
	.dbfile D:\MyProject\SMS-MC55\Code\窃听器delay\main.c
_TxIndex::
	.blkb 1
	.dbfile D:\MyProject\SMS-MC55\Code\窃听器delay/var.h
	.dbsym e TxIndex _TxIndex c
_TxBuf::
	.blkb 32
	.dbsym e TxBuf _TxBuf A[32:32]c
_RxIndex::
	.blkb 1
	.dbsym e RxIndex _RxIndex c
_RxBuf::
	.blkb 128
	.dbsym e RxBuf _RxBuf A[128:128]c
_Pdu::
	.blkb 128
	.dbsym e Pdu _Pdu A[128:128]c
_TmpBuf::
	.blkb 16
	.dbsym e TmpBuf _TmpBuf A[16:16]c
	.area data(ram, con, rel)
	.dbfile D:\MyProject\SMS-MC55\Code\窃听器delay/var.h
L180:
	.blkb 10
	.area idata
	.byte 'A,'T,43,'C,'M,'G,'F,61,49,0
	.area data(ram, con, rel)
	.dbfile D:\MyProject\SMS-MC55\Code\窃听器delay/var.h
L179:
	.blkb 12
	.area idata
	.byte 'A,'T,43,'C,'N,'M,'I,61,50,44,49,0
	.area data(ram, con, rel)
	.dbfile D:\MyProject\SMS-MC55\Code\窃听器delay/var.h
L178:
	.blkb 5
	.area idata
	.byte 'A,'T,'E,48,0
	.area data(ram, con, rel)
	.dbfile D:\MyProject\SMS-MC55\Code\窃听器delay/var.h
L177:
	.blkb 5
	.area idata
	.byte 'A,'T,'V,48,0
	.area data(ram, con, rel)
	.dbfile D:\MyProject\SMS-MC55\Code\窃听器delay/var.h
L176:
	.blkb 3
	.area idata
	.byte 'A,'T,0
	.area data(ram, con, rel)
	.dbfile D:\MyProject\SMS-MC55\Code\窃听器delay/var.h
L135:
	.blkb 10
	.area idata
	.byte 'A,'T,43,'C,'M,'G,'R,61,49,0
	.area data(ram, con, rel)
	.dbfile D:\MyProject\SMS-MC55\Code\窃听器delay/var.h
