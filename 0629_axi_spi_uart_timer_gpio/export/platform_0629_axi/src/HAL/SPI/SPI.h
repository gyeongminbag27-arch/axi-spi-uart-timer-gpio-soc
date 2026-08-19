#ifndef HAL_SPI_H_
#define HAL_SPI_H_

#include <stdint.h>
// #include "xparameters.h"

typedef struct {
    volatile uint32_t CR;       // 0x00
    volatile uint32_t SR;       // 0x04
    volatile uint32_t CLKDIV;   // 0x08
    volatile uint32_t M_TXD;    // 0x0C
    volatile uint32_t M_RXD;    // 0x10
    volatile uint32_t S_TXD;    // 0x14
    volatile uint32_t S_RXD;    // 0x18
    volatile uint32_t IRQ_CLR;  // 0x1C
} SPI_TypeDef;

#define SPI0_BASEADDR 0x44A50000
#define SPI0 ((SPI_TypeDef *)SPI0_BASEADDR)

#define SPI_CR_START       (1U << 0)
#define SPI_CR_CPOL        (1U << 1)
#define SPI_CR_CPHA        (1U << 2)
#define SPI_CR_INT_EN      (1U << 3)
#define SPI_CR_LCD_DC      (1U << 4)
#define SPI_CR_LCD_RST     (1U << 5)
#define SPI_CR_LOOPBACK_EN (1U << 6)

#define SPI_SR_DONE        (1U << 0)
#define SPI_SR_BUSY        (1U << 1)
#define SPI_SR_IRQ_PENDING (1U << 2)
#define SPI_SR_SLAVE_DONE  (1U << 3)

void SPI_Init(SPI_TypeDef *spi, uint32_t clkdiv);
uint8_t SPI_TransferExternal(SPI_TypeDef *spi, uint8_t data);
uint8_t SPI_TransferLoopback(SPI_TypeDef *spi, uint8_t master_tx, uint8_t slave_tx, uint8_t *slave_rx);
void SPI_SendStopWatch(uint8_t min, uint8_t sec, uint8_t centi_sec);

#endif
