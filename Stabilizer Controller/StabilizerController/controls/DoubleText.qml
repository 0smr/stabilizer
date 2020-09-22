import QtQuick 2.0

Item {
    id: control

    readonly property alias leftText: leftText
    readonly property alias rightText:rightText

    property real spacing: -rightText.width/2

    property bool switchable : false;
    property bool doubleMode : false;
    property bool hide: false;

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

    Behavior on opacity {
        NumberAnimation { duration: 1000 }
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
