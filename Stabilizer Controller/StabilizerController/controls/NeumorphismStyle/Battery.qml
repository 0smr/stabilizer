import QtQuick 2.0

Item {
    id:control

    property alias backColor: background.backColor
    property alias background: background
    property alias hide: background.hide

    property real cx  : control.width - background.width / 2
    property real cy  : background.height / 2
    property real rad : background.width - 5

    property var indicatorList: []

    function setBatteryValue(value) {
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

        enabled: parent.enabled
    }

    Component.onCompleted: {

        var comp = Qt.createComponent('BatteryIndicator.qml')
        var i = 0;

        for( ; i < 6 ; i++) {
            indicatorList[i] = comp.createObject(control);
        }

        var j = 0;

        for( i = Math.PI/2 ; i <= 5/4 * Math.PI ; i += 0.4) {
            indicatorList[j].width    = Qt.binding(()=>{ return control.width/10 });
            indicatorList[j].xRadius  = Qt.binding(()=>{ return cx });
            indicatorList[j].yRadius  = Qt.binding(()=>{ return cy });
            indicatorList[j].rad      = Qt.binding(()=>{ return rad });
            indicatorList[j].border.color
                                      = Qt.binding(()=>{ return backColor });
            indicatorList[j].angle    = i
            j++;

        }

        setBatteryValue(0);
    }
}
