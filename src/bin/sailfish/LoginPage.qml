import QtQuick 1.1
import Sailfish.Silica 1.0
import QtWebKit 1.0
import org.SfietKonstantin.qfb.login 4.0

Page {
    PageHeader {
        id: header
        title: qsTr("Login")
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
        LOGIN_MANAGER.login()
    }

    Flickable {
        anchors.top: header.bottom; anchors.left: parent.left; anchors.right: parent.right
        anchors.bottom: parent.bottom
        contentHeight: webView.height
        clip: true

        WebView {
            id: webView
            visible: webView.status == WebView.Ready
            width: parent.width
            preferredWidth: parent.width
            onUrlChanged: LOGIN_MANAGER.checkUrl(url)
        }
    }

    Connections {
        target: LOGIN_MANAGER
        onUrlRequested: webView.url = url
    }
}
