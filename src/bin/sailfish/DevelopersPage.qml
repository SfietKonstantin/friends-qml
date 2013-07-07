import QtQuick 1.1
import Sailfish.Silica 1.0

Page {
    ListModel {
        id: model
        ListElement {
            //icon: "chriadam.jpg"
            icon: ""
            category: "Developers of Nemo Social QML plugin"
            name: "Chris Adams"
            nickname: "chriadam"
            description: "Lead developer"
            twitter: ""
            website: "https://github.com/chriadam"
        }
        ListElement {
            icon: "w00t.jpg"
            category: "Developers of Nemo Social QML plugin"
            name: "Robin Burchell"
            nickname: "w00t"
            description: "Maintainer of Nemo QML plugins"
            twitter: "https://twitter.com/w00teh"
            website: "https://github.com/rburchell"
        }
        ListElement {
            icon: "zchydem.jpg"
            category: "Developers of Nemo Social QML plugin"
            name: "Marko Mattila"
            nickname: "zchydem"
            description: "Contributor"
            twitter: "https://twitter.com/zchydem"
            website: "https://github.com/zchydem"
        }
        ListElement {
            icon: "sfiet_konstantin.jpg"
            category: "Developers of Nemo Social QML plugin"
            name: "Lucien Xu"
            nickname: "Sfiet_Konstantin"
            description: "Contributor"
            twitter: "https://twitter.com/SfietKonstantin"
            website: "https://github.com/SfietKonstantin"
        }
        ListElement {
            icon: "sfiet_konstantin.jpg"
            category: "Developers of Friends"
            name: "Lucien Xu"
            nickname: "Sfiet_Konstantin"
            description: "Main developer"
            twitter: "https://twitter.com/SfietKonstantin"
            website: "https://github.com/SfietKonstantin"
        }
        ListElement {
            icon: "aniket.jpg"
            category: "Thanks to"
            name: "Aniket Vasishth"
            nickname: ""
            description: "Icons master"
            twitter: "https://twitter.com/LogonAniket"
            website: ""
        }
    }

    SilicaListView {
        id: view
        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Developers")
        }

        model: model
        section.property: "category"
        section.delegate: SectionHeader {
            text: section
        }

        delegate: Item {
            width: view.width
            height: column.height + 2 * theme.paddingMedium

            Rectangle {
                id: icon
                color: theme.secondaryColor

                width: 80; height: 80
                anchors.left: parent.left; anchors.leftMargin: theme.paddingMedium
                anchors.verticalCenter: parent.verticalCenter
                Image {
                    anchors.fill: parent
                    source: model.icon != "" ? DATA_PATH + model.icon : ""
                }
            }


            Column {
                id: column
                anchors.top: parent.top; anchors.topMargin: theme.paddingMedium
                anchors.left: icon.right; anchors.leftMargin: theme.paddingMedium
                spacing: theme.paddingSmall
                Label {
//                    font.pixelSize: Ui.FONT_SIZE_LARGE
                    text: model.name + (model.nickname != "" ? " (" + model.nickname + ")" : "")
                }

                Label {
                    text: model.description
                    font.pixelSize: theme.fontSizeExtraSmall
                    color: theme.secondaryColor
                }

//                Row {
//                    Button {
//                        visible: model.twitter != ""
//                        iconSource: "image://theme/icon-s-service-twitter"
//                        platformStyle: ButtonStyle {
//                            buttonWidth: 51
//                            buttonHeight: 51
//                        }
//                        onClicked: Qt.openUrlExternally(model.twitter)
//                    }

//                    Button {
//                        visible: model.website != ""
//                        iconSource: "image://theme/icon-l-browser-main-view"
//                        platformStyle: ButtonStyle {
//                            buttonWidth: 51
//                            buttonHeight: 51
//                        }
//                        onClicked: Qt.openUrlExternally(model.website)
//                    }
//                }
            }
        }
    }
}
