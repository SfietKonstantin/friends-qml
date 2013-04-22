include(../../globals.pri)

TEMPLATE =      lib
TARGET =        $${NAME}imageloaderplugin
QT =            core gui
isEqual(QT_MAJOR_VERSION, 4): QT += declarative
isEqual(QT_MAJOR_VERSION, 5): QT += qml

CONFIG +=       qt plugin hide_symbols

isEqual(QT_MAJOR_VERSION, 4): HEADERS += imageloader_plugin4.h
isEqual(QT_MAJOR_VERSION, 5): HEADERS += imageloader_plugin5.h

HEADERS +=      cachehelper_p.h \
                imageloader.h
SOURCES +=      imageloader_plugin.cpp \
                imageloader.cpp

OTHER_FILES =   qmldir

# Path for QML files
qmlFiles.path = $${IMPORTSDIR}/$$PLUGIN_IMPORT_PATH/imageloader
qmlFiles.files = $${OTHER_FILES}
export(qmlFiles.path)
export(qmlFiles.files)

# Path for target
target.path = $${IMPORTSDIR}/$$PLUGIN_IMPORT_PATH/imageloader
export(target.path)

# Installs
INSTALLS += target qmlFiles



