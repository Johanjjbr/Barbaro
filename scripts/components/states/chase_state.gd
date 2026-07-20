extends EnemyState
class_name ChaseState

var lost_sight_timer: float = 0.0

func enter() -> void:
    lost_sight_timer = 0.0

func update(delta: float) -> void:
    if not actor.is_player_detected or not is_instance_valid(actor.player_ref):
        lost_sight_timer += delta
        if lost_sight_timer >= 2.0:
            finished.emit("Patrol")
            return
    else:
        lost_sight_timer = 0.0
        var distance: float = actor.global_position.distance_to(actor.player_ref.global_position)
        if distance <= actor.enemy_data.attack_range:
            finished.emit("Attack")

func physics_update(delta: float) -> void:
    if not actor.is_player_detected or not is_instance_valid(actor.player_ref):
        return
    var direction: Vector2 = actor.global_position.direction_to(actor.player_ref.global_position)
    actor.velocity = direction * actor.stats.move_speed * actor.enemy_data.chase_speed_modifier
    actor.move_and_slide()
    actor._face_direction(direction)
