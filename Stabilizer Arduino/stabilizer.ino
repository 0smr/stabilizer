#include <Servo.h>
#include <Wire.h>
#include <EEPROM.h>

#include <stdarg.h>

#include "opCode.h"
#include "statusLED.h"

#define BLUETOOTH_MODE_SERIAL

constexpr auto BOTTOM_SERVO_PIN = 9;
constexpr auto MIDDLE_SERVO_PIN = 10;
constexpr auto FRONT_SERVO_PIN = 11;
constexpr auto JSTICK_YAW_PIN = A0;
constexpr auto JSTICK_PITCH_PIN = A1;
constexpr auto RESET_POS_PIN = 3;
constexpr auto MID_POINT = 90;

double pitchMidPoint = MID_POINT,
        yawMidPoint = MID_POINT,
       rollMidPoint = MID_POINT;

const int MPU = 0x68; // MPU6050 I2C address

statusLED SLED(4,5,6,7,8);

Servo yDirection, xDirection, zDirection;

float AccX, AccY, AccZ;
float GyroX, GyroY, GyroZ;
float accAngleX, accAngleY, gyroAngleX, gyroAngleY, gyroAngleZ;
float roll, pitch, yaw;
float lastRoll, lastPitch, lastYaw;
float AccErrorX, AccErrorY, GyroErrorX, GyroErrorY, GyroErrorZ;
float elapsedTime, currentTime, previousTime;

void sendOpCode(const opCode &oc,const String &arg)
{
    Serial.println('c' + String(oc) + "-" +arg);
}
void sendOpCode(const opCode& oc,const char * formatter,...)
{
    va_list valist;
    char seprator = ':';
    int size = strlen(formatter);
    va_start(valist, size);
    String data = 'o' + String(oc);
    
    for (int i = 0; i < size; i++) 
    {
                data += seprator;
        switch(formatter[i])
        {
            case 'i':
                data += va_arg(valist, int);
            break;
            case 's':
                data += va_arg(valist, const char *);
            break;
            case 'S':
                data += va_arg(valist, String);
            break;
            case 'c':
                data += static_cast<char>(va_arg(valist, int));
            break;
            case 'd':
                data += va_arg(valist, double);
            break;
        }
    }
    va_end(valist);

    Serial.println(data);
}
void sendOpCode(opCode oc)
{
    Serial.println(String('o') + oc);
}

void sendErrorCode(const errorCode &ec)
{
    Serial.println(String('e') + ec);
}

void calculate_IMU_error();
void resetHandlers();
void collibrate();
void saveDataToEEPROM();
void initializeDevice();
void parseCommand(const String &);
void split()
{

}

void setup() {
    SLED.blinkALL(100, 2);
    SLED.setStatus(0x01);
    Serial.begin(9600);

    sendOpCode(opCode::DEBUG_MODE,"s","device started");

    Wire.begin();                      // Initialize comunication
    Wire.beginTransmission(MPU);       // Start communication with MPU6050 // MPU=0x68
    Wire.write(0x6B);                  // Talk to the register 6B
    Wire.write(0x00);                  // Make reset - place a 0 into the 6B register
    Wire.endTransmission(true);        // end the transmission

    /*
    // Configure Accelerometer Sensitivity - Full Scale Range (default +/- 2g)
    Wire.beginTransmission(MPU);
    Wire.write(0x1C);                  //Talk to the ACCEL_CONFIG register (1C hex)
    Wire.write(0x10);                  //Set the register bits as 00010000 (+/- 8g full scale range)
    Wire.endTransmission(true);
    // Configure Gyro Sensitivity - Full Scale Range (default +/- 250deg/s)
    Wire.beginTransmission(MPU);
    Wire.write(0x1B);                   // Talk to the GYRO_CONFIG register (1B hex)
    Wire.write(0x10);                   // Set the register bits as 00010000 (1000deg/s full scale)
    Wire.endTransmission(true);
    delay(20);
    */
#ifndef BLUETOOTH_MODE_SERIAL
    sendOpCode(opCode::MESSAGE,"s","begin c_imu_func\n");
#endif // !BLUETOOTH_MODE_SERIAL
    //initializeDevice();
    delay(20);
    SLED.setStatus(0b00000011);
    collibrate();

    xDirection.attach(MIDDLE_SERVO_PIN);
    zDirection.attach(BOTTOM_SERVO_PIN);
    yDirection.attach(FRONT_SERVO_PIN);

    //test servo motors
    for (int i = -1; i <= 1; ++i)
    {
        xDirection.write(MID_POINT + i * 3);
        yDirection.write(MID_POINT + i * 3);
        zDirection.write(MID_POINT + i * 3);

        sendOpCode(opCode::DEBUG_MODE,"sis","test motors on",MID_POINT + i * 3,"degree");
        delay(500); //wait for servo to test
    }
    SLED.setStatus(0b00011111);
    SLED.blinkALL(50, 5);

    pinMode(RESET_POS_PIN,INPUT);
    //attachInterrupt(digitalPinToInterrupt(RESET_POS_PIN), resetHandlers, CHANGE);
}

