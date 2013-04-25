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

Page {
    id: container
    tools: ToolBarLayout {
        ToolIcon {
            iconId: "toolbar-back"
            onClicked: {
                PageManagement.pop()
            }
        }
    }

    function load() {
        if (_facebook_.nodeIdentifier != 0 && _facebook_.count != 0) {
            return
        }

        _facebook_.nodeIdentifier = ME.identifier
        _facebook_.filters = [_friendsFilter_]
        _facebook_.sorters = [_nameSorter_]
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
            id: listView
            property double opacityValue: 0
            anchors.top: cover.bottom; anchors.bottom: parent.bottom
            anchors.left: parent.left; anchors.right: parent.right
            clip: true
            model: _facebook_
            delegate: FriendEntry {
                identifier: model.contentItem.identifier
                name: model.contentItem.name
                opacity: listView.opacityValue
                onClicked: PageManagement.addPage("UserPage",
                                                  {identifier: model.contentItem.identifier,
                                                   name: model.contentItem.name})
            }
            section.property: "section"
            section.criteria : ViewSection.FirstCharacter
            section.delegate: GroupIndicator {
                text: section
            }

            ScrollDecorator {flickableItem: parent}
            cacheBuffer: Ui.LIST_ITEM_HEIGHT_DEFAULT * 5
            states: [
                State {
                    name: "loaded"; when: _facebook_.status == Facebook.Idle
                    PropertyChanges {
                        target: listView
                        opacityValue: 1
                    }
                }
            ]

            Behavior on opacityValue {
                NumberAnimation { duration: Ui.ANIMATION_DURATION_FAST }
            }

            LoadingMessage {loading: _facebook_.status == Facebook.Busy}

            EmptyStateLabel {
                visible: _facebook_.status == Facebook.Idle && _facebook_.count == 0
                text: qsTr("No friends")
            }
        }
    }
}
