import QtQuick 2.0
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0

Dial {
    id: control

    property var color: '#bb4dff'
    property var explicitColor: !enabled ? 'grey' :
                       control.pressed ? Qt.darker(control.color,1.2) :
                       control.hovered? Qt.lighter(control.color,1.1) : Qt.lighter(control.color,1)
    property real startPoint: 0
    property real endPoint: 0
    property real duration: 10000

    function setStartPoint() {
        startPoint = control.value;
        endPointIndicator.visible = true;

        endPointIndicator.value = control.value;
        endPointIndicator.angle = control.angle;
    }

    function setEndPoint() {
        endPointIndicator.value = control.value;
        endPointIndicator.angle = control.angle;
        endPointIndicator.widthAnim.start();

        endPoint = control.value;

        moveToDestAnim.start();

    }

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

        color: explicitColor
        opacity: control.enabled ? 1 : 0.3
        angle: control.angle
    }

    Text {
        id: value
        anchors.centerIn: parent
        text: Math.floor(control.value)
        font.family: 'DS-Digital'
        font.pixelSize: backgroundItem.width/10
        color: control.explicitColor
    }

    Rectangle {
        id: endPointIndicator

        property real value: 0
        property real angle: 0

        x: control.width/2 - width/2
        y: control.height/2 - (valueIndicator.width/2 - 30)

        width: 14
        height: width
        visible: false

        radius: width/2
        border.color: control.explicitColor
        color: 'Transparent'

        property var widthAnim:
            NumberAnimation {
            target: endPointIndicator
            property: "width"
            from:0
            to:14
            duration: 300
        }

        transform:
            Rotation {
                angle: endPointIndicator.angle * 1.08
                origin{
                    y: valueIndicator.width/2 - 30
                    x: endPointIndicator.width/2
                }
            }
    }

    NumberAnimation {
        id: moveToDestAnim
        target: control
        property: "value"
        easing.type: Easing.Linear
        duration: control.duration
        from: startPoint;
        to: endPoint;

        onStopped: {
            endPointIndicator.visible = false;
            endPointIndicator.value = 0;
            endPointIndicator.angle = 0;
        }
    }
}
