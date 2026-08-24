#include "device_gpio.h"

void device_gpio_init(void)
{
    GPIO_SetMode(GPIOC, GPIO_OUTPUT);

    /* 둘 다 비선택 상태 */
    GPIO_WritePin(GPIOC, LCD_CS_PIN, GPIO_SET);
    GPIO_WritePin(GPIOC, SENSOR_CS_PIN, GPIO_SET);

    /* 기본 상태 */
    GPIO_WritePin(GPIOC, LCD_DC_PIN, GPIO_SET);
    GPIO_WritePin(GPIOC, LCD_RST_PIN, GPIO_SET);

    /* 필요하면 Backlight ON */
    GPIO_WritePin(GPIOC, LCD_BL_PIN, GPIO_SET);
}

void lcd_select(void)
{
    /* Sensor와 동시 선택 방지 */
    GPIO_WritePin(GPIOC, SENSOR_CS_PIN, GPIO_SET);
    GPIO_WritePin(GPIOC, LCD_CS_PIN, GPIO_RESET);
}

void lcd_deselect(void)
{
    GPIO_WritePin(GPIOC, LCD_CS_PIN, GPIO_SET);
}

void sensor_select(void)
{
    /* LCD와 동시 선택 방지 */
    GPIO_WritePin(GPIOC, LCD_CS_PIN, GPIO_SET);
    GPIO_WritePin(GPIOC, SENSOR_CS_PIN, GPIO_RESET);
}

void sensor_deselect(void)
{
    GPIO_WritePin(GPIOC, SENSOR_CS_PIN, GPIO_SET);
}

void lcd_dc_command(void)
{
    GPIO_WritePin(GPIOC, LCD_DC_PIN, GPIO_RESET);
}

void lcd_dc_data(void)
{
    GPIO_WritePin(GPIOC, LCD_DC_PIN, GPIO_SET);
}

void lcd_reset_low(void)
{
    GPIO_WritePin(GPIOC, LCD_RST_PIN, GPIO_RESET);
}

void lcd_reset_high(void)
{
    GPIO_WritePin(GPIOC, LCD_RST_PIN, GPIO_SET);
}
