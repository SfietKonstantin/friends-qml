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
        _facebook_.nodeIdentifier = container.identifier
        _facebook_.filters = [_photosFilter_]
//        photoList.load()
    }

    tools: ToolBarLayout {
        ToolIcon {
            iconId: "toolbar-back"
            onClicked: PageManagement.pop()
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
            model: _facebook_
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
////    //                    pictureType: QFBPictureLoader.Normal
                        fillMode: Image.PreserveAspectCrop
                        identifier: model.contentItem.identifier
                    }

                    LoadingIndicator {
                        loading: picture.loading
                    }

                }
                MouseArea {
                    anchors.fill: parent
//                    onClicked: container.showPhoto(repeater.model, model.index)
                }
            }
        }
        LoadingMessage {loading: _facebook_.status != Facebook.Idle}
        EmptyStateLabel {
            visible: _facebook_.status == Facebook.Idle && _facebook_.count == 0
            text: qsTr("No photos")
        }
    }
}
