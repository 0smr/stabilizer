import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

import io.stabilizer.serialPort 1.0

import 'controls'
import 'views'

ApplicationWindow {
    id: window
    visible: true

    width: 240
    height: 480
    title: qsTr("Stabilizer Controller")

    //Material.theme: Material.Dark
    Material.primary: Material.theme == Material.Dark ? 'Grey' : 'white'

    header: ToolBar {
        Material.elevation: 1

        width: window.width
        height: 35

        RowLayout {
            anchors.fill: parent

            HambergerToggle {
                id: toolToggleButton
                enabled: false

                height: parent.height *0.7
                Layout.leftMargin: 5

                color: Material.accent
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            Button {
                id: toolButton
                text: '\uefe2'
                font.family: 'IcoFont'
                font.pixelSize: parent.height * 0.6
                enabled: false

                Material.background: 'Transparent'
                Material.foreground: Material.accent
                Material.elevation: 1
                Layout.preferredHeight: parent.height
                Layout.preferredWidth: parent.height
            }

            Button {
                id: aboutButton

                text: '\uef19'
                font.family: 'IcoFont'
                font.pixelSize: parent.height * 0.6
                enabled: false

                Material.background: 'Transparent'
                Material.foreground: Material.accent
                Material.elevation: 1

                Layout.preferredHeight: parent.height
                Layout.preferredWidth: parent.height
                Layout.rightMargin: 5

                ToolTip.text: "about"

                onClicked: {
                    if(stackView.depth <= 1)
                        stackView.push("views/About.qml")
                }
            }
        }
    }

    Main {
        id: mainPage

//        serialPortAPI: SerialPort{
//        }
        Timer{
            id:timer
            interval: 50
            running: false
            repeat: false
            onTriggered: {
                serialPort.setYawValue(Math.floor(parent.value))
            }
        }
    }

    StackView {
        id: stackView

        initialItem: mainPage
        anchors.fill: parent
    }
}
