import QtQuick 2.12
import QtQuick.Controls 2.12 as QQC2
import QtQuick.Controls 1.2 as QQC1
import QtGraphicalEffects 1.12

import "./" as Neum


Item {
    id: control

    readonly property color lightShadowColor: Qt.hsla(0,0,background.color.hslLightness+0.05)
    readonly property color darkShadowColor: Qt.hsva (0,0,background.color.hsvValue-0.05)
    readonly property real  value: model[currentIndex];

    property bool hide: false;
    property real indicatorHeight: height * 0.6
    property color tiksColor: '#999'

    property alias currentIndex: tumbler.currentIndex
    readonly property alias model: tumbler.model
    readonly property alias background: background

    function setValue(value){
        if(180 < value && value < 180)
            currentIndex = value + 180
    }
    function resetValue(){
        currentIndex = 180
    }
    function increment(){
        currentIndex++
    }
    function decrement(){
        currentIndex--
    }

    width: 200
    height: 50

    state:  hide    ? 'hide':
            enabled ? 'enable' : 'disable';

    onCurrentIndexChanged: {
        control.value
    }

    Rectangle {
        id: background
        anchors.fill: parent
        border.color: Qt.hsva(0,0,color.hslLightness,0.5)
        border.width: 1

        z:10
        //radius:width/2
        color: Qt.hsla(0, 0, 0.95)
    }

//    RangeModel {

//    }

    QQC2.Tumbler {
        id: tumbler

        property var modelArray: Array.from(Array(360), (_, i) => i - 180)
        property real tiksWidth: width * 0.8

        anchors.centerIn: parent
        width: indicatorHeight
        height: control.width

        model: modelArray
        currentIndex: 180
        visibleItemCount: 25
        delegate: Rectangle {
            color: 'Transparent'
            Rectangle {
                color: index === 180 ? 'red' : tiksColor
                width: index % 10 == 0? tumbler.tiksWidth : tumbler.tiksWidth /3
                height: 1

                radius: height /2
                anchors.centerIn: parent
            }
            opacity: 0.5 + (1-Math.abs(QQC2.Tumbler.displacement))*0.035
        }

        z:10

        transform: Rotation {
            angle: 90
            origin.x: tumbler.width / 2
            origin.y: tumbler.height / 2
        }
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
        samples: 13
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
        samples: 13
        color: Qt.hsla(0,0,background.color.hslLightness + 0.1)
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
                target: tumbler
                opacity: 0.8
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
                target: tumbler
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
