//*************************************************************************************************
//*																								  *
//*			 ******************************大写字母处理函数**************************			  *
//*																								  *
//*************************************************************************************************


extern unsigned char uc_ClickCount;
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<按键第1个字母处理函数>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
unsigned char ucCapOne(unsigned char ucKeyCode)
{
	switch(ucKeyCode)
		{
		case 11:return 'A';break;
		case 12:return 'D';break;
		case 13:return 'G';break;
		case 21:return 'J';break;
		case 22:return 'M';break;
		case 23:return 'P';break;
		case 31:return 'S';break;
		case 32:return 'V';break;
		case 33:return 'Y';break;
		default:break;
		}
	return 0xFF;
}


//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<按键第2个字母处理函数>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
unsigned char ucCapTwo(unsigned char ucKeyCode)
{
	switch(ucKeyCode)
		{
		case 11:return 'B';break;
		case 12:return 'E';break;
		case 13:return 'H';break;
		case 21:return 'K';break;
		case 22:return 'N';break;
		case 23:return 'Q';break;
		case 31:return 'T';break;
		case 32:return 'W';break;
		case 33:uc_ClickCount=2;return 'Z';break;
		default:break;
		}
	return 0xFF;
}


//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<按键第3个字母处理函数>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
unsigned char ucCapThree(unsigned char ucKeyCode)
{
	switch(ucKeyCode)
		{
		case 11:return 'C';break;
		case 12:return 'F';break;
		case 13:return 'I';break;
		case 21:return 'L';break;
		case 22:return 'O';break;
		case 23:return 'R';break;
		case 31:return 'U';break;
		case 32:return 'X';break;
		default:break;
		}
	return 0xFF;
}