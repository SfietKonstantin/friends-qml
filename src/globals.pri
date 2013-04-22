# name
NAME = qfb

# version
VERSION_MAJOR = 0
VERSION_MINOR = 0
VERSION_PATCH = 6

# Default directories
isEmpty(BINDIR) {
    BINDIR = /bin
}
isEmpty(SHAREDIR) {
    SHAREDIR = /share/$${NAME}
}
isEmpty(OPTDIR) {
    OPTDIR = /opt/$${NAME}
}
# QML plugins
PLUGIN_IMPORT_PATH = org/SfietKonstantin/qfb


# Useful defines
DEFINES += 'VERSION_MAJOR=$${VERSION_MAJOR}'
DEFINES += 'VERSION_MINOR=$${VERSION_MINOR}'
DEFINES += 'VERSION_PATCH=$${VERSION_PATCH}'
