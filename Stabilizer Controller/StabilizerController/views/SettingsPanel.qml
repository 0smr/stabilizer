import QtQuick 2.0
import QtQuick 2.12
import QtGraphicalEffects 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12
import QtQuick.Extras 1.4

import io.stabilizer.opcode 1.0
import io.stabilizer.serialPort 1.0

import "../controls/NeumorphismStyle/Dial" as NeumDial
import "../controls/NeumorphismStyle" as Neum
import "../controls"

Item {
    id: control
    property color accent: Qt.hsva (0.6,1,1,0.7)
    property color color: Qt.hsla(0, 0, 0.9)
    property real  defualtButtonWidth: width/6 < 180 ? width/6 : 180
    property bool  hide: false

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
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }

}
