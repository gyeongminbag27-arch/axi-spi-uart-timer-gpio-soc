#include "spi.h"

void SPI2_Slave_Init(void)
{
    /* GPIOB Clock Enable */
    RCC->AHB1ENR |= RCC_AHB1ENR_GPIOBEN;

    /* SPI2 Clock Enable */
    RCC->APB1ENR |= RCC_APB1ENR_SPI2EN;

    /*
     * PB12 = SPI2_NSS
     * PB13 = SPI2_SCK
     * PB14 = SPI2_MISO
     * PB15 = SPI2_MOSI
     *
     * PB12~PB15 -> Alternate Function mode
     */
    GPIOB->MODER &= ~(
        (0x3U << 24) |
        (0x3U << 26) |
        (0x3U << 28) |
        (0x3U << 30)
    );

    GPIOB->MODER |= (
        (0x2U << 24) |
        (0x2U << 26) |
        (0x2U << 28) |
        (0x2U << 30)
    );

    /*
     * Alternate Function 5 = SPI2
     * AFR[1]:
     * PB12 -> 16
     * PB13 -> 20
     * PB14 -> 24
     * PB15 -> 28
     */
    GPIOB->AFR[1] &= ~(
        (0xFU << 16) |
        (0xFU << 20) |
        (0xFU << 24) |
        (0xFU << 28)
    );

    GPIOB->AFR[1] |= (
        (0x5U << 16) |
        (0x5U << 20) |
        (0x5U << 24) |
        (0x5U << 28)
    );

    /* Push-Pull */
    GPIOB->OTYPER &= ~(
        (1U << 12) |
        (1U << 13) |
        (1U << 14) |
        (1U << 15)
    );

    /* High Speed */
    GPIOB->OSPEEDR |= (
        (0x3U << 24) |
        (0x3U << 26) |
        (0x3U << 28) |
        (0x3U << 30)
    );

    /* No Pull-Up / Pull-Down */
    GPIOB->PUPDR &= ~(
        (0x3U << 24) |
        (0x3U << 26) |
        (0x3U << 28) |
        (0x3U << 30)
    );

    /*
     * SPI2:
     * Slave
     * CPOL = 0
     * CPHA = 0
     * 8-bit
     * MSB First
     * Hardware NSS
     */
    SPI2->CR1 = 0;
    SPI2->CR2 = 0;

    /* SPI Enable */
    SPI2->CR1 |= SPI_CR1_SPE;
}


unsigned char SPI2_Slave_Transfer(unsigned char tx_data)
{
    /* TX register empty 대기 */
    while ((SPI2->SR & SPI_SR_TXE) == 0);

    /* 응답 데이터 미리 적재 */
    *((volatile unsigned char *)&SPI2->DR) = tx_data;

    /* Master가 한 byte 전송할 때까지 대기 */
    while ((SPI2->SR & SPI_SR_RXNE) == 0);

    /* Master가 보낸 byte 반환 */
    return *((volatile unsigned char *)&SPI2->DR);
}