extends EnemyState
class_name HurtState

var hurt_timer: float = 0.0

func enter() -> void:
    hurt_timer = 0.15
    if actor.visual:
        actor.visual.modulate = Color(1, 0.3, 0.3, 1)

func exit() -> void:
    if actor.visual and not actor.visual.is_queued_for_deletion():
        actor.visual.modulate = Color(1, 1, 1, 1)

func update(delta: float) -> void:
    hurt_timer -= delta
    if hurt_timer <= 0:
        if actor.is_player_detected:
            finished.emit("Chase")
        else:
            finished.emit("Patrol")
