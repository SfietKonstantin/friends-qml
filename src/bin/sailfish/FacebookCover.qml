import QtQuick 1.1
import Sailfish.Silica 1.0
import "UiConstants.js" as Ui

Item {
    id: container
    property string name
    property string category
    property string coverUrl
    property bool large: false


    anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top
    height: !large ? theme.itemSizeLarge : Ui.BANNER_HEIGHT_LARGE

    Item {
        id: coverBackground
        // That's dirty
        // replace with a nice shader instead of just opacity ramp
        anchors.top: parent.top; anchors.topMargin: theme.paddingSmall
        anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom
        clip: true

        FacebookImage {
            id: image
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            url: coverUrl
        }

//        Rectangle {
//            anchors.bottom: parent.bottom
//            anchors.left: parent.left; anchors.right: parent.right
//            height: Ui.MARGIN_DEFAULT + Ui.FONT_SIZE_XXLARGE + Ui.MARGIN_DEFAULT
//            opacity: 0.8
//            gradient: Gradient {
//                GradientStop {position: 0; color: "#00000000"}
//                GradientStop {position: 1; color: "black"}
//            }
//        }

//        Text {
//            id: nameText
//            anchors.left: parent.left; anchors.leftMargin: Ui.MARGIN_DEFAULT
//            anchors.right: parent.right; anchors.rightMargin: Ui.MARGIN_DEFAULT
//            anchors.bottom: parent.bottom
//            anchors.bottomMargin: !container.large ? (container.height - nameText.height) / 2
//                                                   : Ui.MARGIN_DEFAULT
//            color: !theme.inverted ? Ui.FONT_COLOR_INVERTED_PRIMARY : Ui.FONT_COLOR_PRIMARY
//            style: Text.Sunken
//            styleColor: !theme.inverted ? Ui.FONT_COLOR_SECONDARY : Ui.FONT_COLOR_INVERTED_SECONDARY
//            opacity: 0
//            elide: Text.ElideRight
//            wrapMode: Text.NoWrap
//            font.pixelSize: container.large ? Ui.FONT_SIZE_XXLARGE : Ui.FONT_SIZE_LARGE
//            states: [
//                State {
//                    name: "visible"; when: container.name != ""
//                    PropertyChanges {
//                        target: nameText
//                        opacity: 1
//                        text: container.name
//                              + (container.category != "" ? (" − " + container.category) : "")
//                    }
//                }
//            ]
//            Behavior on opacity {
//                NumberAnimation {duration: Ui.ANIMATION_DURATION_NORMAL}
//            }
//        }
        OpacityRampEffect {
            id: imageEffect
            sourceItem: image
            direction: OpacityRampEffect.TopToBottom
            offset: 0.50
            slope: 2
        }
    }


    Label {
        anchors.bottom: parent.bottom; anchors.bottomMargin: theme.paddingMedium
        anchors.left: parent.left; anchors.leftMargin: theme.paddingMedium
        anchors.right: parent.right; anchors.rightMargin: theme.paddingMedium
        text: container.name
        font.pixelSize: theme.fontSizeExtraLarge
        color: theme.highlightColor
    }
}
