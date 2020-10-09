import QtQuick 2.0

CustomTumbler {
    id: control

    property real beginValue:   0
    property real endValue:  0
    property bool mode : false
    property real beginPoint: currentIndex
    property real endPoint: 0
    property real movementDuration: 10000

    function switchMode() {
        beginPoint  = !mode ? currentIndex  : beginPoint
        endPoint    =  mode ? currentIndex  : endPoint

    }

    function startMovement() {
        mode = !mode;
        rangeMovementAnimation.restart();
    }

    function stopMovement() {
        rangeMovementAnimation.stop();
    }

    NumberAnimation {
        id: rangeMovementAnimation

        target: control
        property: 'currentindex'
        duration: control.movementDuration
        from:   control.beginPoint
        to:     control.endPoint
    }
}
