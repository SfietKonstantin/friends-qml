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
//import org.SfietKonstantin.qfb 4.0
//import org.SfietKonstantin.qfb.mobile 4.0
import "../UiConstants.js" as Ui
import "../pagemanagement.js" as PageManagement
import "../components"

Item {
    id: container
    property bool available
    property bool loading
    property string userIdentifier
    property alias header: view.header

    anchors.fill: parent
    Rectangle {
        color: "black"
        height: container.height
        width: 5
        anchors.left: container.left; anchors.leftMargin: 2 * Ui.MARGIN_DEFAULT + Ui.ICON_SIZE_DEFAULT / 2
    }

    ListView {
        id: view
        anchors.fill: parent
        spacing: Ui.MARGIN_DEFAULT
    //    width: parent.width
    //    height: column.height + Ui.MARGIN_DEFAULT //+ (model.haveNext ? button.height + Ui.MARGIN_DEFAULT
    //                                                                : 0)
    //    property bool loading: model.loading
    //    property int count: model.count
    //    property string stream
    //    signal showPost(variant post)
    //    function load() {
    //        model.request(container.facebookId + "/" + stream)
    //    }

        model: container.available ? _facebook_ : null

        State {
            name: "loaded"; when: !loading
            PropertyChanges {
                target: internal
                opacity: 1
            }
        }

        QtObject {
            id: internal
            property real opacity: 0

            Behavior on opacity {
                NumberAnimation { duration: Ui.ANIMATION_DURATION_FAST }
            }
        }

        delegate: Item {
            width: container.width
            height: content.height

    //                Connections {
    //                    target: POST_UPDATE_RELAY
    //                    onUpdatePostLikesAndComments: {
    //                        if (postId == model.data.facebookId) {
    //                            content.likes = likes
    //                            content.comments = comments
    //                        }
    //                    }
    //                }

            Post {
                id: content
    //                    post: model.data
                post: model.contentItem
                userIdentifier: container.userIdentifier
    //                    queryManager: QUERY_MANAGER
                interactive: true
                opacity: internal.opacity
                Component.onCompleted: opacity = 1
    //                    onClicked: container.showPost(model.data)
    //                    onResolveType: PageManagement.resolveType(facebookId, name)
                onCallWebBrowser: PageManagement.openWebBrowser(url)

            }
        }

        ScrollDecorator { flickableItem: container }

    //    LoadingButton {
    //        id: button
    //        anchors.top: column.bottom; anchors.topMargin: Ui.MARGIN_DEFAULT
    //        model: model
    //        onClicked: model.loadNext()
    //        text: qsTr("Load more")
    //        haveMore: model.haveNext
    //    }
    }
}
