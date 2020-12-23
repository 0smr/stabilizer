import QtQuick 2.0
import QtQuick 2.12
import QtGraphicalEffects 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12
import QtQuick.Extras 1.4

import QtQuick.Scene3D 2.0
import QtQuick3D 1.15

import io.stabilizer.opcode 1.0
import io.stabilizer.serialPort 1.0

import "../controls/NeumorphismStyle/Dial" as NEUMDIAL
import "../controls/NeumorphismStyle" as NEUM
import "../resources/model" as MODEL
import "../controls" as CTRLS

Item {
    id: control
    property color accent: Qt.hsva (0.6,1,1,0.7)
    property color color: Qt.hsla(0, 0, 0.9)
    property bool  hide: false
    property real  defualtButtonWidth: width/6 < 180 ? width/6 : 180

    //    readonly property alias backButton : backButton
    readonly property alias backButton : backButton

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
                     * back button
                     *
                     *
                     */

                NEUM.CircleButton {
                    id: backButton

                    height: width
                    color: control.color
                    hide: control.hide
                    text.text: '\uea9d'
                    text.font.family: icoFontRegular.name

                    Layout.preferredWidth: defualtButtonWidth
                    Layout.preferredHeight: defualtButtonWidth
                    Layout.alignment: Qt.AlignTop
                    Layout.leftMargin: 15
                    Layout.topMargin: 15
                }
            }
        }

        Item {
            id: name
            Layout.alignment: Qt.AlignCenter

            width: 200
            height: 200

            Rectangle {
                anchors.fill: parent;border.color: 'gray';
                radius: width/2
                color: 'Transparent'
            }

//          Viewport for 3D content
            View3D {
                id: view
                anchors.fill: parent
                renderMode: View3D.Offscreen
                camera: camera

                DirectionalLight {
                    id: sun
                    x: 0
                    z: 30
                    eulerRotation.x: 170
                    eulerRotation.y: 40
                }

                DirectionalLight {
                    id: sun2
                    x: 0
                    z: 30
                    eulerRotation.x: 30
                    eulerRotation.y: 70
                }

                PerspectiveCamera {
                    id: camera
                    y: -40
                    z: -15
                    eulerRotation.x: 115
                    eulerRotation.z: 180
                    clipNear: 0.1
                    clipFar: 100
                    fieldOfView: 25         //zoom
                    fieldOfViewOrientation: Camera.Horizontal
                }

                MODEL.StabilizerModel {
                    id: stabilizerModel
                    x: xController.value
                    y: yController.value
                    z: zController.value
                }
            }
        }


        Item {
            Layout.fillWidth: true
            height: 150

            ColumnLayout {
                id: controls
                anchors.fill: parent

                CTRLS.CustomMultiRangeSlider {
                    id: xController

                    Layout.fillWidth:       true;
                    Layout.leftMargin:      10;
                    Layout.rightMargin:     10;
                    Layout.bottomMargin:    10;
                    height:     20;
                    from:       -180;
                    to:         +180;
                    stepSize:   1;
                }
                CTRLS.CustomMultiRangeSlider {
                    id: yController

                    Layout.fillWidth:       true;
                    Layout.leftMargin:      10;
                    Layout.rightMargin:     10;
                    Layout.bottomMargin:    10;
                    height:     20;
                    from:       -180;
                    to:         +180;
                    stepSize:   1;
                }
                CTRLS.CustomMultiRangeSlider {
                    id: zController

                    Layout.fillWidth:       true;
                    Layout.leftMargin:      10;
                    Layout.rightMargin:     10;
                    Layout.bottomMargin:    10;
                    height:     20;
                    from:       -180;
                    to:         +180;
                    stepSize:   1;
                }
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
        Item {
            //Layout.fillHeight: true
            Layout.fillWidth: true
            height: 100

            RowLayout {
                anchors.fill: parent

                NEUM.CircleButton {
                    Layout.preferredWidth: defualtButtonWidth
                    Layout.preferredHeight: defualtButtonWidth
                    Layout.alignment: Qt.AlignCenter

                    background.color: control.color
                    hide: control.hide
                    text.text: '\uefc2'
                    text.font.family: icoFontRegular.name

                    onClicked: {
                        xController.setPoint();
                        yController.setPoint();
                        zController.setPoint();
                    }
                }
                NEUM.CircleButton {
                    Layout.preferredWidth: defualtButtonWidth
                    Layout.preferredHeight: defualtButtonWidth
                    Layout.alignment: Qt.AlignCenter

                    background.color: control.color
                    hide: control.hide
                    text.text: '\uea69'
                    text.font.family: icoFontRegular.name

                    onClicked: {
                        xController.startMovement();
                        yController.startMovement();
                        zController.startMovement();
                    }
                }
                NEUM.CircleButton {
                    Layout.preferredWidth: defualtButtonWidth
                    Layout.preferredHeight: defualtButtonWidth
                    Layout.alignment: Qt.AlignCenter

                    background.color: control.color
                    hide: control.hide
                    text.text: '\uefd1'
                    text.font.family: icoFontRegular.name

                    onClicked: {
                        xController.reset();
                        yController.reset();
                        zController.reset();
                        xController.value = 0;
                        yController.value = 0;
                        zController.value = 0;
                    }
                }
            }
        }
    }
}
