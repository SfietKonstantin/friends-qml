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
            onClicked: window.pageStack.pop()
        }
    }

    function load() {
        model.populate()
    }

    SocialNetworkModel {
        id: model
        socialNetwork: facebook
        nodeIdentifier: ME.identifier
        filters: [friendsFilter]
        sorters: [nameSorter]
    }

    Cover {
        id: cover
        name: ME.name
        category: qsTr("Friends")
        coverUrl: ME.coverUrl
    }

    ListView {
        id: view
        anchors.top: cover.bottom; anchors.bottom: parent.bottom
        anchors.left: parent.left; anchors.right: parent.right
        clip: true
        model: model
        delegate: FriendEntry {
            identifier: model.contentItem.identifier
            name: model.contentItem.name
            onClicked: {
                PageManagement.addPage("UserPage.qml",
                                       {identifier: model.contentItem.identifier,
                                        name: model.contentItem.name}, true)
            }
        }
        cacheBuffer: Ui.LIST_ITEM_HEIGHT_DEFAULT * 5
        section.property: "section"
        section.criteria : ViewSection.FirstCharacter
        section.delegate: GroupIndicator {
            text: section
        }

        ScrollDecorator {flickableItem: parent}

        LoadingMessage {
            loading: model.status != SocialNetwork.Idle
        }

        EmptyStateLabel {
            visible: model.status == SocialNetwork.Idle && model.count == 0
            text: qsTr("No friends")
        }
    }
}
