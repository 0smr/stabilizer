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

import "../controls/NeumorphismStyle/Dial" as NeumDial
import "../controls/NeumorphismStyle" as Neum
import "../resources/model" as MODEL
import "../controls"

Item {
    id: control
    property color accent: Qt.hsva (0.6,1,1,0.7)
    property color color: Qt.hsla(0, 0, 0.9)
    property real  defualtButtonWidth: width/6 < 180 ? width/6 : 180
    property bool  hide: false

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

                Neum.CircleButton {
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
                anchors.fill: parent;border.color: 'red';
                radius: width/2
                color: 'Transparent'
            }

//          Viewport for 3D content
            View3D {
                id: view
                anchors.fill: parent
                renderMode: View3D.Overlay
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
                }
            }
        }


        Rectangle {
            Layout.fillWidth: true
            height: 150

            ColumnLayout {
                id: controls
                anchors.fill: parent

                Slider {
                    Layout.fillWidth:true
                }
                Slider {
                    Layout.fillWidth:true
                }
                Slider {
                    Layout.fillWidth:true
                }
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }
}
