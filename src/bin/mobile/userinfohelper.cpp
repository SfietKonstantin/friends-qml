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

#include "userinfohelper.h"

#include <QtCore/QStringList>

UserInfoHelper::UserInfoHelper(QObject *parent) :
    QObject(parent)
{
    m_valid = false;
    m_gender = Unknown;
}

bool UserInfoHelper::isValid() const
{
    return m_valid;
}

UserInfoHelper::Gender UserInfoHelper::gender() const
{
    return m_gender;
}

QString UserInfoHelper::birthday() const
{
    return m_birthday;
}

QString UserInfoHelper::religion() const
{
    return m_religion;
}

QString UserInfoHelper::political() const
{
    return m_political;
}

QString UserInfoHelper::bio() const
{
    return m_bio;
}

QString UserInfoHelper::quotes() const
{
    return m_quotes;
}

QString UserInfoHelper::formattedInformations() const
{
    return m_formattedInformations;
}

void UserInfoHelper::setGender(Gender gender)
{
    if (m_gender != gender) {
        m_gender = gender;
        createText();
        emit genderChanged();
    }
}

void UserInfoHelper::setBirthday(const QString &birthday)
{
    if (m_birthday != birthday) {
        m_birthday = birthday;
        createText();
        emit birthdayChanged();
    }
}

void UserInfoHelper::setReligion(const QString &religion)
{
    if (m_religion != religion) {
        m_religion = religion;
        createText();
        emit religionChanged();
    }
}

void UserInfoHelper::setPolitical(const QString &political)
{
    if (m_political != political) {
        m_political = political;
        createText();
        emit politicalChanged();
    }
}

void UserInfoHelper::setBio(const QString &bio)
{
    if (m_bio != bio) {
        m_bio = bio;
        //createText();
        emit bioChanged();
    }
}

void UserInfoHelper::setQuotes(const QString &quotes)
{
    if (m_quotes != quotes) {
        m_quotes = quotes;
        //createText();
        emit quotesChanged();
    }
}

void UserInfoHelper::createText()
{
    bool valid = false;
    QString formattedInformations;

    QString gender;
    switch(m_gender) {
    case Male:
        gender = tr("Male");
        break;
    case Female:
        gender = tr("Female");
        break;
    default:
        break;
    }

    if (!gender.isEmpty()) {
        valid = true;
        formattedInformations += QString("<b>%1</b>: %2\n").arg(tr("Gender"), gender);
    }

    formattedInformations += "\n";

    // Add birthday
    if (!m_birthday.isEmpty()) {
        valid = true;
        formattedInformations += QString("<b>%1</b>: %2\n").arg(tr("Birthday"), birthday());
    }

    formattedInformations += "\n";

    // Add languages
//    if (!m_user->languages().isEmpty()) {
//        valid = true;
//        QStringList languagesList;
//        foreach (QFB::NamedObject * language, m_user->languages()) {
//            languagesList.append(language->name());
//        }
//        QString languageString = languagesList.join(", ");
//        formattedInformations += QString("<b>%1</b>: %2\n").arg(tr("Language"), languageString);
//    }

//    formattedInformations += "\n";

    // Religion and political view
    if (!m_religion.isEmpty()) {
        valid = true;
        formattedInformations += QString("<b>%1</b>: %2\n").arg(tr("Religion"), m_religion);
    }
    if (!m_political.isEmpty()) {
        valid = true;
        formattedInformations += QString("<b>%1</b>: %2\n").arg(tr("Political view"),
                                                                m_political);
    }


    formattedInformations = formattedInformations.trimmed();
    formattedInformations = formattedInformations.replace(QRegExp("(\n)+"), "<br/>");


    if (m_formattedInformations != formattedInformations) {
        m_formattedInformations = formattedInformations;
        emit formattedInformationsChanged();
    }

//    QString bio = m_user->bio();
//    if (!bio.isEmpty()) {
//        valid = true;
//    }
//    if (m_bio != bio) {
//        m_bio = bio;
//        emit bioChanged();
//    }

//    QString quotes = m_user->quotes();
//    if (!quotes.isEmpty()) {
//        valid = true;
//    }
//    if (m_quotes != quotes) {
//        m_quotes = quotes;
//        emit quotesChanged();
//    }

    if (m_valid != valid) {
        m_valid = valid;
        emit validChanged();
    }
}
