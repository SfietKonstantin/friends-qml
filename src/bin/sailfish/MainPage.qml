import QtQuick 1.1
import Sailfish.Silica 1.0

Page {

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: cover.height + column.height
        FacebookCover {
            id: cover
            large: true
            name: ME.name
            coverUrl: ME.coverUrl
        }
        Column {
            id: column
            anchors.top: cover.bottom
            anchors.left: parent.left; anchors.right: parent.right
            Repeater {
                anchors.left: parent.left; anchors.right: parent.right
                model: ListModel {
                    ListElement {
                        text: "News feed"
                        action: "showNews"
                    }
                    ListElement {
                        text: "Me"
                        action: "showMe"
                    }
                    ListElement {
                        text: "Friends"
                        action: "showFriends"
                    }
                    ListElement {
                        text: "Groups"
                        action: "showGroups"
                    }
                }
                delegate: BackgroundItem {
                    Label {
                        anchors.left: parent.left; anchors.leftMargin: theme.paddingMedium
                        anchors.right: parent.right; anchors.rightMargin: theme.paddingMedium
                        anchors.verticalCenter: parent.verticalCenter
                        text: model.text
                    }
                }
            }
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
             }
        }
    }






}
