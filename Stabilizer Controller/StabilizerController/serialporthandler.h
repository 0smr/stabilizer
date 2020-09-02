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

#include "opCode.h"

using Stabilizer::OpCode;

class serialPortHandler : public QQuickItem
{
    Q_OBJECT
public:

    Q_PROPERTY(bool connected READ connected WRITE setConnected NOTIFY connectedChanged)

    serialPortHandler();
    ~serialPortHandler();
    bool connected() const;
    void setConnected(bool connected);

signals:
    void dataRecived(QString data);
    void connectedChanged(bool connected);
    void log(QString);

public slots:
    /*!
     * @brief sendCommand
     * @param operationCode
     * @param data
     */
    void sendCommand(OpCode operationCode,QString data);

    void bluetoothDeviceStateChanged(QBluetoothLocalDevice::HostMode mode);
    void bluetoothConnected();
    /*!
     * @brief readyRead
     */
    void readyRead();
    /*!
     * @brief errorHandler
     * @param error
     */
    void errorHandler(QBluetoothSocket::SocketError error);
    /*!
     * @brief bluetoothDeviceFound
     * @param bDeviceInfo
     */
    void bluetoothDeviceFound(const QBluetoothDeviceInfo & bDeviceInfo);
    void parseValue(QString input);

    void setYawValue(int yawValue);
    void setPitchValue(int pitchValue);
    void setRollValue(int rollValue);

private:
    bool mConnected;
    int mLastYaw,mLastPitch,mLastRoll;

    QString mBuffer;
    QBluetoothSocket mBluetoothSocket;
    QBluetoothLocalDevice mLocalDevice;
    QBluetoothDeviceDiscoveryAgent mBluetoothDiscoveryAgent;
};

#endif // SERIALPORTHANDLER_H
