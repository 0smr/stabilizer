echo off
"C:/Qt/5.15.0/mingw81_64/bin/balsam.exe" stabilizer.dae -o  "../../Stabilizer Controller/StabilizerController/resources/model/"
cd "../../Stabilizer Controller/StabilizerController/resources/model/"
del StabilizerModel.qml
ren Stabilizer.qml StabilizerModel.qml
pause