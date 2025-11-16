#include "core.h"

// Count exact occurrences (non-overlapping)
int countTokensInText(const QString& text, const QString& token) {
    if (token.isEmpty()) return 0;
    int count = 0;
    int pos = 0;
    while ((pos = text.indexOf(token, pos, Qt::CaseInsensitive)) != -1) {
        ++count;
        pos += token.length();
    }
    return count;
}


QStringList findAllContexts(const QString& text, const QString& token, const QString& point) {
    QStringList results;
    if (text.isEmpty() || token.isEmpty()) return results;

    int pos = 0;
    const int textLen = text.length();

    if (point.isEmpty()) {
        while (pos < textLen) {
            int start = text.indexOf(token, pos, Qt::CaseInsensitive);
            if (start == -1) break;

            int end = text.indexOf('\n', start);
            if (end == -1) end = textLen - 1;

            QString context = text.mid(start, end - start + 1).trimmed();
            results.append(context);

            pos = start + 1; 
        }
        return results;
    }

    while (pos < textLen) {
        int start = text.indexOf(token, pos, Qt::CaseInsensitive);
        if (start == -1) break;

        int end = text.indexOf(point, start);

        if (end == -1) {
            int nextToken = text.indexOf(token, start + token.length(), Qt::CaseInsensitive);
            if (nextToken != -1) {
                end = nextToken - 1; 
            }
            else {
                end = textLen - 1; 
            }
        }

        QString context = text.mid(start, end - start + 1).trimmed();
        results.append(context);

        pos = end + 1; 
    }

    return results;
}



// Build textual report
QString buildReport(const QStringList& contexts, const QString& token, const QString& point, qint64 elapsedUs) {
    QString out;
    out += QString("Token: %1\n").arg(token);
    out += QString("Subtoken: %1\n").arg(point);
    out += QString("Entrypoints: %1\n\n").arg(contexts.isEmpty() ? 0 : contexts.count()); // or use countTokens externally
    //out += QString("Context entrypoints: %1\n\n").arg(contexts.size()); if needed currently not needed thus "Entrypoints" = "Context entrypoints" since algorithm's logic has changed might change in future

    for (int i = 0; i < contexts.size(); ++i) {
        out += QString("[%1] => %2\n").arg(i + 1).arg(contexts.at(i));
    }
    out += QString("\nEstimated time: %1 µs\n").arg(elapsedUs);
    return out;
}
