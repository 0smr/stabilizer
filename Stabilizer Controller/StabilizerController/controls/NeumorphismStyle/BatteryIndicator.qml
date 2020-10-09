import QtQuick 2.0

Rectangle {

    property real xRadius: 0
    property real yRadius: 0
    property real angle: 0
    property real rad: 0
    property bool cell: false
    property bool hide: false

    x: rad * Math.cos(angle) + cx - width / 2
    y: rad * Math.sin(angle) + cy - width / 2
    width: 6
    height: width
    radius: width/2
    color: cell ? border.color : 'Transparent'
    border.color: 'grey'
    opacity: hide ? 0 :
                    enabled ?
                        1 :  0.1

    Behavior on opacity {
        NumberAnimation { duration: 600 }
    }
}
