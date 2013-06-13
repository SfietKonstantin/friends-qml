TEMPLATE = subdirs
contains(CONFIG, mobile): SUBDIRS = mobile
contains(CONFIG, sailfish): SUBDIRS = sailfish
