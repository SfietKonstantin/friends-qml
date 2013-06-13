/****************************************************************************************
 * Copyright (C) 2011 Lucien XU <sfietkonstantin@free.fr>                               *
 *                                                                                      *
 * This program is free software; you can redistribute it and/or modify it under        *
 * the terms of the GNU General Public License as published by the Free Software        *
 * Foundation; either version 3 of the License, or (at your option) any later           *
 * version.                                                                             *
 *                                                                                      *
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY      *
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A      *
 * PARTICULAR PURPOSE. See the GNU General Public License for more details.             *
 *                                                                                      *
 * You should have received a copy of the GNU General Public License along with         *
 * this program.  If not, see <http://www.gnu.org/licenses/>.                           *
 ****************************************************************************************/

import QtQuick 1.1
import com.nokia.meego 1.0
import org.nemomobile.social 1.0
import "../UiConstants.js" as Ui
import "../pagemanagement.js" as PageManagement
import "../components"

AbstractFacebookPage {
    id: container

    tools: ToolBarLayout {
        ToolIcon {
            iconId: "toolbar-back"
            onClicked: {
                PageManagement.pop()
            }
        }
    }

    function load()  {
        _facebook_.nodeIdentifier = ME.identifier
        _facebook_.filters = [_friendsFilter_]
        //_facebook_.sorters = [_nameSorter_]
        _facebook_.populate()
    }

//    function loadPop() {
//        console.debug(listView.previousTopIndex)
//        console.debug(listView.count)
//        listView.positionViewAtEnd()
//        listView.positionViewAtIndex(listView.previousTopIndex, ListView.Beginning)
//        listView.contentY = listView.previousY

//    }

//    Connections {
//        target: _facebook_
//        onNodeChanged : {
//            console.debug(listView.previousTopIndex)
//            listView.positionViewAtIndex(listView.previousTopIndex, ListView.Contain)
//            console.debug("changed")
//        }
//    }

//        onStatusChanged: {
//    onUpdateWhilePopped: {
//            console.debug(container.beingPopped)
//        if (_facebook_.status == Facebook.Idle && container.beingPopped) {
//        }
//    }
//    }

    Item {
        anchors.fill: parent

        Cover {
            id: cover
            name: ME.name
            category: qsTr("Friends")
            coverUrl: ME.coverUrl
        }

        ListView {
            id: listView
            property double opacityValue: 0
            property double previousTopIndex: 0
            onCountChanged: {
                positionViewAtIndex(previousTopIndex, ListView.Beginning)
            }

            anchors.top: cover.bottom; anchors.bottom: parent.bottom
            anchors.left: parent.left; anchors.right: parent.right
            highlightFollowsCurrentItem: true
            clip: true
            model: _facebook_
            delegate: FriendEntry {
                identifier: model.contentItem.identifier
                name: model.contentItem.name
                opacity: listView.opacityValue
                onClicked: {
                    PageManagement.addPage("UserPage", {identifier: model.contentItem.identifier,
                                                        name: model.contentItem.name})
                    listView.previousTopIndex = listView.indexAt(listView.width / 2,
                                                                 listView.contentY)
                }
            }
            section.property: "section"
            section.criteria : ViewSection.FirstCharacter
            section.delegate: GroupIndicator {
                text: section
                opacity: listView.opacityValue
            }

            ScrollDecorator {flickableItem: parent}
            cacheBuffer: Ui.LIST_ITEM_HEIGHT_DEFAULT * 5
            states: [
                State {
                    name: "loaded"; when: !container.loading
                    PropertyChanges {
                        target: listView
                        opacityValue: 1
                    }
                }
            ]

            Behavior on opacityValue {
                NumberAnimation { duration: Ui.ANIMATION_DURATION_FAST }
            }

            LoadingMessage {loading: container.loading}

            EmptyStateLabel {
                visible: !container.loading && _facebook_.count == 0
                text: qsTr("No friends")
            }
        }
    }
}
