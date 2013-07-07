import QtQuick 1.1
import Sailfish.Silica 1.0
import org.nemomobile.social 1.0

Page {
    id: page
    property bool available: (_window_.pageStack.currentPage == page || state == "push_in")
                             && internal.dataLoaded
    property bool loading: (state == "" || state == "push_in" || state == "pop_in")
                           && (_facebook_.status == Facebook.Busy)

    function load(identifier, filters, sorters) {
        _facebook_.nodeIdentifier = identifier
        _facebook_.filters = filters
        _facebook_.sorters = sorters
        _facebook_.populate()
        _facebook_.nextNode()
        internal.dataLoaded = true
    }

//    function createScreen() {
//        if (_window_.inPortrait) {
//            image.source = "image://pagepixmapprovider/screenshotportrait"
//        } else {
//            image.source = "image://pagepixmapprovider/screenshotlandscape"
//        }
//    }

    states: [
        State { name: "push_in" },
        State { name: "push_out" },
        State { name: "pop_in" },
        State { name: "pop_out" }
    ]

    QtObject {
        id: internal
        property bool dataLoaded: false
    }

    Connections {
        target: pageStack
        onBusyChanged: {
            if (!pageStack.busy) {
                page.state = ""
            }
        }
    }

//    Connections {
//        target: _window_
//        onInPortraitChanged: {
//            if (image.source != "") {
//                page.createScreen()
//            }
//        }
//    }

    Connections {
        target: page
        onStateChanged: {
            if (state == "") {
//                image.source = ""
//                image.visible = false
            } else if (state == "pop_out" || state == "push_out") {
                internal.dataLoaded = false

//                if (image.source == "") {
//                    createScreen()
//                }
//                image.visible = true
            } else if (state == "pop_in") {
                internal.dataLoaded = true
            }
        }
    }

//    Image {
//        id: image
//        visible: false
//        z: 1000
//        cache: false
////        asynchronous: true
//        anchors.top: parent.top; anchors.topMargin: -36
//    }

}
