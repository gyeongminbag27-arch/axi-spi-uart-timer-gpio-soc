#include "device_driver.h"


#define OLED_ADDR          0x78
#define OLED_WIDTH         128
#define OLED_PAGE_COUNT    8
#define OLED_FONT_WIDTH    5
#define OLED_CHAR_WIDTH    6


static void I2C1_Start(void);
static void I2C1_Stop(void);
static void I2C1_Send_Byte(unsigned char data);
static void I2C1_Send_Address(unsigned char address);

static void OLED_Write_Command(unsigned char command);
static void OLED_Write_Buffer(const unsigned char *buffer,
                              unsigned int length);
static void OLED_Write_Repeat(unsigned char data,
                              unsigned int count);
static void OLED_Set_Cursor(unsigned char page,
                            unsigned char column);


static const unsigned char OLED_Init_Commands[] =
{
    0xAE,             /* Display OFF */
    0x20, 0x02,       /* Page Addressing Mode */
    0xB0,             /* Page Start */
    0xC8,             /* COM Scan Direction */
    0x00, 0x10,       /* Column Address */
    0x40,             /* Display Start Line */
    0x81, 0x7F,       /* Contrast */
    0xA1,             /* Segment Remap */
    0xA6,             /* Normal Display */
    0xA8, 0x3F,       /* Multiplex Ratio */
    0xA4,             /* RAM Display */
    0xD3, 0x00,       /* Display Offset */
    0xD5, 0x80,       /* Display Clock */
    0xD9, 0xF1,       /* Pre-charge */
    0xDA, 0x12,       /* COM Pins */
    0xDB, 0x40,       /* VCOMH */
    0x8D, 0x14,       /* Charge Pump */
    0xAF              /* Display ON */
};


void I2C1_Init(void)
{
    /* GPIOB Clock Enable */
    Macro_Set_Bit(RCC->AHB1ENR, 1);

    /* I2C1 Clock Enable */
    Macro_Set_Bit(RCC->APB1ENR, 21);

    /*
     * PB8 : I2C1_SCL
     * PB9 : I2C1_SDA
     */

    /* Alternate Function Mode */
    Macro_Write_Block(GPIOB->MODER, 0x3, 0x2, 16);
    Macro_Write_Block(GPIOB->MODER, 0x3, 0x2, 18);

    /* Open Drain */
    Macro_Set_Bit(GPIOB->OTYPER, 8);
    Macro_Set_Bit(GPIOB->OTYPER, 9);

    /* Pull-Up */
    Macro_Write_Block(GPIOB->PUPDR, 0x3, 0x1, 16);
    Macro_Write_Block(GPIOB->PUPDR, 0x3, 0x1, 18);

    /* High Speed */
    Macro_Write_Block(GPIOB->OSPEEDR, 0x3, 0x3, 16);
    Macro_Write_Block(GPIOB->OSPEEDR, 0x3, 0x3, 18);

    /* PB8, PB9 = AF4 */
    Macro_Write_Block(GPIOB->AFR[1], 0xF, 0x4, 0);
    Macro_Write_Block(GPIOB->AFR[1], 0xF, 0x4, 4);

    /* I2C Disable */
    Macro_Clear_Bit(I2C1->CR1, 0);

    /*
     * PCLK1 = 45 MHz
     * I2C = 100 kHz
     */
    I2C1->CR2 = 45;
    I2C1->CCR = 225;
    I2C1->TRISE = 46;

    /* I2C Enable */
    Macro_Set_Bit(I2C1->CR1, 0);
}


static void I2C1_Start(void)
{
    while (Macro_Check_Bit_Set(I2C1->SR2, 1))
    {
    }

    Macro_Set_Bit(I2C1->CR1, 8);

    while (!Macro_Check_Bit_Set(I2C1->SR1, 0))
    {
    }
}


static void I2C1_Send_Address(unsigned char address)
{
    volatile unsigned int temp;

    I2C1->DR = address;

    while (!Macro_Check_Bit_Set(I2C1->SR1, 1))
    {
    }

    /*
     * ADDR Clear:
     * SR1 read 후 SR2 read
     */
    temp = I2C1->SR1;
    temp = I2C1->SR2;

    (void)temp;
}


static void I2C1_Send_Byte(unsigned char data)
{
    while (!Macro_Check_Bit_Set(I2C1->SR1, 7))
    {
    }

    I2C1->DR = data;

    while (!Macro_Check_Bit_Set(I2C1->SR1, 2))
    {
    }
}


