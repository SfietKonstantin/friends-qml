/****************************************************************************************
 * Copyright (C) 2012 Lucien XU <sfietkonstantin@free.fr>                               *
 *                                                                                      *
 * This program is free software; you can redistribute it and/or modify it under        *
 * the terms of the GNU General Public License as published by the Free Software        *
 * Foundation; either version 3 of the License, or (at your option) any later           *
 * version.                                                                             *
 *                                                                                      *
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY      *
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A      *
 * PARTICULAR PURPOSE. See the GNU General Public License for more details.             *
 *                                                                                      *
 * You should have received a copy of the GNU General Public License along with         *
 * this program.  If not, see <http://www.gnu.org/licenses/>.                           *
 ****************************************************************************************/

#include "posthelper.h"

#include <QtCore/QCoreApplication>
#include <QtCore/QDebug>
#include <QtCore/QMetaObject>
#include <QtCore/QMetaProperty>
#include <QtCore/QRegExp>

static const int ELIDE_COUNT = 50;

static const char *RICH_TEXT_NAME
    = "<a style=\"text-decoration:none; color:#0057AE\" href=\"user----%1----%2\">%3</a>";

static const char *URL_REGEXP = "((http://|https://|www.)[a-zA-Z0-9_\\.\\-~%/#?]*)";
static const char *RICH_TEXT_URL
    = "<a style=\"text-decoration:none; color:#0057AE\" href=\"url----%1\">%2</a>";

inline QVariant get(QObject *object, const char *property)
{
    const QMetaObject *metaObject = object->metaObject();
    int index = metaObject->indexOfProperty(property);
    if (index == -1) {
        return QVariant();
    }

    QMetaProperty metaProperty = metaObject->property(index);
    return metaProperty.read(object);
}


//bool tagLesser(QFB::PostTag *tag1, QFB::PostTag *tag2)
//{
//    return tag1->offset() < tag2->offset();
//}

PostHelper::PostHelper(QObject *parent) :
    QObject(parent)
{
    m_post = 0;
    m_from = 0;
    m_fancy = true;
    m_story = false;
}

QObject * PostHelper::post() const
{
    return m_post;
}

QObject * PostHelper::from() const
{
    return m_from;
}

bool PostHelper::fancy() const
{
    return m_fancy;
}

QString PostHelper::userIdentifier() const
{
    return m_userIdentifier;
}

QString PostHelper::header() const
{
    return m_header;
}

QString PostHelper::message() const
{
    return m_message;
}

QString PostHelper::via() const
{
    return m_via;
}

bool PostHelper::isStory() const
{
    return m_story;
}

QDateTime PostHelper::createdTime() const
{
    return m_createdTime;
}

void PostHelper::setPost(QObject *post)
{
    if (m_post != post) {
        m_post = post;
        createPost();
        emit postChanged();
    }
}

void PostHelper::setFrom(QObject *from)
{
    if (m_from != from) {
        m_from = from;
        createPost();
        emit fromChanged();
    }
}

void PostHelper::setFancy(bool fancy)
{
    if (m_fancy != fancy) {
        m_fancy = fancy;
        createPost();
        emit fancyChanged();
    }
}

void PostHelper::setUserIdentifier(const QString &userIdentifier)
{
    if (m_userIdentifier != userIdentifier) {
        m_userIdentifier = userIdentifier;
        createPost();
        emit userIdentifierChanged();
    }
}

void PostHelper::clearTo()
{
    m_to.clear();
}

void PostHelper::appendTo(QObject *to)
{
    m_to.append(to);
    createPost();
}

void PostHelper::clearMessageTags()
{
    m_messageTags.clear();
}

void PostHelper::appendMessageTag(QObject *messageTag)
{
    m_messageTags.append(messageTag);
    createPost();
}

bool PostHelper::event(QEvent *e)
{
    if (e->type() == QEvent::User) {
        performPostCreation();
        return true;
    }
    return QObject::event(e);
}

void PostHelper::createPost()
{
    QCoreApplication::instance()->postEvent(this, new QEvent(QEvent::User));
}


