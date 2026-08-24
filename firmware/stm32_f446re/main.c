#include "spi.h"
#include "device_driver.h"
#include <stdio.h>
#include <string.h>


/* exception.c에서 참조 */
volatile int Key_Pressed = 0;
volatile int Uart_Data_In = 0;
volatile unsigned char Uart_Data = 0;
volatile int TIM4_Expired = 0;


/* 설정값 */
#define PASSWORD_LENGTH     4
#define MOTOR_STEP_COUNT    512
#define MOTOR_STEP_DELAY    5


typedef enum
{
    INPUT_KEYPAD = 0,
    INPUT_BLE
} Input_Source;


/* 비밀번호 */
static const char Password[PASSWORD_LENGTH + 1] = "1234";


static void Sys_Init(int baud)
{
    SCB->CPACR |=
        (0x3 << (10 * 2)) |
        (0x3 << (11 * 2));

    Clock_Init();
    Uart2_Init(baud);

    setvbuf(stdout, NULL, _IONBF, 0);

    LED_Init();
    TIM3_Out_Init();
}


static void Motor_Rotate(int direction)
{
    int i;

    LED_On();

    for (i = 0; i < MOTOR_STEP_COUNT; i++)
    {
        Motor_Step(direction);
        TIM2_Delay(MOTOR_STEP_DELAY);
    }

    Motor_Stop();
    LED_Off();
}


static void Password_Clear(char *input, int *input_index)
{
    memset(input, 0, PASSWORD_LENGTH + 1);
    *input_index = 0;
}


static int Password_Is_Correct(const char *input,
                               int input_index)
{
    return (input_index == PASSWORD_LENGTH) &&
           (strcmp(input, Password) == 0);
}


static void OLED_Show_Password(int count)
{
    int i;

    OLED_Print(4, 0, "      ");

    for (i = 0; i < PASSWORD_LENGTH; i++)
    {
        if (i < count)
        {
            OLED_Print(4,
                       (unsigned char)(i * 6),
                       "*");
        }
        else
        {
            OLED_Print(4,
                       (unsigned char)(i * 6),
                       "_");
        }
    }
}


static void OLED_Show_Main_Screen(void)
{
    OLED_Clear();

    OLED_Print(0, 0, "SMART DOOR LOCK");
    OLED_Print(2, 0, "ENTER PASSWORD");

    OLED_Show_Password(0);
}


static void Input_Send_Prompt(Input_Source source)
{
    if (source == INPUT_BLE)
    {
        Uart1_Send_String("> ");
    }
    else
    {
        printf("Enter Password\r\n");
    }
}


static void Door_Open(void)
{
    printf("Password Correct\r\n");
    printf("Door Open\r\n");

    Uart1_Send_String("\r\nACCESS GRANTED\r\n");
    Uart1_Send_String("DOOR OPEN\r\n");

    OLED_Clear();
    OLED_Print(0, 0, "ACCESS GRANTED");
    OLED_Print(2, 0, "DOOR OPEN");

    Motor_Rotate(1);

    TIM2_Delay(1000);

    OLED_Show_Main_Screen();
}


static void Access_Denied(void)
{
    printf("Password Incorrect\r\n");
    printf("Access Denied\r\n");

    Uart1_Send_String("\r\nACCESS DENIED\r\n");
    Uart1_Send_String("TRY AGAIN\r\n");

    OLED_Clear();
    OLED_Print(0, 0, "ACCESS DENIED");
    OLED_Print(2, 0, "TRY AGAIN");

    Motor_Stop();
    LED_Off();

    Buzzer_Play_Melody();

    TIM2_Delay(1000);

    OLED_Show_Main_Screen();
}


static void Password_Check(const char *input,
                           int input_index)
{
    if (Password_Is_Correct(input, input_index))
    {
        Door_Open();
    }
    else
    {
        Access_Denied();
    }
}


static void Input_Print_Mask(Input_Source source)
{
    if (source == INPUT_BLE)
    {
        Uart1_Send_String("*");
    }
    else
    {
        printf("*");
    }
}


static void Input_Print_Full(Input_Source source)
{
    if (source == INPUT_BLE)
    {
        Uart1_Send_String(
            "\r\nPASSWORD INPUT FULL\r\n");
    }
    else
    {
        printf(
            "\r\nPassword input is full\r\n");
    }

    OLED_Print(6, 0, "INPUT FULL");
}


