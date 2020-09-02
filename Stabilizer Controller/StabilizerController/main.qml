import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12

import io.stabilizer.serialPort 1.0

import 'controls/NeumorphismStyle/Dial'
import 'controls/NeumorphismStyle'
import 'views'

ApplicationWindow {
    id: window
    visible: true

    width: 240
    height: 520

    title: qsTr("Stabilizer Controller")
    color: controlPanel.color

    ControlPanel {
        id: controlPanel
        color: Qt.hsla(0, 0, 0.1)
        visible: false
    }

    StackView {
        id: stackView
        initialItem: controlPanel
        anchors.fill: parent
    }

    contentOrientation: Qt.Vertical
}
