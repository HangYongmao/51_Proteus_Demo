//*************************************************************************************************
//*																								  *
//*			 ******************************Сд��ĸ������**************************			  *
//*																								  *
//*************************************************************************************************

extern unsigned char uc_ClickCount;
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<������1����ĸ������>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
unsigned char ucSmallOne(unsigned char ucKeyCode)
{
	switch(ucKeyCode)
		{
		case 11:return 'a';break;
		case 12:return 'd';break;
		case 13:return 'g';break;
		case 21:return 'j';break;
		case 22:return 'm';break;
		case 23:return 'p';break;
		case 31:return 's';break;
		case 32:return 'v';break;
		case 33:return 'y';break;
		default:break;
		}
	return 0xFF;
}

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<������2����ĸ������>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
unsigned char ucSmallTwo(unsigned char ucKeyCode)
{
	switch(ucKeyCode)
		{
		case 11:return 'b';break;
		case 12:return 'e';break;
		case 13:return 'h';break;
		case 21:return 'k';break;
		case 22:return 'n';break;
		case 23:return 'q';break;
		case 31:return 't';break;
		case 32:return 'w';break;
		case 33:uc_ClickCount=2;return 'z';break;
		default:break;
		}
	return 0xFF;
}

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<������3����ĸ������>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
unsigned char ucSmallThree(unsigned char ucKeyCode)
{
	switch(ucKeyCode)
		{
		case 11:return 'c';break;
		case 12:return 'f';break;
		case 13:return 'i';break;
		case 21:return 'l';break;
		case 22:return 'o';break;
		case 23:return 'r';break;
		case 31:return 'u';break;
		case 32:return 'x';break;
		default:break;
		}
	return 0xFF;
}