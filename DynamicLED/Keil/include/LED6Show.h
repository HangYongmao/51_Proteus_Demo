#ifndef __LED6SHOW_H__
#define __LED6SHOW_H__

unsigned char * pucLedNum(unsigned long ulNumber);  
//计算一个在000000到999999之间的数的每位数字并存储在数组中.并返回数组的首地址

void vShowOneNum(unsigned char ucOneNum,unsigned char ucOrder);
//输入一个数字以及所要显示的位置,在LED相应位置上显示相应数字.

#endif