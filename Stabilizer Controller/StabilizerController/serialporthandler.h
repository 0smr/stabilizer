#ifndef SERIALPORTHANDLER_H
#define SERIALPORTHANDLER_H

#include <QList>
#include <QTimer>
#include <QObject>
#include <QQuickItem>
#include <QtBluetooth/QtBluetooth>
#include <QtBluetooth/QBluetoothSocket>
#include <QtBluetooth/QBluetoothServiceInfo>
#include <QtBluetooth/QBluetoothDeviceDiscoveryAgent>

#include <cstring>
#include <thread>

#include "opCode.h"

using Stablizer::OpCode;

class serialPortHandler : public QQuickItem
{
    Q_OBJECT
public:

    Q_PROPERTY(bool connected READ connected WRITE setConnected NOTIFY connectedChanged)
    Q_ENUMS(opCode)

    serialPortHandler();
    ~serialPortHandler();
    bool connected() const;
    void setConnected(bool connected);

signals:
    void dataRecived(QString data);
    void connectedChanged(bool connected);
    void log(QString);

public slots:
    void sendCommond(OpCode operationCode,QString data)
    {
        QString command = QString::number(operationCode) + ':';

        switch (operationCode)
        {
        case OpCode::MOVE_YAW_MID:
        case OpCode::MOVE_ROLL_MID:
        case OpCode::MOVE_PITCH_MID:
            command += data + ';';
            break;

        default:
            break;
        }

        qDebug() << "data:" << command;
        mBluetoothSocket.write(command.toLocal8Bit());
        mBluetoothSocket.waitForReadyRead(2000);
    }

    void bluetoothDeviceStateChanged(QBluetoothLocalDevice::HostMode mode);
    void bluetoothConnected();
    /*!
        \abstract read data into buffer
    */
    void readyRead();
    void errorHandler(QBluetoothSocket::SocketError error);
    void bluetoothDeviceFound(const QBluetoothDeviceInfo & bDeviceInfo);
    void parseValue(QString input);

    void setYawValue(int data)
    {
        QString command = QString::number(OpCode::MOVE_YAW_MID) + ':' +QString::number(data) + ';';
        qDebug() << "data:" << command;
        mBluetoothSocket.write(command.toLocal8Bit());
        mBluetoothSocket.waitForReadyRead(2000);
    }

private:
    bool mConnected;
    QString mBuffer;
    QBluetoothSocket mBluetoothSocket;
    QBluetoothLocalDevice mLocalDevice;
    QBluetoothDeviceDiscoveryAgent mBluetoothDiscoveryAgent;
};

#endif // SERIALPORTHANDLER_H