static void I2C1_Stop(void)
{
    Macro_Set_Bit(I2C1->CR1, 9);
}


static void OLED_Write_Command(unsigned char command)
{
    I2C1_Start();
    I2C1_Send_Address(OLED_ADDR);

    /*
     * 0x00:
     * 이후 데이터는 Command
     */
    I2C1_Send_Byte(0x00);
    I2C1_Send_Byte(command);

    I2C1_Stop();
}


/*
 * 여러 데이터 바이트를 한 번의 I2C 전송으로 보냄
 */
static void OLED_Write_Buffer(const unsigned char *buffer,
                              unsigned int length)
{
    unsigned int i;

    if ((buffer == 0) || (length == 0))
    {
        return;
    }

    I2C1_Start();
    I2C1_Send_Address(OLED_ADDR);

    /*
     * 0x40:
     * 이후 데이터는 Display Data
     */
    I2C1_Send_Byte(0x40);

    for (i = 0; i < length; i++)
    {
        I2C1_Send_Byte(buffer[i]);
    }

    I2C1_Stop();
}


/*
 * 동일한 데이터를 여러 번 전송
 * OLED 화면 Fill/Clear에서 사용
 */
static void OLED_Write_Repeat(unsigned char data,
                              unsigned int count)
{
    unsigned int i;

    if (count == 0)
    {
        return;
    }

    I2C1_Start();
    I2C1_Send_Address(OLED_ADDR);

    I2C1_Send_Byte(0x40);

    for (i = 0; i < count; i++)
    {
        I2C1_Send_Byte(data);
    }

    I2C1_Stop();
}


void OLED_Init(void)
{
    unsigned int i;
    unsigned int command_count;

    TIM2_Delay(100);

    command_count =
        sizeof(OLED_Init_Commands) /
        sizeof(OLED_Init_Commands[0]);

    for (i = 0; i < command_count; i++)
    {
        OLED_Write_Command(OLED_Init_Commands[i]);
    }

    OLED_Clear();
}


static void OLED_Set_Cursor(unsigned char page,
                            unsigned char column)
{
    if (page >= OLED_PAGE_COUNT)
    {
        return;
    }

    if (column >= OLED_WIDTH)
    {
        return;
    }

    OLED_Write_Command((unsigned char)(0xB0 + page));

    OLED_Write_Command(
        (unsigned char)(0x00 + (column & 0x0F)));

    OLED_Write_Command(
        (unsigned char)(0x10 +
                        ((column >> 4) & 0x0F)));
}


void OLED_Fill(unsigned char data)
{
    unsigned char page;

    for (page = 0; page < OLED_PAGE_COUNT; page++)
    {
        OLED_Set_Cursor(page, 0);

        /*
         * 한 페이지 128바이트를
         * 하나의 I2C 트랜잭션으로 전송
         */
        OLED_Write_Repeat(data, OLED_WIDTH);
    }
}


void OLED_Clear(void)
{
    OLED_Fill(0x00);
}


void OLED_Write_Char(unsigned char page,
                     unsigned char column,
                     char ch)
{
    unsigned char character_data[OLED_CHAR_WIDTH];
    unsigned char font_index;
    unsigned char i;

    if ((ch < 0x20) || (ch > 0x5F))
    {
        ch = '?';
    }

    font_index = (unsigned char)(ch - 0x20);

    for (i = 0; i < OLED_FONT_WIDTH; i++)
    {
        character_data[i] =
            Font5x7[font_index][i];
    }

    /* 문자 사이 공백 */
    character_data[OLED_FONT_WIDTH] = 0x00;

    OLED_Set_Cursor(page, column);

    /*
     * 문자 1개에 해당하는 6바이트를
     * 한 번의 I2C 트랜잭션으로 전송
     */
    OLED_Write_Buffer(character_data,
                      OLED_CHAR_WIDTH);
}


void OLED_Print(unsigned char page,
                unsigned char column,
                const char *str)
{
    if (str == 0)
    {
        return;
    }

    while (*str)
    {
        if (column >
            (OLED_WIDTH - OLED_CHAR_WIDTH))
        {
            page++;
            column = 0;
        }

        if (page >= OLED_PAGE_COUNT)
        {
            break;
        }

        OLED_Write_Char(page, column, *str);

        column =
            (unsigned char)(column +
                            OLED_CHAR_WIDTH);

        str++;
    }
}