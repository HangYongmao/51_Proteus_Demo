#ifndef __KEYPROCESS_H__
#define __KEYPROCESS_H__

void vKeyProcess(unsigned char ucKeyCode);

#define MOTORPORT P1

#define MO_COMMON 0x09		  //正向。
#define MO_OPPOSE 0x06		  //反向。
#define MO_CUTOFF 0x00		  //切断。
#define MO_STOP 0x0A		  //停止。


#endif