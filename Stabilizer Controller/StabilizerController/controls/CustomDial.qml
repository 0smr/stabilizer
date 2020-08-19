import QtQuick 2.0
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0

Dial {
    id: control

    property var color: '#bb4dff'
    from: -90
    value: 0;
    to: 90

    background: Rectangle {
        id: backgroundItem
        x: control.width / 2 - width / 2
        y: control.height / 2 - height / 2
        width: Math.max(150, Math.min(control.width,control.height))
        color: 'transparent'
        height: width
        radius: width / 2
    }

    handle: CustomDialindicator {
        id: valueIndicator

        width: backgroundItem.width
        height: width
        anchors.centerIn: backgroundItem

        color: !enabled ? 'grey' :
                        control.pressed ? Qt.darker(control.color,1.2) :
                        control.hovered? Qt.lighter(control.color,1.1) : Qt.lighter(control.color,1)
        opacity: control.enabled ? 1 : 0.3
        angle: control.angle
    }

    Text {
        id: value
        anchors.centerIn: parent
        text: Math.floor(control.value)
        font.family: 'DS-Digital'
        font.pixelSize: backgroundItem.width/10
        color: valueIndicator.color
    }
}
