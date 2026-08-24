#ifndef DEVICE_GPIO_H
#define DEVICE_GPIO_H

#include "../gpio/gpio.h"

#define LCD_CS_PIN       GPIO_PIN_0
#define SENSOR_CS_PIN    GPIO_PIN_1
#define LCD_DC_PIN       GPIO_PIN_2
#define LCD_RST_PIN      GPIO_PIN_3
#define LCD_BL_PIN       GPIO_PIN_7

void device_gpio_init(void);

void lcd_select(void);
void lcd_deselect(void);

void sensor_select(void);
void sensor_deselect(void);

void lcd_dc_command(void);
void lcd_dc_data(void);

void lcd_reset_low(void);
void lcd_reset_high(void);

#endif
