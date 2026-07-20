extends EnemyState
class_name PatrolState

var wander_position: Vector2
var wander_timer: float = 0.0

func enter() -> void:
    wander_position = actor.global_position + Vector2(randf_range(-64.0, 64.0), randf_range(-64.0, 64.0))
    wander_timer = randf_range(1.0, 2.5)

func update(delta: float) -> void:
    if actor.is_player_detected:
        finished.emit("Chase")
        return
    wander_timer -= delta
    if wander_timer <= 0:
        finished.emit("Idle")

func physics_update(delta: float) -> void:
    var direction: Vector2 = actor.global_position.direction_to(wander_position)
    var distance: float = actor.global_position.distance_to(wander_position)
    if distance < 8.0:
        finished.emit("Idle")
        return
    actor.velocity = direction * actor.stats.move_speed * 0.5
    actor.move_and_slide()
