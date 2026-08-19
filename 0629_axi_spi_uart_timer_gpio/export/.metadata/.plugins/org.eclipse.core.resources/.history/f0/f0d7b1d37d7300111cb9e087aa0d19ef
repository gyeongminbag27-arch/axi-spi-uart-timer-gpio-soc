#ifndef HAL_GPIO_H_
#define HAL_GPIO_H_

#include <stdint.h>
// #include "xparameters.h"

/*
 * AXI GPIO Register Map
 * 0x00 : CR  direction/control, 1=output, 0=input
 * 0x04 : IDR input data
 * 0x08 : ODR output data
 */

typedef struct {
    volatile uint32_t CR;
    volatile uint32_t IDR;
    volatile uint32_t ODR;
} GPIO_TypeDef;

/*
 * Address Editor ±âÁØ
 * gpio_0      : 0x44A00000 -> GPIOA
 * gpio_1      : 0x44A10000 -> GPIOB
 * gpio_2      : 0x44A20000 -> GPIOC
 * gpio_3      : 0x44A30000 -> GPIOD
 * gpio_lcd_bl : 0x44A40000 -> LCD_GPIO
 */

#define GPIOA_BASEADDR     0x44A00000
#define GPIOB_BASEADDR     0x44A10000
#define GPIOC_BASEADDR     0x44A20000
#define GPIOD_BASEADDR     0x44A30000
#define LCD_GPIO_BASEADDR  0x44A40000

#define GPIOA     ((GPIO_TypeDef *)GPIOA_BASEADDR)
#define GPIOB     ((GPIO_TypeDef *)GPIOB_BASEADDR)
#define GPIOC     ((GPIO_TypeDef *)GPIOC_BASEADDR)
#define GPIOD     ((GPIO_TypeDef *)GPIOD_BASEADDR)
#define LCD_GPIO  ((GPIO_TypeDef *)LCD_GPIO_BASEADDR)

#define GPIO_INPUT   0x00U
#define GPIO_OUTPUT  0xFFU

#define GPIO_RESET   0U
#define GPIO_SET     1U

#define GPIO_PIN_0   0x01U
#define GPIO_PIN_1   0x02U
#define GPIO_PIN_2   0x04U
#define GPIO_PIN_3   0x08U
#define GPIO_PIN_4   0x10U
#define GPIO_PIN_5   0x20U
#define GPIO_PIN_6   0x40U
#define GPIO_PIN_7   0x80U

void GPIO_SetMode(GPIO_TypeDef *GPIOx, uint32_t mode);
uint32_t GPIO_GetODR(GPIO_TypeDef *GPIOx);
uint32_t GPIO_GetCR(GPIO_TypeDef *GPIOx);
void GPIO_WritePort(GPIO_TypeDef *GPIOx, uint32_t data);
void GPIO_WritePin(GPIO_TypeDef *GPIOx, uint32_t gpio_pin, uint32_t gpio_pin_state);
uint32_t GPIO_ReadPort(GPIO_TypeDef *GPIOx);
uint32_t GPIO_ReadPin(GPIO_TypeDef *GPIOx, uint32_t gpio_pin);

#endif
