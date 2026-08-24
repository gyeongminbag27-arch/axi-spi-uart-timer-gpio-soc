#include "device_driver.h"

typedef struct
{
    GPIO_TypeDef *port;
    unsigned char pin;
} GPIO_Pin_t;


static const char Key_Table[4][4] =
{
    {'1', '2', '3', 'A'},
    {'4', '5', '6', 'B'},
    {'7', '8', '9', 'C'},
    {'*', '0', '#', 'D'}
};


static const GPIO_Pin_t Row_Pins[4] =
{
    {GPIOC, 8},   /* R1 */
    {GPIOB, 3},   /* R2 */
    {GPIOB, 5},   /* R3 */
    {GPIOB, 4}    /* R4 */
};


static const GPIO_Pin_t Column_Pins[4] =
{
    {GPIOB, 10},  /* C1 */
    {GPIOA, 8},   /* C2 */
    {GPIOC, 6},   /* C3 */
    {GPIOC, 7}    /* C4 */
};


static void GPIO_Set_Output(GPIO_TypeDef *port,
                            unsigned char pin)
{
    Macro_Write_Block(port->MODER,
                      0x3,
                      0x1,
                      pin * 2);

    Macro_Clear_Bit(port->OTYPER, pin);
}


static void GPIO_Set_Input_Pullup(GPIO_TypeDef *port,
                                  unsigned char pin)
{
    Macro_Write_Block(port->MODER,
                      0x3,
                      0x0,
                      pin * 2);

    Macro_Write_Block(port->PUPDR,
                      0x3,
                      0x1,
                      pin * 2);
}


void Keypad_Init(void)
{
    int i;

    Macro_Set_Bit(RCC->AHB1ENR, 0);
    Macro_Set_Bit(RCC->AHB1ENR, 1);
    Macro_Set_Bit(RCC->AHB1ENR, 2);

    for (i = 0; i < 4; i++)
    {
        GPIO_Set_Output(Row_Pins[i].port,
                        Row_Pins[i].pin);

        Macro_Set_Bit(Row_Pins[i].port->ODR,
                      Row_Pins[i].pin);
    }

    for (i = 0; i < 4; i++)
    {
        GPIO_Set_Input_Pullup(Column_Pins[i].port,
                              Column_Pins[i].pin);
    }
}


static void Keypad_Select_Row(int selected_row)
{
    int row;

    for (row = 0; row < 4; row++)
    {
        Macro_Set_Bit(Row_Pins[row].port->ODR,
                      Row_Pins[row].pin);
    }

    if ((selected_row >= 0) &&
        (selected_row < 4))
    {
        Macro_Clear_Bit(
            Row_Pins[selected_row].port->ODR,
            Row_Pins[selected_row].pin);
    }
}


static int Keypad_Get_Column(void)
{
    int column;

    for (column = 0; column < 4; column++)
    {
        if (!Macro_Check_Bit_Set(
                Column_Pins[column].port->IDR,
                Column_Pins[column].pin))
        {
            return column;
        }
    }

    return -1;
}


char Keypad_Get_Key(void)
{
    int row;
    int column;
    volatile int delay;

    for (row = 0; row < 4; row++)
    {
        Keypad_Select_Row(row);

        for (delay = 0; delay < 100; delay++)
        {
        }

        column = Keypad_Get_Column();

        if (column >= 0)
        {
            return Key_Table[row][column];
        }
    }

    return 0;
}