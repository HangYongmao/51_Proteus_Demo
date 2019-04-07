CC = iccavr
CFLAGS =  -ID:\icc\include\ -e -DATMega8  -l -g -Mavr_enhanced_small -Wa-W 
ASFLAGS = $(CFLAGS)  -Wa-g
LFLAGS =  -LD:\icc\lib\ -g -Wl-W -bfunc_lit:0x26.0x2000 -dram_end:0x45f -bdata:0x60.0x45f -dhwstk_size:16 -beeprom:1.512 -fihx_coff -S0
FILES = main.o delay.o 

Detectaphone:	$(FILES)
	$(CC) -o Detectaphone $(LFLAGS) @Detectaphone.lk  
main.o: D:/icc/include/iom8v.h D:/icc/include/macros.h D:\MyProject\SMS-MC55\Code\ÇÔÌýÆ÷delay/var.h D:/icc/include/iom8v.h D:/icc/include/macros.h
main.o:	D:\MyProject\SMS-MC55\Code\ÇÔÌýÆ÷delay\main.c
	$(CC) -c $(CFLAGS) D:\MyProject\SMS-MC55\Code\ÇÔÌýÆ÷delay\main.c
delay.o: D:/icc/include/iom8v.h D:/icc/include/macros.h
delay.o:	D:\MyProject\SMS-MC55\Code\ÇÔÌýÆ÷delay\delay.c
	$(CC) -c $(CFLAGS) D:\MyProject\SMS-MC55\Code\ÇÔÌýÆ÷delay\delay.c
