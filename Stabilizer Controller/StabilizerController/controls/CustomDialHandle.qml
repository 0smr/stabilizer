import QtQuick 2.0

Item {
    id: control
    anchors.fill: parent

    property var color: "blue"//Qt.blue

    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true
        smooth: true

        onPaint: {
//            console.log(canvas.width,canvas.height);
//            ctx.globalCompositeOperation = "source-over";

//            ctx.lineWidth = 20;
//            ctx.lineWidth /= canvas.scale;

//            ctx.strokeStyle = "#ff000000";
//            ctx.createPattern("#ff000000", Qt.Dense5Pattern);

//            ctx.setLineDash([0.1, 0.6]);
//            ctx.arc(canvas.width/2, canvas.height/2, canvas.width*0.45, 6.2, Math.PI * 2, true);

//            Outer circle
//            ctx.stroke();

            var ctx = canvas.getContext('2d');
            var r = canvas.width/2;

            ctx.clearRect(0, 0, canvas.width, canvas.height);
            ctx.lineWidth = 3;
            ctx.lineCap = "round";



            for(var i = Math.PI * 3/4 ; i < Math.PI * 9/4  ; i+=0.05) {

                var xPos = r * Math.cos(i) + canvas.width/2;
                var yPos = r * Math.sin(i) + canvas.height/2;
                var r2 = r - 30 + 5 * Math.abs(Math.PI * 1.5 - i);
                var xPos1 = r2 * Math.cos(i) + canvas.width /2;
                var yPos2 = r2 * Math.sin(i) + canvas.height/2;

                ctx.moveTo(xPos, yPos);
                ctx.lineTo(xPos1, yPos2);
            }

            var gradient = ctx.createLinearGradient(canvas.width/2, 0, canvas.width/2, canvas.height/2+r);
            console.log(color.hslHue)
            gradient.addColorStop("0", Qt.hsla(color.hslHue,0.5,0.5,1));
            gradient.addColorStop("0.45", Qt.hsla(color.hslHue,0.6,0.5,0.5));
            gradient.addColorStop("1.0", Qt.hsla(color.hslHue,0.9,0.5,0));

            ctx.strokeStyle = gradient;

            ctx.stroke();
        }
    }
}
