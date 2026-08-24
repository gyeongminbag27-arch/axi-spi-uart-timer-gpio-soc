#include "spi.h"

#include "xil_io.h"

static uint32_t spi_ctrl_cfg = 0;

void spi_init(uint8_t clk_div, uint8_t cpol, uint8_t cpha)
{
    spi_ctrl_cfg = 0;

    if (cpol)
        spi_ctrl_cfg |= SPI_CTRL_CPOL;

    if (cpha)
        spi_ctrl_cfg |= SPI_CTRL_CPHA;

    Xil_Out32(SPI_BASE_ADDR + SPI_CLKDIV_OFFSET, clk_div);
    Xil_Out32(SPI_BASE_ADDR + SPI_CTRL_OFFSET, spi_ctrl_cfg);
}

uint8_t spi_transfer(uint8_t tx_data)
{
    uint32_t status;

    do {
        status = Xil_In32(SPI_BASE_ADDR + SPI_STATUS_OFFSET);
    } while (status & SPI_STATUS_BUSY);

    Xil_Out32(SPI_BASE_ADDR + SPI_TX_OFFSET, tx_data);

    Xil_Out32(
        SPI_BASE_ADDR + SPI_CTRL_OFFSET,
        spi_ctrl_cfg | SPI_CTRL_START
    );

    do {
        status = Xil_In32(SPI_BASE_ADDR + SPI_STATUS_OFFSET);
    } while (!(status & SPI_STATUS_BUSY));

    do {
        status = Xil_In32(SPI_BASE_ADDR + SPI_STATUS_OFFSET);
    } while (status & SPI_STATUS_BUSY);

    return (uint8_t)Xil_In32(SPI_BASE_ADDR + SPI_RX_OFFSET);
}
