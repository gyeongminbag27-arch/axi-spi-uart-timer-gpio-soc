#include "stm32_protocol.h"
#include "../spi/spi.h"
#include "../spi/spi_device.h"

#define SPI_DUMMY_BYTE 0x00U

static uint8_t stm32_command(uint8_t command)
{
    uint8_t response;

    spi_select(SPI_DEVICE_STM32);

    /*
     * 1st transfer:
     * MicroBlaze -> STM32 command
     */
    spi_transfer(command);

    /*
     * 2nd transfer:
     * STM32 -> MicroBlaze response
     */
    response = spi_transfer(SPI_DUMMY_BYTE);

    spi_deselect();

    return response;
}

uint8_t stm32_get_status(void)
{
    return stm32_command(CMD_GET_STATUS);
}

uint8_t stm32_door_open(void)
{
    return stm32_command(CMD_DOOR_OPEN);
}

uint8_t stm32_door_close(void)
{
    return stm32_command(CMD_DOOR_CLOSE);
}
