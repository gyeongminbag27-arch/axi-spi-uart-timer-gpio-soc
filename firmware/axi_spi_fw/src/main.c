#include <stdint.h>

#include "spi/spi.h"
#include "spi/spi_device.h"

int main(void)
{
    volatile uint8_t rx = 0;

    /* GPIO 기반 CS 초기화 */
    spi_device_init();

    /* SPI Mode 0
       clk_div = 10
       CPOL = 0
       CPHA = 0
    */
    spi_init(10, 0, 0);

    /* STM32 선택 후 0xA5 전송
       STM32가 보내는 1Byte를 rx에 저장 */
    rx = spi_transaction(SPI_DEVICE_STM32, 0xA5);

    /* 여기에서 Breakpoint를 걸어 rx 값을 확인 */
    if (rx == 0x3C)
    {
        while (1)
        {
            /* PASS */
        }
    }
    else
    {
        while (1)
        {
            /* FAIL */
        }
    }

    return 0;
}
