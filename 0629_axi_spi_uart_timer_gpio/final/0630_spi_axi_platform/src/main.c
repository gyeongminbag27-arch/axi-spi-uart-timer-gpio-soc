#include <stdint.h>

#include "HAL/GPIO/GPIO.h"
#include "HAL/LCD/LCD.h"
#include "HAL/SPI/SPI.h"
#include "HAL/UART/UART.h"
#include "APP/StopWatchApp.h"

static void delay_us(uint32_t us)
{
    volatile uint32_t i;
    volatile uint32_t count;

    for (count = 0; count < us; count++) {
        for (i = 0; i < 20; i++) {
            __asm__("nop");
        }
    }
}

int main(void)
{
    // init_platform();  // BSP include path 문제 때문에 사용 안 함

    // GPIO role based on current XDC
    // GPIOA: LED output
    // GPIOB: switch input. SW0=mode, SW1=run, SW2=clear
    // GPIOC/GPIOD: status output
    // LCD_GPIO: parallel LCD output
    GPIO_SetMode(GPIOA, GPIO_OUTPUT);
    GPIO_SetMode(GPIOB, GPIO_INPUT);
    GPIO_SetMode(GPIOC, GPIO_OUTPUT);
    GPIO_SetMode(GPIOD, GPIO_OUTPUT);
    GPIO_SetMode(LCD_GPIO, GPIO_OUTPUT);

    SPI_Init(SPI0, 10);
    LCD_Init();
    StopWatchApp_Init();

    UART_Print("\r\nAXI Stopwatch Demo Start\r\n");
    UART_Print("SW0=1 LCD, SW0=0 SPI slave\r\n");
    UART_Print("SW1=1 RUN, SW2=1 CLEAR\r\n");

    uint8_t prev_mode = 0xFF;
    uint32_t lcd_refresh_count = 0;
    uint32_t spi_send_count = 0;

    while (1) {
        uint32_t sw = GPIO_ReadPort(GPIOB);

        uint8_t mode_lcd = (sw & GPIO_PIN_0) ? 1U : 0U;
        uint8_t run      = (sw & GPIO_PIN_1) ? 1U : 0U;
        uint8_t clear    = (sw & GPIO_PIN_2) ? 1U : 0U;

        if (mode_lcd != prev_mode) {
            prev_mode = mode_lcd;
            LCD_Clear();

            if (mode_lcd) {
                LCD_SetCursor(0, 0);
                LCD_Print("LCD MODE        ");
                UART_Print("Mode: LCD\r\n");
            } else {
                LCD_SetCursor(0, 0);
                LCD_Print("SPI SLAVE MODE  ");
                UART_Print("Mode: SPI slave\r\n");
            }
        }

        StopWatchApp_Tick10ms(run, clear);
        StopWatchApp_OutputGPIO(mode_lcd);

        if (mode_lcd) {
            // LCD update every 100 ms to reduce flicker
            if (++lcd_refresh_count >= 10) {
                lcd_refresh_count = 0;
                StopWatchApp_OutputLCD();
            }
        } else {
            // SPI packet every 100 ms
            if (++spi_send_count >= 10) {
                spi_send_count = 0;
                StopWatchApp_OutputSPI();
            }
        }

        delay_us(10000); // 10 ms
    }

    // cleanup_platform(); // while(1) 때문에 도달하지 않음
    // return 0;
}