static void Input_Print_Invalid(Input_Source source)
{
    if (source == INPUT_BLE)
    {
        Uart1_Send_String(
            "\r\nINVALID INPUT\r\n");

        Uart1_Send_String(
            "USE 0-9, #, *\r\n");
    }
    else
    {
        printf("\r\nInvalid Key\r\n");
    }

    OLED_Print(6, 0, "INVALID INPUT");

    Input_Send_Prompt(source);
}


static void Input_Process(Input_Source source,
                          char data,
                          char *input,
                          int *input_index)
{
    if ((data >= '0') && (data <= '9'))
    {
        if (*input_index < PASSWORD_LENGTH)
        {
            input[*input_index] = data;
            (*input_index)++;

            input[*input_index] = '\0';

            Input_Print_Mask(source);
            OLED_Show_Password(*input_index);
        }
        else
        {
            Input_Print_Full(source);
        }
    }
    else if (data == '#')
    {
        if (source == INPUT_BLE)
        {
            Uart1_Send_String("\r\n");
        }
        else
        {
            printf("\r\n");
        }

        Password_Check(input, *input_index);

        Password_Clear(input, input_index);

        Input_Send_Prompt(source);
    }
    else if (data == '*')
    {
        Password_Clear(input, input_index);

        OLED_Show_Main_Screen();

        if (source == INPUT_BLE)
        {
            Uart1_Send_String(
                "\r\nINPUT CLEARED\r\n");
        }
        else
        {
            printf("\r\nInput Cleared\r\n");
        }

        Input_Send_Prompt(source);
    }
    else if ((data == '\r') ||
             (data == '\n'))
    {
        /* BLE 앱에서 자동으로 전송하는 CR/LF 무시 */
    }
    else
    {
        Input_Print_Invalid(source);
    }
}


void Main(void)
{
    char key;
    char previous_key = 0;
    char ble_data;
    unsigned char spi_rx;
    char keypad_input[PASSWORD_LENGTH + 1] = {0};
    char ble_input[PASSWORD_LENGTH + 1] = {0};

    int keypad_input_index = 0;
    int ble_input_index = 0;

    Sys_Init(115200);

    Motor_Init();

    I2C1_Init();
    OLED_Init();

    Uart1_Init(9600);
    SPI2_Slave_Init();
    *((volatile unsigned char *)&SPI2->DR) = 0x3C;
    /*
     * 다른 초기화 함수가 GPIO 설정을 변경할 수 있으므로
     * Keypad를 마지막에 초기화
     */
    Keypad_Init();

    OLED_Show_Main_Screen();

    printf("Smart Door Lock Start\r\n");
    printf("Keypad or BLE: 4-digit password + #\r\n");

    Uart1_Send_String(
        "\r\nSMART DOOR LOCK READY\r\n");

    Uart1_Send_String(
        "ENTER 4-DIGIT PASSWORD + #\r\n");

    Uart1_Send_String("> ");

    for (;;)
    {   
          /* ---------- FPGA SPI ---------- */

    if (SPI2->SR & SPI_SR_RXNE)
    {
        spi_rx = *((volatile unsigned char *)&SPI2->DR);

        printf("[SPI2] RX = 0x%02X\r\n", spi_rx);

        if (spi_rx == 0xA5)
        {
            printf("[SPI2] FPGA TEST PASS\r\n");
        }

        /* 다음 transfer용 응답값 */
        *((volatile unsigned char *)&SPI2->DR) = 0x3C;
    }

    /* ---------- Keypad ---------- */


        key = Keypad_Get_Key();

        if ((key != 0) &&
            (previous_key == 0))
        {
            printf("[KEYPAD] %c\r\n", key);

            Input_Process(
                INPUT_KEYPAD,
                key,
                keypad_input,
                &keypad_input_index);
        }

        previous_key = key;


        if (Macro_Check_Bit_Set(USART1->SR, 5))
        {
            ble_data = (char)USART1->DR;

            printf("[BLE] %c\r\n", ble_data);

            Input_Process(
                INPUT_BLE,
                ble_data,
                ble_input,
                &ble_input_index);
        }
    }
}