#ifndef HAL_UART_H_
#define HAL_UART_H_

#include <stdint.h>
// #include "xparameters.h"

typedef struct {
    volatile uint32_t SR;   // 0x00, bit0 tx_ready, bit1 rx_flag
    volatile uint32_t TDR;  // 0x04
    volatile uint32_t RDR;  // 0x08
    volatile uint32_t CR;   // 0x0C, bit0 interrupt enable
} UART_TypeDef;

#define UART0_BASEADDR 0x44A70000
#define UART0 ((UART_TypeDef *)UART0_BASEADDR)

void UART_StartInterrupt(UART_TypeDef *uart);
void UART_StopInterrupt(UART_TypeDef *uart);
void UART_Transmit(UART_TypeDef *uart, uint8_t data);
uint8_t UART_Receive(UART_TypeDef *uart);
uint8_t UART_RxAvailable(UART_TypeDef *uart);
void UART_Print(const char *str);
void UART_PrintHex8(uint8_t data);

#endif
