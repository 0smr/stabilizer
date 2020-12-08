import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import "NeumorphismStyle" as NEUM

Item {
    id: control

    property bool hide: false
    property real itemWidth: 40
    property color color: Qt.hsla(0, 0, 0.9)

    readonly property alias resetButton: resetButton
    readonly property alias darkModeToggleButton: darkModeToggleButton
    readonly property alias rangeModeButton: rangeModeButton
    readonly property alias lockPositionButton: lockPositionButton
    readonly property alias andvancedRangeModeButton: andvancedRangeModeButton

    //    clip: true
    //    background: Rectangle {
    //        id: back
    //        color: control.color
    //    }

    FontLoader {
        id: icoFontRegular
        source: 'qrc:/resources/fonts/icofont.ttf'
    }
    FontLoader {
        id: dsDigitalRegular
        source: 'qrc:/resources/fonts/DS-DIGI.TTF'
    }

    Flickable {
        id: scroll

        topMargin: 18
        width: parent.width
        height: parent.height

        ScrollBar.horizontal: ScrollBar { }

        //interactive: false
        flickableDirection: Qt.Horizontal

        contentWidth: width
        contentHeight: buttonsGrid.height


        Item {
            anchors.centerIn: parent

            width: buttonsGrid.width
            height: buttonsGrid.height

            Row {
                id: buttonsGrid
                spacing: defualtButtonWidth / 2
                NEUM.CircleButton {
                    id: resetButton
                    width: defualtButtonWidth
                    hide: control.hide
                    background.color: control.color
                    text.text: '\uefd1'
                    text.font.family: icoFontRegular.name
                }

                NEUM.CircleButton {
                    id: darkModeToggleButton

                    width: defualtButtonWidth
                    hide: control.hide
                    background.color: control.color
                    text.text: checked ? '\uef9e': '\uee7e';
                    text.font.family: icoFontRegular.name
                }

                NEUM.CircleButton {
                    id: rangeModeButton

                    width: defualtButtonWidth
                    hide: control.hide
                    checkable: true
                    background.color: control.color
                    text.text: '\uef0c'
                    text.font.family: icoFontRegular.name
                }

                NEUM.CircleButton {
                    id: lockPositionButton

                    width: defualtButtonWidth
                    hide: control.hide
                    checkable: true
                    background.color: control.color
                    text.text: checked ? '\uef7a': '\uf01a';
                    text.font.family: icoFontRegular.name
                }

                NEUM.CircleButton {
                    id: andvancedRangeModeButton

                    width: defualtButtonWidth
                    hide: control.hide
                    background.color: control.color
                    text.text: '\uf020'
                    text.font.family: icoFontRegular.name
                }
            }
        }

    }
}
