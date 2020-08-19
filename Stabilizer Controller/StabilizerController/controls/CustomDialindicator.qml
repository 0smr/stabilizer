import QtQuick 2.0
import QtGraphicalEffects 1.15
import QtQuick.Controls.Material 2.12

Item {
    id: control

    property var color: 'purple'
    property real angle: 0

    onColorChanged: {
        canvas.requestPaint();
    }

    onAngleChanged: {
        canvas.requestPaint();
    }

    Canvas {
        id: canvas

        property real radianAngle: control.angle * 0.0186
                            // 140 * Math.PI * 140/180
        anchors.fill: parent
        antialiasing: true
        smooth: true

        onPaint: {
            var ctx = canvas.getContext('2d');
            var radius = canvas.width/2 - 20;
            ctx.reset();

            ctx.lineWidth = 3;
            ctx.lineCap = 'round';
            ctx.arc(width/2,height/2 , radius , -Math.PI/2 , radianAngle-Math.PI/2 , radianAngle <= 0);
            var grd = context.createLinearGradient(canvas.width /2 , 0, canvas.width / 2 , canvas.height);
            grd.addColorStop(0, control.color);
            grd.addColorStop(1, '#2bedff');
            ctx.strokeStyle = grd;
            ctx.stroke();
        }
    }

    Rectangle {
        id: handle
        x: control.width/2 - width/2
        y: control.height/2 - (canvas.width/2 - 30)

        width: 2
        height: 10

        radius: width/2
        color: control.color

        transform:
            Rotation {
                angle: control.angle * 1.08
                origin{
                    y: canvas.width/2 - 30
                    x: handle.width/2
                }
            }
    }

    FastBlur{
        anchors.fill: canvas
        source: canvas
        radius: 20
    }
}
