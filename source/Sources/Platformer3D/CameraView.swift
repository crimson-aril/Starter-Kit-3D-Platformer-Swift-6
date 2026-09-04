import SwiftGodot
import Numerics

@Godot
class CameraView: Node3D {

    var cameraRotation = Vector3.zero
    var zoom = 10.0
    var camera: Camera3D?

    #exportGroup("Properties")
    @Export(.nodeType, "Player") var target: Player?

    #exportGroup("Zoom")
    @Export var minimumZoom: Double = 16
    @Export var maximumZoom: Double = 4
    @Export var zoomSpeed: Int = 10

    #exportGroup("Rotation")
    @Export var rotationSpeed: Int = 120

    // Trackpad / mouse sensitivity.
    var mouseSensitivity: Float = 0.15

    override func _ready() {
        camera = getNode(path: "Camera") as? Camera3D
        cameraRotation = rotationDegrees
    }

    override func _physicsProcess(delta: Double) {
        guard let target else {
            GD.pushError("CameraView does not hold a reference to the Target node!")
            return
        }

        guard let camera else {
            GD.pushError("CameraView does not hold a reference to the Camera node!")
            return
        }

        position = position.lerp(
            to: target.position,
            weight: delta * 4
        )

        rotationDegrees = rotationDegrees.lerp(
            to: cameraRotation,
            weight: delta * 6
        )

        camera.position = camera.position.lerp(
            to: Vector3(
                x: 0,
                y: 0,
                z: Float(zoom)
            ),
            weight: delta * 8
        )

        handleInput(delta: delta)
    }

    override func _input(event: InputEvent?) {
        guard let event else {
            return
        }

        // Trackpad / mouse movement.
        if let motion = event as? InputEventMouseMotion {

            let movement = motion.relative

            cameraRotation.y -= movement.x * mouseSensitivity
            cameraRotation.x -= movement.y * mouseSensitivity

            // Prevent the camera from flipping upside down.
            cameraRotation.x = cameraRotation.x.clamped(
                to: -80 ... -10
            )
        }
    }

    func handleInput(delta: Double) {
        var input = Vector3.zero

        // Keyboard / controller camera rotation.
        input.y = Float(
            Input.getAxis(
                negativeAction: "camera_left",
                positiveAction: "camera_right"
            )
        )

        input.x = Float(
            Input.getAxis(
                negativeAction: "camera_up",
                positiveAction: "camera_down"
            )
        )

        if input.length() > 0 {
            cameraRotation.y +=
                input.y * Float(rotationSpeed) * Float(delta)

            cameraRotation.x +=
                input.x * Float(rotationSpeed) * Float(delta)

            cameraRotation.x = cameraRotation.x.clamped(
                to: -80 ... -10
            )
        }

        // Zoom.
        let zoomInput = Input.getAxis(
            negativeAction: "zoom_in",
            positiveAction: "zoom_out"
        )

        zoom += zoomInput * Double(zoomSpeed) * delta

        zoom = zoom.clamped(
            to: maximumZoom ... minimumZoom
        )
    }
}