include(../../globals.pri)

TEMPLATE = app
TARGET = $${NAME}-sailfish

QT += core gui declarative

INCLUDEPATH += ../../lib/login
LIBS += -L../../lib/login -l$${NAME}login

DEFINES += 'IMPORT_PATH=\'\"$${IMPORTSDIR}"\''

HEADERS += sailfishapplication.h \
            ../shared/tokenmanager.h \
            ../shared/me.h

SOURCES += main.cpp \
            sailfishapplication.cpp \
            ../shared/tokenmanager.cpp \
            ../shared/me.cpp

OTHER_FILES += main.qml \
                UiConstants.js \
                AbstractFacebookPage.qml \
                LoginPage.qml \
                MainPage.qml \
                FacebookCover.qml \
                FacebookImage.qml \
                AboutPage.qml \
                DevelopersPage.qml \
                FriendsPage.qml

OTHER_FILES +=  ../shared/data/friends.png \
                ../shared/data/sfiet_konstantin.jpg \
                ../shared/data/aniket.jpg \
                ../shared/data/w00t.jpg \
                ../shared/data/zchydem.jpg \

target.path = $${BINDIR}

qml.path = $${SHAREDIR}
qml.files = $${OTHER_FILES}

INSTALLS += target qml

DEFINES += DEPLOYMENT_PATH=\"\\\"\"$${SHAREDIR}/\"\\\"\"
DEFINES += 'DATA_PATH=\'\"$${SHAREDIR}/\"\''

CONFIG += link_pkgconfig
packagesExist(qdeclarative-boostable) {
    message("Building with qdeclarative-boostable support")
    DEFINES += HAS_BOOSTER
    PKGCONFIG += qdeclarative-boostable
} else {
    warning("qdeclarative-boostable not available; startup times will be slower")
}
