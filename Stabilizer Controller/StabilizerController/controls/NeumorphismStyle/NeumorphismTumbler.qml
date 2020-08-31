import QtQuick 2.0
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12
import QtQuick.Particles 2.12
import QtQuick.Controls.Styles 1.0


Item {
    id: control

    width: 200
    height: 40

    readonly property color lightShadowColor: Qt.hsla(0,0,background.color.hslLightness+0.05)
    readonly property color darkShadowColor: Qt.hsva (0,0,background.color.hsvValue-0.05)

    property bool hide: false;
    property real indicatorHeight: height * 0.6

    readonly property alias background: background

    state:'enable';

    Tumbler {
        id: tumbler

        anchors.centerIn: parent
        width: indicatorHeight
        height: control.width

        model: 360
        visibleItemCount: control.width/6
        delegate: Rectangle {
            color: 'Transparent'
            Rectangle {
                id: modelDelegate

                color: modelData == 180 ? 'red' : '#bbb'
                width: modelData % 10 == 0? parent.width * 0.7 : Math.abs(2 - modelData % 5) + 5
                height: modelData == 180 ? parent.height/3 : 1

                radius: height /2
                anchors.centerIn: parent
            }
            opacity: 0.5 + (1-Math.abs(Tumbler.displacement))*0.035       }

        z:2

        transform: Rotation {
            angle: 90
            origin.x: tumbler.width / 2
            origin.y: tumbler.height / 2
        }

        onCurrentIndexChanged: {
            console.log(currentIndex)
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        border.color: Qt.hsva(0,0,color.hslLightness,0.5)
        border.width: 2

        z:1
        //radius:width/2
        color: Qt.hsla(0, 0, 0.95)
    }

    Rectangle {
        id: shadow

        width: control.width *0.65
        height: width

        anchors.centerIn: parent

        radius: width * 0.5
        color: background.color

        transform: Scale {
            id: shadowScale
            yScale: 0.27
            origin.y: shadow.height/2
        }
    }
    // TODO: change dark and light shadow radius and offset. to make button more responsive.

    readonly property real shadowOffset: control.height*1.1
    readonly property real shadowRadius: control.height*0.7
    // light shadow
    // position: top left.
    DropShadow {
        id: darkShadow
        anchors.fill: shadow
        horizontalOffset: 0
        verticalOffset: shadowOffset
        radius: shadowRadius
        samples: 17
        color: Qt.hsva(0,0,background.color.hsvValue-0.1)
        source: shadow
        transform: Scale {
            yScale: shadowScale.yScale
            origin.y: shadow.width/2
        }
    }

    // dark shadow
    // position: bottom right.
    DropShadow {
        id: lightShadow
        anchors.fill: shadow
        horizontalOffset: 0
        verticalOffset: -shadowOffset
        radius: shadowRadius
        samples: 17
        color: Qt.hsla(0,0,background.color.hslLightness + 0.2)
        source: shadow
        transform: Scale {
            yScale: shadowScale.yScale
            origin.y: shadow.width/2
        }
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
