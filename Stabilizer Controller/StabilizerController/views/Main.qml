import QtQuick 2.0
import QtGraphicalEffects 1.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Extras 1.4

import io.stabilizer.opcode 1.0

import "../controls"

Item {
    id: control

    property var color: 'purple'
    property var serialPortAPI: null
    property var pathMoveDuration: 10000
    /*
      initialized with an serial port instance.
      methods:

    */

    ColumnLayout {
        id: mainSection
        anchors.fill: parent

        ColumnLayout {
            id: controllerSection

            Layout.fillWidth: true

            Item {
                RowLayout {

                    anchors.fill: parent

                    Item {
                        //reserved
                        width: pitchController.width
                        visible: false
                    }

                    CustomDial {
                        id: yawController

                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignTop
                        snapMode: "SnapAlways"

                        color: Material.accent

                        onValueChanged: {
                            serialPortAPI.setYawValue(value);
                        }

                        duration: pathMoveDuration

                        //enabled: serialPortAPI.connected
                    }
                    ColumnLayout {
                        Button {
                            id: pitchControllerIncreament
                            text: '\ueaa1'
                            font.family: 'IcoFont'
                            enabled: rollController.enabled

                            Material.background: 'Transparent'
                            Material.foreground: Material.accent
                            Material.elevation: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 25
                            Layout.alignment: Qt.AlignHCenter

                            onClicked: {
                                pitchController.value ++
                                pitchController.tooltip.show(pitchController.value)
                            }
                        }

                        Slider {
                            id: pitchController

                            from: -90
                            value: 0
                            to: 90
                            stepSize: 1

                            orientation: Qt.Vertical
                            Layout.alignment: Qt.AlignHCenter
                            snapMode: Slider.SnapAlways

                            handle.z: 1

                            property real startPoint : 0
                            property real endPoint : 0

                            function setStartPoint() {
                                startPoint = pitchController.value
                                endPointIndicator.visible = true;
                                endPointIndicator.visualPosition = visualPosition;
                                endPointIndicator.appearAnim.start();
                            }

                            function setEndPoint() {
                                endPoint = pitchController .value;
                                endPointIndicator.visualPosition = visualPosition;
                                endPointIndicator.appearAnim.start();

                                moveToDestAnim.start()
                            }

                            property var tooltip: ToolTip {
                                parent: pitchController.handle
                                visible: pitchController.pressed
                                text: Math.floor(pitchController.value)
                            }

                            property var endPointIndicator: Rectangle {
                                property real visualPosition: 0
                                x: parent.leftPadding + parent.availableWidth / 2 - width /2
                                y: parent.topPadding + visualPosition * (parent.availableHeight - height + 2) - 1
                                width: 15
                                height: width
                                radius: width/2
                                parent: pitchController
                                visible: false
                                border.color: control.Material.accent

                                property var appearAnim: NumberAnimation {
                                    target: pitchController.endPointIndicator
                                    properties: "width"
                                    from: 0
                                    to: 15
                                    duration: 200
                                }
                            }

                            property var moveToDestAnim: NumberAnimation {
                                target: pitchController
                                from: pitchController.startPoint
                                to: pitchController.endPoint
                                property: "value"
                                easing.type: Easing.Linear
                                duration: control.pathMoveDuration

                                onStopped: {
                                    pitchController.endPointIndicator.visible = false;
                                    pitchController.endPointIndicator.visualPosition = 0;
                                }
                            }

                            onValueChanged: {
                                serialPortAPI.setPitchValue(value);
                            }
                        }

                        Button {
                            id: pitchControllerDecreament
                            text: '\uea99'
                            font.family: 'IcoFont'
                            enabled: rollController.enabled

                            Material.background: 'Transparent'
                            Material.foreground: Material.accent
                            Material.elevation: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 25
                            Layout.alignment: Qt.AlignHCenter

                            onClicked: {
                                pitchController.value --
                                pitchController.tooltip.show(pitchController.value)
                            }
                        }
                    }

                }

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                height: 300
            }

            Item {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                height: 50

                RowLayout {
                    anchors.fill: parent
                    Button {
                        id: rollControllerDecreament
                        text: '\uea9d'
                        font.family: 'IcoFont'
                        enabled: rollController.enabled

                        Material.background: 'Transparent'
                        Material.foreground: Material.accent
                        Material.elevation: 1
                        Layout.preferredHeight: 35
                        Layout.preferredWidth: 25
                        Layout.leftMargin: 5

                        onClicked: {
                            rollController.value--
                            rollController.tooltip.show(rollController.value)
                        }
                    }

                    Slider {
                        id: rollController
                        from: -90
                        value: 0
                        to: 90
                        stepSize: 1

                        Layout.fillWidth: true

                        handle.z: 1

                        property real startPoint : 0
                        property real endPoint : 0

                        function setStartPoint() {
                            startPoint = rollController.value
                            endPointIndicator.visible = true;
                            endPointIndicator.visualPosition = visualPosition;
                            endPointIndicator.appearAnim.start();
                        }

                        function setEndPoint() {
                            endPoint = rollController.value;
                            endPointIndicator.visualPosition = visualPosition;
                            endPointIndicator.appearAnim.start();

                            moveToDestAnim.start()
                        }

                        property var tooltip: ToolTip {
                            parent: rollController.handle
                            visible: rollController.pressed
                            text: Math.floor(rollController.value)
                        }

                        property var endPointIndicator: Rectangle {
                            property real visualPosition: 0
                            x: parent.leftPadding + visualPosition * (parent.availableWidth - width + 2) - 1
                            y: parent.topPadding + parent.availableHeight / 2 - height /2
                            width: 15
                            height: width
                            radius: width/2
                            parent: rollController
                            visible: false
                            border.color: control.Material.accent

                            property var appearAnim: NumberAnimation {
                                target: rollController.endPointIndicator
                                properties: "width"
                                from: 0
                                to: 15
                                duration: 200
                            }
                        }

                        property var moveToDestAnim: NumberAnimation {
                            target: rollController
                            from: rollController.startPoint
                            to: rollController.endPoint
                            property: "value"
                            easing.type: Easing.Linear
                            duration: control.pathMoveDuration

                            onStopped: {
                                rollController.endPointIndicator.visible = false;
                                rollController.endPointIndicator.visualPosition = 0;
                            }
                        }

                        onValueChanged: {
                            serialPortAPI.setRollValue(value);
                        }
                    }

                    Button {
                        id: rollControllerIncreament
                        text: '\ueaa0'
                        font.family: 'IcoFont'
                        enabled: true

                        Material.background: 'Transparent'
                        Material.foreground: Material.accent
                        Material.elevation: 1
                        Layout.preferredHeight: 35
                        Layout.preferredWidth: 25
                        Layout.rightMargin: 5

                        onClicked: {
                            rollController.value ++
                            rollController.tooltip.show(rollController.value)
                        }
                    }
                }
            }

            RowLayout {

                width: control.width
                height: 50
                Button {
                    id: resetButton
                    text: '\uefd1'
                    font.family: 'IcoFont'
                    enabled: rollController.enabled

                    Material.background: 'Transparent'
                    Material.foreground: Material.accent
                    Material.elevation: 1

                    Layout.alignment: Qt.AlignCenter
                    Layout.preferredWidth: height

                    ToolTip.text: 'reset button'
                    ToolTip.visible: hovered
                    property var animation : NumberAnimation {
                        target: resetButton.contentItem
                        property: "rotation"
                        duration: 1000
                        easing.type: Easing.OutCubic
                        from: 0
                        to: 360
                    }

                    onClicked: {
                        animation.start()
                        yawController.value = 0;
                        pitchController.value = 0;
                        rollController.value = 0;
                    }
                }

                Button {
                    id: pathMode
                    text: '\uf020'
                    font.family: 'IcoFont'
                    font.pixelSize: 20

                    Material.background: 'Transparent'
                    Material.foreground: Material.accent
                    Material.elevation: 1

                    Layout.alignment: Qt.AlignCenter
                    Layout.preferredWidth: height

                    ToolTip.text: 'slow mode'
                    ToolTip.visible: hovered

                    checkable: true

                    Rectangle {
                        id: statusRect
                        anchors.centerIn: parent
                        color: Material.accent
                        height: width
                        radius: width/2-2
                        z: 0
                    }
                    property var appearStatusRectAnim: NumberAnimation {
                        target: statusRect
                        properties: "width"
                        from: 0
                        to: control.height*2.5
                        duration: 1000
                        easing.type: Easing.InOutQuad
                    }

                    property var fadeStatusRectAnim: NumberAnimation {
                        target: statusRect
                        properties: "opacity"
                        to: 0
                    }

                    onToggled: {

                        if(checked === true)
                        {
                            statusRect.opacity = 0.1;
                            appearStatusRectAnim.start();

                            yawController.setStartPoint();
                            rollController.setStartPoint();
                            pitchController.setStartPoint();
                        }
                        else
                        {
                            fadeStatusRectAnim.start();

                            yawController.setEndPoint();
                            rollController.setEndPoint();
                            pitchController.setEndPoint();
                        }
                    }
                }

                Button {
                    //id: rollControllerIncreament
                    text: checked ? '\uec61':'\uec8c';
                    font.family: 'IcoFont'
                    enabled: true
                    checkable: true

                    Material.background: 'Transparent'
                    Material.foreground: Material.accent
                    Material.elevation: 1
                    Layout.alignment: Qt.AlignCenter
                    Layout.preferredWidth: height

                    ToolTip.text: 'lock'
                    ToolTip.visible: hovered

                    onClicked: {

                    }
                }

                Button {
                    //id: rollControllerIncreament
                    text: '\uec42'
                    font.family: 'IcoFont'
                    enabled: false

                    Material.background: 'Transparent'
                    Material.foreground: Material.accent
                    Material.elevation: 1
                    Layout.preferredWidth: height
                    Layout.alignment: Qt.AlignCenter

                    ToolTip.text: 'bluetooth'
                    ToolTip.visible: hovered

                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Pane {
            id: toolsPan
            Layout.fillWidth: true
            visible: false

            Material.elevation: 1
        }
    }

    //Material.accent: Material.Grey
}
