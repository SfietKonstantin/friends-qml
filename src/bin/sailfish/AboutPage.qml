import QtQuick 1.1
import Sailfish.Silica 1.0

Page {

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: header.height + theme.paddingMedium + icon.height + theme.paddingMedium
                       + title.height + theme.paddingSmall + version.height + theme.paddingLarge
                       + info.height
        PageHeader {
            id: header
            title: qsTr("About")
        }


        Image {
            id: icon
            anchors.top: header.bottom; anchors.topMargin: theme.paddingMedium
            anchors.horizontalCenter: parent.horizontalCenter
            source: DATA_PATH + "/friends.png"
            smooth: true
            width: 128
            height: 128
        }

        Label {
            id: title
            anchors.top: icon.bottom; anchors.topMargin: theme.paddingMedium
            anchors.left: parent.left; anchors.right: parent.right
            font.pixelSize: theme.fontSizeExtraLarge
            horizontalAlignment: Text.AlignHCenter
            color: theme.highlightColor
            text: qsTr("Friends")
        }

        Label {
            id: version
            anchors.top: title.bottom; anchors.topMargin: theme.paddingSmall
            anchors.left: parent.left; anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: theme.fontSizeSmall
            color: theme.secondaryHighlightColor
            text: qsTr("Version") + " " + VERSION_MAJOR + "." + VERSION_MINOR + "." + VERSION_PATCH
                  + ", powered by Nemo Social."
        }

        Label {
            id: info
            anchors.top: version.bottom; anchors.topMargin: theme.paddingLarge
            anchors.left: parent.left; anchors.leftMargin: theme.paddingMedium
            anchors.right: parent.right; anchors.rightMargin: theme.paddingMedium
            wrapMode: Text.WordWrap
            text: qsTr("Friends is a Facebook client that tries to provide the best experience for \
the user. It is an Open Source software, meaning that it can me modified and enhanced by \
anybody. If you like Friends, please consider a donation. It will help maintaining the software, \
and keeping it status of Open Source software.")
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("Facebook page")
                onClicked: Qt.openUrlExternally(FACEBOOK_PAGE)
            }
            MenuItem {
                text: qsTr("Donate")
                onClicked: Qt.openUrlExternally(PAYPAL_DONATE)
            }
            MenuItem {
                text: qsTr("Developers")
                onClicked: window.pageStack.push(Qt.resolvedUrl("DevelopersPage.qml"))

            }
        }
    }
}
