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
import "../UiConstants.js" as Ui

Item {
    id: container
    property string identifier
    property string name
    property string category
    property string coverUrl
    anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top
    //height: Ui.BANNER_HEIGHT_LARGE + Ui.MARGIN_DEFAULT + Ui.BANNER_HEIGHT_PORTRAIT / 2
    height: childrenRect.height
    onIdentifierChanged: {
        imageLoader.load(imageLoader.pictureUrl(container.identifier, facebook.accessToken,
                                                Ui.BANNER_PORTRAIT, Ui.BANNER_PORTRAIT))
    }

    Rectangle {
        id: coverBackground
        anchors.top: parent.top
        anchors.left: parent.left; anchors.right: parent.right
        height: Ui.BANNER_HEIGHT_LARGE
        color: Ui.THEME_COLOR_PRIMARY
        clip: true

        FacebookImage {
            id: image
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            url: coverUrl
        }

    }

    Rectangle {
        anchors.bottom: coverBackground.bottom
        anchors.left: parent.left; anchors.right: parent.right
        height: Ui.MARGIN_DEFAULT + Ui.FONT_SIZE_XXLARGE + Ui.MARGIN_DEFAULT
        opacity: 0.8
        gradient: Gradient {
            GradientStop {position: 0; color: "#00000000"}
            GradientStop {position: 1; color: "black"}
        }
    }

    Text {
        id: nameText
        anchors.left: coverBackground.left; anchors.leftMargin: Ui.MARGIN_DEFAULT
        anchors.right: portraitContainer.left; anchors.rightMargin: Ui.MARGIN_DEFAULT
        anchors.bottom: coverBackground.bottom
        anchors.bottomMargin: Ui.MARGIN_DEFAULT
        color: !theme.inverted ? Ui.FONT_COLOR_INVERTED_PRIMARY : Ui.FONT_COLOR_PRIMARY
        style: Text.Sunken
        styleColor: !theme.inverted ? Ui.FONT_COLOR_SECONDARY : Ui.FONT_COLOR_INVERTED_SECONDARY
        opacity: 0
        wrapMode: Text.WordWrap
        font.pixelSize: Ui.FONT_SIZE_XXLARGE
        states: [
            State {
                name: "visible"; when: container.name != ""
                PropertyChanges {
                    target: nameText
                    opacity: 1
                    text: container.name
                }
            }
        ]
        Behavior on opacity {
            NumberAnimation {duration: Ui.ANIMATION_DURATION_NORMAL}
        }
    }

    Rectangle {
        id: portraitContainer
        opacity: 0
        anchors.right: parent.right; anchors.rightMargin: Ui.MARGIN_DEFAULT
        anchors.verticalCenter: coverBackground.bottom
        width: Ui.BANNER_PORTRAIT + 2 * Ui.MARGIN_XSMALL
        height: width
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

    Connections {
        target: imageLoader
        onLoaded: {
            if (url == imageLoader.pictureUrl(container.identifier, facebook.accessToken,
                                              Ui.BANNER_PORTRAIT, Ui.BANNER_PORTRAIT)) {
                portrait.source = path
            }
        }
    }
}
