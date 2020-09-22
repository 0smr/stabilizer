import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Private 1.0

import './' as Neum

Neum.Dial {
    id: control

    property color accent: Qt.hsva (0.6,1,1)
    property bool doubleMode: false

    property alias endValue: range.value
    property alias endAngle: mouseArea.angle

    readonly property alias endPoint: endPoint

    function toggle() {
        endValue = doubleMode ?  endValue : 0;
        doubleMode = !doubleMode;
    }


    RangeModel {
        id: range
        minimumValue: control.from
        maximumValue: control.to
        stepSize: control.stepSize
        value: 0
    }

    Neum.DialIndicaor {
        id: endPoint

        color: control.accent
        anchors.centerIn: parent

        width: control.width * 0.8
        height: control.height * 0.8

        rotation: control.endAngle - 180

        state: doubleMode ? 'double' : 'single'

        states: [
            State {
                name: "single"
                PropertyChanges {
                    target: endPoint
                    width: control.width * 0.9
                    opacity: 0
                }
                PropertyChanges {
                    target: mouseArea
                    enabled: false
                }
            },
            State {
                name: "double"
                PropertyChanges {
                    target: endPoint
                    width: control.width * 0.8
                    opacity: 1
                }
                PropertyChanges {
                    target: mouseArea
                    enabled: true
                }
            }
        ]

        transitions:
            Transition {
            SequentialAnimation {
                NumberAnimation {
                    property: "opacity"
                    duration: 500
                }
                NumberAnimation {
                    property: "width"
                    duration: 500
                }
            }
        }
    }

    MouseArea {
        id: mouseArea

        width: control.width * 0.8
        height: width

        property real angle: 180

        hoverEnabled: true
        anchors.centerIn: control

        //propagateComposedEvents: true

        onPositionChanged: {
            if (pressed) {
                endValue = valueFromPoint(mouseX, mouseY);
            }
        }

        onPressed: {
            if(isInCircleRadius(mouseX, mouseY ,width/2)) {
                endValue = valueFromPoint(mouseX, mouseY);
                mouse.accepted = true;
            } else {
                mouse.accepted = false
            }

            if (activeFocusOnPress)
                dial.forceActiveFocus();
        }

        function isInCircleRadius(x, y,r) {
            var yy = height / 2.0 - y;
            var xx = width / 2.0 - x;

            if (Math.sqrt(xx*xx + yy*yy) <= r) {
                return true;
            } else {
                return false;
            }
        }

        function valueFromPoint(x, y) {
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

    onEndValueChanged: {
        var mid = (to - from) / 2
        endAngle = 180 * (endValue - mid) / mid;
    }
}
