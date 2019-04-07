NOTE: AVR Code addresses are word addresses
All other addresses (including ones in FLASH) are byte addresses

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                             lit   0054   03D2 =    978. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       0054  __lit_start
       0054  _ASC_16
       0252  _GB_16
       0426  __lit_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                           idata   0426   0065 =    101. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       0426  __idata_start
       048B  __idata_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                            text   048C   0F4A =   3914. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       0246  __start
       0246  __text_start
       0266  _exit
       0267  _delay_1us
       0269  _delay_nus
       0278  _delay_1ms
       0282  _delay_nms
       0291  _LCD_BUSY
       0321  _write_LCD
       0372  _read_LCD
       0403  _set_start_line_L
       0411  _set_start_line_R
       041F  _set_page_L
       042D  _set_page_R
       043B  _set_col_addr_L
       0449  _set_col_addr_R
       0457  _init_lcd
       0468  _clr_lcd
       048B  _GetPage
       048E  _GetCol
       0491  _SetPageCol
       04A8  _SetRowCol
       04E4  _disp_ch
       05F9  _disp_hz
       070B  _disp_str
       0730  _pixel
       0799  _Linexy
       0837  _circle
       08D0  _delay
       08F3  _init_port
       0900  _main
       096C  push_arg4
       096E  push_arg2
       0971  mod16s
       0975  div16s
       098F  mod16u
       0991  div16u
       0992  xdiv16u
       09AB  empy16s
       09BB  pop_gset2
       09BE  pop_gset4
       09C1  pop_gset5
       09C4  push_gset1
       09C7  pop_gset1
       09C8  pop
       09DB  push_gset2
       09DF  push_gset3
       09E3  push_gset4
       09E7  push_gset5
       09EB  __text_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                            data   0060   0065 =    101. bytes (rel,con,ram)

       Addr  Global Symbol
      -----  --------------------------------
       0060  _LCD_DIR_PORT
       0060  __data_start
       0062  _LCD_IP_PORT
       0064  _LCD_OP_PORT
       0066  _LCD_EN_PORT
       0068  _LCD_CS2_PORT
       006A  _LCD_CS1_PORT
       006C  _LCD_RW_PORT
       006E  _LCD_DI_PORT
       0070  _LCD_EN_BIT
       0071  _LCD_CS2_BIT
       0072  _LCD_CS1_BIT
       0073  _LCD_RW_BIT
       0074  _LCD_DI_BIT
       00C5  __data_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                             bss   00C5   0004 =      4. bytes (rel,con,ram)

       Addr  Global Symbol
      -----  --------------------------------
       00C5  __bss_start
       00C5  _CurCol
       00C6  _CurPage
       00C7  _CurRow
       00C8  _CurOffset
       00C9  __bss_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                          vector   0000   0004 =      4. bytes (abs,ovr,rom)

Files Linked      [ module(s) ]

D:\icc\lib\crtatmega.o	[ crtatmega.s ]
DISPLAY.o	[ DISPLAY.C ]
<library>	[ asave.s, div16s.s, div16u.s, emul16s.s, gpop2.s, gpop4.s, gpop5.s, gpush.s, gpush2.s, gpush3.s, gpush4.s ]
[ gpush5.s ]

User Global Definitions

ram_end = 0x85f
hwstk_size = 0x10

User Base Address Definitions

func_lit = 0x54
data = 0x60
eeprom:1.1024

