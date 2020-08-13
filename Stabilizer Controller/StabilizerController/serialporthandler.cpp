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

    if(mLocalDevice.isValid())
    {
        mLocalDevice.powerOn();
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
    emit connectedChanged(connected);
    mConnected = connected;
}

void serialPortHandler::bluetoothDeviceStateChanged(QBluetoothLocalDevice::HostMode mode)
{
    if(mode == QBluetoothLocalDevice::HostConnectable
            || mode == QBluetoothLocalDevice::HostConnectable)
    {
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
    QStringList strList = input.split(':',QString::SplitBehavior::SkipEmptyParts);

    int operationCode = strList[0].toInt();

    switch (operationCode)
    {
    case Stablizer::OpCode::MESSAGE:
        qDebug() << strList.join(' ');
        break;
    }
}


