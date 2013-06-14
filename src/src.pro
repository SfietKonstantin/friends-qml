TEMPLATE = subdirs
SUBDIRS = lib imports bin

imports.depends = lib
bin.depends = lib imports
