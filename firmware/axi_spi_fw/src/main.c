#include "xil_printf.h"

#include "spi/spi.h"
#include "device/device_gpio.h"

int main(void)
{
    xil_printf("\r\nAXI SPI FW Start\r\n");
    device_gpio_init();

    /* SPI Mode 0, 우선 느린 clock */
    spi_init(10, 0, 0);
    xil_printf("GPIO init complete\r\n");

    xil_printf("SPI init complete\r\n");

    while (1)
    {
    }

    return 0;
}
