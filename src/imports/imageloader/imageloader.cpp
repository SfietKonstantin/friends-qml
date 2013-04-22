#include "imageloader.h"
#include <QtCore/QCoreApplication>
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

typedef QPair<QUrl, QString> UrlImage;
static const int MAX_COUNT = 4;

class ImageLoaderPrivate
{
public:
    explicit ImageLoaderPrivate(ImageLoader *q);
    static QString imageName(const QUrl &url);
    void createReply(const QUrl &url, const QUrl &originalUrl = QUrl());
    void slotFinished();
    void slotError(QNetworkReply::NetworkError error);
    void slotSslErrors(QList<QSslError> sslErrors);
    QNetworkAccessManager *networkAccessManager;
    QMap<QNetworkReply *, QUrl> replyToUrl;
    QList<QUrl> stack;
    QList<QPair<QUrl, QString> > eventImages;
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

void ImageLoaderPrivate::createReply(const QUrl &url, const QUrl &originalUrl)
{
    Q_Q(ImageLoader);
    QNetworkReply *reply = networkAccessManager->get(QNetworkRequest(url));
    if (originalUrl.isEmpty()) {
        replyToUrl.insert(reply, url);
    } else {
        replyToUrl.insert(reply, originalUrl);
    }
    QObject::connect(reply, SIGNAL(finished()), q, SLOT(slotFinished()));
    QObject::connect(reply, SIGNAL(error(QNetworkReply::NetworkError)),
                     q, SLOT(slotError(QNetworkReply::NetworkError)));
    QObject::connect(reply, SIGNAL(sslErrors(QList<QSslError>)),
                     q, SLOT(slotSslErrors(QList<QSslError>)));
}

void ImageLoaderPrivate::slotFinished()
{
    Q_Q(ImageLoader);
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(q->sender());
    if (!reply) {
        return;
    }

    if (reply->error() != QNetworkReply::NoError) {
        reply->deleteLater();
        return;
    }

    if (!replyToUrl.contains(reply)) {
        reply->deleteLater();
        return;
    }

    QUrl url = replyToUrl.take(reply);

    // Check redirect
    QVariant possibleRedirect = reply->attribute(QNetworkRequest::RedirectionTargetAttribute);
    QUrl possibleRedirectUrl = possibleRedirect.toUrl();
    if (!possibleRedirectUrl.isEmpty() && possibleRedirectUrl != url) {
        reply->deleteLater();
        createReply(possibleRedirectUrl, url);
        return;
    }

    QString path = cacheFolderPath();
    QDir::root().mkpath(path);
    QDir dir = QDir(path);
    QString fileName = imageName(url);

    QByteArray data = reply->readAll();
    reply->deleteLater();
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

    while (replyToUrl.count() < MAX_COUNT && !stack.isEmpty()) {
        createReply(stack.takeLast());
    }
}

void ImageLoaderPrivate::slotError(QNetworkReply::NetworkError error)
{
    Q_Q(ImageLoader);
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(q->sender());
    if (!reply) {
        return;
    }

    if (!replyToUrl.contains(reply)) {
        return;
    }

    QUrl url = replyToUrl.take(reply);
    qDebug() << "Error: " << error << url;

    emit q->error(url);
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

QUrl ImageLoader::pictureUrl(const QString &id, const QString &token)
{
    QUrl url = QUrl(QString("https://graph.facebook.com/%1/picture").arg(id));
    url.addQueryItem("access_token", token);
    return url;
}

void ImageLoader::load(const QUrl &url)
{
    Q_D(ImageLoader);

    // Check the cache for existing image
    QDir dir (cacheFolderPath());
    QString fileName = d->imageName(url);

    if (dir.exists(fileName)) {
        d->eventImages.append(UrlImage(url, dir.absoluteFilePath(fileName)));
        QCoreApplication::postEvent(this, new QEvent(QEvent::User));
        return;
    }

    if (d->replyToUrl.count() >= MAX_COUNT) {
        d->stack.append(url);
        return;
    }

    d->createReply(url);
}

bool ImageLoader::event(QEvent *e)
{
    Q_D(ImageLoader);
    if (e->type() == QEvent::User) {
        if (!d->eventImages.isEmpty()) {
            UrlImage pair = d->eventImages.takeFirst();
            emit loaded(pair.first, pair.second);

            QCoreApplication::postEvent(this, new QEvent(QEvent::User));
        }
        return true;
    } else {
        return QObject::event(e);
    }
}

#include "moc_imageloader.cpp"
