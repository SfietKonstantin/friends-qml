/****************************************************************************************
 * Copyright (C) 2012 Lucien XU <sfietkonstantin@free.fr>                               *
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
import "../composite"
import "../components"

AbstractFacebookPage {
    id: container
    property string identifier
    property string name
    property string coverUrl

    onStateChanged: {
        if (state == "push_in") {
            _facebook_.nodeIdentifier = container.identifier
            _facebook_.filters = [_albumsFilter_]
            _facebook_.sorters = []
            _facebook_.populate()
            _facebook_.nextNode()
        }
    }

    tools: ToolBarLayout {
        ToolIcon {
            iconId: "toolbar-back"
            onClicked: PageManagement.pop(true, true, true)
        }
    }


    Cover {
        id: cover
        name: container.name
        category: qsTr("Albums")
        coverUrl: container.coverUrl
    }


    Item {
        id: content
        anchors.top: cover.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left; anchors.right: parent.right

        ScrollDecorator { flickableItem: view }

        ListView {
            id: view
            anchors.fill: parent
            clip: true
            model: container.available ? _facebook_ : null
            spacing: Ui.MARGIN_DEFAULT

            header: Item {
                width: container.width
                height: Ui.MARGIN_DEFAULT
            }

            footer: Item {
                width: container.width
                height: Ui.MARGIN_DEFAULT
            }

            delegate: Item {
                width: container.width
                height: entry.height

                AlbumEntry {
                    id: entry
                    identifier: model.contentItem.identifier
                    name: model.contentItem.name
                    onClicked: PageManagement.addPage("PhotoListPage.qml",
                                                      {identifier: identifier, name: container.name,
                                                       coverUrl: container.coverUrl}, true, true)
                }
            }

            ViewPreviousTracker {
                view: view
                available: container.available
                mode: ListView.Beginning
            }
        }

        LoadingMessage {
            loading: container.loading
        }

        EmptyStateLabel {
            visible: !container.loading && container.available && view.model.count == 0
            text: qsTr("No albums")
        }
    }


}
