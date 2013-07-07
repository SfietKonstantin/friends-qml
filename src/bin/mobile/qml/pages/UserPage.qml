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
import "../composite"
import "../components"

Page {
    id: container
    property string identifier
    property string name
    property string coverUrl
    property bool isUser: false

    function load() {
        model.populate()
    }

//    onStateChanged: {
//        if (state == "push_in") {
//            load(container.identifier, [_feedFilter_], [])
//            _facebook_.dataFilters = [_storyDataFilter_]
//            if (isUser) {
//                container.coverUrl = ME.coverUrl
//            }
//        } else if (state == "pop_in") {
//            _facebook_.dataFilters = [_storyDataFilter_]
//        } else if (state == "push_out" || state == "pop_out") {
//            _facebook_.dataFilters = []
//        }
//    }

    function setCover() {
        container.coverUrl = model.node.cover.source
    }

    SocialNetworkModel {
        id: model
        socialNetwork: facebook
        nodeIdentifier: container.identifier
        filters: [feedFilter]
        dataFilters: [storyDataFilter]

        onNodeChanged: {
            if (node.type == Facebook.User) {
                if (node.cover.source == "") {
                    node.coverChanged.connect(container.setCover)
                    node.reload("cover")
                } else {
                    setCover()
                }
            }
        }
    }

    tools: ToolBarLayout {
        ToolIcon {
            iconId: "toolbar-back"
            onClicked: window.pageStack.pop()
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
//            MenuItem {
//                text: container.facebookId == ME.facebookId ? qsTr("Personnal informations")
//                                                            : qsTr("User informations")
//                onClicked: PageManagement.addPage("UserInfoPage.qml",
//                                                  {identifier: container.identifier,
//                                                   name: container.name,
//                                                   coverUrl: container.coverUrl})
//            }
            MenuItem {
                text: qsTr("Albums")
                onClicked: PageManagement.addPage("AlbumListPage.qml",
                                                  {identifier: container.identifier,
                                                   name: container.name,
                                                   coverUrl: container.coverUrl}, true)
            }
            MenuItem {
                text: qsTr("Photos")
                onClicked: PageManagement.addPage("PhotoListPage.qml",
                                                  {identifier: container.identifier,
                                                   name: container.name,
                                                   coverUrl: container.coverUrl}, true)
            }
        }
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        contentHeight: cover.height + Ui.MARGIN_DEFAULT + column.height + Ui.MARGIN_DEFAULT

        UserCover {
            id: cover
            identifier: container.identifier
            name: container.name
            coverUrl: container.coverUrl
        }

        Column {
            id: column
            anchors.top: cover.bottom; anchors.topMargin: Ui.MARGIN_DEFAULT
            spacing: Ui.MARGIN_DEFAULT
            Repeater {
                model: model
                delegate: Item {
                    width: container.width
                    height: content.height

                    Post {
                        id: content
                        post: model.contentItem
                        userIdentifier: container.identifier
        //                interactive: true
                    }
                }
            }
        }
    }
    ScrollDecorator { flickableItem: flickable }
}
