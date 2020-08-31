import QtQuick 2.0
import QtGraphicalEffects 1.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Extras 1.4

import io.stabilizer.opcode 1.0

import "../controls/NeumorphismStyle/Dial"
import "../controls/NeumorphismStyle"
import "../controls"

Item {
    id: control

    //required property SerialPort serialPortAPI;
    property color color: Qt.hsla(0, 0, 0.1)

    /*
      initialized with an serial port instance.
      methods:

    */

    ColumnLayout {
        id: mainSection
        anchors.fill: parent

        Item {
            Layout.fillWidth: true
            height: 80
            RowLayout {
                id: header
                anchors.fill: parent
                NeumorphismCircleButton {
                    width: 40
                    height: width
                    backColor: control.color
                    text.text: '\uef3a'

                    Layout.alignment: Qt.AlignTop
                    Layout.leftMargin: 15
                    Layout.topMargin: 15
                }

                Battery {
                    width: 60
                    height: width
                    backColor: control.color

                    Layout.alignment: Qt.AlignRight | Qt.AlignTop
                    Layout.rightMargin: 15
                    Layout.topMargin: 15
                }
            }
        }

        Item {
            height: 200
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop

            ColumnLayout {
                id: controllerSection
                anchors.fill: parent
                NeumorphismDial {
                    id: pitchAngle
                    width: 150
                    height: width

                    Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                    Layout.bottomMargin: 20

                    background.color: control.color
                    from: -180
                    to: 180
                    stepSize: 1

                    Text {
                        anchors.centerIn: parent
                        color: Qt.hsva (0,0,1-pitchAngle.background.color.hsvValue,0.5)
                        text: parent.value
                        opacity: 0.3
                    }
                }

                Item {
                    id: name
                    Layout.fillWidth: true
                    Layout.leftMargin: 5
                    Layout.rightMargin:5
                    height: 50
                    RowLayout {
                        anchors.fill: parent
                        NeumorphismCircleButton {
                            width: 20
                            background.color: control.color
                        }

                        NeumorphismTumbler {
                            Layout.fillWidth: true
                            Layout.maximumWidth: 150
                            Layout.alignment: Qt.AlignHCenter
                            background.color: control.color
                        }

                        NeumorphismCircleButton {
                            width: 20
                            background.color: control.color
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.leftMargin: 5
                    Layout.rightMargin:5
                    height: 50
                    RowLayout {
                        anchors.fill: parent
                        NeumorphismCircleButton {
                            width: 20
                            background.color: control.color
                        }

                        NeumorphismTumbler {
                            Layout.fillWidth: true
                            Layout.maximumWidth: 150
                            Layout.alignment: Qt.AlignHCenter
                            background.color: control.color
                        }

                        NeumorphismCircleButton {
                            width: 20
                            background.color: control.color
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }

    //Material.accent: Material.Grey
}
