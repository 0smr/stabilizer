#pragma once

enum errorCode
{
    EMPTY_EEPROM = 0x3,
    INVALID_EEPROM,
    INVALID_GYRO,
    INVALID_SERIAL_DATA,
    ERROR,
    WRONG_INPUT,
};

enum opCode
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
    BLINK_LED = 0xe0,   
    SET_LED_STATUS,

    //system code
    OK = 0xf0,
    MESSAGE,
    DEBUG_MODE,
};