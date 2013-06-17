import QtQuick 1.1

QtObject {
    id: container
    property bool available
    property ListView view
    property int previousTopIndex: -1
    property int previousContentY: -1
    property int mode

    onViewChanged: bind()

    function bind() {
        view.countChanged.connect(container.setPosition)
        view.contentYChanged.connect(container.getPosition)
    }

    function setPosition() {
        if (container.running) {
            return
        }

        if (!container.available) {
            return
        }

        if (container.previousTopIndex != -1) {
            view.positionViewAtIndex(container.previousTopIndex, container.mode)
            view.contentY = container.previousContentY
        }
    }

    function getPosition() {
        if (!container.available) {
            return
        }

        var topIndex = view.indexAt(view.width / 2, view.contentY)
        if (topIndex != -1) {
            container.previousTopIndex = topIndex
            container.previousContentY = view.contentY
        }
    }
}
