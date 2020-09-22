import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12

Item {
    id: control
    width: 50
    height: width

    readonly property color lightShadowColor: Qt.hsla(0,0,background.color.hslLightness+0.05)
    readonly property color darkShadowColor: Qt.hsva (0,0,background.color.hsvValue-0.05)

    property bool hide: false;
    property bool checkable: false
    property bool checked: false

    property alias  accent: checkIndicator.color
    property alias color: buttonPlate.color

    readonly property alias background: buttonPlate
    readonly property alias text: text
    readonly property alias pressed: mouseArea.pressed;
    readonly property alias hovered: mouseArea.containsMouse;

    signal clicked();
    signal pressAndHold();
    signal pressAndHoldRpeater();

    function toggle() {
        toggleAnimation.from = 0;
        toggleAnimation.to = 1;
        toggleAnimation.start();

    }

    state: hide ? 'hide' :
           !enabled ? 'disable' :
           pressed ? 'press' : 'enable';

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
            color: Qt.hsla(0,0,1-background.color.hslLightness,0.3)
            font.pixelSize: parent.height * 0.6
            font.family: 'IcoFont'

            anchors.centerIn: parent
        }
    }

    Rectangle {
        id: checkIndicator

        property real colorOpacity: control.checked

        x: control.width * 0.65
        y: 5

        width: control.width / 10
        height: width
        radius: width / 2

        z:10

        visible: control.checkable
        enabled: control.checkable

        color: Qt.hsva (0.6,1,1,colorOpacity)

        Behavior on colorOpacity {
            NumberAnimation {duration: 300}
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

        onPressAndHold: {
            control.pressAndHold()
            timer.start()
            control.checked = control.checkable ? !control.checked:control.checked
        }
        onClicked: control.clicked();
    }

    Timer {
        id: timer
        interval: 400
        onTriggered: {
            control.pressAndHoldRpeater()
            start()
        }
        running: control.pressed
    }

    // TODO: change dark and light shadow radius and offset. to make button more responsive.

    readonly property real shadowOffset: control.width * 0.03 + 3.33
    readonly property real shadowRadius: control.width * 0.1 + 7.67
    // light shadow
    // position: top left.
    DropShadow {
        id: darkShadow
        anchors.fill: buttonBorder
        horizontalOffset: shadowOffset
        verticalOffset: shadowOffset
        radius: shadowRadius
        samples: 10
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
        samples: 10
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
            PropertyChanges {
                target: text
                opacity: 0.7
            }
            PropertyChanges {
                target: checkIndicator
                opacity: 0.7
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
            to: 'hide'
            PropertyAnimation {
                properties: 'opacity'
                duration: 500
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
