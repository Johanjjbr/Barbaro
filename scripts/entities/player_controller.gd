extends Entity
class_name PlayerController

@onready var health_component: HealthComponent = $HealthComponent

func _ready() -> void:
    add_to_group("player")

func _physics_process(_delta: float) -> void:
    if GameManager.current_state == GameManager.GameState.PAUSED:
        velocity = Vector2.ZERO
        return
    var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    velocity = direction * stats.move_speed
    move_and_slide()

func take_damage(amount: int) -> void:
    RunData.take_damage(amount)
