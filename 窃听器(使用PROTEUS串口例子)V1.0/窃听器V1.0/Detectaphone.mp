NOTE: AVR Code addresses are word addresses
All other addresses (including ones in FLASH) are byte addresses

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                             lit   0026   0149 =    329. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       0026  _At
       0026  __lit_start
       0029  _Ata
       002D  _Ath
       0031  _Ate0
       0036  _Atv0
       003B  _Atx0
       0040  _Atf
       0045  _Atclip
       004F  _Atcsq
       0056  _Atssyn
       0061  _Atsmso
       0069  _Atsnfs
       0073  _Atsnfi
       0083  _Atcnmi
       0095  _Atsnfo
       00C1  _Atcmgf
       00CB  _Atcmgs
       00D4  _Atcmgr
       00DE  _Atcmgl
       00E8  _Atcmgd
       00F1  _Atsnfpt
       00FC  _Atclck1
       010C  _Atcpin
       0115  _Atclck2
       0124  _Atcpwd
       0132  _Atclck0
       0142  _Atcpinc
       014B  _Atsblk
       0153  _Atccfc
       015C  _SMSin
       016B  _Atd
       016F  __lit_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                           idata   016F   0045 =     69. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       016F  __idata_start
       01B4  __idata_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                            text   01B4   0924 =   2340. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       00DA  __text_start
       00DA  __start
       00F9  _exit
       00FA  _uart0_rx_isr
       018B  _uart0_tx_isr
       01C8  _CheckRx
       01E6  _ClearRxBuf
       01F4  _TxEnable
       01F9  _Put_AT_command
       0235  _Put_AT_String
       0271  _PutString
       02B7  _DialNum
       0310  _StringCompare
       0327  _Delete_SMS
       0366  _CheckSMS_in
       037C  _CheckSMS
       03A5  _CheckPhoneNum
       03B3  _RecSMS
       040A  _DetQEITING
       0430  _IGT
       0437  _work
       0467  _InitMC55
       04B6  _port_init
       04C2  _uart0_init
       04CD  _init_devices
       04D7  _main
       04DD  _DelayMs
       04F2  _Write_EEPROM
       0509  _Read_EEPROM
       051F  _PhoneNum_to_EEPROM
       0532  _EEPROM_to_PhoneNum
       0545  pop_gset2
       0547  pop_gset3
       0549  pop_gset4
       054B  pop_gset5
       054D  push_gset5
       054F  push_gset4
       0551  push_gset3
       0553  push_gset2
       0555  push_gset1
       0558  pop_gset1
       0559  pop
       056C  __text_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                            data   0060   0045 =     69. bytes (rel,con,ram)

       Addr  Global Symbol
      -----  --------------------------------
       0060  __data_start
       0060  _PhoneNum
       006C  _RxIndexTail
       00A5  __data_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                             bss   00A5   0132 =    306. bytes (rel,con,ram)

       Addr  Global Symbol
      -----  --------------------------------
       00A5  __bss_start
       00A5  _TxIndex
       00A6  _TxBuf
       00C6  _RxIndex
       00C7  _RxBuf
       0147  _Pdu
       01C7  _TmpBuf
       01D7  __bss_end

Area                               Start  End    Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                          vector   0000   001C =     28. bytes (abs,ovr,rom)

Files Linked      [ module(s) ]

D:\icc\lib\crtAVR.o	[ crtavr.s ]
main.o	[ main.c ]
delay.o	[ delay.c ]
<library>	[ gpop2.s, gpop3.s, gpop4.s, gpop5.s, gpush.s ]

User Global Definitions

ram_end = 0x45f
hwstk_size = 0x10

User Base Address Definitions

func_lit = 0x26
data = 0x60
eeprom:1.512

