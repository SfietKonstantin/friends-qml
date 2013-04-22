include(../../globals.pri)

TEMPLATE = lib
VERSION = $${VERSION_MAJOR}.$${VERSION_MINOR}.$${VERSION_PATCH}

TARGET = $${NAME}login

QT = core

DEFINES += QFBLOGIN_LIBRARY

HEADERS +=  login_global.h \
            loginmanager.h \
            cookiejar.h
SOURCES +=  loginmanager.cpp \
            cookiejar.cpp



# Deployment
target.path = $$[QT_INSTALL_LIBS]

headers.path = $$[QT_INSTALL_HEADERS]/login
headers.files = $${HEADERS}

INSTALLS += target
contains(CONFIG, dev): INSTALLS += headers
