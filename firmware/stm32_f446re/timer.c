#include "device_driver.h"

#define TIM2_TICK         	(20) 				// usec
#define TIM2_FREQ 	  		(1000000/TIM2_TICK)	// Hz
#define TIME2_PLS_OF_1ms  	(1000/TIM2_TICK)
#define TIM2_MAX	  		(0xffffu)

#define TIM4_TICK	  		(20) 				// usec
#define TIM4_FREQ 	  		(1000000/TIM4_TICK) // Hz
#define TIME4_PLS_OF_1ms  	(1000/TIM4_TICK)
#define TIM4_MAX	  		(0xffffu)

void TIM2_Stopwatch_Start(void)
{
	Macro_Set_Bit(RCC->APB1ENR, 0);

	TIM2->CR1 = (1<<4)|(1<<3);
	TIM2->PSC = (unsigned int)(TIMXCLK/50000.0 + 0.5)-1;
	TIM2->ARR = TIM2_MAX;

	Macro_Set_Bit(TIM2->EGR,0);
	Macro_Set_Bit(TIM2->CR1, 0);
}

unsigned int TIM2_Stopwatch_Stop(void)
{
	unsigned int time;

	Macro_Clear_Bit(TIM2->CR1, 0);
	time = (TIM2_MAX - TIM2->CNT) * TIM2_TICK;
	return time;
}

/* Delay Time Max = 65536 * 20use = 1.3sec */

#if 0

void TIM2_Delay(int time)
{
	Macro_Set_Bit(RCC->APB1ENR, 0);

	TIM2->CR1 = (1<<4)|(1<<3);
	TIM2->PSC = (unsigned int)(TIMXCLK/(double)TIM2_FREQ + 0.5)-1;
	TIM2->ARR = TIME2_PLS_OF_1ms * time;

	Macro_Set_Bit(TIM2->EGR,0);
	Macro_Clear_Bit(TIM2->SR, 0);
	Macro_Set_Bit(TIM2->CR1, 0);

	while(Macro_Check_Bit_Clear(TIM2->SR, 0));

	Macro_Clear_Bit(TIM2->CR1, 0);
}

#else

/* Delay Time Extended */

void TIM2_Delay(int time)
{
	int i;
	unsigned int t = TIME2_PLS_OF_1ms * time;

	Macro_Set_Bit(RCC->APB1ENR, 0);

	TIM2->PSC = (unsigned int)(TIMXCLK/(double)TIM2_FREQ + 0.5)-1;
	TIM2->CR1 = (1<<4)|(1<<3);
	TIM2->ARR = 0xffff;
	Macro_Set_Bit(TIM2->EGR,0);

	for(i=0; i<(t/0xffffu); i++)
	{
		Macro_Set_Bit(TIM2->EGR,0);
		Macro_Clear_Bit(TIM2->SR, 0);
		Macro_Set_Bit(TIM2->CR1, 0);
		while(Macro_Check_Bit_Clear(TIM2->SR, 0));
	}
	// 돌리고 자투리만큼 더 돌리기 
	TIM2->ARR = t % 0xffffu;
	Macro_Set_Bit(TIM2->EGR,0);
	Macro_Clear_Bit(TIM2->SR, 0);
	Macro_Set_Bit(TIM2->CR1, 0);
	while (Macro_Check_Bit_Clear(TIM2->SR, 0));

	Macro_Clear_Bit(TIM2->CR1, 0);
}

#endif

void TIM4_Repeat(int time)
{
	Macro_Set_Bit(RCC->APB1ENR, 2);

	TIM4->CR1 = (1<<4)|(0<<3);
	TIM4->PSC = (unsigned int)(TIMXCLK/(double)TIM4_FREQ + 0.5)-1;
	TIM4->ARR = TIME4_PLS_OF_1ms * time - 1;

	Macro_Set_Bit(TIM4->EGR,0);
	Macro_Clear_Bit(TIM4->SR, 0);
	Macro_Set_Bit(TIM4->CR1, 0);
}

