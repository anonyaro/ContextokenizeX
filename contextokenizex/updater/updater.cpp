#include "updater.h"

Updater::Updater(QObject* parent)
    : QObject(parent),
    manager(new QNetworkAccessManager(this))
{
}

void Updater::downloadRelease(const QString& urlStr)
{
    if (urlStr.isEmpty()) {
        emit downloadFailed("Empty URL");
        return;
    }

    QString downloadsPath = QStandardPaths::writableLocation(QStandardPaths::DownloadLocation);
    qDebug() << "Home path:" << QDir::homePath();
    qDebug() << "Saving to:" << downloadsPath;
    if (downloadsPath.isEmpty())
        downloadsPath = QDir::homePath() + "/Downloads";
    QDir().mkpath(downloadsPath);
    QString fileName = QString("ContextokenizeX_version-%1_build-%2.%3")
        .arg(APP_VER)
        .arg(QDateTime::currentDateTime().toString("yyyyMMddhhmmss"))
#ifdef _WIN32
        .arg("rar");
#else
        .arg("AppImage");
#endif

    QString savePath = QDir(downloadsPath).filePath(fileName);
    QUrl url(urlStr);

    QNetworkRequest request(url);
    QNetworkReply* reply = manager->get(request);

    connect(reply, &QNetworkReply::readyRead, this, [reply, savePath]() {
        QFile file(savePath);
        if (file.open(QIODevice::Append)) {
            file.write(reply->readAll());
            file.close();
        }
        });

    connect(reply, &QNetworkReply::downloadProgress, this, [this](qint64 received, qint64 total) {
        if (total > 0) {
            emit downloadProgressChanged(received, total); 
        }
        });

    connect(reply, &QNetworkReply::finished, this, [reply, savePath, this]() {
        if (reply->error() == QNetworkReply::NoError) {
            emit downloadFinished(savePath);
        }
        else {
            emit downloadFailed(reply->errorString());
        }
        reply->deleteLater();
        });
}
