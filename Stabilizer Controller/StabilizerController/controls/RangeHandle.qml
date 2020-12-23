import QtQuick 2.0

Rectangle {
    id: control

    //property alias pressed: mouseArea.pressed;
    //property alias hovered: mouseArea.containsMouse;

    property real   labelNumber: 0
    property real   value: 0
    property color  tColor: 'gray'

    signal clicked();

    implicitHeight: 6

    height: implicitHeight;
    width:  height/3

    radius: width/2

    color: Qt.hsla(0,0,1-control.tColor.hslLightness,0.8)

    Text {
        id: label
        anchors.bottom: control.top
        text: control.labelNumber
        anchors.horizontalCenter: control.horizontalCenter
        font.pixelSize: control.width * 1.5
        color: control.color;
    }

    states: [
        State {
            name: 'normal'
            PropertyChanges {
                target: control
                width: control.implicitHeight
            }
        },State {
            name: 'pressed'
            PropertyChanges {
                target: control
                width: control.implicitHeight + 4
            }
        }
    ]

    function setPos(visualPos,value,labelNumber){
        control.x       = visualPos - control.width/2;
        control.value   = value;
        control.labelNumber
                        = labelNumber;
    }
}