void loop() {
    // === Read acceleromter data === //
    Wire.beginTransmission(MPU);
    Wire.write(0x3B); // Start with register 0x3B (ACCEL_XOUT_H)
    Wire.endTransmission(false);
    Wire.requestFrom(MPU, 6, true); // Read 6 registers total, each axis value is stored in 2 registers
    //For a range of +-2g, we need to divide the raw values by 16384, according to the datasheet
    AccX = (Wire.read() << 8 | Wire.read()) / 16384.0; // X-axis value                   
    AccY = (Wire.read() << 8 | Wire.read()) / 16384.0; // Y-axis value                   
    AccZ = (Wire.read() << 8 | Wire.read()) / 16384.0; // Z-axis value                   
    // Calculating Roll and Pitch from the accelerometer data                            
    accAngleX = (atan(AccY / sqrt(pow(AccX, 2) + pow(AccZ, 2))) * 180 / PI) - AccErrorX;      // AccErrorX ~(0.58) See the calculate_IMU_error()custom function for more details
    accAngleY = (atan(-1 * AccX / sqrt(pow(AccY, 2) + pow(AccZ, 2))) * 180 / PI) - AccErrorY; // AccErrorY ~(-1.58)
    // === Read gyroscope data === //                                                    
    previousTime = currentTime;        // Previous time is stored before the actual time read
    currentTime = millis();            // Current time actual time read
    elapsedTime = (currentTime - previousTime) / 1000; // Divide by 1000 to get seconds
    Wire.beginTransmission(MPU);
    Wire.write(0x43); // Gyro data first register address 0x43
    Wire.endTransmission(false);
    Wire.requestFrom(MPU, 6, true); // Read 4 registers total, each axis value is stored in 2 registers
    GyroX = (Wire.read() << 8 | Wire.read()) / 131.0; // For a 250deg/s range we have to divide first the raw value by 131.0, according to the datasheet
    GyroY = (Wire.read() << 8 | Wire.read()) / 131.0;
    GyroZ = (Wire.read() << 8 | Wire.read()) / 131.0;
    // Correct the outputs with the calculated error values
    GyroX = GyroX - GyroErrorX; // GyroErrorX ~(-0.56)
    GyroY = GyroY - GyroErrorY; // GyroErrorY ~(2)
    GyroZ = GyroZ - GyroErrorZ; // GyroErrorZ ~ (-0.8)
    // Currently the raw values are in degrees per seconds, deg/s, so we need to multiply by sendonds (s) to get the angle in degrees
    gyroAngleX = gyroAngleX + GyroX * elapsedTime; // deg/s * s = deg
    gyroAngleY = gyroAngleY + GyroY * elapsedTime;

    yaw = yaw + GyroZ * elapsedTime;
    // Complementary filter - combine acceleromter and gyro angle values
    roll = 0.96 * gyroAngleX + 0.04 * accAngleX;
    pitch = 0.96 * gyroAngleY + 0.04 * accAngleY;

#ifdef BLUETOOTH_MODE_SERIAL
    if (Serial.available())
    {
        String commmand = Serial.readStringUntil(';');
        parseCommand(commmand);
    }
#elif 1
    // Print the values on the serial monitor
    sendOpCode(opCode::PITCH_DEGREE,"i",pitch);
    sendOpCode(opCode::ROLL_DEGREE,"i",roll);
    sendOpCode(opCode::YAW_DEGREE,"i",yaw);
#endif // BLUETOOTH_MODE_SERIAL

    if (lastRoll != roll || lastPitch != pitch || lastYaw != yaw)
    {
        xDirection.write(roll + rollMidPoint);
        yDirection.write(pitch + pitchMidPoint);
        zDirection.write(-yaw + yawMidPoint);
    }

    lastRoll = roll;
    lastPitch = pitch;
    lastYaw = yaw;

    auto yButton = analogRead(JSTICK_YAW_PIN);
    auto pButton = analogRead(JSTICK_PITCH_PIN) ;

    if(yButton < 450 || yButton > 550)
    {
        yawMidPoint += (yButton - 500.) / 1200.;
        if (yawMidPoint > 180)
        {
            yawMidPoint = 175;
        }
        else if (yawMidPoint < 0)
        {
            yawMidPoint = 5;
        }
    }    
    if(pButton < 450 || pButton > 550)
    {
        pitchMidPoint -= (pButton - 500.) / 600.;
        if (pitchMidPoint > 180)
        {
            pitchMidPoint = 175;
        }
        else if(pitchMidPoint < 0)
        {
            pitchMidPoint = 5;
        }
    }
#if !defined(BLUETOOTH_MODE_SERIAL) && 0
    sendOpCode(opCode::MESSAGE,"isisi",pButton," ",yButton," ",digitalRead(RESET_POS_PIN));
#endif // !BLUETOOTH_MODE_SERIAL
}

