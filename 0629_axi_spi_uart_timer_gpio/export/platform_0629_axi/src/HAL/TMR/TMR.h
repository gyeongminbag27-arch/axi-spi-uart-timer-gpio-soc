#ifndef TMR_H_
#define TMR_H_

#include <stdint.h>
// #include "xparameters.h"

typedef struct {
    volatile uint32_t CR;   // 0x00
    volatile uint32_t PSC;  // 0x04
    volatile uint32_t ARR;  // 0x08
    volatile uint32_t CNT;  // 0x0C
} TMR_TypeDef;

#define TMR0_BASEADDR 0x44A60000
#define TMR0 ((TMR_TypeDef *)TMR0_BASEADDR)

// bit index, not bit mask
#define TMR_EN_BIT    0U
#define TMR_IE_BIT    1U

void TMR_SetPSC(TMR_TypeDef *tmr, uint32_t psc);
uint32_t TMR_GetPSC(TMR_TypeDef *tmr);
void TMR_SetARR(TMR_TypeDef *tmr, uint32_t arr);
uint32_t TMR_GetARR(TMR_TypeDef *tmr);
void TMR_SetCNT(TMR_TypeDef *tmr, uint32_t cnt);
uint32_t TMR_GetCNT(TMR_TypeDef *tmr);

void TMR_StartTimer(TMR_TypeDef *tmr);
void TMR_StopTimer(TMR_TypeDef *tmr);
void TMR_StartInterrupt(TMR_TypeDef *tmr);
void TMR_StopInterrupt(TMR_TypeDef *tmr);

#endif
