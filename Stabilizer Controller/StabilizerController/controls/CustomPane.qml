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
    readonly property alias advancedRangeModeButton: advancedRangeModeButton

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

    //    Column {
    //        anchors.fill: parent

    //        Flickable {
    //            id: scroll

    //            topMargin: 18
    //            width: parent.width
    //            height: parent.height

    //            ScrollBar.vertical: ScrollBar { }

    //            //interactive: false
    //            flickableDirection: Qt.Vertical

    //            contentWidth: width
    //            contentHeight: grid.height


    Item {
        anchors.centerIn: parent

        width: buttonsGrid.width
        height: buttonsGrid.height

        Grid {
            id: buttonsGrid
            spacing: defualtButtonWidth / 2
            //columns: 3
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
                text.text: '\uf020'
                text.font.family: icoFontRegular.name
            }

            NEUM.CircleButton {
                id: advancedRangeModeButton

                width: defualtButtonWidth
                hide: control.hide
                checkable: true
                background.color: control.color
                text.text: '\uf02f'
                text.font.family: icoFontRegular.name
            }
        }
    }

    //        }
    //    }
}
