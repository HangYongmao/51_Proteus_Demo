////////////////////////////////////////////////////////////////////////////////
// ICC-AVR application builder : 2006-6-25 ���� 06:02:39
// Target : M8
// Crystal: 3.6864Mhz
// Author:  Anwarye
// Title:   Detcetaphone
////////////////////////////////////////////////////////////////////////////////

#include <iom8v.h>
#include <macros.h>

////////////////////////////////////////////////////////////////////////////////




#define SetIGT()	 (PORTD |= (1<<PD6))	  // MC55ģ������ƽţ�����Ч
#define ClrIGT()     (PORTD &= ~(1<<PD6))

#define SetLED()     (PORTB |= (1<<PB0))     // LED
#define ClrLED()     (PORTB &= ~(1<<PB0))

#define CplLED()     (PORTB ^=(1<<PB0))  


#define SetRTS()     (PORTD |= (1<<PD4))     // LED
#define ClrRTS()     (PORTD &= ~(1<<PD4))

#define DetRING0()   (PIND & (1<<PD3))
#define DetQT()      (PIND & (1<<PD2))


#define FALSE      0
#define TRUE       1

#define DONE       1
#define UNDONE     0

#define OK         1
#define ERROR      0

#define ON         1
#define OFF        0

#define ALL        0xFF


#define RX_BUF_SIZE  128
#define TX_BUF_SIZE  32


volatile unsigned char          TmpBuf[16];                // ��ʱ����
volatile unsigned char          Pdu[128];
//volatile unsigned char          RetCMGR[14];
volatile unsigned char          PhoneNum[12]={"13713526472"}; 

unsigned char                   RxBuf[RX_BUF_SIZE];		   // ���ڽ��ջ���
volatile unsigned char          RxIndex;                   // ���ڽ��ջ���ָ��
volatile unsigned char          RxIndexTail = 0;               // ���ڽ��ջ���β


volatile unsigned char          TxBuf[TX_BUF_SIZE];		   // ���ͻ���
volatile unsigned char          TxIndex;                   // ���ͻ���ָ��

//volatile unsigned char          _0D_Flag = 0;
static volatile unsigned char          RxStatus = 0;
static volatile unsigned char          TxStatus = 1;

static volatile unsigned char          OkFlag = 0;
static volatile unsigned char          CallInFlag = 0;
static volatile unsigned char          NoCarrierFlag = 0;
static volatile unsigned char          BusyFlag = 0;
static volatile unsigned char          DettqFlag = 0;
static volatile unsigned char          release = 0;
static volatile unsigned char          CallOut = 0;

static volatile unsigned char          error = 0;

static volatile unsigned char          PhoneNumData = 0;



////////////////////////////////////////////////////////////////////////////////
extern void DelayMs(unsigned int ms);
extern void PhoneNum_to_EEPROM(void);
extern void EEPROM_to_PhoneNum(void);

////////////////////////////////////////////////////////////////////////////////

