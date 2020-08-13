import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12

import 'controls'
import 'views'

ApplicationWindow {
    id: window
    visible: true

    width: 340
    height: 580
    title: qsTr("Stack")

    color: 'red'

    header: Rectangle {

        height: 30
        width: window.width

        RowLayout {
            anchors.fill: parent

            HambergerToggle {
                id: toolToggleButton
                width: parent.height - 5

                Layout.alignment: Qt.AlignHCenter | Qt.AlignLeft
                Layout.leftMargin: 5
            }
            Rectangle {

                Layout.fillWidth: true
            }

            IconButton {
                id: aboutButton
                text: '\uefe2'
                height: parent.height
                width: height
            }

            IconButton {
                id: toolButton
                text: '\uef19'
                height: parent.height
                width: height
            }
        }
    }

    Column {
        anchors.fill: parent

        ItemDelegate {
            text: qsTr("Page 1")
            width: parent.width
            onClicked: {
                // stackView.push("Page1Form.ui.qml")
                // drawer.close()
            }
        }
    }

    StackView {
        id: stackView

        anchors.fill: parent
    }
}
