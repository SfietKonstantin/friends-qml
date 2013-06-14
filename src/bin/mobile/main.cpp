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

#include "qplatformdefs.h"
#include <QtGui/QApplication>
#include <QtDeclarative/qdeclarative.h>
#include <QtDeclarative/QDeclarativeContext>
#include <QtDeclarative/QDeclarativeEngine>
#include <QtDeclarative/QDeclarativeView>

#include "userinfohelper.h"
//#include "posthelper.h"
//#include "mobilepostvalidator.h"
//#include "querymanager.h"
#include "loginmanager.h"
#include "../shared/tokenmanager.h"
#include "networkaccessmanagerfactory.h"
#include "../shared/me.h"
#include "pagepixmapprovider.h"
//#include "backpixmapitem.h"
//#include "postupdaterelay.h"

// Friends specific
#include "clientidinterface.h"
#include <QtCore/QPluginLoader>
#include <QtCore/QDebug>
// End Friends specific
#include <QtOpenGL/QGLFormat>
#include <QtOpenGL/QGLWidget>

static const char *FACEBOOK_PAGE = "https://m.facebook.com/friendsforn9";
static const char *PAYPAL_DONATE = "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&\
hosted_button_id=RZ2A2ZB93827Y";

int main(int argc, char **argv)
{
    QApplication app (argc, argv);
    app.setOrganizationName("SfietKonstantin");
    app.setApplicationName("qfb-mobile");

//    QFB::QueryManager queryManager;
    QFB::LoginManager loginManager;
    TokenManager tokenManager;
    Me me;
//    PostUpdateRelay postUpdateRelay;

    qmlRegisterType<UserInfoHelper>("org.SfietKonstantin.qfb.mobile", 4, 0, "QFBUserInfoHelper");
//    qmlRegisterType<BackPixmapItem>("org.SfietKonstantin.qfb.mobile", 4, 0,
//                                    "QFBBackPixmapItem");
//    qmlRegisterType<PostHelper>("org.SfietKonstantin.qfb.mobile", 4, 0, "QFBPostHelper");
//    qmlRegisterType<MobilePostValidator>("org.SfietKonstantin.qfb.mobile", 4, 0,
//                                         "QFBMobilePostValidator");

    QDeclarativeView view;
#ifdef MEEGO_EDITION_HARMATTAN
    QGLFormat format = QGLFormat::defaultFormat();
    format.setSampleBuffers(false);
    format.setSwapInterval(1);
    QGLWidget* glWidget = new QGLWidget(format);
    glWidget->setAutoFillBackground(false);
    view.setViewport(glWidget);
    PagePixmapProvider *pagePixmapProvider = new PagePixmapProvider(glWidget);
#else
    PagePixmapProvider *pagePixmapProvider = new PagePixmapProvider(&view);
#endif

#ifndef MEEGO_EDITION_HARMATTAN
    view.engine()->addImportPath(IMPORT_PATH);
#endif
    view.engine()->addImageProvider("pagepixmapprovider", pagePixmapProvider);
    view.engine()->setNetworkAccessManagerFactory(new NetworkAccessManagerFactory());
//    view.rootContext()->setContextProperty("QUERY_MANAGER", &queryManager);
    view.rootContext()->setContextProperty("LOGIN_MANAGER", &loginManager);
    view.rootContext()->setContextProperty("TOKEN_MANAGER", &tokenManager);
//    view.rootContext()->setContextProperty("POST_UPDATE_RELAY", &postUpdateRelay);
    view.rootContext()->setContextProperty("ME", &me);
    view.rootContext()->setContextProperty("DATA_PATH", DATA_PATH);
    view.rootContext()->setContextProperty("FACEBOOK_PAGE", FACEBOOK_PAGE);
    view.rootContext()->setContextProperty("PAYPAL_DONATE", PAYPAL_DONATE);
    view.rootContext()->setContextProperty("VERSION_MAJOR", QString::number(VERSION_MAJOR));
    view.rootContext()->setContextProperty("VERSION_MINOR", QString::number(VERSION_MINOR));
    view.rootContext()->setContextProperty("VERSION_PATCH", QString::number(VERSION_PATCH));

    // Friends specific
    QString clientId;
    QPluginLoader pluginLoader (CLIENT_ID_PLUGIN);
    if (pluginLoader.load()) {
        QObject *plugin = pluginLoader.instance();
        Interface *castedPlugin = qobject_cast<Interface *>(plugin);
        if (castedPlugin) {
            clientId = castedPlugin->clientId();
            qDebug() << "Client id loaded";
        }
    }

    if (clientId.isEmpty()) {
        if (app.arguments().count() == 2) {
            clientId = app.arguments().at(1);
        } else {
            qDebug() << "Failed to find the client id";
            return -1;
        }
    }
    view.rootContext()->setContextProperty("CLIENT_ID", clientId);
    // End Friends specific

    view.setSource(QUrl(MAIN_QML_FILE));
    view.showFullScreen();
    QObject::connect(view.engine(), SIGNAL(quit()), &app, SLOT(quit()));

    return app.exec();
}
