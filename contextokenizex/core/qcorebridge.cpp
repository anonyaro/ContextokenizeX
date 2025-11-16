#include "qcorebridge.h"
#include "core.h"

CoreBridge::CoreBridge(QObject* parent) : QObject(parent) {}

void CoreBridge::processAsync(const QString& text, const QString& token, const QString& point)
{
    // thread watcher
    auto watcher = new QFutureWatcher<QString>(this);

    QObject::connect(watcher, &QFutureWatcher<QString>::finished, this, [this, watcher]() {
        emit processed(watcher->result());
        watcher->deleteLater();
        });

    QFuture<QString> future = QtConcurrent::run([=]() -> QString {
        QElapsedTimer timer;
        timer.start();

        QStringList contexts = findAllContexts(text, token, point);
        qint64 elapsedUs = timer.nsecsElapsed() / 1000;

        return buildReport(contexts, token, point, elapsedUs);
        });

    watcher->setFuture(future);
}
