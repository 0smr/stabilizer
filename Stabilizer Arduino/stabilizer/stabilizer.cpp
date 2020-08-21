#include "stabilizer.h"

void sendOpCode(const OpCode oc)
{
    Serial.println(String(oc) + ';');
}

void sendOpCode(const OpCode operationCode, const String &commandString)
{
    Serial.println(String(operationCode) + ":" + commandString) + ';';
}

void sendOpCode(const OpCode oc, const char *formatter,...)
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
    data += ';';

    Serial.println(data);
}
