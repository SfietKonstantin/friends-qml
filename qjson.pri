INCLUDEPATH += $$PWD/qjson/src/
INCLUDE_HEADERS +=  $$PWD/qjson/src/parser.h \
                    $$PWD/qjson/src/qobjecthelper.h \
                    $$PWD/qjson/src/parserrunnable.h \
                    $$PWD/qjson/src/serializer.h \
                    $$PWD/qjson/src/serializerrunnable.h

HEADERS +=  $${INCLUDE_HEADERS} \
            $$PWD/qjson/src/json_parser.hh \
            $$PWD/qjson/src/location.hh \
            $$PWD/qjson/src/position.hh \
            $$PWD/qjson/src/stack.hh \
            $$PWD/qjson/src/json_scanner.h \

SOURCES +=  $$PWD/qjson/src/parser.cpp \
            $$PWD/qjson/src/qobjecthelper.cpp \
            $$PWD/qjson/src/json_scanner.cpp \
            $$PWD/qjson/src/json_parser.cc \
            $$PWD/qjson/src/parserrunnable.cpp \
            $$PWD/qjson/src/serializer.cpp \
            $$PWD/qjson/src/serializerrunnable.cpp
