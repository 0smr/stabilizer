import QtQuick 2.0

Item {
    id: control

    readonly property alias leftText: leftText
    readonly property alias rightText:rightText

    property color accent: 'lightblue'
    property real spacing: -rightText.width/2

    property bool checkable : false;
    property bool checked: false;
    property bool doubleMode : false;
    property bool hide: false;

    signal clicked();

    function toggle() {
        doubleMode = !doubleMode
    }

    state: doubleMode ? 'double' : 'single'
    width:  rightText.width + leftText.width
    height: childrenRect.height
    opacity: hide ? 0 : 1

    Text {
        id: leftText
        x: -spacing
        color: 'grey'
        text: '0'
    }

    Text {
        id: rightText
        x: spacing + leftText.width
        color: 'blue'
        text: '0'
    }

    Rectangle{
        x: checked ? control.width + 5 : leftText.x - 5
        y: leftText.height/2-height/2
        visible: doubleMode && checkable
        width: 3
        height: width
        radius: width/2
        color: control.accent

        Behavior on x {
            NumberAnimation {duration: 500; easing.type: Easing.OutBack}
        }
    }

    Behavior on opacity {
        NumberAnimation { duration: 1000 }
    }

    MouseArea {
        id:mousearea
        anchors.fill: parent
        enabled: control.doubleMode

        onClicked: {
            //checked = checkable ? !checked : checked;
            control.clicked();
        }
    }

    states: [
        State {
            name: 'single'
            PropertyChanges {
                target: rightText
                opacity: 0
            }
            PropertyChanges {
                target: control
                spacing: -rightText.width/2
            }
        },

        State {
            name: 'double'
            PropertyChanges {
                target: rightText
                opacity: 1
            }
            PropertyChanges {
                target: control
                spacing: 3
            }
        } ]

    transitions :
        Transition {
            SequentialAnimation {
                NumberAnimation {
                    property: "opacity"
                    duration: 500
                }
                NumberAnimation {
                    property: "spacing"
                    duration: 500
                }
            }
        }
}
