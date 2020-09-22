import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import QtQuick.Window 2.1

import 'controls' //as NEUM
import 'views'

ApplicationWindow {
    id: window
    visible: true

    width: 240
    height: 520

    title: qsTr("Stabilizer Controller")
    color: Qt.hsla(0, 0, 0.9)

    ControlPanel {
        id: controlPanel
        color: window.color
        visible: false

        settingButton.onClicked: {
            stackView.push(settingPanel)
        }

        onToggleDarkMode: {
            window.color = status ? Qt.hsla(0, 0, 0.1) : Qt.hsla(0, 0, 0.9)
        }
    }

    SettingsPanel {
        id: settingPanel
        visible: false
        color: window.color

        backButton.onClicked: {
            stackView.pop()
        }
    }

    StackView {
        id: stackView
        initialItem: controlPanel
        anchors.fill: parent

        pushEnter: Transition {
            SequentialAnimation {
                PropertyAction {
                    properties: 'hide'
                    value: false
                }
                PauseAnimation {
                    duration: 700
                }
            }
        }

        popExit: Transition {
            SequentialAnimation {
                PropertyAction {
                    properties: 'hide'
                    value: true
                }
                PauseAnimation {
                    duration: 700
                }
            }
        }

        pushExit: popExit
        popEnter: pushEnter
    }
}
