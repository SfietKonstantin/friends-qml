import QtQuick 1.1
import com.nokia.meego 1.0
import org.nemomobile.social 1.0
//import org.SfietKonstantin.qfb.mobile 4.0

Page {
    property bool beingPushed: false
    property bool beingPopped: false
    property bool loading: beingPushed || _facebook_.status == Facebook.Loading

    function displayPixmap() {
//        pixmapItem.saveState()
        if (_window_.inPortrait) {
            image.source = "image://pagepixmapprovider/screenshotportrait"
        } else {
            image.source = "image://pagepixmapprovider/screenshotlandscape"
        }

    }

    Connections {
        target: pageStack
        onBusyChanged: {
            if (!pageStack.busy) {
                beingPushed = false
                beingPopped = false
            }
        }
    }

    onBeingPushedChanged: {
        if (!beingPushed) {
            _facebook_.nextNode()
        }
    }

//    QFBBackPixmapItem {
//        id: pixmapItem
//        anchors.fill: parent
//    }


    Image {
        id: image
        z: 1000
        cache: false
//        asynchronous: true
        anchors.top: parent.top; anchors.topMargin: -36
    }

}
