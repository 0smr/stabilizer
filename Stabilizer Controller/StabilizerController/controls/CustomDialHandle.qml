import QtQuick 2.0

Item {
    id: control
    anchors.fill: parent

    property var color: 'purple'

    onColorChanged: {
        canvas.requestPaint();
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true
        smooth: true

        onPaint: {
            var ctx = canvas.getContext('2d');
            var r = canvas.width/2 - 20;
            ctx.reset();

            ctx.stroke();
            ctx.lineWidth = 2;
            ctx.lineCap = 'round';

            for(var i = Math.PI * 3/4 ; i <= Math.PI * 9/4  ; i+=0.2) {

                var xPos = r * Math.cos(i) + canvas.width/2;
                var yPos = r * Math.sin(i) + canvas.height/2;
                var diff = 5 - 2* Math.abs(Math.PI * 1.5 - i);

                ctx.moveTo(xPos, yPos);
                ctx.arc(xPos, yPos, diff, 0, 2 * Math.PI);
            }

            var gradient = ctx.createLinearGradient(canvas.width/2, canvas.height/2 -r, canvas.width/2, canvas.height/2+r);

            control.color.a = 1;
            gradient.addColorStop('0', control.color);
            control.color.a = 0.5;
            gradient.addColorStop('0.65', control.color);
            control.color.a = 0;
            gradient.addColorStop('1.0', control.color);

            ctx.strokeStyle = gradient;
            ctx.fillStyle = gradient;

            ctx.stroke();
            ctx.fill();
        }
    }
}
