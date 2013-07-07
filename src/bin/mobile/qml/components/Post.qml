/****************************************************************************************
 * Copyright (C) 2011 Lucien XU <sfietkonstantin@free.fr>                               *
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
import org.SfietKonstantin.qfb.mobile 4.0
import "../UiConstants.js" as Ui

Rectangle {
    id: container
    property QtObject post

    onPostChanged: {
        postHelper.clearTo()
        for (var i = 0; i < post.to.length; i++) {
            postHelper.appendTo(post.to[i])
        }
        postHelper.clearMessageTags()
        for (var i = 0; i < post.messageTags.length; i++) {
            postHelper.appendMessageTag(post.messageTags[i])
        }
    }

    property string userIdentifier
    property bool extendedView: false
//    property bool interactive: false
//    property int likes: post.likes.count
//    property int comments: post.comments.count
    signal clicked()
    signal callWebBrowser(string url)
    signal resolveType(string facebookId, string name)
//    function reactToLink(link) {
//        var strings = link.split("----")
//        if (strings[0] == "user") {
//            container.resolveType(strings[1], strings[2])
//        } else if (strings[0] == "url") {
//            callWebBrowser(strings[1])
//        }
//    }
    anchors.left: parent.left; anchors.leftMargin: Ui.MARGIN_DEFAULT
    anchors.right: parent.right; anchors.rightMargin: Ui.MARGIN_DEFAULT
    height: childrenRect.height + 2 * Ui.MARGIN_DEFAULT
    color: !theme.inverted ? "white" : "black"

    QFBPostHelper {
        id: postHelper
        post: container.post
        from: container.post.from
        fancy: container.extendedView
        userIdentifier: container.userIdentifier
    }

    Column {
        anchors.top: parent.top; anchors.topMargin: Ui.MARGIN_DEFAULT
        anchors.left: parent.left; anchors.leftMargin: Ui.MARGIN_DEFAULT
        anchors.right: parent.right; anchors.rightMargin: Ui.MARGIN_DEFAULT
        height: childrenRect.height

        Item {
            id: header
            height: Math.max(picture.height, headerText.height)
            property bool headerTextLarge: headerText.height > picture.height
            anchors.left: parent.left; anchors.right: parent.right


            FacebookPicture {
                id: picture
                anchors.top: parent.top
                anchors.topMargin: !header.headerTextLarge ? (header.height - picture.height) / 2
                                                           : 0
                identifier: container.post.from.objectIdentifier
            }

            Label {
                id: headerText
                anchors.top: parent.top
                anchors.left: picture.right; anchors.leftMargin: Ui.MARGIN_DEFAULT
                anchors.right: parent.right; anchors.rightMargin: Ui.MARGIN_DEFAULT
                anchors.topMargin: !header.headerTextLarge ? (header.height - headerText.height) / 2
                                                           : 0
                text: postHelper.header
            }
        }

        Item {
            id: messageContainer
            height: postHelper.message != "" ? Ui.MARGIN_DEFAULT + message.height : 0
            anchors.left: parent.left; anchors.right: parent.right

            Label {
                id: message
                text: postHelper.message
                anchors.top: parent.top;  anchors.topMargin: Ui.MARGIN_DEFAULT
                anchors.left: parent.left; anchors.right: parent.right
                textFormat: Text.RichText
    //            onLinkActivated: reactToLink(link)
            }
        }
    }





//    Item {
//        id: content
//        anchors.top: messageContainer.bottom
//        anchors.left: parent.left; anchors.right: parent.right
//        visible: container.post.picture != "" || container.post.name != ""
//                 || container.post.caption != "" || container.post.description != ""
//        height: visible ? childrenRect.height + Ui.MARGIN_DEFAULT : 0

//        Separator {
//            id: contentSeparator
//            anchors.top: parent.top; anchors.topMargin: Ui.MARGIN_DEFAULT
//            anchors.leftMargin: 0; anchors.rightMargin: 0
//        }

//        Row {
//            id: imageAndMetaRow
//            anchors.top: contentSeparator.bottom; anchors.topMargin: Ui.MARGIN_DEFAULT
//            anchors.left: parent.left; anchors.leftMargin: Ui.MARGIN_DEFAULT
//            anchors.right: parent.right; anchors.rightMargin: Ui.MARGIN_DEFAULT
//            spacing: Ui.MARGIN_DEFAULT

//            BorderImage {
//                id: imageContainer
//                width: content.width * 0.35
//                height: width
//                source: "image://theme/meegotouch-list" + (theme.inverted ? "-inverted" : "") +
//                        "-background-pressed-center"

//                LoadingIndicator {
//                    loading: postImage.status != Image.Ready
//                }

//                FacebookImage {
//                    id: postImage
//                    anchors.fill: parent
//                    fillMode: Image.PreserveAspectFit
//                    queryManager: container.queryManager
//                    url: container.post.picture
//                }
//            }

//            Column {
//                width: imageAndMetaRow.width - imageContainer.width - Ui.MARGIN_DEFAULT
//                spacing: Ui.MARGIN_SMALL

//                Label {
//                    text: container.post.name
//                    width: parent.width
//                }

//                Label {
//                    text: container.post.caption
//                    width: parent.width
//                    font.pixelSize: Ui.FONT_SIZE_SMALL
//                    color: !theme.inverted ? Ui.FONT_COLOR_SECONDARY
//                                           : Ui.FONT_COLOR_INVERTED_SECONDARY
//                }
//            }
//        }

//        Item {
//            anchors.top: imageAndMetaRow.bottom
//            anchors.left: parent.left; anchors.leftMargin: Ui.MARGIN_DEFAULT
//            anchors.right: parent.right; anchors.rightMargin: Ui.MARGIN_DEFAULT
//            height: container.post.description != "" ? description.height + Ui.MARGIN_DEFAULT : 0

//            Label {
//                id: description
//                anchors.top: parent.top; anchors.topMargin: Ui.MARGIN_DEFAULT
//                anchors.left: parent.left; anchors.right: parent.right
//                text: container.post.description
//                font.pixelSize: Ui.FONT_SIZE_SMALL
//                color: !theme.inverted ? Ui.FONT_COLOR_SECONDARY : Ui.FONT_COLOR_INVERTED_SECONDARY
//            }
//        }
//    }

//    Item {
//        id: footer
//        anchors.top: content.bottom
//        anchors.left: parent.left; anchors.right: parent.right
//        height: childrenRect.height + Ui.MARGIN_DEFAULT

//        Separator {
//            id: footerSeparator
//            anchors.top: parent.top; anchors.topMargin: Ui.MARGIN_DEFAULT
//            anchors.leftMargin: 0; anchors.rightMargin: 0
//        }


//        Item {
//            anchors.top: footerSeparator.bottom
//            anchors.left: parent.left; anchors.right: parent.right
//            height: Ui.LIST_ITEM_HEIGHT_SMALL

//            BorderImage {
//                id: background
//                anchors.fill: parent
//                visible: mouseArea.pressed
//                source: "image://theme/meegotouch-list" + (theme.inverted ? "-inverted" : "") +
//                        "-background-pressed-center"
//            }

//            Label {
//                anchors.left: parent.left; anchors.leftMargin: Ui.MARGIN_DEFAULT
//                anchors.verticalCenter: parent.verticalCenter
//                text: qsTr("%n likes", "", container.likes)
//                      + (!container.extendedView ?  ", " + qsTr("%n comments", "",
//                                                                container.comments)
//                                                 : "")
//            }

//            Image {
//                id: indicator
//                visible: !container.extendedView || container.likes != 0
//                source: "image://theme/icon-m-common-drilldown-arrow" +
//                        (theme.inverted ? "-inverse" : "")
//                anchors.right: parent.right; anchors.rightMargin: Ui.MARGIN_DEFAULT
//                anchors.verticalCenter: parent.verticalCenter
//            }

//            MouseArea {
//                id: mouseArea
//                onClicked: container.clicked()
//                anchors.fill: parent
//                enabled: !container.extendedView || container.likes != 0
//            }
//        }

//    }
}
