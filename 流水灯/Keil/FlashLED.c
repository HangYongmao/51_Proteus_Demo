#include <REGX52.H>

void Delay1ms(unsigned int count)
{
	unsigned int i,j;
	for(i=0;i<count;i++)
	for(j=0;j<120;j++);
}

main()
{
	unsigned char LEDIndex = 0;
	bit LEDDirection = 1;

	while(1)
	{
		if(LEDDirection)
			P1 = ~(0x01<<LEDIndex);
		else
			P1 = ~(0x80>>LEDIndex);	
		if(LEDIndex==7)
			LEDDirection = !LEDDirection;
		LEDIndex = (LEDIndex+1)%8;
		Delay1ms(100);
	}
}
