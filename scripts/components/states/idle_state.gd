extends EnemyState
class_name IdleState

var idle_timer: float = 0.0

func enter() -> void:
    idle_timer = randf_range(1.0, 3.0)

func update(delta: float) -> void:
    idle_timer -= delta
    if actor.is_player_detected:
        finished.emit("Chase")
        return
    if idle_timer <= 0:
        finished.emit("Patrol")
