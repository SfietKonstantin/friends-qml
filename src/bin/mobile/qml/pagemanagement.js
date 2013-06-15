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

function simplePop() {
    _window_.pageStack.pop()
}

function simpleAddPage(name, properties) {
    _window_.pageStack.push(Qt.resolvedUrl(name + ".qml"), properties)
}

function simpleAddPageAndLoad(name, properties) {
    var page = _window_.pageStack.push(Qt.resolvedUrl(name + ".qml"), properties)
    page.load()
}

function pop() {
    var oldPage = _window_.pageStack.pop()
    var currentPage = _window_.pageStack.currentPage

//    console.debug("Current page: " + currentPage.identifier
//                  + " old page: " + oldPage.identifier)
//    if (currentPage.identifier != oldPage.identifier && currentPage.identifier != null) {
//        _facebook_.previousNode()
//    }
    currentPage.beingPopped = true
//    currentPage.loadPop()
    //_window_.state = "popping"
    //_facebook_.previousNode()
    oldPage.displayPixmap()
//    _window_.popping = true
    _facebook_.previousNode()


}

function addPage(name, properties) {
    //_window_.state = "pushing"
    var newPage = _window_.pageStack.push(Qt.resolvedUrl(name + ".qml"), properties)
    newPage.load()
    newPage.beingPushed = true
    //_facebook_.nextNode()
}

function showPhotoViewer(index) {
    var newPage = _window_.pageStack.push(Qt.resolvedUrl("PhotoViewerPage.qml"))
    newPage.setPosition(index)
}

//function showFeedDialog(facebookId) {
//    _feed_dialog_.to = facebookId
//    _feed_dialog_.showDialog()
//}

//function resolveType(facebookId, name) {
//    _type_resolver_.resolvedName = name
//    _type_resolver_.request(facebookId)
//}

function openWebBrowser(url) {
    Qt.openUrlExternally(url)
    _launching_web_browser_info_banner_.parent = _window_.pageStack.currentPage
    _launching_web_browser_info_banner_.show()
}
