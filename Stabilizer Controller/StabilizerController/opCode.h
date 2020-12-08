#pragma once
#ifndef OP_CODE
#define OP_CODE

#include <QObject>

namespace Stabilizer
{
    Q_NAMESPACE
    enum OpCode:uint8_t
    {
        /// operations : contain controll commands.
        MOVE_PITCH_MID = 0x05,  /**
                                 * this command send from controller application.
                                 * and means pitch motor must move with given angle.
                                 * \param angle : single parameters containing a number between -90 to 90
                                 */
        MOVE_ROLL_MID,          /** same as the \a MOVE_PITCH_MID   */
        MOVE_YAW_MID,           /** same as the \a MOVE_PITCH_MID   */
        RESET_PITCH_MID,        /// reset just pitch mid    (no parameters)
        RESET_ROLL_MID,         /// reset just roll mid     (no parameters)
        RESET_YAW_MID,          /// reset just yaw mid      (no parameters)
        PATH_WITH_SPEED,        /*!
                                * this command send by controller application and contain 6 parameters
                                * \param midDist : distention
                                */
        PITCH_MID,              /** get \a PITCH_MID value (no parameters)       */
        ROLL_MID,               /** get \a ROLL_MID value (no parameters)        */
        YAW_MID,                /** get \a YAW_MID value (no parameters)         */
        PITCH_ANGLE,            /** get \a PITCH_ANGLE value (no parameters)     */
        ROLL_ANGLE,             /** get \a ROLL_ANGLE value (no parameters)      */
        YAW_ANGLE,              /** get \a YAW_ANGLE value (no parameters)       */
        LOCK_POSITION,              /** get \a YAW_ANGLE value (no parameters)       */

        /// settings:
        CALIBRATE_STABILIZER = 0x20,
        /**
         * call calibration function.
         * it take some seconds to calibrate
         */
        GET_ERROR_DATA,         /** get data from GYRO and ACCEL error data and send to controller application. */
        GET_EEPROM_DATA,        /** get data from eeprom data and send to controller application. */
        GET_CURRENT_ANGLE,      /** get */

        CLEAR_EEPROM,
        GYRO_ERROR_DATA,
        ACC_ERROR_DATA,

        /// status LED : LED's command goes here.
        BLINK_LED = 0xe0,       /// make status LED to blink (call blink function)
        SET_LED_STATUS,         /** a command with a \param that is a number between zero (0b0) and 63(0b11111)*/

        /// error codes : error code for better debuging.
        EMPTY_EEPROM = 0xd0,    /// an error rise when eeprom is empty (data for calibration will store in eeprom)
        INVALID_EEPROM,         /// an error rise when data in eeprom is invalid (can be fetermined ).
        INVALID_GYRO,
        INVALID_SERIAL_DATA,    /// an error rise when data that came from serial COM is invalid.
        INVALID_INPUT,          ///
        ERROR,                  /// reserved

        /// system code.
        OK = 0xf0,              // send a message from/to controller to verify command correctness
        MESSAGE,                /**
                             * a command that followed by single parameter.
                             * \param message : an string containing a message from/to controller application.
                             */
        DEBUG_MODE,             /// switch micro to debug mode, so debug message sends over serial COM.
    };
    Q_ENUM_NS(OpCode)
}

#endif //OP_CODE!
