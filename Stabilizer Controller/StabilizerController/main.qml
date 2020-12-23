import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import QtQuick.Window 2.1

import 'controls/NeumorphismStyle' as NEUM
import 'controls' as CTRLS
import 'views'

ApplicationWindow {
    id: window
    visible: true

    width:  352
    height: 700

    title: qsTr("Stabilizer Controller")
    color: Qt.hsla(0, 0, 0.9)

    ControlPanel {
        id: controlPanel
        color: window.color
        visible: false

        defualtButtonWidth: width/7 < 150 ? width/7 : 150

        settingButton.onClicked: {
            stackView.push(settingPanel)
        }

        darkModeButton.onClicked: {
            darkModeButton.checked = !darkModeButton.checked;
            window.color = darkModeButton.checked ? Qt.hsla(0, 0, 0.1) : Qt.hsla(0, 0, 0.9)
        }

        aRangeModeButton.onClicked: {
            stackView.push(apmp)
        }
    }

    SettingsPanel {
        id: settingPanel
        visible: false
        color: window.color
        defualtButtonWidth: width/7 < 150 ? width/7 : 150

        backButton.onClicked: {
            stackView.pop()
        }
    }

    AdvancedPathMovePanel {
        id: apmp
        visible: false
        color: window.color
        defualtButtonWidth: width/7 < 150 ? width/7 : 150
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
