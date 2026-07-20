extends EnemyState
class_name DeadState

func enter() -> void:
    actor.is_dead = true
    actor.velocity = Vector2.ZERO
    actor.set_physics_process(false)
    EventBus.combat.enemy_killed.emit(actor, null)
    _play_death()

func _play_death() -> void:
    var tween := actor.create_tween()
    if actor.visual:
        tween.tween_property(actor.visual, "modulate", Color(0.5, 0.3, 0.3, 0.5), 0.4)
    tween.tween_callback(actor.queue_free)
