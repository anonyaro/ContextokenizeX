#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QQmlContext>
#include <QDebug>
#include "updater/updater.h"
#include <QDesktopServices>
#include "filedlg/readfile.h"
#include <QApplication>
#include <QtQuickControls2/QQuickStyle> 
#include "core/qcorebridge.h"

int main(int argc, char* argv[])
{
    QQuickStyle::setStyle("Material");
    qputenv("QT_QUICK_CONTROLS_STYLE", QByteArray("Material"));
    qputenv("QT_QUICK_CONTROLS_MATERIAL_THEME", QByteArray("Dark"));
    qputenv("QT_QUICK_CONTROLS_MATERIAL_ACCENT", QByteArray("Purple"));
    qputenv("QT_QUICK_CONTROLS_MATERIAL_FOREGROUND", QByteArray("Purple"));
    qputenv("QT_QUICK_CONTROLS_MATERIAL_BACKGROUND", QByteArray("#121212"));
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("APP_VER", APP_VER);
    Updater updater;
    engine.rootContext()->setContextProperty("updater", &updater);

    QObject::connect(&updater, &Updater::downloadFinished, &updater,
        [=](const QString& filePath) {
            QString folder = QFileInfo(filePath).absolutePath();
            QDesktopServices::openUrl(QUrl::fromLocalFile(folder));
        });

    QObject::connect(&updater, &Updater::downloadFailed, &updater,
        [=](const QString& errorString) {
            qDebug() << "Download failed:" << errorString;
        });

    FileReader fileReader;
    engine.rootContext()->setContextProperty("FileReader", &fileReader);

    CoreBridge coreBridge;
    engine.rootContext()->setContextProperty("Core", &coreBridge);

    const QUrl url(u"qrc:/ui/window.qml"_qs);
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject* obj, const QUrl& objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    if (engine.rootObjects().isEmpty())
        return -1;

    app.setWindowIcon(QIcon(":/icons/main.png"));

    qDebug() << "Graphics API being used:" << QQuickWindow::graphicsApi();

    return app.exec();
}
