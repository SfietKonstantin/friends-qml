
#include <QtGui/QApplication>
#include <QtDeclarative/QDeclarativeView>
#include <QtDeclarative/QDeclarativeContext>
#include <QtDeclarative/QDeclarativeEngine>
#include <QtDeclarative/qdeclarative.h>

#include "sailfishapplication.h"
#include "../shared/tokenmanager.h"
#include "../shared/me.h"
#include "loginmanager.h"


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
    if (!clientId.isEmpty()) {
        view.data()->rootContext()->setContextProperty("CLIENT_ID", clientId);
    }
    Sailfish::initializeView(view.data(), "main.qml");
    Sailfish::showView(view.data());

    return app->exec();
}


