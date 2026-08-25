#ifndef STM32_PROTOCOL_H
#define STM32_PROTOCOL_H

#include <stdint.h>

/* Command */
#define CMD_GET_STATUS       0x10U
#define CMD_DOOR_OPEN        0x20U
#define CMD_DOOR_CLOSE       0x21U

/* Response */
#define RESP_ACK             0x80U
#define RESP_STATUS_CLOSED   0x81U
#define RESP_STATUS_OPEN     0x82U
#define RESP_INVALID_CMD     0xFFU

uint8_t stm32_get_status(void);
uint8_t stm32_door_open(void);
uint8_t stm32_door_close(void);

#endif