void calculate_IMU_error() {
    int c = 0;
    // Note that you should place the IMU flat in order to get the proper values, so that you then can the correct values
    // Read accelerometer values 400 times
    while (c < 400) {
        Wire.beginTransmission(MPU);
        Wire.write(0x3B);
        Wire.endTransmission(false);
        Wire.requestFrom(MPU, 6, true);
        AccX = (Wire.read() << 8 | Wire.read()) / 16384.0;
        AccY = (Wire.read() << 8 | Wire.read()) / 16384.0;
        AccZ = (Wire.read() << 8 | Wire.read()) / 16384.0;
        // Sum all readings
        AccErrorX = AccErrorX + ((atan((AccY) / sqrt(pow((AccX), 2) + pow((AccZ), 2))) * 180 / PI));
        AccErrorY = AccErrorY + ((atan(-1 * (AccX) / sqrt(pow((AccY), 2) + pow((AccZ), 2))) * 180 / PI));
        c++;
    }
    SLED.setStatus(0b00000111);
    //Divide the sum by 500 to get the error value
    AccErrorX = AccErrorX / 400;
    AccErrorY = AccErrorY / 400;
    c = 0;
    // Read gyro values 400 times
    while (c < 400) {
        Wire.beginTransmission(MPU);
        Wire.write(0x43);
        Wire.endTransmission(false);
        Wire.requestFrom(MPU, 6, true);
        GyroX = Wire.read() << 8 | Wire.read();
        GyroY = Wire.read() << 8 | Wire.read();
        GyroZ = Wire.read() << 8 | Wire.read();
        // Sum all readings
        GyroErrorX = GyroErrorX + (GyroX / 131.0);
        GyroErrorY = GyroErrorY + (GyroY / 131.0);
        GyroErrorZ = GyroErrorZ + (GyroZ / 131.0);
        c++;
    }
    SLED.setStatus(0b00001111);
    //Divide the sum by 200 to get the error value
    GyroErrorX = GyroErrorX / 400;
    GyroErrorY = GyroErrorY / 400;
    GyroErrorZ = GyroErrorZ / 400;

    // Print the error values on the Serial Monitor

#if !defined(BLUETOOTH_MODE_SERIAL) && 0
    sendOpCode(opCode::ACC_ERROR_DATA,"ff",AccErrorX,AccErrorY);
    sendOpCode(opCode::GYRO_ERROR_DATA,"fff",GyroErrorX,GyroErrorY,GyroErrorZ);
#endif
}
void collibrate()
{
    calculate_IMU_error();
    //
    //some other codes ***************88
    //
    saveDataToEEPROM();
}

