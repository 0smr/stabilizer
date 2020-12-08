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

    property color accent: Qt.hsva (0.6,1,1,0.7)
    property color color: Qt.hsla(0, 0, 0.9)
    property bool  hide: false
    property real  defualtButtonWidth: width/7 < 180 ? width/7 : 180

    readonly property real defultFontSize: defualtButtonWidth * 0.24
    readonly property alias settingButton : settingButton
    readonly property alias buttonList : settingButton
    readonly property alias darkModeButton: buttonList.darkModeToggleButton
    readonly property alias aRangeModeButton: buttonList.andvancedRangeModeButton

    /*
      initialized with an serial port instance.
      methods:

    */

    //SerialPort {
    //    id: serialPort
    //}

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
                    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                    Layout.leftMargin: 15
                    Layout.topMargin: 15
                }

                TimerStarter {
                    id: timerInput
                    Layout.fillWidth: true
                    color: value != '0' ? control.accent : Qt.hsva (0.9,1,1,0.7)
                    hide: control.hide || !buttonList.rangeModeButton.checked
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

        /*!
         *
         */

        NEUMDIAL.RangedDial {
            id: yawAngleController

            enabled: true
            hide: control.hide

            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            Layout.preferredWidth: parent.width * 0.6
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

                accent: control.accent
                anchors.centerIn: parent
                hide: parent.hide

                leftText {
                    text: yawAngleController.value
                    color: Qt.hsva (0,0,1-control.color.hsvValue,0.2)
                    font.pixelSize: defultFontSize
                }

                rightText{
                    color: control.accent
                    text: yawAngleController.endValue
                    font.pixelSize: defultFontSize
                }
            }
        }
        /*!
         *
         */

        Item {
            Layout.fillWidth: true
            Layout.topMargin:   defualtButtonWidth/2
            Layout.bottomMargin:defualtButtonWidth/2

            NEUM.CircleButton {
                id: timerStarter

                color: control.color
                hide: control.hide || !buttonList.rangeModeButton.checked
                text.text: checked? '\uec72':'\uec74'
                checkable: true

                text.font{
                    family: icoFontRegular.name
                    pixelSize: width * 0.4
                }
                width: defualtButtonWidth * 0.7

                anchors{
                    bottom: parent.top
                    left: parent.left
                    leftMargin: 10
                }

                onClicked: {
                    if (timerInput.value == '0') {
                        checked =! checked;
                        timerInput.focus = true;
                    }
                    else if (checked) {
                        var e1 = yawAngleController.startMovement(timerInput.value)
                        var e2 = rollAngleController.startMovement(timerInput.value);
                        var e3 = pitchAngleController.startMovement(timerInput.value);
                        if(e1 || e2 || e3) {
                            movementTimer.start();
                        } else {
                            checked =! checked;
                        }
                    }
                    else {
                        movementTimer.stop();
                        yawAngleController.stopMovement();
                        rollAngleController.stopMovement();
                        pitchAngleController.stopMovement();
                    }
                }

                Timer {
                    id: movementTimer
                    interval: timerInput.value + "000"
                    onTriggered: timerStarter.checked = false;
                }

                Timer {
                    interval: 1000
                    running: movementTimer.running && timerInput.value != '0'
                    repeat: true
                    onTriggered: timerInput.value = timerInput.value-1;
                }
            }

            DoubleText {
                id: rollValueIndicator

                accent: control.accent
                hide: rollAngleController.hide
                anchors.centerIn: parent
                checkable: true
                checked: rollAngleController.mode

                leftText {
                    text: rollAngleController.beginValue
                    color: Qt.hsva (0,0,1-control.color.hsvValue,0.2)
                    font.pixelSize: defultFontSize
                }

                rightText{
                    text: rollAngleController.endValue
                    color: control.accent
                    font.pixelSize: defultFontSize
                }

                onClicked: {
                    rollAngleController.toggleMode();
                }
            }
        }

        Item {
            Layout.leftMargin: 10
            Layout.rightMargin:10
            Layout.fillWidth: true
            Layout.preferredHeight: width * 0.25  - 29
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

                NEUM.RangedTumbler {
                    id: rollAngleController

                    hide: control.hide
                    background.color: control.color
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.leftMargin: 10
                    Layout.rightMargin:10

                    ticksColor: !mode ? '#999' : control.accent
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
            Layout.topMargin:       defualtButtonWidth/2
            Layout.bottomMargin:    defualtButtonWidth/2

            DoubleText {
                id: pitchValueIndicator

                anchors.centerIn: parent
                accent: control.accent
                checkable: true
                checked: pitchAngleController.mode
                hide: pitchAngleController.hide

                leftText {
                    text: pitchAngleController.beginValue;
                    color: Qt.hsva (0,0,1-control.color.hsvValue,0.2)
                    font.pixelSize: defultFontSize
                }

                rightText{
                    text: pitchAngleController.endValue
                    color: control.accent
                    font.pixelSize: defultFontSize
                }

                onClicked: {
                    pitchAngleController.toggleMode();
                }
            }
        }

        Item {
            Layout.leftMargin: 10
            Layout.rightMargin:10
            Layout.fillWidth: true
            Layout.maximumWidth: 300 + defualtButtonWidth
            Layout.preferredHeight: width * 0.25  - 29
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

                NEUM.RangedTumbler {
                    id: pitchAngleController

                    hide: control.hide //|| !footerSection.dockMode
                    background.color: control.color
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.leftMargin: 10
                    Layout.rightMargin:10

                    ticksColor: !mode ? '#999' : control.accent
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

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Item {
            id: footerSection

            Layout.fillWidth: true
            Layout.preferredHeight: 100
            Layout.alignment: Qt.AlignBottom | Qt.AlignLeft

            CustomPane {
                id: buttonList

                anchors.fill: parent
                itemWidth: defualtButtonWidth
                color: control.color
                hide: control.hide

                resetButton.onClicked: {
                    pitchAngleController.resetValue()
                    rollAngleController.resetValue()
                    yawAngleController.value = 0;
                    yawAngleController.endValue = 0;
                }

                rangeModeButton.onClicked: {
                    yawValueIndicator.toggle();
                    yawAngleController.toggle();
                    pitchValueIndicator.toggle();
                    rollValueIndicator.toggle();
                    timerInput.activeFocus();
                }

                lockPositionButton.onClicked: {
                }
            }
        }
    }
}
