#pragma once
#ifndef STABILIZER_H
#define STABILIZER_H
#include <stdarg.h>
#include <inttypes.h>
#include <string.h>
#include <Arduino.h>

#include "opcode.h"
/**
 *
 * \param  {OpCode} oc :
 */
void sendOpCode(const OpCode oc);

/**
 *
 * \param  {OpCode} oc  :
 * \param  {String} arg :
 */
void sendOpCode(const OpCode operationCode,const String &commandString);

/**
 *
 * \param  {OpCode} oc       :
 * this parameter representing operation code witch defined as \a OpCode enum.
 * \param  {char*} formatter :
 * this parameter containing a set of character in {i for integer, s for const char *, S for String, c for char and d for double}
 * \param  {...} undefined   :
 * this three dots represent initialize list
 */
void sendOpCode(const OpCode oc,const char * formatter,...);

#endif //* !STABILIZER_H
