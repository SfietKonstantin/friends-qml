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
//import org.SfietKonstantin.qfb.mobile 4.0
import "../UiConstants.js" as Ui
import "../pagemanagement.js" as PageManagement
//import "../composite"
import "../components"

AbstractFacebookPage {
    id: container
    property string identifier
    property string name
    property bool isUser: false

    onStateChanged: {
        if (state == "push_in") {
            if (!isUser) {
                _facebook_.nodeIdentifier = identifier
                _facebook_.filters = []
                _facebook_.sorters = []
                _facebook_.populate()
                _facebook_.nextNode()
            } else {
                cover.coverUrl = ME.coverUrl
            }
        }
    }

    function setCover() {
        cover.coverUrl = _facebook_.node.cover.source
    }

    Connections {
        target: _facebook_
        onNodeChanged: {
            if (_facebook_.node.type == Facebook.User) {
                if (_facebook_.node.cover.source == "") {
                    _facebook_.node.coverChanged.connect(container.setCover)
                    _facebook_.node.reload("cover")
                } else {
                    setCover()
                }
            }
        }
    }

    tools: ToolBarLayout {
        ToolIcon {
            iconId: "toolbar-back"
            onClicked: {
                PageManagement.pop(true, !container.isUser, !container.isUser)
            }
        }

//        ToolButton {
//            text: qsTr("Post something")
//            onClicked: PageManagement.showFeedDialog(container.facebookId)
//        }

        ToolIcon {
            iconId: "toolbar-view-menu"
            onClicked: menu.open()
        }
    }

    Menu {
        id: menu
        MenuLayout {
            MenuItem {
                text: container.facebookId == ME.facebookId ? qsTr("Personnal informations")
                                                            : qsTr("User informations")
                onClicked: PageManagement.addPage("UserInfoPage.qml",
                                                  {identifier: container.identifier,
                                                   name: container.name,
                                                   coverUrl: cover.coverUrl}, false, true)
            }
            MenuItem {
                text: qsTr("Albums")
                onClicked: PageManagement.addPage("AlbumListPage.qml",
                                                  {identifier: container.identifier,
                                                   name: container.name,
                                                   coverUrl: cover.coverUrl}, true, true)
            }
            MenuItem {
                text: qsTr("Photos")
                onClicked: PageManagement.addPage("PhotoListPage.qml",
                                                  {identifier: container.identifier,
                                                   name: container.name,
                                                   coverUrl: cover.coverUrl}, true, true)
            }
        }
    }

    ScrollDecorator { flickableItem: flickable }
    Flickable {
        id: flickable
        anchors.fill: parent
        contentWidth: width
        contentHeight: cover.height + postList.height + Ui.MARGIN_DEFAULT

        UserCover {
            id: cover
            identifier: container.identifier
            name: container.name
        }

//        PostList {
//            id: postList
//            anchors.top: cover.bottom; anchors.topMargin: Ui.MARGIN_DEFAULT
//            facebookId: container.facebookId
//            stream: "feed"
//            onShowPost: PageManagement.addPage("PostPage", {facebookId: container.facebookId,
//                                                            name: container.name,
//                                                            coverUrl: cover.coverUrl,
//                                                            post: post})
//        }
    }
}
