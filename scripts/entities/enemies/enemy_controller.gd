extends Entity
class_name EnemyController

@export var enemy_data: EnemyData

var player_ref: Node2D = null
var is_player_detected: bool = false
var is_dead: bool = false
var visual: Node2D = null

@onready var detection_area: Area2D = $DetectionArea
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var state_machine: EnemyStateMachine = $EnemyStateMachine

func _ready() -> void:
    add_to_group("enemy")
    _resolve_visual()
    if enemy_data:
        stats = enemy_data.stats
        _apply_stats()
        _setup_detection_area()
        _setup_hitbox()
        _setup_health()
    hurtbox_component.hurt.connect(_on_hurt)
    health_component.health_depleted.connect(_on_health_depleted)
    _check_initial_player_detection()

func _resolve_visual() -> void:
    visual = $Sprite2D if has_node("Sprite2D") else null
    if not visual:
        visual = $AnimatedSprite2D if has_node("AnimatedSprite2D") else null

func _setup_detection_area() -> void:
    var shape := CircleShape2D.new()
    shape.radius = enemy_data.detection_range
    var collision_shape := detection_area.get_node_or_null("CollisionShape2D")
    if collision_shape:
        collision_shape.shape = shape
    detection_area.body_entered.connect(_on_detection_body_entered)
    detection_area.body_exited.connect(_on_detection_body_exited)

func _setup_hitbox() -> void:
    hitbox_component.damage = enemy_data.stats.strength if enemy_data.stats else 1
    var shape := CircleShape2D.new()
    shape.radius = enemy_data.attack_range
    var collision_shape := hitbox_component.get_node_or_null("CollisionShape2D")
    if collision_shape:
        collision_shape.shape = shape

func _setup_health() -> void:
    if enemy_data.stats:
        health_component.set_max_health(enemy_data.stats.max_hp)

func _check_initial_player_detection() -> void:
    for body in detection_area.get_overlapping_bodies():
        if body.is_in_group("player"):
            _on_detection_body_entered(body)
            return

func _on_detection_body_entered(body: Node2D) -> void:
    if not body.is_in_group("player"):
        return
    player_ref = body
    is_player_detected = true

func _on_detection_body_exited(body: Node2D) -> void:
    if body == player_ref:
        player_ref = null
        is_player_detected = false

func _on_hurt(_amount: int, _source: Node) -> void:
    if is_dead:
        return
    state_machine.transition("Hurt")

func _on_health_depleted() -> void:
    die()

func die() -> void:
    if is_dead:
        return
    is_dead = true
    state_machine.transition("Dead")

func _face_direction(direction: Vector2) -> void:
    if not visual:
        return
    if direction.x > 0:
        visual.scale.x = abs(visual.scale.x)
    elif direction.x < 0:
        visual.scale.x = -abs(visual.scale.x)
