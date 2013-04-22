#include "imageloader.h"
#include <QtCore/QDir>
#include <QtCore/QMap>
#include <QtCore/QCryptographicHash>
#include <QtCore/QDebug>
#include <QtGui/QImage>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkReply>
#include <QtNetwork/QNetworkRequest>
#include <QtNetwork/QSslError>
#include "cachehelper_p.h"

class ImageLoaderPrivate
{
public:
    explicit ImageLoaderPrivate(ImageLoader *q);
    static QString imageName(const QUrl &url);
    void slotFinished();
    void slotError(QNetworkReply::NetworkError error);
    void slotSslErrors(QList<QSslError> sslErrors);
    QNetworkAccessManager *networkAccessManager;
    QMap<QNetworkReply *, QUrl> replyToUrl;
protected:
    ImageLoader * const q_ptr;
private:
    Q_DECLARE_PUBLIC(ImageLoader)
};

ImageLoaderPrivate::ImageLoaderPrivate(ImageLoader *q):
    networkAccessManager(0), q_ptr(q)
{
}

QString ImageLoaderPrivate::imageName(const QUrl &url)
{
    QByteArray asciiUrl = url.toString().toLocal8Bit();
    QByteArray encodedUrl = QCryptographicHash::hash(asciiUrl, QCryptographicHash::Md5);
    return QString("img_%1.jpg").arg(QString(encodedUrl.toHex()));
}

void ImageLoaderPrivate::slotFinished()
{
    Q_Q(ImageLoader);
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(q->sender());
    qDebug() << reply << replyToUrl;
    if (!reply) {
        return;
    }

    if (!replyToUrl.contains(reply)) {
        return;
    }

    // Check cache
    QUrl url = replyToUrl.take(reply);
    qDebug() << url;
    QString path = cacheFolderPath();
    QDir::root().mkpath(path);
    QDir dir = QDir(path);
    QString fileName = imageName(url);

    QByteArray data = reply->readAll();
    QImage image;
    bool ok = false;
    if (image.loadFromData(data, "JPG")) {
        ok = true;
    }
    if (!ok) {
        if (image.loadFromData(data, "PNG")) {
            ok = true;
        }
    }
    if (!ok) {
        if (image.loadFromData(data, "GIF")) {
            ok = true;
        }
    }

    if (image.isNull()) {
        emit q->error(url);
    }

    QString imagePath = dir.absoluteFilePath(fileName);
    image.save(imagePath, "JPG");
    emit q->loaded(url, imagePath);
}

void ImageLoaderPrivate::slotError(QNetworkReply::NetworkError error)
{
    Q_Q(ImageLoader);
    qDebug() << "Error: " << error;
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(q->sender());
    if (!reply) {
        return;
    }

    if (!replyToUrl.contains(reply)) {
        return;
    }
    emit q->error(replyToUrl.take(reply));
}

void ImageLoaderPrivate::slotSslErrors(QList<QSslError> sslErrors)
{
    Q_Q(ImageLoader);
    Q_UNUSED(sslErrors)
    qDebug() << "SSL error";
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(q->sender());
    if (!reply) {
        return;
    }

    if (!replyToUrl.contains(reply)) {
        return;
    }

    emit q->error(replyToUrl.take(reply));
}

////// End of private class //////

ImageLoader::ImageLoader(QObject *parent) :
    QObject(parent), d_ptr(new ImageLoaderPrivate(this))
{
    Q_D(ImageLoader);
    d->networkAccessManager = new QNetworkAccessManager(this);
}

ImageLoader::~ImageLoader()
{
}

void ImageLoader::load(const QUrl &url)
{
    Q_D(ImageLoader);

    // Check the cache for existing image
    QDir dir (cacheFolderPath());
    QString fileName = d->imageName(url);

    if (dir.exists(fileName)) {
        emit loaded(url, dir.absoluteFilePath(fileName));
        return;
    }


    QNetworkReply *reply = d->networkAccessManager->get(QNetworkRequest(url));
    d->replyToUrl.insert(reply, url);
    connect(reply, SIGNAL(finished()), this, SLOT(slotFinished()));
    connect(reply, SIGNAL(error(QNetworkReply::NetworkError)),
            this, SLOT(slotError(QNetworkReply::NetworkError)));
    connect(reply, SIGNAL(sslErrors(QList<QSslError>)),
            this, SLOT(slotSslErrors(QList<QSslError>)));
}

#include "moc_imageloader.cpp"
