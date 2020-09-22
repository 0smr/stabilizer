import QtQuick 2.12
import QtGraphicalEffects 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12
import QtQuick.Extras 1.4

import io.stabilizer.opcode 1.0
import io.stabilizer.serialPort 1.0

import "../controls/NeumorphismStyle/Dial" as NEUMDIAL
import "../controls/NeumorphismStyle" as NEUM
import "../controls"

Item {
    id: control

    property color accent: Qt.hsva (0.6,1,1)
    property color color: Qt.hsla(0, 0, 0.9)
    property real defualtButtonWidth: width/6 < 180 ? width/6 : 180
    property bool hide: false

    readonly property alias settingButton : settingButton
    readonly property alias buttonList : settingButton

    signal toggleDarkMode(bool status)

    /*
      initialized with an serial port instance.
      methods:

    */

//    SerialPort {
//        id: serialPort
//    }

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

                /*
                 * setting button
                 *
                 *
                 */

                NEUM.CircleButton {
                    id: settingButton

                    color: control.color
                    hide: control.hide
                    text.text: '\uef3a'
                    text.font.family: icoFontRegular.name

                    Layout.preferredWidth: defualtButtonWidth
                    Layout.preferredHeight: defualtButtonWidth
                    Layout.alignment: Qt.AlignTop
                    Layout.leftMargin: 15
                    Layout.topMargin: 15
                }

                NEUM.Battery {
                    height: width
                    color: control.color
                    enabled: false
                    hide: control.hide

                    Layout.preferredWidth: defualtButtonWidth  * 3/2
                    Layout.preferredHeight: defualtButtonWidth * 3/2
                    Layout.alignment: Qt.AlignRight | Qt.AlignTop
                    Layout.rightMargin: 15
                    Layout.topMargin: 15
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop

            ColumnLayout {
                id: controllerSection
                anchors.fill: parent
                /*!
                 *
                 */
                NEUMDIAL.RangedDial {
                    id: yawAngleController

                    enabled: true
                    hide: control.hide

                    Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                    Layout.preferredWidth: parent.width * 3/5
                    Layout.preferredHeight: width

                    Layout.maximumWidth: 400
                    Layout.maximumHeight: 400

                    accent: control.accent
                    background.color: control.color
                    from: -180
                    value: 0
                    to: 180
                    stepSize: 1

                    DoubleText {
                        id: yawValueIndicator
                        anchors.centerIn: parent
                        hide: parent.hide
                        rightText{
                            color: control.accent
                            text: yawAngleController.endValue
                        }

                        leftText {
                            text: yawAngleController.value
                            color: Qt.hsva (0,0,1-control.color.hsvValue,0.2)
                        }
                    }
                }
                /*!
                 *
                 */

                Item {
                    Layout.fillWidth: true
                    Layout.topMargin:20
                    Layout.bottomMargin:20

                    DoubleText {
                        id: rollValueIndicator

                        hide: rollAngleController.hide
                        anchors.centerIn: parent

                        rightText{
                            text: rollAngleController.value
                            color: control.accent
                        }

                        leftText {
                            text: rollAngleController.value
                            color: Qt.hsva (0,0,1-control.color.hsvValue,0.2)
                        }
                    }
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
                        NEUM.CircleButton {
                            Layout.preferredWidth:  defualtButtonWidth/2
                            Layout.preferredHeight: defualtButtonWidth/2
                            hide: rollAngleController.hide
                            background.color: control.color
                            text.text: '\uea9d'
                            text.font.family: icoFontRegular.name

                            onClicked: rollAngleController.currentIndex--
                            onPressAndHoldRpeater: rollAngleController.currentIndex--
                        }

                        NEUM.CustomTumbler {
                            id: rollAngleController

                            hide: control.hide
                            background.color: control.color
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.leftMargin: 10
                            Layout.rightMargin:10
                        }

                        NEUM.CircleButton {
                            Layout.preferredWidth:  defualtButtonWidth/2
                            Layout.preferredHeight: defualtButtonWidth/2
                            hide: rollAngleController.hide
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
                Item {
                    Layout.fillWidth: true
                    Layout.topMargin:20
                    Layout.bottomMargin:20

                    DoubleText {
                        id: pitchValueIndicator

                        anchors.centerIn: parent

                        hide: pitchAngleController.hide

                        rightText{
                            text: pitchAngleController.value;
                            color: control.accent
                        }

                        leftText {
                            text: pitchAngleController.value
                            color: Qt.hsva (0,0,1-control.color.hsvValue,0.2)
                        }
                    }
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
                        NEUM.CircleButton {
                            Layout.preferredWidth: defualtButtonWidth/2
                            Layout.preferredHeight: defualtButtonWidth/2

                            background.color: control.color
                            text.text: '\uea9d'
                            text.font.family: icoFontRegular.name
                            hide: pitchAngleController.hide

                            onClicked: pitchAngleController.currentIndex--
                            onPressAndHoldRpeater: pitchAngleController.currentIndex--
                        }

                        NEUM.CustomTumbler {
                            id: pitchAngleController

                            hide: control.hide || !footerSection.dockMode
                            background.color: control.color
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.leftMargin: 10
                            Layout.rightMargin:10
                        }

                        NEUM.CircleButton {
                            Layout.preferredWidth: defualtButtonWidth/2
                            Layout.preferredHeight: defualtButtonWidth/2

                            background.color: control.color
                            hide: pitchAngleController.hide
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

        Item {
            id: footerSection

            property bool dockMode: true
            property bool hide: control.hide

            Layout.fillWidth: true
            Layout.alignment: Qt.AlignBottom

            state: hide ? 'hide' :
                    dockMode ? 'dock' : 'show'

            states: [
                State {
                    name: "dock"
                    PropertyChanges {
                        target: footerSection
                        Layout.preferredHeight: control.defualtButtonWidth * 1.5 + 10
                    }
                },
                State {
                    name: "show"
                    PropertyChanges {
                        target: footerSection
                        Layout.preferredHeight: buttonList.grid.height + 30;
                    }
                },
                State {
                    name: "hide"
                    PropertyChanges {
                        target: footerSection
                        Layout.preferredHeight: 0
                    }
                }
            ]

            transitions:
                Transition {
                    NumberAnimation {
                        properties: 'preferredHeight'
                        duration: 300
                    }
                }


            CustomPane {
                id: buttonList

                anchors.fill: parent
                itemWidth: defualtButtonWidth
                color: control.color

                gridView: Grid {
                    id: buttonsGrid
                    spacing: defualtButtonWidth / 2
                    //columns: 3
                    NEUM.CircleButton {
                        width: defualtButtonWidth
                        hide: control.hide
                        background.color: control.color
                        text.text: '\uefd1'
                        text.font.family: icoFontRegular.name

                        onClicked: {
                            pitchAngleController.resetValue()
                            rollAngleController.resetValue()
                            yawAngleController.value = 0;
                            yawAngleController.endValue = 0;
                        }
                    }

                    NEUM.CircleButton {
                        id: darkModeToggleButton

                        property bool isDarkModeOn : false;

                        width: defualtButtonWidth
                        hide: control.hide
                        background.color: control.color
                        text.text: isDarkModeOn ? '\uef9e': '\uee7e';
                        text.font.family: icoFontRegular.name

                        onClicked: {
                            isDarkModeOn = !isDarkModeOn;
                            control.toggleDarkMode(isDarkModeOn);
                        }
                    }

                    NEUM.CircleButton {

                        width: defualtButtonWidth
                        hide: control.hide
                        checkable: true
                        background.color: control.color
                        text.text: '\uf020'
                        text.font.family: icoFontRegular.name

                        onClicked: {
                            checked = !checked
                            yawValueIndicator.toggle();
                            yawAngleController.toggle();
                            pitchValueIndicator.toggle();
                            rollValueIndicator.toggle();
                        }
                    }

                    NEUM.CircleButton {

                        width: defualtButtonWidth
                        hide: control.hide
                        //checkable: true
                        background.color: control.color

                        text {
                            text: '\ueaa1'
                            font.family: icoFontRegular.name
                            Behavior on rotation{
                                NumberAnimation{}
                            }
                        }

                        onClicked: {
                            checked = !checked;
                            text.rotation = checked ? -180 : 0;
                            //rollAngleController.hide   = checked ? true : false;
                            //pitchAngleController.hide  = checked ? true : false;
                            footerSection.dockMode = !checked;
                            yawValueIndicator.state
                        }
                    }

                    NEUM.CircleButton {
                        width: defualtButtonWidth
                        hide: control.hide
                        checkable: true
                        background.color: control.color
                        text.text: ' '
                        text.font.family: icoFontRegular.name

                        onClicked: {
                            checked = !checked
                        }
                    }
                }
            }
            DropShadow {
                anchors {
                    fill: buttonList
                }
                source: buttonList
                verticalOffset: -3
                radius: 10
                samples: 15
                color: Qt.hsla (0,0,control.color.hslLightness + 0.1)
                z:2
            }
        }
    }
}
