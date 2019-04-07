CC = iccavr
CFLAGS =  -ID:\icc\include\ -e -DATMEGA  -l -g -Mavr_enhanced 
ASFLAGS = $(CFLAGS)  -Wa-g
LFLAGS =  -LD:\icc\lib\ -g -ucrtatmega.o -bfunc_lit:0x54.0x8000 -dram_end:0x85f -bdata:0x60.0x85f -dhwstk_size:16 -beeprom:1.1024 -fihx_coff -S2
FILES = DISPLAY.o 

MEGA32-LCM:	$(FILES)
	$(CC) -o MEGA32-LCM $(LFLAGS) @MEGA32-LCM.lk   -lcatmega
DISPLAY.o: D:/icc/include/iom32v.h D:/icc/include/macros.h E:\PROTEU~1.7\User\MEGA32-LCM\MEGA32-LCM/delay.h
DISPLAY.o:	E:\PROTEU~1.7\User\MEGA32-LCM\MEGA32-LCM\DISPLAY.C
	$(CC) -c $(CFLAGS) E:\PROTEU~1.7\User\MEGA32-LCM\MEGA32-LCM\DISPLAY.C
