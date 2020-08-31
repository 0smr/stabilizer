import QtQuick 2.12
import QtQuick.Controls 1.2
import QtQuick.Controls.Private 1.0
import QtQuick.Controls.Styles 1.1
import QtQuick.Extras 1.4
import QtQuick.Extras.Private 1.0

Control {
    id: control

    width: 200
    height: width

    readonly property alias background: dialBackground
    readonly property alias handle: dialHandle
    readonly property alias pressed: mouseArea.pressed
    readonly property alias hovered: mouseArea.containsMouse

    property bool activeFocusOnPress: false
    property bool tickmarksVisible: true

    property alias angle: mouseArea.angle
    property alias value: range.value
    property alias from: range.minimumValue
    property alias to: range.maximumValue
    property alias stepSize: range.stepSize

    Keys.onLeftPressed:     value -= stepSize
    Keys.onDownPressed:     value -= stepSize
    Keys.onRightPressed:    value += stepSize
    Keys.onUpPressed:       value += stepSize

    activeFocusOnTab: true

    NeumorphismDialBackground {
        id: dialBackground
        anchors.fill: control
    }

    NeumorphismDialIndicaor {
        id: dialHandle
        width: parent.width - 15
        height: width
        anchors.centerIn: parent

        rotation: angle
        color: Qt.hsva (0,0,1-background.color.hsvValue,0.2)

        lineWidth: 1
    }

    RangeModel {
        id: range
        minimumValue: 0.0
        maximumValue: 1.0
        stepSize: 0
        value: 0
    }

    MouseArea {
        id: mouseArea

        property real angle: 0

        hoverEnabled: true
        anchors.fill: background

        onPositionChanged: {
            if (pressed) {
                value = valueFromPoint(mouseX, mouseY);
            }
        }
        onPressed: {
            value = valueFromPoint(mouseX, mouseY);

            if (activeFocusOnPress)
                dial.forceActiveFocus();
        }

        function valueFromPoint(x, y)
        {
            var yy = height / 2.0 - y;
            var xx = x - width / 2.0;
            var value;
            var pointAngle = ((xx || yy) ? Math.atan2(yy, xx) : 0) + Math.PI / 2;

            if (pointAngle < 0)
                pointAngle = pointAngle + Math.PI * 2;

            var range = to - from;
            value = from + range * (2 * Math.PI - pointAngle) / (2 * Math.PI);

            return value
        }
    }

    onValueChanged: {
        var mid = (to - from) / 2
        angle = 180 * (value - mid) / mid;
    }
}
