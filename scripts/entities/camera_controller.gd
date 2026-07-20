extends Camera2D
class_name CameraController

@export var smoothing_speed: float = 5.0
@export var default_zoom: Vector2 = Vector2(1, 1)

func _ready() -> void:
    make_current()
    position_smoothing_enabled = true
    position_smoothing_speed = smoothing_speed
    zoom = default_zoom
