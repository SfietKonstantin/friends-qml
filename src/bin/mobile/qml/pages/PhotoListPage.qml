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
import "../composite"
import "../components"

Page {
    id: container
    property string identifier
    property string name
    property string coverUrl

    function load() {
        model.populate()
    }

    function repositionView(index) {
        view.positionViewAtIndex(index, GridView.Contain)
    }

    tools: ToolBarLayout {
        ToolIcon {
            iconId: "toolbar-back"
            onClicked: window.pageStack.pop()
        }
    }

    SocialNetworkModel {
        id: model
        socialNetwork: facebook
        nodeIdentifier: container.identifier
        filters: [photosFilter]
    }

    Cover {
        id: cover
        name: container.name
        category: qsTr("Photos")
        coverUrl: container.coverUrl
    }

    Item {
        id: content
        anchors.top: cover.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right


        ScrollDecorator { flickableItem: view }
        GridView {
            id: view
            property real columns: 3
            clip: true
            anchors.top: parent.top; anchors.bottom: parent.bottom
            anchors.left: parent.left; anchors.leftMargin: Ui.MARGIN_DEFAULT / 2
            anchors.right: parent.right
            model: model
            cellWidth: (width - 3) / columns
            cellHeight: cellWidth

            header: Item {
                width: container.width
                height: Ui.MARGIN_DEFAULT / 2
            }

            footer: LoadingFooter {
                width: container.width
                margins: Ui.MARGIN_DEFAULT / 2
                visible: model.status != SocialNetwork.Idle && model.count != 0
            }

            delegate: Item {
                width: view.cellWidth
                height: view.cellHeight

                Rectangle {
                    width: parent.width - Ui.MARGIN_SMALL / 2
                    height: width
                    anchors.centerIn: parent
                    color: !theme.inverted ? "white" : "black"

                    FacebookPicture {
                        id: picture
                        anchors.fill: parent
                        clip: true
                        fillMode: Image.PreserveAspectCrop
                        identifier: model.contentItem.identifier
                    }

                    LoadingIndicator {
                        loading: picture.loading
                    }

                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: PageManagement.showPhotoViewer(view.model, model.index)
                }
            }

            onAtYEndChanged: {
                if (atYEnd && view.count > 0 && model.hasNext) {
                    model.loadNext()
                }
            }
        }
        LoadingMessage {
            visible: model.status != SocialNetwork.Idle && model.count == 0
        }

        EmptyStateLabel {
            visible: model.status == SocialNetwork.Idle && model.count == 0
            text: qsTr("No photos")
        }
    }
}
