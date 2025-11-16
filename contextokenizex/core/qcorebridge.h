#pragma once
#include <QObject>
#include <QString>
#include <QtConcurrent>
#include <QElapsedTimer>
#include <QFutureWatcher>

class CoreBridge : public QObject {
    Q_OBJECT
public:
    explicit CoreBridge(QObject* parent = nullptr);

    Q_INVOKABLE void processAsync(const QString& text, const QString& token, const QString& point);

signals:
    void processed(const QString& result);
};
