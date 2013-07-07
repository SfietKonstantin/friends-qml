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
    id: window
    initialPage: mainPage

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
            facebook.accessToken = TOKEN_MANAGER.token
        }
    }

    Connections {
        target: LOGIN_MANAGER
        onLoginSucceeded: {
            facebook.accessToken = token
            TOKEN_MANAGER.token = token
            loginSheet.close()
        }
    }

    Facebook {
        id: facebook

//        onStatusChanged: console.debug("Current status: " + status + ", node: " + node)
//        onErrorChanged: console.debug("Current error: " + error)
//        onErrorMessageChanged: console.debug("Current error message: " + errorMessage)

        onAccessTokenChanged: {
            if (accessToken != "") {
                initialInfoModel.getInitialInfo()
            }
        }
    }

    AlphabeticalSorter {id: nameSorter; field: "name" }
    ContentItemTypeFilter {id: feedFilter; type: Facebook.Post}
    ContentItemTypeFilter {id: friendsFilter; type: Facebook.User}
    ContentItemTypeFilter {id: albumsFilter; type: Facebook.Album}
    ContentItemTypeFilter {id: photosFilter; type: Facebook.Photo; limit: 21}

    StoryDataFilter {id: storyDataFilter}

    QFBImageLoader {
        id: imageLoader
    }

    SocialNetworkModel {
        id: initialInfoModel
        socialNetwork: facebook
        property bool loading: false
        function getInitialInfo() {
            console.debug("getting intial info")
            loading = true
            nodeIdentifier = "me"
            populate()
        }
        function setCover() {
            ME.coverUrl = node.cover.source
            loading = false
        }
        onStatusChanged: {
            if (loading && node != null) {
                ME.identifier = node.identifier
                ME.name = node.name
                node.coverChanged.connect(setCover)
                node.reload("cover")
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

//    Connections {
//        target: _facebook_
//        onStatusChanged: {
//            if (_facebook_.status == SocialNetwork.Error) {
//                if (ME.identifier == "") {
//                    _facebook_.popNode()
//                    LOGIN_MANAGER.login()
//                    loginSheet.open()
//                    return
//                }
//                errorBanner.parent = _window_.pageStack.currentPage
//                errorBanner.show()
//            }
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

    InfoBanner {
        id: errorBanner
        text: qsTr("Session expired. Please restart Friends and login again")
    }
}