//save error data to EEPROM (AccErrorX, AccErrorY, GyroErrorX, GyroErrorY, GyroErrorZ)
constexpr int dataSize = sizeof(float);
constexpr int dataShift = 1;

void saveDataToEEPROM()
{
    //true means data saved atleast one time.
    EEPROM.write(0, 0x1);
    EEPROM.put(0x0 * dataSize + dataShift, AccErrorX);
    EEPROM.put(0x1 * dataSize + dataShift, AccErrorY);
    EEPROM.put(0x2 * dataSize + dataShift, GyroErrorX);
    EEPROM.put(0x3 * dataSize + dataShift, GyroErrorY);
    EEPROM.put(0x4 * dataSize + dataShift, GyroErrorZ);
}

//load error values from EEPROM.
void initializeDevice()
{
    if (dataShift > 0 && EEPROM.length() >= 5 * dataSize + dataShift && EEPROM.read(0) == 0x1)//if true then EEPROM data is valid
    {
        EEPROM.get(0x0 * dataSize + dataShift, AccErrorX);
        EEPROM.get(0x1 * dataSize + dataShift, AccErrorY);
        EEPROM.get(0x2 * dataSize + dataShift, GyroErrorX);
        EEPROM.get(0x3 * dataSize + dataShift, GyroErrorY);
        EEPROM.get(0x4 * dataSize + dataShift, GyroErrorZ);
    }
    else if (EEPROM.read(0) == 0x1) //send error code
    {
        sendErrorCode(errorCode::EMPTY_EEPROM);
        collibrate();
    }
    else
    {
        sendErrorCode(errorCode::INVALID_EEPROM);
    }
}

//parse comming COM serial data.
void parseCommand(const String &command)
{
    int seprator = command.indexOf(':');
    int operationCode = command.substring(0,seprator).toInt();

    sendOpCode(opCode::MESSAGE,"iS",operationCode,command);
    switch (operationCode)
    {
        
    case opCode::MOVE_PITCH_MID:
    {
        pitchMidPoint = static_cast<double>(command.substring(seprator+1,command.indexOf(';')).toInt()) +MID_POINT;
        sendOpCode(opCode::PITCH_MID,"i",static_cast<int>(pitchMidPoint));
        yDirection.write(pitch + pitchMidPoint);
        break;
    }

    case opCode::MOVE_ROLL_MID: 
    {
        rollMidPoint = static_cast<double>(command.substring(seprator+1,command.indexOf(';')).toInt()) + MID_POINT;
        sendOpCode(opCode::ROLL_MID,"i",static_cast<int>(rollMidPoint));
        xDirection.write(roll + rollMidPoint);
        SLED.setStatus(0x04);
        break;
    }

    case opCode::MOVE_YAW_MID:
    {
        yawMidPoint = -static_cast<double>(command.substring(seprator+1,command.indexOf(';')).toInt()) + MID_POINT;
        sendOpCode(opCode::YAW_MID,"i",static_cast<int>(yawMidPoint));
        zDirection.write(-yaw + yawMidPoint);
        break;
    }
    default:
        sendErrorCode(errorCode::ERROR);
        break;
    }
}

// reset positions intrrupt function.
void resetHandlers()
{
    pitchMidPoint = rollMidPoint = yawMidPoint = MID_POINT;
    SLED.setStatus(0b00000100);
    delay(100);
    SLED.clearALL();
}
