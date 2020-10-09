import QtQuick 2.0

Item {
    id:control

    property alias color: background.color
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
                indicatorList[i++].cell = true

            while(i < 6)
                indicatorList[i++].cell = false

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

    CircleButton {
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
            indicatorList[j].width      = Qt.binding(()=>{ return control.width/10 });
            indicatorList[j].xRadius    = Qt.binding(()=>{ return control.cx });
            indicatorList[j].yRadius    = Qt.binding(()=>{ return control.cy });
            indicatorList[j].rad        = Qt.binding(()=>{ return control.rad });
            indicatorList[j].enabled    = Qt.binding(()=>{ return control.enabled });
            indicatorList[j].border.color
                                        = Qt.binding(()=>{ return Qt.hsva(0,0,1-control.color.hsvValue) });
            indicatorList[j].hide       = Qt.binding(()=>{ return control.hide });
            indicatorList[j].angle      = i
            j++;
        }

        setBatteryValue(0);
    }
}
