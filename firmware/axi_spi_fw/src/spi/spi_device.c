#include "spi_device.h"
#include "spi.h"
#include "../gpio/gpio.h"

#define LCD_CS_PIN       GPIO_PIN_0
#define TOUCH_CS_PIN     GPIO_PIN_1
#define STM32_CS_PIN     GPIO_PIN_4

#define SPI_CS_MASK \
    (LCD_CS_PIN | TOUCH_CS_PIN | STM32_CS_PIN)

static void spi_all_deselect(void)
{
    /*
     * 모든 SPI Slave CS를 HIGH로 만든다.
     * GPIOC의 다른 bit 값은 유지한다.
     */
    GPIOC->ODR |= SPI_CS_MASK;
}

void spi_device_init(void)
{
    /*
     * 현재 GPIOC는 8-bit 출력 포트로 사용.
     */
    GPIO_SetMode(GPIOC, GPIO_OUTPUT);

    /*
     * 초기 상태에서는 모든 SPI Slave 비선택.
     */
    spi_all_deselect();
}

void spi_select(spi_device_t device)
{
    /*
     * 먼저 모든 Slave를 해제한 뒤
     * 하나의 Slave만 LOW로 만든다.
     */
    spi_all_deselect();

    switch (device)
    {
    case SPI_DEVICE_LCD:
        GPIO_WritePin(GPIOC, LCD_CS_PIN, GPIO_RESET);
        break;

    case SPI_DEVICE_TOUCH:
        GPIO_WritePin(GPIOC, TOUCH_CS_PIN, GPIO_RESET);
        break;

    case SPI_DEVICE_STM32:
        GPIO_WritePin(GPIOC, STM32_CS_PIN, GPIO_RESET);
        break;

    default:
        /*
         * 잘못된 Device ID이면
         * 모든 Slave 비선택 상태 유지.
         */
        break;
    }
}

void spi_deselect(void)
{
    spi_all_deselect();
}

uint8_t spi_transaction(spi_device_t device, uint8_t tx_data)
{
    uint8_t rx_data;

    spi_select(device);

    rx_data = spi_transfer(tx_data);

    spi_deselect();

    return rx_data;
}
