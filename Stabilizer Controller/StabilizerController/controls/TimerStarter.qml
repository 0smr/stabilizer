import QtQuick 2.0

Item {
    id: control
    property color  color: 'gray'
    property bool   hide: false
    property alias value: timerTextEdit.text

    function toggle() {
       state = (state == 'hide')? 'enable' : 'hide';
    }

    function activeFocus() {
        timerTextEdit.focus = true;
    }

    state:   hide       ? 'hide' :
            !enabled    ? 'disable': 'endable'

    enabled: !hide

    states: [
        State {
            name: "enable"
            PropertyChanges {
                target: timerTextEdit
                opacity: 1
            }
        },
        State {
            name: "disable"
            PropertyChanges {
                target: timerTextEdit
                opacity: 0.3
            }
        },
        State {
            name: "hide"
            PropertyChanges {
                target: timerTextEdit
                opacity: 0
            }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation {properties:'opacity';duration: 300;}
        }
    ]

    TextInput {
        id: timerTextEdit
        width: defualtButtonWidth
        height: width/2
        anchors.centerIn: parent
        validator: RegExpValidator { regExp: /[0-9]{1,4}/ }
        text: '10'
        color: control.color
        font {
            family: dsDigitalRegular.name
            pixelSize: height
        }

        Text {
            height: parent.height * 0.7
            anchors.left: parent.right
            text: 'sec'
            color: control.color
            font {
                family: dsDigitalRegular.name
                pixelSize: height
            }
        }
    }
}
