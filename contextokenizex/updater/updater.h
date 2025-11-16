#pragma once

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QFile>
#include <QDir>
#include <QDateTime>
#include <QStandardPaths>
#include <QUrl>
#include <QDebug>

class QNetworkAccessManager;
class QNetworkReply;
constexpr double APP_VER = 1.0;

class Updater : public QObject
{
    Q_OBJECT
public:
    explicit Updater(QObject* parent = nullptr);

    Q_INVOKABLE void downloadRelease(const QString& urlStr);

signals:
    void downloadFinished(const QString& filePath);
    void downloadFailed(const QString& errorString);
    void downloadProgressChanged(qint64 received, qint64 total);

private:
    QNetworkAccessManager* manager = nullptr;
};