void PostHelper::performPostCreation()
{
    if (!m_post) {
        return;
    }

    if (!m_from) {
        return;
    }

    QString story = get(m_post, "story").toString();
    if (!story.isEmpty()) {
        performStoryCreation();
    } else {
        performNormalPostCreation();
    }

    // Process message
//    QString message;
//    if (m_fancy) {
//        QString endMessage = get(m_post, "message").toString();
////        QList<QFB::PostTag *> messageTags = m_post->messageTags();
////        qSort(messageTags.begin(), messageTags.end(), tagLesser);

//        int previousOffset = 0;
//        foreach (QFB::PostTag *tag, messageTags) {
//            message.append(endMessage.left(tag->offset() - previousOffset));
//            endMessage = endMessage.remove(0, tag->offset() + tag->length() - previousOffset);
//            previousOffset = tag->offset() + tag->length();
//            message.append(QString(RICH_TEXT_NAME).arg(tag->facebookId(), tag->name(),
//                                                       tag->name()));
//        }
//        message.append(endMessage);

//        // Parse links
//        endMessage = message;
//        message.clear();

//        QRegExp urlRegExp(URL_REGEXP);
//        int nextUrlIndex = endMessage.indexOf(urlRegExp);
//        while (nextUrlIndex != -1) {
//            QString captured = urlRegExp.cap(1);
//            QString url = captured;
//            if (!url.startsWith("http://")) {
//                url.prepend("http://");
//            }
//            message.append(endMessage.left(nextUrlIndex));
//            endMessage = endMessage.remove(0, nextUrlIndex + captured.size());
//            message.append(QString(RICH_TEXT_URL).arg(url, captured));
//            nextUrlIndex = endMessage.indexOf(urlRegExp);
//        }
//        message.append(endMessage);
//    } else {


    // Via
    QString via;
    QObject *application = get(m_post, "application").value<QObject *>();
    QString applicationName;
    if (application) {
        applicationName = get(application, "objectName").toString();
    }
    if (!applicationName.isEmpty()) {
        via = tr("Via %1").arg(applicationName);
    }
    if (m_via != via) {
        m_via = via;
        emit viaChanged();
    }

    // Created time
    QString createdTimeString = get(m_post, "createdTime").toString();
    QDateTime createdTime = QDateTime::fromString(createdTimeString, Qt::ISODate);

    if (m_createdTime != createdTime) {
        m_createdTime = createdTime;
        emit createdTimeChanged();
    }
}

void PostHelper::performStoryCreation()
{
    QString story = get(m_post, "story").toString();
    story.replace("<", "&lt;");
    story.replace(">", "&gt;");
    story.replace("\n", "<br/>");

    if (m_header != story) {
        m_header = story;
        emit headerChanged();
    }

    if (!m_message.isEmpty()) {
        m_message.clear();
        emit messageChanged();
    }
}

void PostHelper::performNormalPostCreation()
{
    QString message = get(m_post, "message").toString();
    if (!m_fancy) {
        message = elideText(message, 120);
    }

    message.replace("<", "&lt;");
    message.replace(">", "&gt;");
    message.replace("\n", "<br/>");

    if (m_message != message) {
        m_message = message;
        emit messageChanged();
    }

    // Process from and to
    QList<QObject *> toList = m_to;
    foreach (QObject *messageTag, m_messageTags) {
        foreach (QObject *to, toList) {
            QString messageTagIdentifier = get(messageTag, "userIdentifier").toString();
            QString toIdentifier = get(messageTag, "objectIdentifier").toString();

            if (messageTagIdentifier == toIdentifier) {
                toList.removeAll(to);
            }
        }
    }

    QString toIdentifier;
    QString toName;
    if (toList.count() == 1) {
        if (get(toList.first(), "objectIdentifier").toString() != m_userIdentifier) {
            toIdentifier = get(toList.first(), "objectIdentifier").toString();
            toName = get(toList.first(), "objectName").toString();
        }
    }
    QString toHeader = RICH_TEXT_NAME;
    if (!toIdentifier.isEmpty() && !toName.isEmpty()) {
        QString elidedTo = elideText(toName, ELIDE_COUNT);
        toHeader = toHeader.arg(toIdentifier, toName, elidedTo);
    }
    QString elidedFrom;
    QString fromName;
    QString fromIdentifier;
    fromName = get(m_from, "objectName").toString();
    fromIdentifier = get(m_from, "objectIdentifier").toString();
    if (!toIdentifier.isEmpty() && !toName.isEmpty()) {
        elidedFrom = elideText(fromName, ELIDE_COUNT);
    } else {
        elidedFrom = elideText(fromName, 2 * ELIDE_COUNT);
    }
    QString header = RICH_TEXT_NAME;
    header = header.arg(fromIdentifier, fromName, elidedFrom);

    if (!toIdentifier.isEmpty() && !toName.isEmpty()) {
        header.append(" &gt; ");
        header.append(toHeader);
    }

    if (m_header != header) {
        m_header = header;
        emit headerChanged();
    }
}


QString PostHelper::elideText(const QString &text, int count)
{
    if (text.size() <= count) {
        return text;
    }
    QString elidedText = text.left(count - 2);
    elidedText.append(QString::fromUtf8(" …"));
    return elidedText;
}
