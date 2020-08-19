#pragma once
#ifndef STATUS_LED_H
#define STATUS_LED_H
//#include <vector>
//#include <initializer_list>
#define size_t unsigned long long

class statusLED
{
public:
    statusLED(uint8_t a, uint8_t b, uint8_t c, uint8_t d, uint8_t e);
    /**
     *
     * \param  {uint8_t} status :
     */
    void setStatus(uint8_t status);
    /**
     * \brief turn off all LEDs.
     */
    void clearALL();
    /**
     * \brief a theme for loading blink.
     * \param  {unsigned} long :
     */
    void loadingMode_1(unsigned long _delay);
    /**
     *
     * \param  {unsigned} long :
     */
    void loadingMode_2(unsigned long _delay);
    /**
     *
     * \param  {unsigned} long :
     * \param  {size_t} count  :
     */
    void blinkALL(unsigned long _delay, size_t count);

private:
    uint8_t mLEDE;
    uint8_t *mLedPins;
    int mLEDCount = 5;
};
#endif // * !STATUS_LED_H

