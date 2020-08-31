import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12

Control {
    id: control
    width: 50
    height: width

    readonly property color lightShadowColor: Qt.hsla(0,0,background.color.hslLightness+0.05)
    readonly property color darkShadowColor: Qt.hsva (0,0,background.color.hsvValue-0.05)

    property alias background: buttonPlate
    property alias text: text

    property bool hide: false;
    property bool pressed: false;
    property bool hovered: false;

    signal clicked();

    state: !enabled ? 'disable' :
            pressed ? 'press' :
            hide ? 'hide' :'enable';

    Rectangle {
        id: buttonPlate

        color: Qt.hsla(0, 0, 0.95)

        anchors.centerIn: buttonBorder
        width: control.width - control.width / 20
        height: width

        radius: width/2

        z: 10

        Text {
            id: text
            text: ''
            color: Qt.hsla(0,0,1-background.color.hslLightness,0.7)

            anchors.centerIn: parent
        }
    }

    Rectangle {
        id: buttonBorder

        width: control.width
        height: width

        radius: width/2
        color: background.color

        Rectangle {
            id: buttonBorderGradiant
            anchors.fill: buttonBorder
            radius: width/2
            rotation: -45

            gradient: Gradient {
                    GradientStop {
                        position: 0.0;
                        color: control.lightShadowColor//Qt.hsla(0, 0, 1)
                    }
                    GradientStop {
                        position: 1.0;
                        color: control.darkShadowColor//Qt.hsla(0, 0, 0.9)
                    }
                }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: control
        hoverEnabled: true

        onPressed: {
            control.pressed = true;
            control.clicked();
        }
        onReleased: {
            control.pressed = false;
        }

        onEntered: {
            control.hovered = true;
        }
        onExited: {
            control.hovered = false;
        }
    }

    // TODO: change dark and light shadow radius and offset. to make button more responsive.

    readonly property real shadowOffset: control.width * 0.03 + 3.33
    readonly property real shadowRadius: control.width * 0.05 + 7.67
    // light shadow
    // position: top left.
    DropShadow {
        id: darkShadow
        anchors.fill: buttonBorder
        horizontalOffset: shadowOffset
        verticalOffset: shadowOffset
        radius: shadowRadius
        samples: 17
        color: Qt.hsva(0,0,background.color.hsvValue-0.1)
        source: buttonBorder
    }

    // dark shadow
    // position: bottom right.
    DropShadow {
        id: lightShadow
        anchors.fill: buttonBorder
        horizontalOffset: - shadowOffset
        verticalOffset: - shadowOffset
        radius: shadowRadius
        samples: 17
        color: Qt.hsla(0,0,background.color.hslLightness + 0.1)
        source: buttonBorder
    }

    states: [
        State {
            //button normal state
            name: "enable"
            PropertyChanges {
                target: darkShadow
                opacity: 1
            }
            PropertyChanges {
                target: lightShadow
                opacity: 1
            }
        },
        State {
            // this state activated when button pressed and comes with some decreasing in shadows.
            name: "press"
            PropertyChanges {
                target: darkShadow
                opacity: 0.5
            }
            PropertyChanges {
                target: lightShadow
                opacity: 0.5
            }
        },
        State {
            name: "disable"
            PropertyChanges {
                target: darkShadow
                opacity: 0
            }
            PropertyChanges {
                target: lightShadow
                opacity: 0
            }
            PropertyChanges {
                target: text
                opacity: 0.4
            }
        },
        State {
            name: "hide"
            PropertyChanges {
                target: darkShadow
                opacity: 0
            }
            PropertyChanges {
                target: lightShadow
                opacity: 0
            }
            PropertyChanges {
                target: buttonBorderGradiant
                opacity: 0
            }
            PropertyChanges {
                target: text
                opacity: 0
            }
            PropertyChanges {
                target: buttonPlate
                opacity: 0
            }
        }
    ]

    transitions: [
        Transition {
            from: 'hide'
            PropertyAnimation {
                properties: 'opacity'
                duration: 1000
            }
        },
        Transition {
            PropertyAnimation {
                properties: 'opacity'
                duration: 180
            }
        }
    ]
}
