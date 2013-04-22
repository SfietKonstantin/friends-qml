#ifndef IMAGELOADER_H
#define IMAGELOADER_H

#include <QtCore/QObject>
#include <QtCore/QUrl>

class ImageLoaderPrivate;
class ImageLoader : public QObject
{
    Q_OBJECT
public:
    explicit ImageLoader(QObject *parent = 0);
    virtual ~ImageLoader();
public Q_SLOTS:
    void load(const QUrl &url);
Q_SIGNALS:
    void error(const QUrl &url);
    void loaded(const QUrl &url, const QString &path);
protected:
    QScopedPointer<ImageLoaderPrivate> d_ptr;
private slots:
    void slotFinished();
private:
    Q_DECLARE_PRIVATE(ImageLoader)
    Q_PRIVATE_SLOT(d_func(), void slotFinished())
    Q_PRIVATE_SLOT(d_func(), void slotError(QNetworkReply::NetworkError))
    Q_PRIVATE_SLOT(d_func(), void slotSslErrors(QList<QSslError>))
};

#endif // IMAGELOADER_H
