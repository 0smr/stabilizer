import QtQuick 2.12
import QtQuick.Controls 1.2 as QQC1
import QtQuick.Controls 2.12 as QQC2
import QtQuick.Controls.Private 1.0
import QtQuick.Controls.Styles 1.1
import QtQuick.Extras 1.4
import QtQuick.Extras.Private 1.0

Control{
    id: control

    property alias  from:           range.minimumValue;
    property alias  to:             range.maximumValue;
    property alias  value:          range.value;
    property alias  stepSize:       range.stepSize;
    property real   visualPosition: range.position;
    property color  color:          'gray';
    property alias  pressed:        mouseArea.pressed;
    property var    handleList:     []
    property var    durationList:   []


    width: 200;
    height: 20;

    Rectangle {
        id: background;

        anchors.verticalCenter: control.verticalCenter;
        color:  "gray";
        width:  control.width;
        height: 1;
    }

    Rectangle {
        id: handle

        x: control.visualPosition - width/2;
        height: control.height;
        width: 5;
        radius: width/2;
        color: control.pressed ? "#f0f0f0" : "#f6f6f6"
        z: 11

        QQC2.ToolTip {
            parent: handle;
            visible: control.pressed;
            background: Rectangle {color: 'Transparent'}
            contentItem: Text {
                color: Qt.hsla(0,0,1-control.color.hslLightness,0.9)
                font.pixelSize: handle.width * 3
                text: control.value;
            }
        }
    }

    RangeModel {
        id: range;
        minimumValue: 0.0;
        maximumValue: 1.0;
        positionAtMinimum: 0;
        positionAtMaximum: control.width;
        stepSize: 0.1;
        value: 0;
    }

    MouseArea {
        id: mouseArea
        anchors.fill: control;

        onMouseXChanged: {
            if(pressed && containsMouse) {
                range.position = mouseX;
            }
        }
    }

    Repeater {
        model:3
        z: 10
        Rectangle{x:(1+index)*0.25*parent.width;
            height: parent.height/2;
            width: 1;
            color: 'gray';
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    NumberAnimation {
        id: valueNumAnim
        target:     control
        property:   'value'
        duration:   200
        from:       0
        to:         0

        onStopped: {
            startMovement();
        }
    }

    property real i: 0
    property real j: 0

    function setPoint() {
        var comp = Qt.createComponent('RangeHandle.qml');
        var object = comp.createObject(control);
        object.height = control.height * 0.75;
        object.anchors.verticalCenter = control.verticalCenter;
        object.setPos(control.visualPosition,control.value,i+1);
        object.tColor = Qt.binding(()=>{ return control.color });
        //object.z = 11;
        handleList[i] = object;
        i++;
    }

    function reset() {
        for(i = 0 ; i < handleList.length ; ++i)
            handleList[i].destroy();
        handleList = []
        i = 0;
    }

    function startMovement() {
        if(j >= handleList.length-1)
        {
            j = 0;
            return false;
        }
        valueNumAnim.from   = handleList[j  ].value;
        valueNumAnim.to     = handleList[j+1].value;
        valueNumAnim.duration
                            = 2500;
        valueNumAnim.start();
        j++;
        return true;
    }
}
