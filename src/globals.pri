# name
NAME = qfb

# version
VERSION_MAJOR = 0
VERSION_MINOR = 0
VERSION_PATCH = 6

!isEmpty(DEPLOYMENT_PREFIX) {
    PREFIX=$${DEPLOYMENT_PREFIX}
}

isEmpty(PREFIX) {
    PREFIX=/usr/
}

# Default directories
isEmpty(BINDIR) {
    BINDIR = $${PREFIX}/bin
}
isEmpty(LIBDIR) {
    LIBDIR = $${PREFIX}/lib
}
isEmpty(INCLUDEDIR) {
    INCLUDEDIR = $${PREFIX}/include
}
isEmpty(SHAREDIR) {
    SHAREDIR = $${PREFIX}/share/$${NAME}
}
isEmpty(OPTDIR) {
    OPTDIR = $${DEPLOYMENT_PREFIX}/opt/$${NAME}
}
isEmpty(IMPORTSDIR) {
    IMPORTSDIR = $${PREFIX}/lib/qt4/imports
}
# QML plugins
PLUGIN_IMPORT_PATH = org/SfietKonstantin/qfb


# Useful defines
DEFINES += 'VERSION_MAJOR=$${VERSION_MAJOR}'
DEFINES += 'VERSION_MINOR=$${VERSION_MINOR}'
DEFINES += 'VERSION_PATCH=$${VERSION_PATCH}'
