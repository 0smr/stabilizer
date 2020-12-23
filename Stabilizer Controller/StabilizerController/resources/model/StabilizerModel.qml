import QtQuick3D 1.15
import QtQuick 2.15
import QtQuick.Scene3D 2.0
//import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Extras 2.0

Node {
    id: scene

    property real x:0;
    property real y:0;
    property real z:0;

    eulerRotation.z: z

    Model {
        id: rollHandle
        eulerRotation.x: scene.x
        eulerRotation.y: scene.y
        eulerRotation.z: -180
        scale.x: 1.1
        scale.y: 1.1
        scale.z: 1.5
        source: "meshes/rollHandle.mesh"

        DefaultMaterial {
            id: material_material
            diffuseColor: "#ffebebeb"
        }
        materials: [
            material_material
        ]
    }

    Model {
        id: pitchHandle
        y: 0
        z: 0
        eulerRotation.z: -180
        eulerRotation.y: -180 + scene.y
        scale.x: 7.5
        scale.y: 7.5
        scale.z: 8
        source: "meshes/pitchHandle.mesh"
        materials: [
            material_material
        ]
    }

    Model {
        id: yawHandle
        eulerRotation.x: 0
        eulerRotation.y: -90
        eulerRotation.z: -180
        scale.x: 10
        scale.y: 10
        scale.z: 8
        source: "meshes/yawHandle.mesh"
        materials: [
            material_material
        ]
    }

}
