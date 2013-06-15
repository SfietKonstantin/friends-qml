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

#ifndef USERINFOHELPER_H
#define USERINFOHELPER_H

#include <QtCore/QObject>

class UserInfoHelper : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool valid READ isValid NOTIFY validChanged)
    Q_PROPERTY(Gender gender READ gender WRITE setGender NOTIFY genderChanged)
    Q_PROPERTY(QString birthday READ birthday WRITE setBirthday NOTIFY birthdayChanged)
    Q_PROPERTY(QString religion READ religion WRITE setReligion NOTIFY religionChanged)
    Q_PROPERTY(QString political READ political WRITE setPolitical NOTIFY politicalChanged)
    Q_PROPERTY(QString bio READ bio WRITE setBio NOTIFY bioChanged)
    Q_PROPERTY(QString quotes READ quotes WRITE setQuotes NOTIFY quotesChanged)
    Q_PROPERTY(QString formattedInformations READ formattedInformations
               NOTIFY formattedInformationsChanged)
public:
    enum Gender {
        Unknown,
        Male,
        Female
    };
    Q_ENUMS(Gender)

    explicit UserInfoHelper(QObject *parent = 0);
    bool isValid() const;
    Gender gender() const;
    QString birthday() const;
    QString religion() const;
    QString political() const;
    QString bio() const;
    QString quotes() const;
    QString formattedInformations() const;
public slots:
    void setGender(Gender gender);
    void setBirthday(const QString &birthday);
    void setReligion(const QString &religion);
    void setPolitical(const QString &political);
    void setBio(const QString &bio);
    void setQuotes(const QString &quotes);
signals:
    void validChanged();
    void genderChanged();
    void birthdayChanged();
    void religionChanged();
    void politicalChanged();
    void bioChanged();
    void quotesChanged();
    void formattedInformationsChanged();
private:
    void createText();
    bool m_valid;
    Gender m_gender;
    QString m_birthday;
    QString m_religion;
    QString m_political;
    QString m_bio;
    QString m_quotes;
    QString m_formattedInformations;
};

#endif // USERINFOHELPER_H
