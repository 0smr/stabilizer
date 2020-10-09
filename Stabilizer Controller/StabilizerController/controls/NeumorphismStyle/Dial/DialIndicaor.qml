import QtQuick 2.12

Item {
    id: control

    property color color: '#fff'
    property real lineWidth: 1
    property real lineLength: 1

    onColorChanged: canvas.requestPaint()
    onLineWidthChanged: canvas.requestPaint()
    onLineLengthChanged: canvas.requestPaint()

    Canvas {
        id: canvas
        anchors.fill: parent

        onPaint: {
            var ctx = canvas.getContext('2d');
            var radius = canvas.width/2 - 5;
            ctx.reset();

            ctx.lineCap = 'round';
            ctx.lineWidth = control.lineWidth;
            ctx.strokeStyle = control.color;

            var i = -Math.PI/2;
            const [x1,y1] = getPoint(i,radius + 3)
            ctx.moveTo(x1,y1)
            const [x2,y2] = getPoint(i,radius - control.lineLength - 3)
            ctx.lineTo(x2,y2)

            for(i+=0.15; i <= 3/2 * Math.PI ; i+=0.15)
            {
                const [x1,y1] = getPoint(i,radius)
                ctx.moveTo(x1,y1)
                const [x2,y2] = getPoint(i,radius-control.lineLength)
                ctx.lineTo(x2,y2)
            }
            ctx.stroke();
        }

        function getPoint(angle,radius) {
            var x = radius * Math.cos(angle) + canvas.width/2;
            var y = radius * Math.sin(angle) + canvas.height/2;

            return [x,y];
        }
    }
}
