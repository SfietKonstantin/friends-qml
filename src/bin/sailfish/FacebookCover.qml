import QtQuick 1.1
import Sailfish.Silica 1.0
//import Qt.labs.shaders 1.0
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
        //anchors.top: parent.top; anchors.topMargin: theme.paddingSmall
        anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom
        clip: true

        FacebookImage {
            id: image
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            url: coverUrl
        }

        OpacityRampEffect {
            id: imageEffect
            sourceItem: image
            direction: OpacityRampEffect.TopToBottom
            offset: 0.50
            slope: 2
        }
    }

//    ShaderEffectItem {
//        property variant source: ShaderEffectSource {
//            sourceItem: coverBackground
//        }
//        property int titleHeight: nameLabel.height + theme.paddingMedium
//        property int separatorHeight: theme.paddingLarge

////        property real _titleHeightRatio: flickArea.contentY > 0 ? 1 - titleHeight / height : 0
////        property real _titleHeightAndSeparatorRatio: flickArea.contentY > 0
////                                                     ? 1 - (titleHeight + separatorHeight) / height
////                                                     : 0


//        anchors.fill: coverBackground

//        fragmentShader: "
//        varying highp vec2 qt_TexCoord0;
//        //uniform float height;
//        uniform sampler2D source;
//        void main(void)
//        {
//            lowp vec4 textureColor = texture2D(source, qt_TexCoord0.st);
//            //gl_FragColor = smoothstep(0., 1.,
//            //                          qt_TexCoord0.y)
//            //               * textureColor;
//            gl_FragColor = textureColor;
//        }
//        "
//    }


    Label {
        id: nameLabel
        anchors.bottom: parent.bottom; anchors.bottomMargin: theme.paddingMedium
        anchors.left: parent.left; anchors.leftMargin: theme.paddingMedium
        anchors.right: parent.right; anchors.rightMargin: theme.paddingMedium
        text: container.name
        font.pixelSize: theme.fontSizeExtraLarge
        color: theme.highlightColor
    }
}
