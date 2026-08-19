#ifndef APP_STOPWATCHAPP_H_
#define APP_STOPWATCHAPP_H_

#include <stdint.h>

typedef struct {
    uint8_t min;
    uint8_t sec;
    uint8_t centi_sec; // 0~99, 10 ms unit
} StopWatchTime_t;

void StopWatchApp_Init(void);
void StopWatchApp_Tick10ms(uint8_t run, uint8_t clear);
StopWatchTime_t StopWatchApp_GetTime(void);
void StopWatchApp_OutputLCD(void);
void StopWatchApp_OutputSPI(void);
void StopWatchApp_OutputGPIO(uint8_t mode_lcd);

#endif
