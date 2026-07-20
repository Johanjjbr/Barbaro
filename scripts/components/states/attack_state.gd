extends EnemyState
class_name AttackState

var cooldown_timer: float = 0.0
var has_attacked: bool = false

func enter() -> void:
    has_attacked = false
    cooldown_timer = 0.0
    _perform_attack()

func update(delta: float) -> void:
    if not actor.is_player_detected or not is_instance_valid(actor.player_ref):
        finished.emit("Chase")
        return
    var distance: float = actor.global_position.distance_to(actor.player_ref.global_position)
    if distance > actor.enemy_data.attack_range * 1.2:
        finished.emit("Chase")
        return
    cooldown_timer -= delta
    if cooldown_timer <= 0:
        _perform_attack()

func _perform_attack() -> void:
    if actor.is_dead:
        return
    var targets := actor.hitbox_component.get_targets()
    if targets.is_empty():
        finished.emit("Chase")
        return
    EventBus.combat.attack_started.emit(actor, targets[0])
    for target in targets:
        DamageSystem.apply_hit(target, actor.hitbox_component.damage, actor)
    cooldown_timer = actor.enemy_data.attack_cooldown
