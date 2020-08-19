#ifndef STABILIZER_H
#define STABILIZER_H

//extern Serial_ Serial;
/**
 * 
 * \param  {OpCode} oc : 
 */
void sendOpCode(const OpCode oc)
{
    Serial.println(oc);
}

/**
 * 
 * \param  {OpCode} oc  : 
 * \param  {String} arg : 
 */
void sendOpCode(const OpCode operationCode,const String &commandString)
{
    Serial.println(String(operationCode) + ":" + commandString);
}

/**
 * 
 * \param  {OpCode} oc       : 
 * this parameter representing operation code witch defined as \a OpCode enum.
 * \param  {char*} formatter :
 * this parameter containing a set of character in {i for integer, s for const char *, S for String, c for char and d for double} 
 * \param  {...} undefined   : 
 * this three dots represent initialize list 
 */
void sendOpCode(const OpCode oc,const char * formatter,...)
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

/**
 * this function parse data coming from serial COM
 * and send appropriate command to controller application.
 * 
 * \param  {String} command : 
 *      input command is contain commands and their parameters separated with ':' and ens with ';'.
 */
void parseCommand(const String &command)
{
    int seprator = command.indexOf(':');
    int operationCode = command.substring(0,seprator).toInt();

    sendOpCode(OpCode::MESSAGE,"iS",operationCode,command);
    switch (operationCode)
    {
        
    case OpCode::MOVE_PITCH_MID:
    {
        pitchMidPoint = static_cast<double>(command.substring(seprator+1,command.indexOf(';')).toInt()) +MID_POINT;
        sendOpCode(OpCode::PITCH_MID,"i",static_cast<int>(pitchMidPoint));
        yDirection.write(pitch + pitchMidPoint);
        break;
    }

    case OpCode::MOVE_ROLL_MID: 
    {
        rollMidPoint = static_cast<double>(command.substring(seprator+1,command.indexOf(';')).toInt()) + MID_POINT;
        sendOpCode(OpCode::ROLL_MID,"i",static_cast<int>(rollMidPoint));
        xDirection.write(roll + rollMidPoint);
        SLED.setStatus(0x04);
        break;
    }

    case OpCode::MOVE_YAW_MID:
    {
        yawMidPoint = -static_cast<double>(command.substring(seprator+1,command.indexOf(';')).toInt()) + MID_POINT;
        sendOpCode(OpCode::YAW_MID,"i",static_cast<int>(yawMidPoint));
        zDirection.write(-yaw + yawMidPoint);
        break;
    }
    default:
        sendOpCode(OpCode::INVALID_SERIAL_COM);
        break;
    }
}
#endif //* !STABILIZER_H