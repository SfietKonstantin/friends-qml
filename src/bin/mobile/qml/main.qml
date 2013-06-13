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
import QtWebKit 1.0
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import org.nemomobile.social 1.0
import org.SfietKonstantin.qfb.login 4.0
import org.SfietKonstantin.qfb.imageloader 4.0
import "pages"
import "dialogs"
import "pagemanagement.js" as PageManagement

PageStackWindow {
    id: _window_
    initialPage: mainPage
//    property bool popping: false

    Connections {
        target: _window_.pageStack
//        onBusyChanged: {
//            if (!_window_.pageStack.busy) {
//                if (_window_.popping) {
//                    _window_.popping = false
//                    _facebook_.previousNode()
//                }
//            }
//        }
    }

    Component.onCompleted: {
        LOGIN_MANAGER.clientId = CLIENT_ID
        LOGIN_MANAGER.uiType = QFBLoginManager.Mobile
        LOGIN_MANAGER.friendsPermissions = QFBLoginManager.FriendsAboutMe
                                         + QFBLoginManager.FriendsActivities
                                         + QFBLoginManager.FriendsBirthday
                                         + QFBLoginManager.FriendsEducationHistory
                                         + QFBLoginManager.FriendsEvents
                                         + QFBLoginManager.FriendsGroups
                                         + QFBLoginManager.FriendsHometowm
                                         + QFBLoginManager.FriendsInterests
                                         + QFBLoginManager.FriendsLikes
                                         + QFBLoginManager.FriendsLocation
                                         + QFBLoginManager.FriendsNotes
                                         + QFBLoginManager.FriendsPhotos
                                         + QFBLoginManager.FriendsQuestions
                                         + QFBLoginManager.FriendsRelationships
                                         + QFBLoginManager.FriendsRelationshipDetails
                                         + QFBLoginManager.FriendsReligionPolitics
                                         + QFBLoginManager.FriendsStatus
                                         + QFBLoginManager.FriendsSubscriptions
                                         + QFBLoginManager.FriendsVideos
                                         + QFBLoginManager.FriendsWebsite
                                         + QFBLoginManager.FriendsWorkHistory
        LOGIN_MANAGER.userPermissions = QFBLoginManager.UserAboutMe
                                       + QFBLoginManager.UserActivities
                                       + QFBLoginManager.UserBirthday
                                       + QFBLoginManager.UserEducationHistory
                                       + QFBLoginManager.UserEvents
                                       + QFBLoginManager.UserGroups
                                       + QFBLoginManager.UserHometown
                                       + QFBLoginManager.UserInterests
                                       + QFBLoginManager.UserLikes
                                       + QFBLoginManager.UserLocation
                                       + QFBLoginManager.UserNotes
                                       + QFBLoginManager.UserPhotos
                                       + QFBLoginManager.UserQuestions
                                       + QFBLoginManager.UserRelationships
                                       + QFBLoginManager.UserRelationshipDetails
                                       + QFBLoginManager.UserReligionPolitics
                                       + QFBLoginManager.UserStatus
                                       + QFBLoginManager.UserSubscriptions
                                       + QFBLoginManager.UserVideos
                                       + QFBLoginManager.UserWebsite
                                       + QFBLoginManager.UserWorkHistory
                                       + QFBLoginManager.Email
        LOGIN_MANAGER.extendedPermissions = QFBLoginManager.ReadFriendList
                                          + QFBLoginManager.ReadInsights
                                          + QFBLoginManager.ReadMailbox
                                          + QFBLoginManager.ReadRequests
                                          + QFBLoginManager.ReadStream
                                          + QFBLoginManager.XmppLogin
                                          + QFBLoginManager.AdsManagement
                                          + QFBLoginManager.CreateEvent
                                          + QFBLoginManager.ManageFriendList
                                          + QFBLoginManager.ManageNotifications
                                          + QFBLoginManager.UserOnlinePresence
                                          + QFBLoginManager.FriendsOnlinePresence
                                          + QFBLoginManager.PublishCheckins
                                          + QFBLoginManager.PublishStream
                                          + QFBLoginManager.RsvpEvent
        if (TOKEN_MANAGER.token == "") {
            loginSheet.open()
            LOGIN_MANAGER.login()
        } else {
            _facebook_.accessToken = TOKEN_MANAGER.token
        }
    }

    Connections {
        target: LOGIN_MANAGER
        onLoginSucceeded: {
            _facebook_.accessToken = token
            TOKEN_MANAGER.token = token
            loginSheet.close()
        }
    }

    Facebook {
        id: _facebook_
        onAccessTokenChanged: {
            if (accessToken != "") {
                initialInfoLoader.getInitialInfo()
            }
        }
    }

    //NameSorter {id: _nameSorter_ }
    ContentItemTypeFilter {id: _friendsFilter_; type: Facebook.User}
    ContentItemTypeFilter {id: _albumsFilter_; type: Facebook.Album}
    ContentItemTypeFilter {id: _photosFilter_; type: Facebook.Photo}

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

//    Connections {
//        target: _facebook_
//        onNodeChanged: {
//            if (_facebook_.node.type == Facebook.User) {
//                if (initialInfoLoader.loading) {
//                    if (ME.name == "") {
//                        ME.identifier = _facebook_.node.identifier
//                        ME.name = _facebook_.node.name
//                        _facebook_.node.coverChanged.connect(initialInfoLoader.setCover)
//                        _facebook_.node.reload("cover")
//                    }
//                }
//            }
//        }
//    }
//    QFBTypeLoader {
//        id: _type_resolver_
//        queryManager: QUERY_MANAGER
//        property string resolvedName
//        onLoaded: {
//            var facebookId = _type_resolver_.object.facebookId
//            var type = _type_resolver_.object.objectType
//            switch (type) {
//            case QFBObject.UserType:
//                PageManagement.addPage("pages/UserPage", {"facebookId": facebookId,
//                                                          "name": resolvedName})
//                break
//            case QFBObject.GroupType:
//                PageManagement.addPage("pages/GroupPage", {"facebookId": facebookId,
//                                                          "name": resolvedName})
//                break
//            default:
//                unsupportedInfoBanner.parent = _window_.pageStack.currentPage
//                unsupportedInfoBanner.show()
//                break
//            }
//            resolvedName = ""
//        }
//    }

    LoginSheet {
        id: loginSheet
        onRejected: Qt.quit()
    }

//    FeedDialogSheet {
//        id: _feed_dialog_
//        onAccepted: window.pageStack.currentPage.load()
//    }

    MainPage {
        id: mainPage
    }

    InfoBanner {
        id: unsupportedInfoBanner
        text: qsTr("Loading this page is not supported yet")
    }

    InfoBanner {
        id: _launching_web_browser_info_banner_
        text: qsTr("Launching web browser")
    }
}
