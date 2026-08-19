#ifndef HAL_LCD_H_
#define HAL_LCD_H_

#include <stdint.h>

#include "../GPIO/GPIO.h"

// lcd_gpio[0] = RS, lcd_gpio[1] = E, lcd_gpio[2..5] = D4..D7, lcd_gpio[6] = BLA
#define LCD_RS   GPIO_PIN_0
#define LCD_E    GPIO_PIN_1
#define LCD_D4   GPIO_PIN_2
#define LCD_D5   GPIO_PIN_3
#define LCD_D6   GPIO_PIN_4
#define LCD_D7   GPIO_PIN_5
#define LCD_BLA  GPIO_PIN_6

void LCD_Init(void);
void LCD_Command(uint8_t cmd);
void LCD_Data(uint8_t data);
void LCD_Print(const char *str);
void LCD_Clear(void);
void LCD_SetCursor(uint8_t row, uint8_t col);
void LCD_PrintStopwatch(uint8_t min, uint8_t sec, uint8_t centi_sec);

#endif
