import QtQuick 1.1
import com.nokia.meego 1.0
import org.nemomobile.social 1.0
//import org.SfietKonstantin.qfb.mobile 4.0

Page {
    id: page
    property bool available: _window_.pageStack.currentPage == page || state == "push_in"
    property bool loading: (state == "" || state == "push_in" || state == "pop_in")
                           && (_facebook_.status == Facebook.Busy)

    function createScreen() {
        if (_window_.inPortrait) {
            image.source = "image://pagepixmapprovider/screenshotportrait"
        } else {
            image.source = "image://pagepixmapprovider/screenshotlandscape"
        }
    }

    states: [
        State { name: "push_in" },
        State { name: "push_out" },
        State { name: "pop_in" },
        State { name: "pop_out" }
    ]

    Connections {
        target: pageStack
        onBusyChanged: {
            if (!pageStack.busy) {
                page.state = ""
            }
        }
    }

    Connections {
        target: _window_
        onInPortraitChanged: {
            if (image.source != "") {
                page.createScreen()
            }
        }
    }

    Connections {
        target: page
        onStateChanged: {
            if (state == "") {
                image.source = ""
                image.visible = false
            } else if (state == "pop_out" || state == "push_out") {
                if (image.source == "") {
                    createScreen()
                }
                image.visible = true
            }
        }
    }

    Image {
        id: image
        visible: false
        z: 1000
        cache: false
//        asynchronous: true
        anchors.top: parent.top; anchors.topMargin: -36
    }

}
