//ICC-AVR application builder : 2006-5-9 12:31:05
// Target : M32
// Crystal: 16.000Mhz

#include <iom32v.h>
#include <macros.h>

void port_init(void)
{
 PORTA = 0x00;
 DDRA  = 0xFF;
 PORTB = 0x0F;
 DDRB  = 0x10;
 PORTC = 0x00; 
 DDRC  = 0xFF;
 PORTD = 0x00;
 DDRD  = 0xFD;
}

//TWI initialize
// bit rate:0
void twi_init(void)
{
 TWCR= 0x00; //disable twi
 TWBR= 0x00; //set bit rate
 TWAR= 0x01; //set slave address
 TWCR= 0x05; //enable twi
}

#pragma interrupt_handler twi_isr:20
void twi_isr(void)
{
 //twi event
}

//UART0 initialize
// desired baud rate: 9600
// actual: baud rate:9615 (0.2%)
// char size: 8 bit
// parity: Disabled
void uart0_init(void)
{
 UCSRB = 0x00; //disable while setting baud rate
 UCSRA = 0x00;
 UCSRC = BIT(URSEL) | 0x06;
 UBRRL = 0x67; //set baud rate lo
 UBRRH = 0x00; //set baud rate hi
 UCSRB = 0x18;
}

//call this routine to initialize all peripherals
void init_devices(void)
{
 //stop errant interrupts until set up
 CLI(); //disable all interrupts
 port_init();
 twi_init();
 uart0_init();

 MCUCR = 0x00;
 GICR  = 0x00;
 TIMSK = 0x00; //timer interrupt sources
 SEI(); //re-enable interrupts
 //all peripherals are now initialized
}

//
void main(void)
{
 init_devices();
 //insert your functional code here...
}

