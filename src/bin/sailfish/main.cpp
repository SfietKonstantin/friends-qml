
#include <QtGui/QApplication>
#include <QtDeclarative/QDeclarativeView>
#include <QtDeclarative/QDeclarativeContext>
#include <QtDeclarative/QDeclarativeEngine>
#include <QtDeclarative/qdeclarative.h>

#include "sailfishapplication.h"
#include "../shared/tokenmanager.h"
#include "../shared/me.h"
#include "loginmanager.h"

static const char *FACEBOOK_PAGE = "https://m.facebook.com/friendsforn9";
static const char *PAYPAL_DONATE = "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&\
hosted_button_id=RZ2A2ZB93827Y";

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(Sailfish::createApplication(argc, argv));
    app.data()->setApplicationName("Friends");
    app.data()->setOrganizationName("SfietKonstantin");
    TokenManager tokenManager;
    Me me;
    QFB::LoginManager loginManager;
    QString clientId;
    if (app.data()->arguments().count() == 2) {
        clientId = app.data()->arguments().at(1);
    }
    QScopedPointer<QDeclarativeView> view(Sailfish::createUninitializedView());
    view.data()->engine()->addImportPath(IMPORT_PATH);
    view.data()->rootContext()->setContextProperty("LOGIN_MANAGER", &loginManager);
    view.data()->rootContext()->setContextProperty("TOKEN_MANAGER", &tokenManager);
    view.data()->rootContext()->setContextProperty("ME", &me);
    view.data()->rootContext()->setContextProperty("DATA_PATH", DATA_PATH);
    view.data()->rootContext()->setContextProperty("FACEBOOK_PAGE", FACEBOOK_PAGE);
    view.data()->rootContext()->setContextProperty("PAYPAL_DONATE", PAYPAL_DONATE);
    view.data()->rootContext()->setContextProperty("VERSION_MAJOR", QString::number(VERSION_MAJOR));
    view.data()->rootContext()->setContextProperty("VERSION_MINOR", QString::number(VERSION_MINOR));
    view.data()->rootContext()->setContextProperty("VERSION_PATCH", QString::number(VERSION_PATCH));
    if (!clientId.isEmpty()) {
        view.data()->rootContext()->setContextProperty("CLIENT_ID", clientId);
    }
    Sailfish::initializeView(view.data(), "main.qml");
    Sailfish::showView(view.data());

    return app->exec();
}