int TIM4_Check_Timeout(void)
{
	if(Macro_Check_Bit_Set(TIM4->SR, 0))
	{
		Macro_Clear_Bit(TIM4->SR, 0);
		return 1;
	}
	else
	{
		return 0;
	}
}

void TIM4_Stop(void)
{
	Macro_Clear_Bit(TIM4->CR1, 0);
}

void TIM4_Change_Value(int time)
{
	TIM4->ARR = TIME4_PLS_OF_1ms * time;
}

void TIM4_Repeat_Interrupt_Enable(int en, int time)
{
	if(en)
	{
		// TIM4 Clock On
		Macro_Set_Bit(RCC->APB1ENR, 2);
		TIM4->CR1 = (1<<4)|(0<<3);
		TIM4->PSC = (unsigned int)(TIMXCLK/(double)TIM4_FREQ + 0.5)-1;
		TIM4->ARR = TIME4_PLS_OF_1ms * time;
		Macro_Set_Bit(TIM4->EGR,0);

		// TIM4 Pending Clear
		Macro_Clear_Bit(TIM4->SR, 0);
		// NVIC Pending Clear
		NVIC_ClearPendingIRQ(30);

		// TIM4 Interrupt Enable
		Macro_Set_Bit(TIM4->DIER, 0);
		// NVIC Interrupt Enable
		NVIC_EnableIRQ((IRQn_Type)30);
		// TIM4 Start
		Macro_Set_Bit(TIM4->CR1, 0);

	}

	else
	{
		NVIC_DisableIRQ(30);
		Macro_Clear_Bit(TIM4->CR1, 0);
		Macro_Clear_Bit(TIM4->DIER, 0);
		Macro_Clear_Bit(TIM4->SR, 0);
		NVIC_ClearPendingIRQ(30);
	}
}

#define TIM3_COUNTER_FREQ    (1000000u)

void TIM3_Out_Init(void)
{
    /* GPIOA Clock Enable */
    Macro_Set_Bit(RCC->AHB1ENR, 0);

    /* TIM3 Clock Enable */
    Macro_Set_Bit(RCC->APB1ENR, 1);

    /* PA6 = Alternate Function */
    Macro_Write_Block(GPIOA->MODER, 0x3, 0x2, 12);

    /* PA6 = AF2 = TIM3_CH1 */
    Macro_Write_Block(GPIOA->AFR[0], 0xf, 0x2, 24);

    /* Push-Pull */
    Macro_Clear_Bit(GPIOA->OTYPER, 6);

    /* TIM3 CH1 PWM Mode 1 + preload */
    Macro_Write_Block(TIM3->CCMR1, 0xff, 0x68, 0);

    /* TIM3 CH1 Output Enable */
    Macro_Set_Bit(TIM3->CCER, 0);

    /* 초기 Duty 0% */
    TIM3->CCR1 = 0;

    /* 초기에는 정지 */
    Macro_Clear_Bit(TIM3->CR1, 0);
}

void TIM3_Out_Freq_Generation(unsigned short freq)
{
    if (freq == 0)
    {
        TIM3_Out_Stop();
        return;
    }

    /* TIM3 Counter Clock = 1MHz */
    TIM3->PSC =
        (unsigned int)
        (TIMXCLK / (double)TIM3_COUNTER_FREQ + 0.5) - 1;

    /* PWM 주파수 설정 */
    TIM3->ARR = (TIM3_COUNTER_FREQ / freq) - 1;

    /* Duty 50%, PA6 = TIM3_CH1이므로 CCR1 */
    TIM3->CCR1 = (TIM3->ARR + 1) / 2;

    /* 레지스터 반영 */
    Macro_Set_Bit(TIM3->EGR, 0);
    Macro_Clear_Bit(TIM3->SR, 0);

    /* Up Counter, Repeat Mode, Start */
    TIM3->CR1 =
        (0 << 4) |
        (0 << 3) |
        (1 << 0);
}

void TIM3_Out_Stop(void)
{
    /* Timer Stop */
    Macro_Clear_Bit(TIM3->CR1, 0);

    /* Duty 0% */
    TIM3->CCR1 = 0;

    /* 변경값 반영 */
    Macro_Set_Bit(TIM3->EGR, 0);
}