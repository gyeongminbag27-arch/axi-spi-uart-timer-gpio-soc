#ifndef SPI_DEVICE_H
#define SPI_DEVICE_H

#include <stdint.h>

typedef enum {
    SPI_DEVICE_LCD = 0,
    SPI_DEVICE_TOUCH,
    SPI_DEVICE_STM32,
    SPI_DEVICE_COUNT
} spi_device_t;

void spi_device_init(void);

void spi_select(spi_device_t device);
void spi_deselect(void);

uint8_t spi_transaction(spi_device_t device, uint8_t tx_data);

#endif
