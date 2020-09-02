#include "serialporthandler.h"

serialPortHandler::serialPortHandler()
    :mConnected(false),mBluetoothSocket(QBluetoothServiceInfo::RfcommProtocol)
{
    connect(&mBluetoothSocket,&QBluetoothSocket::readyRead,
            this,&serialPortHandler::readyRead);
    connect(&mBluetoothDiscoveryAgent,&QBluetoothDeviceDiscoveryAgent::deviceDiscovered
            ,this,&serialPortHandler::bluetoothDeviceFound);
    connect(this,&serialPortHandler::dataRecived
            ,this,&serialPortHandler::parseValue);
    connect(&mLocalDevice,&QBluetoothLocalDevice::hostModeStateChanged
            ,this,&serialPortHandler::bluetoothDeviceStateChanged);

    connectedChanged(false);

    mBluetoothSocket.connectToService(QBluetoothAddress("00:18:E5:04:81:AD")
                                          ,QBluetoothUuid(QString("00001101-0000-1000-8000-00805F9B34FB"))
                                          ,QIODevice::ReadWrite);
    mBluetoothDiscoveryAgent.start();
    QString localDeviceName = "";
    if(mLocalDevice.isValid())
    {
        mLocalDevice.powerOn();

        // Read local device name
        localDeviceName = mLocalDevice.name();

        // Make it visible to others
        mLocalDevice.setHostMode(QBluetoothLocalDevice::HostDiscoverable);

        // Get connected devices
        QList<QBluetoothAddress> remotes;
        remotes = mLocalDevice.connectedDevices();
    }
}

serialPortHandler::~serialPortHandler()
{
    mBluetoothDiscoveryAgent.stop();
    mBluetoothSocket.close();
}

bool serialPortHandler::connected() const
{
    return mConnected;
}

void serialPortHandler::setConnected(bool connected)
{
    mConnected = connected;
    emit connectedChanged(connected);
}

void serialPortHandler::sendCommand(Stabilizer::OpCode operationCode, QString data)
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
    mBluetoothSocket.waitForReadyRead(50);
}

void serialPortHandler::bluetoothDeviceStateChanged(QBluetoothLocalDevice::HostMode mode)
{
    if(mode == QBluetoothLocalDevice::HostConnectable
            || mode == QBluetoothLocalDevice::HostConnectable)
    {
        mConnected = true;
        emit connectedChanged(true);
        mBluetoothSocket.connectToService(QBluetoothAddress("00:18:E5:04:81:AD")
                                          ,QBluetoothUuid(QString("00001101-0000-1000-8000-00805F9B34FB"))
                                          ,QIODevice::ReadWrite);
        mBluetoothDiscoveryAgent.start();
    }
}

void serialPortHandler::bluetoothConnected()
{
    mConnected = 1;
    connectedChanged(true);
}

void serialPortHandler::readyRead()
{
    if(mBluetoothSocket.bytesAvailable() > 0)
    {
        mBuffer += mBluetoothSocket.readLine();
        if(mBuffer.endsWith("\n") == true)
        {
            emit dataRecived(mBuffer);
            mBuffer.clear();
        }
    }
}

void serialPortHandler::errorHandler(QBluetoothSocket::SocketError error)
{
    qDebug() << error << mBluetoothSocket.errorString();
}

void serialPortHandler::bluetoothDeviceFound(const QBluetoothDeviceInfo &bDeviceInfo)
{
    qDebug() << bDeviceInfo.name() << bDeviceInfo.address().toString();
}

void serialPortHandler::parseValue(QString input)
{
    input.remove("\r\n");

    QStringList strList = input.split(':',Qt::SplitBehavior(Qt::SplitBehaviorFlags::SkipEmptyParts));

    int operationCode = strList[0].toInt();

    switch (operationCode)
    {
    case Stabilizer::OpCode::MESSAGE:
        qDebug() << strList.join(' ');
        break;
    }
}

void serialPortHandler::setYawValue(int yawValue)
{
    if(mLastRoll == yawValue)
    {
        mLastRoll = yawValue;
        sendCommand(OpCode::MOVE_YAW_MID,QString::number(yawValue));
    }
}

void serialPortHandler::setPitchValue(int pitchValue)
{
    if(mLastPitch == pitchValue)
    {
        mLastPitch = pitchValue;
        sendCommand(OpCode::MOVE_PITCH_MID,QString::number(pitchValue));
    }
}

void serialPortHandler::setRollValue(int rollValue)
{
    if(mLastYaw != rollValue)
    {
        mLastYaw = rollValue;
        sendCommand(OpCode::MOVE_ROLL_MID,QString::number(rollValue));
    }
}

