import QtQuick 2.0
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0

Dial {
    id: control

    property var color: '#ffbb4dff' //Argb
    value: 0;
    from: -90
    to: 90

    background: Rectangle {
        id:backgroundItem
        x: control.width / 2 - width / 2
        y: control.height / 2 - height / 2
        width: Math.max(64, Math.min(control.width, control.height))
        height: width
        color: 'transparent'
        radius: width / 2
        border.color: control.hovered? Qt.lighter(control.color,1.1):
                                       control.pressed ? Qt.darker(control.color,1.1) : control.color
        opacity: control.enabled ? 1 : 0.3

        Rectangle {
            height: control.width/20
            width: height/3
            radius: width/2

            color: 'white'
            border.color: control.color

            anchors{
                top: backgroundItem.top
                topMargin: -height/2
                horizontalCenter: backgroundItem.horizontalCenter
            }
        }
    }

    handle: CustomDialHandle {
        id: handleItem

        width: backgroundItem.width - 50
        height: width
        anchors.centerIn: backgroundItem

        color: control.hovered? Qt.lighter(control.color,1.1):
                                control.pressed ? Qt.darker(control.color,1.1) : Qt.lighter(control.color,1)
        opacity: control.enabled ? 1 : 0.3
        transform:
            Rotation {
            angle: control.angle*1.07
            origin.x: handleItem.width / 2
            origin.y: handleItem.height / 2
        }
    }

    //onAngleChanged: console.log(angle)
}
