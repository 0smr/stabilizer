import QtQuick 2.0
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0

Dial {
    id: control

    from:-90
    to:90

    value: 0
    height: 75
    width: height*1.5

    background:
        Rectangle {    }

    handle:
        Rectangle {    }
}
