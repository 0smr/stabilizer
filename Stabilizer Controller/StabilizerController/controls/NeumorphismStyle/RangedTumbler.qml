import QtQuick 2.0

CustomTumbler {
    id: control

    property real beginValue : value
    property real endValue : 0
    property bool mode : false
    property real beginPoint: currentIndex;
    property real endPoint: 180;
    property real movementDuration: 10000

    function toggleMode() {
        mode = !mode;

        if (!mode) {
            endValue    =   endValue
            endPoint    =   endPoint
            currentIndex=   beginPoint
            beginValue  =   Qt.binding(()=>{return value;})
            beginPoint  =   Qt.binding(()=>{return currentIndex;})
        }
        else {
            beginValue  =   beginValue
            beginPoint  =   beginPoint
            currentIndex=   endPoint
            endValue    =   Qt.binding(()=>{return value;})
            endPoint    =   Qt.binding(()=>{return currentIndex;})
        }
    }

    function startMovement(duration) {
        if(beginPoint != endPoint) {
            if (mode)
                toggleMode();
            movementDuration = duration + "000"
            rangeMovementAnimation.restart();
            return true;
        }
        else {
            return false
        }
    }

    function stopMovement() {
        rangeMovementAnimation.stop();
    }

    NumberAnimation {
        id: rangeMovementAnimation

        target: control
        property: 'currentIndex'//'instantIndex'
        duration: control.movementDuration
        from:   control.beginPoint
        to:     control.endPoint
    }
}
