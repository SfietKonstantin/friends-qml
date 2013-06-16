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

AbstractFacebookPage {
    id: container
    property string identifier
    property string name
    property string coverUrl


    onStateChanged: {
        if (state == "push_in") {
            _facebook_.nodeIdentifier = container.identifier
            _facebook_.filters = [_photosFilter_]
            _facebook_.populate()
            _facebook_.nextNode()
        }
    }

    tools: ToolBarLayout {
        ToolIcon {
            iconId: "toolbar-back"
            onClicked: PageManagement.pop(true, true, true)
        }
    }

    Cover {
        id: cover
        name: container.name
        category: qsTr("Photos")
        coverUrl: container.coverUrl
    }


    Item {
        id: content
        anchors.top: cover.bottom; anchors.topMargin: Ui.MARGIN_DEFAULT
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right


        ScrollDecorator { flickableItem: view }
        GridView {
            id: view
            property real columns: 3
            clip: true
            anchors.top: parent.top; anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            model: container.available ? _facebook_ : null
            cellWidth: width / columns
            cellHeight: cellWidth

            delegate: Item {
                width: view.cellWidth
                height: view.cellHeight

                Rectangle {
                    width: parent.width - Ui.MARGIN_DEFAULT
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
                    onClicked: PageManagement.showPhotoViewer(model.index)
                }
            }
        }
        LoadingMessage {loading: container.loading}
        EmptyStateLabel {
            visible: !container.loading && container.available && view.model.count == 0
            text: qsTr("No photos")
        }
    }
}
