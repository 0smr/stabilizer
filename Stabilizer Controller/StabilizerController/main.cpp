#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "opCode.h"
#include "serialporthandler.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    qmlRegisterType<serialPortHandler>("io.stabilizer.serialPort",1,0,"SerialPort");
    qmlRegisterUncreatableMetaObject(Stabilizer::staticMetaObject, "io.stabilizer.opcode", 1, 0, "OpCode", "Access to enums & flags only");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
