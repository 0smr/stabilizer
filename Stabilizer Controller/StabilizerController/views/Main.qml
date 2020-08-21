import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12

import io.stabilizer.opcode 1.0

import "../controls"

Item {
    id: control

    property var color: 'purple'
    property var serialPortAPI: null
    /*
      initialized with an serial port instance.
      methods:



    */

    ColumnLayout {
        id: mainSection
        anchors.fill: parent

        ColumnLayout {
            id: controllerSection

            Layout.fillWidth: true

            Item {
                RowLayout {

                    anchors.fill: parent

                    Item {
                        //reserved
                        width: pitchController.width
                        visible: false
                    }

                    CustomDial {
                        id: yawController

                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignTop

                        color: Material.accent

                        onValueChanged: {
                            serialPortAPI.setYawValue(value);
                        }

                        //enabled: serialPortAPI.connected
                    }
                    ColumnLayout {
                        Button {
                            id: pitchControllerIncreament
                            text: '\ueaa1'
                            font.family: 'IcoFont'
                            enabled: rollController.enabled

                            Material.background: 'Transparent'
                            Material.foreground: Material.accent
                            Material.elevation: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 25
                            Layout.alignment: Qt.AlignHCenter

                            onClicked: {
                                pitchController.value ++
                                pitchController.tooltip.show(pitchController.value)
                            }
                        }

                        Slider {
                            id: pitchController

                            from: -90
                            value: 0
                            to: 90
                            stepSize: 1

                            orientation: Qt.Vertical
                            Layout.alignment: Qt.AlignHCenter
                            property var tooltip: ToolTip {
                                parent: pitchController.handle
                                visible: pitchController.pressed
                                text: Math.floor(pitchController.value)
                            }

                            onValueChanged: {
                                serialPortAPI.setPitchValue(value);
                            }
                        }

                        Button {
                            id: pitchControllerDecreament
                            text: '\uea99'
                            font.family: 'IcoFont'
                            enabled: rollController.enabled

                            Material.background: 'Transparent'
                            Material.foreground: Material.accent
                            Material.elevation: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 25
                            Layout.alignment: Qt.AlignHCenter

                            onClicked: {
                                pitchController.value --
                                pitchController.tooltip.show(pitchController.value)
                            }
                        }
                    }

                }

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                height: 300
            }

            Item {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                height: 50

                RowLayout {
                    anchors.fill: parent
                    Button {
                        id: rollControllerDecreament
                        text: '\uea9d'
                        font.family: 'IcoFont'
                        enabled: rollController.enabled

                        Material.background: 'Transparent'
                        Material.foreground: Material.accent
                        Material.elevation: 1
                        Layout.preferredHeight: 35
                        Layout.preferredWidth: 25
                        Layout.leftMargin: 5

                        onClicked: {
                            rollController.value --
                            rollController.tooltip.show(rollController.value)
                        }
                    }

                    Slider {
                        id: rollController
                        from: -90
                        value: 0
                        to: 90
                        stepSize: 1

                        Layout.fillWidth: true

                        property var tooltip: ToolTip {
                            parent: rollController.handle
                            visible: rollController.pressed
                            text: Math.floor(rollController.value)
                        }

                        onValueChanged: {
                            serialPortAPI.setRollValue(value);
                        }
                    }

                    Button {
                        id: rollControllerIncreament
                        text: '\ueaa0'
                        font.family: 'IcoFont'
                        enabled: true

                        Material.background: 'Transparent'
                        Material.foreground: Material.accent
                        Material.elevation: 1
                        Layout.preferredHeight: 35
                        Layout.preferredWidth: 25
                        Layout.rightMargin: 5

                        onClicked: {
                            rollController.value ++
                            rollController.tooltip.show(rollController.value)
                        }
                    }
                }
            }

            RowLayout {

                width: control.width
                height: 50
                Button {
                    id: resetButton
                    text: '\uefd1'
                    font.family: 'IcoFont'
                    enabled: rollController.enabled

                    Material.background: 'Transparent'
                    Material.foreground: Material.accent
                    Material.elevation: 1

                    Layout.leftMargin: 5
                    Layout.preferredWidth: height

                    ToolTip.text: 'reset button'
                    ToolTip.visible: hovered
                    property var animation : NumberAnimation {
                        target: resetButton
                        property: "rotation"
                        duration: 200
                        easing.type: Easing.InOutQuad
                        to: 720
                    }

                    onClicked: {
                        rotation = 0;
                        animation.start()
                    }
                }

                Button {
                    //id: rollControllerIncreament
                    text: '\ueebe'
                    font.family: 'IcoFont'
                    enabled: false

                    Material.background: 'Transparent'
                    Material.foreground: Material.accent
                    Material.elevation: 1

                    Layout.preferredWidth: height

                    ToolTip.text: 'reset button'
                    ToolTip.visible: hovered

                    onClicked: {

                    }
                }

                Button {
                    //id: rollControllerIncreament
                    text: '\uefc4'
                    font.family: 'IcoFont'
                    enabled: false

                    Material.background: 'Transparent'
                    Material.foreground: Material.accent
                    Material.elevation: 1
                    Layout.preferredWidth: height

                    onClicked: {

                    }
                }

                Button {
                    //id: rollControllerIncreament
                    text: '\ueec3'
                    font.family: 'IcoFont'
                    enabled: false

                    Material.background: 'Transparent'
                    Material.foreground: Material.accent
                    Material.elevation: 1
                    Layout.preferredWidth: height
                    Layout.alignment: Qt.AlignRight
                    Layout.rightMargin: 5

                    onClicked: {

                    }
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Pane {
            id: toolsPan
            Layout.fillWidth: true
            visible: false

            Material.elevation: 1
        }
    }
}
