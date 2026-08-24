#include "device_driver.h"

static const unsigned char Step_Table[8] =
{
    0x01,   /* IN1 */
    0x03,   /* IN1 + IN2 */
    0x02,   /* IN2 */
    0x06,   /* IN2 + IN3 */
    0x04,   /* IN3 */
    0x0C,   /* IN3 + IN4 */
    0x08,   /* IN4 */
    0x09    /* IN4 + IN1 */
};

static int Step_Index = 0;

static void Motor_Write(unsigned char data)
{
    /* bit0 → IN1 → PA0 */
    if (data & 0x01)
    {
        Macro_Set_Bit(GPIOA->ODR, 0);
    }
    else
    {
        Macro_Clear_Bit(GPIOA->ODR, 0);
    }

    /* bit1 → IN2 → PA1 */
    if (data & 0x02)
    {
        Macro_Set_Bit(GPIOA->ODR, 1);
    }
    else
    {
        Macro_Clear_Bit(GPIOA->ODR, 1);
    }

    /* bit2 → IN3 → PB0 */
    if (data & 0x04)
    {
        Macro_Set_Bit(GPIOB->ODR, 0);
    }
    else
    {
        Macro_Clear_Bit(GPIOB->ODR, 0);
    }

    /* bit3 → IN4 → PB1 */
    if (data & 0x08)
    {
        Macro_Set_Bit(GPIOB->ODR, 1);
    }
    else
    {
        Macro_Clear_Bit(GPIOB->ODR, 1);
    }
}

void Motor_Init(void)
{
    /* GPIOA, GPIOB Clock Enable */
    Macro_Set_Bit(RCC->AHB1ENR, 0);
    Macro_Set_Bit(RCC->AHB1ENR, 1);

    /* PA0, PA1 출력 */
    Macro_Write_Block(GPIOA->MODER, 0x3, 0x1, 0);
    Macro_Write_Block(GPIOA->MODER, 0x3, 0x1, 2);

    Macro_Clear_Bit(GPIOA->OTYPER, 0);
    Macro_Clear_Bit(GPIOA->OTYPER, 1);

    /* PB0, PB1 출력 */
    Macro_Write_Block(GPIOB->MODER, 0x3, 0x1, 0);
    Macro_Write_Block(GPIOB->MODER, 0x3, 0x1, 2);

    Macro_Clear_Bit(GPIOB->OTYPER, 0);
    Macro_Clear_Bit(GPIOB->OTYPER, 1);

    Step_Index = 0;
    Motor_Stop();
}

void Motor_Step(int direction)
{
    if (direction > 0)
    {
        Step_Index++;

        if (Step_Index >= 8)
        {
            Step_Index = 0;
        }
    }
    else
    {
        Step_Index--;

        if (Step_Index < 0)
        {
            Step_Index = 7;
        }
    }

    Motor_Write(Step_Table[Step_Index]);
}

void Motor_Stop(void)
{
    Motor_Write(0x00);
}