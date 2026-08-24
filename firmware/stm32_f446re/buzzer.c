#include "device_driver.h"

#define NOTE_REST   0

#define NOTE_C4     262
#define NOTE_CS4    277
#define NOTE_D4     294
#define NOTE_DS4    311
#define NOTE_E4     330
#define NOTE_F4     349
#define NOTE_FS4    370
#define NOTE_G4     392
#define NOTE_GS4    415
#define NOTE_A4     440
#define NOTE_AS4    466
#define NOTE_B4     494

#define NOTE_C5     523
#define NOTE_D5     587
#define NOTE_E5     659

/*
 * 절망적인 느낌의 하강형 Game Over 멜로디
 *
 * 높은 음에서 시작해서 점점 낮아지고,
 * 마지막 음을 길게 유지
 */
static const unsigned short Game_Over_Tone[] =
{
    NOTE_E5,
    NOTE_D5,
    NOTE_C5,
    NOTE_B4,

    NOTE_REST,

    NOTE_A4,
    NOTE_GS4,
    NOTE_G4,
    NOTE_FS4,

    NOTE_REST,

    NOTE_F4,
    NOTE_E4,
    NOTE_DS4,
    NOTE_D4,
    NOTE_CS4,
    NOTE_C4
};

static const unsigned short Game_Over_Duration[] =
{
    180,
    180,
    180,
    260,

    100,

    200,
    200,
    220,
    280,

    120,

    220,
    220,
    250,
    280,
    320,
    700
};

void Buzzer_Play_Melody(void)
{
    unsigned int i;
    unsigned int note_count;

    note_count =
        sizeof(Game_Over_Tone) /
        sizeof(Game_Over_Tone[0]);

    for (i = 0; i < note_count; i++)
    {
        if (Game_Over_Tone[i] == NOTE_REST)
        {
            TIM3_Out_Stop();
        }
        else
        {
            TIM3_Out_Freq_Generation(
                Game_Over_Tone[i]
            );
        }

        TIM2_Delay(Game_Over_Duration[i]);

        /*
         * 음 사이를 끊어서
         * 각 음이 분명하게 들리게 함
         */
        TIM3_Out_Stop();
        TIM2_Delay(35);
    }

    TIM3_Out_Stop();
}