import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import "NeumorphismStyle"

Page {
    id: control

    property bool hide: false
    property real itemWidth: 40
    property color color: Qt.hsla(0, 0, 0.9)

    property Component gridView: Grid { spacing: 5;  }

    readonly property alias grid: grid;

    clip: true
    background: Rectangle {
        id: back
        color: control.color
    }

    Column {
        anchors.fill: parent

        Flickable {
            id: scroll

            topMargin: 18
            width: parent.width
            height: parent.height

            //ScrollBar.vertical: ScrollBar { }

            interactive: false
            flickableDirection: Qt.Vertical

            contentWidth: width
            contentHeight: grid.height

            Item {
                anchors.horizontalCenter: parent.horizontalCenter
                width: grid.width
                height: childrenRect.height

                Loader {
                    id: grid
                    sourceComponent: control.gridView
                }
            }
        }
    }
}
