#include "statusled.h"

statusLED::statusLED(uint8_t a, uint8_t b, uint8_t c, uint8_t d, uint8_t e)
{
    mLEDCount = 5;
    mLedPins = new uint8_t[mLEDCount]{};
    mLedPins[0] = a;
    mLedPins[1] = b;
    mLedPins[2] = c;
    mLedPins[3] = d;
    mLedPins[4] = e;

    for (int i = 0; i < mLEDCount; ++i)
    {
        pinMode(mLedPins[i], OUTPUT);
    }
    clearALL();
}

void statusLED::setStatus(uint8_t status)
{
    uint8_t flag = 0x1;
    for (int i = 0; i < mLEDCount; ++i)
    {
        digitalWrite(mLedPins[i], flag & status);
        flag <<= 1;
    }
}

void statusLED::clearALL()
{
    for (int i = 0; i < mLEDCount; ++i)
    {
        digitalWrite(mLedPins[i], LOW);
    }
}

void statusLED::loadingMode_1(unsigned long _delay)
{
    for (int i = 0; i < mLEDCount; ++i)
    {
        digitalWrite(mLedPins[i], HIGH);
        delay(_delay);
    }
}

void statusLED::loadingMode_2(unsigned long _delay)
{
    for (int i = 0; i < mLEDCount; ++i)
    {
        digitalWrite(mLedPins[i], HIGH);
        delay(_delay);
        digitalWrite(mLedPins[i - 1], LOW);
    }
}

void statusLED::blinkALL(unsigned long _delay, unsigned long long count)
{
    for (size_t i = 0; i < count; ++i)
    {
        for (int j = 0; j < mLEDCount; ++j)
        {
            digitalWrite(mLedPins[j], HIGH);
        }
        delay(_delay);
        for (int j = 0; j < mLEDCount; ++j)
        {
            digitalWrite(mLedPins[j], LOW);
        }
        delay(_delay);
    }
}
