#include "TMR.h"

void TMR_SetPSC(TMR_TypeDef *tmr, uint32_t psc)
{
    tmr->PSC = psc;
}

uint32_t TMR_GetPSC(TMR_TypeDef *tmr)
{
    return tmr->PSC;
}

void TMR_SetARR(TMR_TypeDef *tmr, uint32_t arr)
{
    tmr->ARR = arr;
}

uint32_t TMR_GetARR(TMR_TypeDef *tmr)
{
    return tmr->ARR;
}

void TMR_SetCNT(TMR_TypeDef *tmr, uint32_t cnt)
{
    tmr->CNT = cnt;
}

uint32_t TMR_GetCNT(TMR_TypeDef *tmr)
{
    return tmr->CNT;
}

void TMR_StartTimer(TMR_TypeDef *tmr)
{
    tmr->CR |= (1U << TMR_EN_BIT);
}

void TMR_StopTimer(TMR_TypeDef *tmr)
{
    tmr->CR &= ~(1U << TMR_EN_BIT);
}

void TMR_StartInterrupt(TMR_TypeDef *tmr)
{
    tmr->CR |= (1U << TMR_IE_BIT);
}

void TMR_StopInterrupt(TMR_TypeDef *tmr)
{
    tmr->CR &= ~(1U << TMR_IE_BIT);
}
