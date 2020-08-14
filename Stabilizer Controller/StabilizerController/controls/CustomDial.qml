import QtQuick 2.0
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0

Dial {
    id: control

    property var color: "red"

    background: Rectangle {
        x: control.width / 2 - width / 2
        y: control.height / 2 - height / 2
        width: Math.max(64, Math.min(control.width, control.height))
        height: width
        color: "transparent"
        radius: width / 2
        border.color: control.pressed ? Qt.darker(control.color,1.1) : control.color
        opacity: control.enabled ? 1 : 0.3
    }

    handle: Rectangle {
        id: handleItem
        x: control.background.x + control.background.width / 2 - width / 2
        y: control.background.y + control.background.height / 2 - height / 2
        width: 2
        height: 16
        color: control.pressed ? Qt.darker(control.color,1.1) : control.color
        radius: 1
        antialiasing: true
        opacity: control.enabled ? 1 : 0.3
        transform: [
            Translate {
                y: -Math.min(control.background.width, control.background.height) * 0.4 + handleItem.height / 2
            },
            Rotation {
                angle: control.angle*1.07
                origin.x: handleItem.width / 2
                origin.y: handleItem.height / 2
            }
        ]
    }

    onAngleChanged: console.log(angle)
}
