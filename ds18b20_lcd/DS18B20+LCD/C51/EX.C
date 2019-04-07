#include "reg51.H"

extern unsigned int GET_TEMPER();
extern unsigned char TEMPER_COV(unsigned int j);
main()
{
	unsigned int kk;
	unsigned char k;
	P1=0xff;
	while(1)
	{
		kk=GET_TEMPER();
		k=TEMPER_COV(kk);
	}
}
