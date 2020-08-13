#pragma once
#ifndef OP_CODE
#define OP_CODE

#include <QObject>

namespace Stablizer
{
    //Q_NAMESPACE
    enum OpCode
    {
        //operations
        MOVE_PITCH_MID = 0x05,
        MOVE_ROLL_MID,
        MOVE_YAW_MID,
        RESET_PITCH_MID,
        RESET_ROLL_MID,
        RESET_YAW_MID,
        PATH_WITH_SPEED,
        PITCH_MID,
        ROLL_MID,
        YAW_MID,
        PITCH_DEGREE,
        ROLL_DEGREE,
        YAW_DEGREE,
        //settings
        COLLIBRATE_STABILIZER = 0x20,
        GET_ERROR_DATA,
        GET_EEPROM_DATA,
        GET_CURRENT_DEGREE,
        CLEAR_EEPROM,
        GYRO_ERROR_DATA,
        ACC_ERROR_DATA,

        //ledes
        BLINK_LED = 0xc0,
        SET_LED_STATUS,

        //error codes
        EMPTY_EEPROM = 0xd0,
        INVALID_EEPROM,
        INVALID_GYRO,
        INVALID_SERIAL_DATA,
        ERROR,
        WRONG_INPUT,

        //system code
        OK = 0xf0,
        MESSAGE,
        DEBUG_MODE,
    };
    //Q_ENUM_NS(OpCode)
}

#endif //OP_CODE!
