import QtQuick 1.1
import Sailfish.Silica 1.0
import org.SfietKonstantin.qfb.login 4.0
import org.SfietKonstantin.qfb.imageloader 4.0
import org.nemomobile.social 1.0

ApplicationWindow {
    id: window
    initialPage: Page {
        PageHeader {
            id: header
            title: qsTr("Welcome")
        }

        Label {
            text: qsTr("Welcome to Friends. Please login into Facebook by pressing the button below")
            anchors.top: header.bottom; anchors.topMargin: theme.paddingLarge
            anchors.left: parent.left; anchors.leftMargin: theme.paddingMedium
            anchors.right: parent.right; anchors.rightMargin: theme.paddingMedium
            wrapMode: Text.WordWrap
        }

        Button {
            text: qsTr("Login")
            anchors.bottom: parent.bottom; anchors.bottomMargin: theme.paddingLarge
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: window.pageStack.replace(Qt.resolvedUrl("LoginPage.qml"))
        }
    }

    Component.onCompleted:  {
        if (TOKEN_MANAGER.token != "") {
            _facebook_.accessToken = TOKEN_MANAGER.token
            window.pageStack.replace(Qt.resolvedUrl("MainPage.qml"))
            initialInfoLoader.getInitialInfo()
        }
    }

    Connections {
        target: LOGIN_MANAGER
        onLoginSucceeded: {
            _facebook_.accessToken = token
            TOKEN_MANAGER.token = token
            window.pageStack.replace(Qt.resolvedUrl("MainPage.qml"))
            initialInfoLoader.getInitialInfo()

        }
    }

    Facebook {
        id: _facebook_
    }

    QFBImageLoader {
        id: _imageLoader_
    }

    QtObject {
        id: initialInfoLoader
        property bool loading: false
        function getInitialInfo() {
            loading = true
            _facebook_.nodeIdentifier = "me"
            _facebook_.filters = []
            _facebook_.sorters = []
            _facebook_.populate()
            _facebook_.nextNode()
        }
        function setCover() {
            ME.coverUrl = _facebook_.node.cover.source
            loading = false
        }
    }

    Connections {
        target: _facebook_
        onStatusChanged: {
            if (initialInfoLoader.loading && _facebook_.node != null) {
                ME.identifier = _facebook_.node.identifier
                ME.name = _facebook_.node.name
                _facebook_.node.coverChanged.connect(initialInfoLoader.setCover)
                _facebook_.node.reload("cover")
            }
        }
    }

//    cover: Qt.resolvedUrl("cover/CoverPage.qml")
}


