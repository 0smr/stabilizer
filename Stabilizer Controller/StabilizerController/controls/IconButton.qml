import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12

Rectangle {
    id: control

    property alias text: icon.text
    property alias fontFamily: icon.font.family
    property alias toolTip: toolTip
    property var mainColor: 'orange'

    property bool press: false
    property bool hover: false

    clip: true;
    color: 'Transparent'

    function fadeToggle() {
        if(control.opacity == 0)
            appearAnimation.restart();
        else
            disappearAnimation.restart();
    }

    signal pressed()
    signal hovered();

    Text {
        id: icon

        anchors.centerIn: parent
        text: '.'
        font.family: 'IcoFont'
        font.pixelSize: control.height - 5
        color: control.press ? Qt.darker(control.mainColor,1.1) :
                               control.hover ? Qt.lighter(control.mainColor,1.3)
                                            : control.mainColor;
    }

    ToolTip {
        id:toolTip
        text: ''

    }

    MouseArea {
        id: mouseArea
        anchors.fill: control
        hoverEnabled: true

        onPressed: {
            control.pressed();
            control.press = true;
        }
        onReleased: control.press = false;

        onEntered: {
            control.hovered();
            control.hover = true;
        }
        onExited: control.hover = false;
    }

    NumberAnimation {
        id: appearAnimation
        target: control
        properties: 'opacity'
        running: false
        to: 1
        duration: 300
        onStarted: {
            control.visible = true;
        }
    }

    NumberAnimation {
        id: disappearAnimation
        target: control
        properties: 'opacity'
        to: 0
        duration: 300
        onFinished: {
            control.visible = false;
        }
    }
}
