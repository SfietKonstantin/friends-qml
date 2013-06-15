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

import QtQuick 1.1
import com.nokia.meego 1.0
import org.nemomobile.social 1.0
import org.SfietKonstantin.qfb.mobile 4.0
import "../UiConstants.js" as Ui
import "../pagemanagement.js" as PageManagement
import "../components"
import "../composite"

Page {
    id: container
    property string identifier
    property string name
    property string coverUrl

    function setGender() {
        switch (_facebook_.node.gender) {
        case FacebookUser.Male:
            userInfo.gender = QFBUserInfoHelper.Male
            break;
        case FacebookUser.Female:
            userInfo.gender = QFBUserInfoHelper.Female
            break;
        default:
            userInfo.gender = QFBUserInfoHelper.Unknown
            break;
        }
    }

    function load() {
        setGender()
        _facebook_.node.reload("gender,birthday,religion,political,bio,quotes")
        _facebook_.node.genderChanged.connect(userInfo.manageGender)
        _facebook_.node.birthdayChanged.connect(userInfo.manageBirthday)
        _facebook_.node.religionChanged.connect(userInfo.manageReligion)
        _facebook_.node.politicalChanged.connect(userInfo.managePolitical)
        _facebook_.node.bioChanged.connect(userInfo.manageBio)
        _facebook_.node.quotesChanged.connect(userInfo.manageQuotes())
    }

    tools: ToolBarLayout {
        ToolIcon {
            iconId: "toolbar-back"
            onClicked: PageManagement.simplePop()
        }
    }

    Cover {
        id: cover
        name: container.name
        category: qsTr("Informations")
        coverUrl: container.coverUrl
    }


    Item {
        anchors.top: cover.bottom; anchors.bottom: parent.bottom
        anchors.left: parent.left; anchors.right: parent.right
        id: content

        ScrollDecorator { flickableItem: flickable }
        Flickable {
            id: flickable
            anchors.fill: parent
            clip: true
            contentWidth: width
            contentHeight: userInfo.height + Ui.MARGIN_DEFAULT


            UserInfo {
                id: userInfo
                function manageGender() {
                    setGender()
                }
                function manageBirthday() {
                    userInfo.birthday = _facebook_.node.birthday
                }
                function manageReligion() {
                    userInfo.religion = _facebook_.node.religion
                }
                function managePolitical() {
                    userInfo.political = _facebook_.node.political
                }
                function manageBio() {
                    userInfo.bio = _facebook_.node.bio
                }
                function manageQuotes() {
                    userInfo.quotes = _facebook_.node.quotes
                }

                anchors.top: parent.top; anchors.topMargin: Ui.MARGIN_DEFAULT
            }
        }

        EmptyStateLabel {
            visible: !userInfo.valid && _facebook_.node.status == Facebook.Idle
            text: qsTr("No informations")
        }
    }

    LoadingMessage {loading: _facebook_.status != Facebook.Idle}
}
