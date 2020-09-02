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
    property color color: Qt.hsla(0, 0, 0.9)
    property real defualtButtonWidth: width/6 < 180 ? width/6 : 180

    /*
      initialized with an serial port instance.
      methods:

    */
    FontLoader {
        id: icoFontRegular
        source: 'qrc:/resources/fonts/icofont.ttf'
    }
    FontLoader {
        id: dsDigitalRegular
        source: 'qrc:/resources/fonts/DS-DIGI.TTF'
    }

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
                    height: width
                    color: control.color
                    text.text: '\uef3a'
                    text.font.family: icoFontRegular.name

                    Layout.preferredWidth: defualtButtonWidth
                    Layout.preferredHeight: defualtButtonWidth
                    Layout.alignment: Qt.AlignTop
                    Layout.leftMargin: 15
                    Layout.topMargin: 15
                }

                Battery {
                    height: width
                    color: control.color
                    enabled: false

                    Layout.preferredWidth: defualtButtonWidth  * 3/2
                    Layout.preferredHeight: defualtButtonWidth * 3/2
                    Layout.alignment: Qt.AlignRight | Qt.AlignTop
                    Layout.rightMargin: 15
                    Layout.topMargin: 15
                }
            }
        }

        Item {
            //height: 2 * rollAngleController.height + 20 + width * 3/5
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop

            ColumnLayout {
                id: controllerSection
                anchors.fill: parent

                /*!
                 *
                 */

                NeumorphismDial {
                    id: yawAngleController

                    enabled: true

                    Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                    Layout.preferredWidth: parent.width * 3/5
                    Layout.preferredHeight: width

                    Layout.maximumWidth: 400
                    Layout.maximumHeight: 400
                    Layout.bottomMargin: 10

                    background.color: control.color
                    from: -180
                    value: 0
                    to: 180
                    stepSize: 1

                    Text {
                        anchors.centerIn: parent
                        color: Qt.hsva (0,0,1-parent.background.color.hsvValue,0.5)
                        text: parent.value
                        opacity: 0.3
                    }

                }

                /*!
                 *
                 */

                Text {
                    text: rollAngleController.model[rollAngleController.currentIndex]
                    color: Qt.hsva (0,0,1-control.color.hsvValue,0.2)

                    Layout.alignment: Qt.AlignHCenter
                    Layout.bottomMargin:10
                }

                Item {
                    Layout.leftMargin: 10
                    Layout.rightMargin:10
                    Layout.fillWidth: true
                    Layout.maximumWidth: 300 + defualtButtonWidth
                    Layout.preferredHeight: width * 0.4  - 50
                    Layout.alignment: Qt.AlignHCenter
                    RowLayout {
                        anchors.fill: parent
                        NeumorphismCircleButton {
                            Layout.preferredWidth:  defualtButtonWidth/2
                            Layout.preferredHeight: defualtButtonWidth/2
                            background.color: control.color
                            text.text: '\uea9d'
                            text.font.family: icoFontRegular.name

                            onClicked: rollAngleController.currentIndex--
                            onPressAndHoldRpeater: rollAngleController.currentIndex--
                        }

                        NeumorphismTumbler {
                            id: rollAngleController

                            background.color: control.color
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.leftMargin: 10
                            Layout.rightMargin:10
                        }

                        NeumorphismCircleButton {
                            Layout.preferredWidth:  defualtButtonWidth/2
                            Layout.preferredHeight: defualtButtonWidth/2
                            background.color: control.color
                            text.text: '\ueaa0'
                            text.font.family: icoFontRegular.name

                            onClicked: rollAngleController.currentIndex++
                            onPressAndHoldRpeater: rollAngleController.currentIndex++
                        }
                    }
                }

                /*!
                 *
                 */

                Text {
                    text: pitchAngleController.model[pitchAngleController.currentIndex]
                    color: Qt.hsva (0,0,1-control.color.hsvValue,0.2)

                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin:10
                    Layout.bottomMargin:10
                }

                Item {
                    Layout.leftMargin: 10
                    Layout.rightMargin:10
                    Layout.fillWidth: true
                    Layout.maximumWidth: 300 + defualtButtonWidth
                    Layout.preferredHeight: width * 0.4  - 50
                    Layout.alignment: Qt.AlignHCenter
                    RowLayout {
                        anchors.fill: parent
                        NeumorphismCircleButton {
                            Layout.preferredWidth: defualtButtonWidth/2
                            Layout.preferredHeight: defualtButtonWidth/2

                            background.color: control.color
                            text.text: '\uea9d'
                            text.font.family: icoFontRegular.name

                            onClicked: pitchAngleController.currentIndex--
                            onPressAndHoldRpeater: pitchAngleController.currentIndex--
                        }

                        NeumorphismTumbler {
                            id: pitchAngleController

                            background.color: control.color
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.leftMargin: 10
                            Layout.rightMargin:10
                        }

                        NeumorphismCircleButton {
                            Layout.preferredWidth: defualtButtonWidth/2
                            Layout.preferredHeight: defualtButtonWidth/2

                            background.color: control.color
                            text.text: '\ueaa0'
                            text.font.family: icoFontRegular.name

                            onClicked: pitchAngleController.currentIndex++
                            onPressAndHoldRpeater: pitchAngleController.currentIndex++
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }

        ButtonListView {
            id: buttonList

            color: control.color
            defualtItemWidth: defualtButtonWidth

            Layout.fillWidth: true
            Layout.maximumWidth: 500
            Layout.alignment: Qt.AlignHCenter
            height: 100

            listModel: ListModel {
                    ListElement {
                        //night mode
                        name: 'reset button'
                        func: (button)=>{ control.toggleNightMode(button); }
                        icon: '\uee7e'
                        activate: true
                    }
                    ListElement {
                        // reset controller button
                        name: 'reset'
                        func: ()=>{ control.resetControllers(); }
                        icon: '\uefd1'
                        activate: true
                    }
                    ListElement {
                        // range iterator
                        name: 'range'
                        func: ()=>{}
                        icon:'\uf020'
                        activate: false
                    }
                    ListElement {
                        // bluetooth reconnection button
                        name: 'lock'
                        func: ()=>{}
                        icon:'\uec61'
                        activate: false
                    }
                    ListElement {
                        // bluetooth reconnection button
                        name: 'bluetooth reconnection'
                        func: ()=>{}
                        icon: '\uec42'
                        activate: false
                    }
                }
        }

    }

    function resetControllers() {
        pitchAngleController.resetValue()
        rollAngleController.resetValue()
        yawAngleController.value = 0;
    }


    property bool isNightModeOn : false;
    function toggleNightMode(button) {

        isNightModeOn = !isNightModeOn;
        button.text.text = isNightModeOn ? '\uef9e': '\uee7e'  ;
        if(isNightModeOn === true)
        {
            control.color = Qt.hsla(0, 0, 0.1)
        }
        else
        {
            control.color = Qt.hsla(0, 0, 0.9)
        }
    }
}
