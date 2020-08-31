import QtQuick 2.0



Item {
    id:control

    property alias backColor: background.backColor
    property alias background: background

    property var indicatorList: []

    function setBatteryStatus(value) {
        if( 0 <= value && value <= 6) {
            var i = 0
            while(i < value)
                indicatorList[i++].color = 'grey'

            while(i < 6)
                indicatorList[i++].color = 'Transparent'

            background.text.text = value <= 0 ? '\ueeb1':
                                   value <= 2 ? '\ueeb4':
                                   value <= 4 ? '\ueeb3' : '\ueeb2';

            return true;
        } else {
            return false;
        }
    }

    width: 60
    height: width

    NeumorphismCircleButton {
        id: background

        anchors.right: parent.right
        width: control.width * 2/3
        height: width

        text.text: '\ueeb1'
        text.font.family: 'IcoFont'
        text.font.pixelSize: width / 2
    }

    Component.onCompleted: {
        var cx = control.width - background.width / 2
        var cy = background.height / 2
        var rad = background.width - 5

        var comp = Qt.createComponent('BatteryIndicator.qml')
        var j = 0;

        for(var i = Math.PI/2 ; i <= 5/4 * Math.PI ; i += 0.4) {
            indicatorList[j++] = comp.createObject(control,{x: rad * Math.cos(i) + cx - 3,
                                                       y: rad * Math.sin(i) + cy - 3})
        }

        setBatteryStatus(2);
    }
}
