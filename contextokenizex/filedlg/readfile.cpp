#include "readfile.h"

FileReader::FileReader(QObject* parent) : QObject(parent) {}

QString FileReader::readFile(const QString& filePath)
{
    if (filePath.isEmpty()) {
        qWarning() << "Empty file path";
        return QString();
    }

    QUrl url(filePath);
    QString localPath = url.isLocalFile() ? url.toLocalFile() : filePath;

    QFile file(localPath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Cannot open file:" << localPath;
        return QString();
    }

    // --- Check for unsupported data/files ---
    QByteArray probe = file.peek(1024);
    for (char c : probe) {
        if (c == '\0') {
            qWarning() << "Unsupported format detected:" << localPath;
            file.close();
            return QString();
        }
    }

    QTextStream in(&file);
    QString content = in.readAll();
    file.close();

    return content;
}
