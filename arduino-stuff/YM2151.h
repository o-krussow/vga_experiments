#if !defined( YM2151_H_INCLUDED )
#define YM2151_H_INCLUDED
#include	"Arduino.h"
#include	<avr/pgmspace.h>

class	YM2151_Class{
	public:
		YM2151_Class();
		void	begin();
		void	initLFO();
		uint8_t	read();
		void	write(uint8_t addr,uint8_t data);
		
		void	setTone(uint8_t ch,uint8_t keycode,int16_t kf);
		void	setVolume(uint8_t ch,uint8_t volume,uint16_t offset);
		void	noteOn(uint8_t ch);
		void	noteOff(uint8_t ch);
		void	loadTimbre(uint8_t ch,uint16_t prog_addr);
		void	loadSeparationTimbre(uint8_t ch,uint16_t prog_addr);
		void	dumpTimbre(uint16_t prog_addr);
		void	setPanpot(uint8_t ch,uint8_t pan);
	private:
		static	const	uint8_t		YM_PIN_D0=A2;
		static	const	uint8_t		YM_PIN_D1=A3;
		static	const	uint8_t		YM_PIN_D2=A4;
		static	const	uint8_t		YM_PIN_D3=A5;
		static	const	uint8_t		YM_PIN_D4=A6;
		static	const	uint8_t		YM_PIN_D5=A7;
		static	const	uint8_t		YM_PIN_D6=A8;
		static	const	uint8_t		YM_PIN_D7=A9;
		
		static	const	uint8_t		YM_PIN_RD=A10;
		static	const	uint8_t		YM_PIN_WR=A11;
		static	const	uint8_t		YM_PIN_A0=A12;
		static	const	uint8_t		YM_PIN_IC=A13;
		
		uint8_t		RegFLCON[8];
		uint8_t		RegSLOTMASK[8];
		uint8_t		CarrierSlot[8];
		uint8_t		RegTL[8][4];

		void	wait(uint8_t loop);
};
extern YM2151_Class YM2151;
#endif  //YM2151H_INCLUDED