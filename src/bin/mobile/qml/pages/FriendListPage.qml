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
                PageManagement.pop(true, false, true)
            }
        }
    }

    onStateChanged: {
        if (state == "push_in") {
            _facebook_.nodeIdentifier = ME.identifier
            _facebook_.filters = [_friendsFilter_]
            _facebook_.sorters = [_nameSorter_]
            _facebook_.populate()
            _facebook_.nextNode()
        } else if (state == "pop_in") {
            _facebook_.sorters = [_nameSorter_]
        }
    }

    Item {
        anchors.fill: parent

        Cover {
            id: cover
            name: ME.name
            category: qsTr("Friends")
            coverUrl: ME.coverUrl
        }

        ListView {
            id: view
            property double opacityValue: 0
            property double previousTopIndex: 0
            onCountChanged: {
                positionViewAtIndex(previousTopIndex, view.Beginning)
            }

            anchors.top: cover.bottom; anchors.bottom: parent.bottom
            anchors.left: parent.left; anchors.right: parent.right
            highlightFollowsCurrentItem: true
            clip: true
            model: container.available ? _facebook_ : null
            delegate: FriendEntry {
                identifier: model.contentItem.identifier
                name: model.contentItem.name
                opacity: view.opacityValue
                onClicked: {
                    PageManagement.addPage("UserPage.qml",
                                           {identifier: model.contentItem.identifier,
                                            name: model.contentItem.name}, true, true)
                    view.previousTopIndex = view.indexAt(view.width / 2, view.contentY)
                }
            }
            section.property: "section"
            section.criteria : ViewSection.FirstCharacter
            section.delegate: GroupIndicator {
                text: section
                opacity: view.opacityValue
            }

            ScrollDecorator {flickableItem: parent}
            cacheBuffer: Ui.LIST_ITEM_HEIGHT_DEFAULT * 5
            states: [
                State {
                    name: "loaded"; when: !container.loading
                    PropertyChanges {
                        target: view
                        opacityValue: 1
                    }
                }
            ]

            Behavior on opacityValue {
                NumberAnimation { duration: Ui.ANIMATION_DURATION_FAST }
            }

            LoadingMessage {loading: container.loading}

            EmptyStateLabel {
                visible: !container.loading && container.available && view.model.count == 0
                text: qsTr("No friends")
            }
        }
    }
}
