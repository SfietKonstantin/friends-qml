import QtQuick 1.1
import Sailfish.Silica 1.0
import Qt.labs.shaders 1.0
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
        anchors.top: parent.top
        anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom
        clip: true

        FacebookImage {
            id: image
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            url: coverUrl
        }

//        OpacityRampEffect {
//            id: imageEffect
//            sourceItem: image
//            direction: OpacityRampEffect.TopToBottom
//            offset: 0.50
//            slope: 2
//        }

        ShaderEffectItem {
            property variant source: ShaderEffectSource {
                sourceItem: image
                hideSource: true
            }
            property real _imageOpacity: image.opacity

            anchors.fill: image

            fragmentShader: "
            varying highp vec2 qt_TexCoord0;
            uniform float height;
            uniform sampler2D source;
            uniform float _imageOpacity;
            void main(void)
            {
                lowp vec4 textureColor = texture2D(source, qt_TexCoord0.st);
                //gl_FragColor = textureColor;
                lowp float opacity = //smoothstep(0.05, 0.15, 1. - qt_TexCoord0.y)
                                     smoothstep(0.15, 0.30, qt_TexCoord0.y)
                                     * _imageOpacity;
                gl_FragColor = vec4(textureColor.xyz, 1.) * opacity;
            }
            "
        }
    }

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
