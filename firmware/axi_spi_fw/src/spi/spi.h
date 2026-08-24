#ifndef SPI_H
#define SPI_H

#include <stdint.h>

#define SPI_BASE_ADDR      0x44A80000U

#define SPI_CTRL_OFFSET    0x00U
#define SPI_STATUS_OFFSET  0x04U
#define SPI_CLKDIV_OFFSET  0x08U
#define SPI_TX_OFFSET      0x0CU
#define SPI_RX_OFFSET      0x10U

#define SPI_CTRL_START     (1U << 0)
#define SPI_CTRL_CPOL      (1U << 1)
#define SPI_CTRL_CPHA      (1U << 2)
#define SPI_CTRL_INT_EN    (1U << 3)

#define SPI_STATUS_DONE        (1U << 0)
#define SPI_STATUS_BUSY        (1U << 1)
#define SPI_STATUS_IRQ_PENDING (1U << 2)

void spi_init(uint8_t clk_div, uint8_t cpol, uint8_t cpha);
uint8_t spi_transfer(uint8_t tx_data);

#endif
