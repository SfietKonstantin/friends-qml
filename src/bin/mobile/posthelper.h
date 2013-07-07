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

#ifndef POSTHELPER_H
#define POSTHELPER_H

#include <QtCore/QObject>
#include <QtCore/QDateTime>

class PostHelper : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QObject * post READ post WRITE setPost NOTIFY postChanged)
    Q_PROPERTY(QObject * from READ from WRITE setFrom NOTIFY postChanged)
    Q_PROPERTY(bool fancy READ fancy WRITE setFancy NOTIFY fancyChanged)
    Q_PROPERTY(QString userIdentifier READ userIdentifier WRITE setUserIdentifier
               NOTIFY userIdentifierChanged)
    Q_PROPERTY(QString header READ header NOTIFY headerChanged)
    Q_PROPERTY(QString message READ message NOTIFY messageChanged)
    Q_PROPERTY(QString via READ via NOTIFY viaChanged)
    Q_PROPERTY(bool story READ isStory NOTIFY storyChanged)
    Q_PROPERTY(QDateTime createdTime READ createdTime NOTIFY createdTimeChanged)
public:
    explicit PostHelper(QObject *parent = 0);
    QObject * post() const;
    QObject * from() const;
    bool fancy() const;
    QString userIdentifier() const;
    QString header() const;
    QString message() const;
    QString via() const;
    bool isStory() const;
    QDateTime createdTime() const;
public slots:
    void setPost(QObject *post);
    void setFrom(QObject *from);
    void setFancy(bool fancy);
    void setUserIdentifier(const QString &userIdentifier);
    void clearTo();
    void appendTo(QObject *to);
    void clearMessageTags();
    void appendMessageTag(QObject *messageTag);
signals:
    void postChanged();
    void fromChanged();
    void fancyChanged();
    void userIdentifierChanged();
    void headerChanged();
    void messageChanged();
    void viaChanged();
    void storyChanged();
    void createdTimeChanged();
protected:
    bool event(QEvent *e);
private:
    void createPost();
    void performPostCreation();
    void performStoryCreation();
    void performNormalPostCreation();
    static QString elideText(const QString &text, int count);
    QObject *m_post;
    QObject *m_from;
    bool m_fancy;
    QString m_userIdentifier;
    QList<QObject *> m_to;
    QList<QObject *> m_messageTags;
    QString m_header;
    QString m_message;
    QString m_via;
    bool m_story;
    QDateTime m_createdTime;
};

#endif // POSTHELPER_H