//���峣��,�ڳ�����
const unsigned char At[]        =     {"AT"};	   						   		// AT������ͷ
const unsigned char Ata[]       =     {"ATA"};                                  // ��������
const unsigned char Ath[]       =     {"ATH"};                                  // �һ�
const unsigned char Ate0[]      =     {"ATE0"};                                 // �رջ���
const unsigned char Atv0[]      =     {"ATV0"};                                 // ����ģ�鷵�����ʽ V0 = �򵥷������� V1=���ӷ����ı�
const unsigned char Atx0[]      =     {"ATX0"};                                 // ���ú��е绰�󷵻���Ϣ��ʽ
const unsigned char Atf[]       =     {"AT&F"};                                 // �ָ���������
const unsigned char Atclip[]    =     {"AT+CLIP=1"};                            // Calling line identification presentation
const unsigned char Atcsq[]     =     {"AT+CSQ"};                               // ��ѯGSM�ź�ǿ��
const unsigned char Atssyn[]    =     {"AT^SSYNC=1"};                           // Configure SYNC Pin
const unsigned char Atsmso[]    =     {"AT^SMSO"};                              // Switch off mobile station
const unsigned char Atsnfs[]    =     {"AT^SNFS=4"};                            // Select audio hardware set
const unsigned char Atsnfi[]    =     {"AT^SNFI=4,32767"};                      // Set microphone path parameters
const unsigned char Atcnmi[]    =     {"AT+CNMI=1,1,0,0,1"};                    // ��SMS��Ϣָʾ AT+CNMI =[<mode>][,<mt>][,<bm>][,<ds>][,<bfr>] ��See 168 page
const unsigned char Atsnfo[]    =     {"AT^SNFO=3,16384,16384,16384,16384,16384,4,0"}; //Set audio output (= loudspeaker path) parameter
const unsigned char Atcmgf[]    =     {"AT+CMGF=0"};                            // ѡ��SMS��Ϣ��ʽ =0 PUD Mode, =1 TEXT Mode
const unsigned char Atcmgs[]    =     {"AT+CMGS="};                             // ���Ͷ���Ϣ����ϸ��162ҳ
const unsigned char Atcmgr[]    =     {"AT+CMGR=1"};                            // ������Ϣ����159ҳ
const unsigned char Atcmgl[]    =     {"AT+CMGL=0"};                            // �г�����Ϣ����ѡ�洢�� =0 �г�δ��ȡ�Ķ���Ϣ
const unsigned char Atcmgd[]    =     {"AT+CMGD="};                             // ɾ������Ϣ��= X ,X�Ƕ��Ž�����ţ�һ��ֻ��ɾ��һ��
const unsigned char Atsnfpt[]   =     {"AT^SNFPT=0"};                           // Call progress tones
const unsigned char Atclck1[]   =     {"AT+CLCK=\"SC\",1,"};                    // ������ Facility lock SC= SIM����1=����
const unsigned char Atcpin[]    =     {"AT+CPIN?"};                             // Enter PIN,����PIN��
const unsigned char Atclck2[]   =     {"AT+CLCK=\"SC\",2"};                     // ������ Facility lock SC= SIM����2=��ѯ����״̬
const unsigned char Atcpwd[]    =     {"AT+CPWD=\"SC\","};                      // Change password �޸�PIN��
const unsigned char Atclck0[]   =     {"AT+CLCK=\"SC\",0,"};                    // ������ Facility lock SC= SIM����0=����
const unsigned char Atcpinc[]   =     {"AT+CPIN="};                             // ����PIN�� Enter PIN
const unsigned char Atsblk[]    =     {"AT^SBLK"};

const unsigned char Atccfc[]    =     {"AT^CCFC="};                             // ���ú���ת�� AT+CCFC=<reas>,<mode>[,<number>[,<type>[,<class>[,<time>]]]]

const unsigned char SMSin[]     =     {"+CMTI: \"SM\", 1"};                     // �յ���Ϣ 1��
const unsigned char Atd[]       =     {"ATD"};

// ����AT�������
//const unsigned char AtcLength[] =     {2,3,3,4,4,4,4,9,6,10,7,9,15,17,43,9,8,8,9,8,10,15,8,14,13,15,8,7};
#define AtLen     	  2
#define AtaLen     	  3
#define AthLen        3
#define Ate0Len       4
#define Atv0Len       4
#define Atx0Len       4
#define AtfLen        4
#define AtclipLen     9
#define AtcsqLen      6
#define AtssynLen     10
#define AtsmsoLen     7
#define AtsnfsLen     9
#define AtsnfiLen     15
#define AtcnmiLen     17
#define AtsnfoLen     43
#define AtcmgfLen     9
#define AtcmgsLen     8
#define AtcmgrLen     9
#define AtcmglLen     9
#define AtcmgdLen     8
#define AtsnfptLen    10
#define Atclck1Len    15
#define AtcpinLen     8
#define Atclck2Len    14
#define AtcpwdLen     13
#define Atclck0Len    15
#define AtcpincLen    8
#define AtcsblkLen    7
#define SMSinLen      14

#define AtdLen        3