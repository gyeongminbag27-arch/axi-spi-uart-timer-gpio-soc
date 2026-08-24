#ifndef SPI_H
#define SPI_H

#include "stm32f4xx.h"

void SPI2_Slave_Init(void);
unsigned char SPI2_Slave_Transfer(unsigned char tx_data);

#endif