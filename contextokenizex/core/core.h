#pragma once
#include <QString>
#include <QStringList>
#include <QElapsedTimer>

QStringList findAllContexts(const QString& text, const QString& token, const QString& point);
int countTokens(const QString& text, const QString& token);
QString buildReport(const QStringList& contexts, const QString& token, const QString& point, qint64 elapsedUs);
