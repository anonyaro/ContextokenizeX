#pragma once

#include <QObject>
#include <QString>
#include <QFile>
#include <QTextStream>
#include <QUrl>
#include <QDebug>

class FileReader : public QObject
{
    Q_OBJECT
public:
    explicit FileReader(QObject* parent = nullptr);

    Q_INVOKABLE QString readFile(const QString& filePath);
};
