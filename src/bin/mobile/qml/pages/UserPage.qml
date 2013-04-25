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

Page {
    id: container
    property string identifier
    property string name
    property bool needPop: true
    function load() {
        _imageLoader_.load(_imageLoader_.pictureUrl(container.identifier, _facebook_.accessToken,
                                                    "large"))

        if (identifier == _facebook_.node.identifier) {
            if (_facebook_.node.cover.source != "") {
                cover.coverUrl = _facebook_.node.cover.source
                container.needPop = false
            } else {
                _facebook_.node.coverChanged.connect(container.setCover)
                _facebook_.node.reload("cover")
            }
            return
        }

        _facebook_.nodeIdentifier = identifier
//        _facebook_.filters = [_emptyFilter_]
        _facebook_.filters = []
        _facebook_.sorters = []
        _facebook_.populate()
    }

    function setCover() {
        cover.coverUrl = _facebook_.node.cover.source
    }

    Connections {
        target: _facebook_
        onNodeChanged: {
            if (_facebook_.node.type == Facebook.User) {
                if (cover.coverUrl == "") {
                    _facebook_.node.coverChanged.connect(container.setCover)
                    _facebook_.node.reload("cover")
                }
            }
        }
    }

    tools: ToolBarLayout {
        ToolIcon {
            iconId: "toolbar-back"
            onClicked: {
                if (container.needPop) {
                    _facebook_.previousNode()
                }
                PageManagement.pop()
            }
        }

        ToolButton {
            text: qsTr("Post something")
            onClicked: PageManagement.showFeedDialog(container.facebookId)
        }

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
                onClicked: PageManagement.addPage("UserInfoPage", {identifier: container.identifier,
                                                                   name: container.name,
                                                                   coverUrl: cover.coverUrl})
            }
            MenuItem {
                text: qsTr("Albums")
                onClicked: PageManagement.addPage("AlbumListPage",
                                                  {facebookId: container.facebookId,
                                                   name: container.name,
                                                   coverUrl: cover.coverUrl})
            }
            MenuItem {
                text: qsTr("Photos")
                onClicked: PageManagement.addPage("PhotoListPage",
                                                  {facebookId: container.facebookId,
                                                   name: container.name,
                                                   coverUrl: cover.coverUrl})
            }
        }
    }

    Connections {
        target: _imageLoader_
        onLoaded: {
            if (url == _imageLoader_.pictureUrl(container.identifier,_facebook_.accessToken,
                                                "large")) {
                portrait.source = path
            }
        }
    }

    ScrollDecorator { flickableItem: flickable }
    Flickable {
        id: flickable
        anchors.fill: parent
        contentWidth: width
        contentHeight: cover.height + postList.height + Ui.MARGIN_DEFAULT


        Cover {
            id: cover
            name: container.name
            large: true
        }

        Rectangle {
            id: portraitContainer
            opacity: 0
            anchors.right: parent.right; anchors.rightMargin: Ui.MARGIN_DEFAULT
            anchors.top: cover.top; anchors.topMargin: Ui.MARGIN_DEFAULT
            width: portrait.width + 2 * Ui.MARGIN_XSMALL
            height: Math.min(portrait.height + 2 * Ui.MARGIN_XSMALL,
                             cover.height - 2 * Ui.MARGIN_DEFAULT)
            color: "white"

            Item {
                anchors.fill: parent
                anchors.margins: Ui.MARGIN_XSMALL
                clip: true

                Image {
                    id: portrait
                    anchors.top: parent.top
                }
            }

            states: [
                State {
                    name: "visible"; when: portrait.status == Image.Ready
                    PropertyChanges {
                        target: portraitContainer
                        opacity: 1
                    }
                }
            ]
            Behavior on opacity {
                NumberAnimation {duration: Ui.ANIMATION_DURATION_NORMAL}
            }
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
