import QtQuick3D 1.15
import QtQuick 2.15

Node {
    id: scene
    eulerRotation.x: -0

    Model {
        id: rollHandle
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
        y: 2.38419e-07
        z: -1.86265e-09
        eulerRotation.z: -180
        eulerRotation.y: -180
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
