extends CharacterBody2D

const SPEED = 200.0
const ATTACK_COOLDOWN = 0.5
const HEAVY_ATTACK_COOLDOWN = 1.5
const HEAVY_ATTACK_COST = 20

var attack_cooldown_timer: float = 0.0
var heavy_cooldown_timer: float = 0.0
var can_attack: bool = true
var can_heavy: bool = true
var is_attacking: bool = false
var attack_timer: float = 0.0
var input_enabled: bool = true
var is_paused: bool = false

@onready var sprite = $PlayerSprite
@onready var attack_area = $AttackArea
@onready var weapon_sprite = $PlayerSprite/WeaponSprite

var move_direction: Vector2 = Vector2.ZERO


func _ready():
	add_to_group("player")
	attack_area.body_entered.connect(_on_attack_hit)


func _process(delta):
	if GameManager.current_state == GameManager.GameState.PAUSED:
		return
	_handle_timers(delta)
	_handle_attack_animation(delta)
	if Input.is_action_just_pressed("ui_cancel"):
		GameManager.toggle_pause()
		return


func _physics_process(delta):
	if GameManager.current_state == GameManager.GameState.PAUSED:
		velocity = Vector2.ZERO
		return
	_handle_movement()


func _handle_movement():
	move_direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()
	if is_attacking:
		velocity = move_direction * SPEED * 0.5
	else:
		velocity = move_direction * SPEED
	if move_direction.x != 0:
		sprite.scale.x = sign(move_direction.x)
		attack_area.position.x = 20 * sign(move_direction.x)
		weapon_sprite.position.x = 16 * sign(move_direction.x)
		weapon_sprite.scale.x = sign(move_direction.x)
	move_and_slide()


func _handle_timers(delta):
	if not can_attack:
		attack_cooldown_timer -= delta
		if attack_cooldown_timer <= 0:
			can_attack = true
	if not can_heavy:
		heavy_cooldown_timer -= delta
		if heavy_cooldown_timer <= 0:
			can_heavy = true


func _handle_attack_animation(delta):
	if is_attacking:
		attack_timer -= delta
		if attack_timer <= 0:
			is_attacking = false
			attack_area.get_node("CollisionShape2D").disabled = true


func _unhandled_input(event):
	if GameManager.current_state == GameManager.GameState.PAUSED:
		return
	if event.is_action_pressed("attack"):
		_perform_attack()
	elif event.is_action_pressed("heavy_attack"):
		_perform_heavy_attack()
	elif event.is_action_pressed("skill_1"):
		_use_skill("bash")
	elif event.is_action_pressed("skill_2"):
		_use_skill("roar")


func _perform_attack():
	if not can_attack or is_attacking:
		return
	can_attack = false
	attack_cooldown_timer = ATTACK_COOLDOWN
	is_attacking = true
	attack_timer = 0.2
	attack_area.get_node("CollisionShape2D").disabled = false
	var damage = RunData.strength
	if RunData.berserker_active:
		damage *= 2
	apply_damage_to_enemies(damage)


func _perform_heavy_attack():
	if not can_heavy or RunData.fury < HEAVY_ATTACK_COST or is_attacking:
		return
	can_heavy = false
	heavy_cooldown_timer = HEAVY_ATTACK_COOLDOWN
	RunData.fury -= HEAVY_ATTACK_COST
	is_attacking = true
	attack_timer = 0.35
	attack_area.get_node("CollisionShape2D").disabled = false
	var damage = RunData.strength * 2
	if RunData.berserker_active:
		damage *= 2
	apply_damage_to_enemies(damage)


func _use_skill(skill_id: String):
	match skill_id:
		"bash":
			if RunData.fury >= 30:
				RunData.fury -= 30
				velocity = move_direction * SPEED * 3
				NotificationSystem.add_notification("¡Embestida!")
		"roar":
			if RunData.fury >= 25:
				RunData.fury -= 25
				_debuff_nearby_enemies()
				NotificationSystem.add_notification("¡Grito atemorizante!")


func apply_damage_to_enemies(damage: int):
	for body in attack_area.get_overlapping_bodies():
		if body.is_in_group("enemy"):
			body.take_damage(damage)
	for area in attack_area.get_overlapping_areas():
		if area.is_in_group("enemy_hurtbox"):
			area.get_parent().take_damage(damage)


func _debuff_nearby_enemies():
	for enemy in get_tree().get_nodes_in_group("enemy"):
		var distance = global_position.distance_to(enemy.global_position)
		if distance < 150:
			enemy.apply_debuff("weakened", 3.0)


func _on_attack_hit(body):
	if body.is_in_group("enemy"):
		RunData.add_fury(3)


func take_damage(amount: int):
	RunData.take_damage(amount)
	NotificationSystem.add_notification("-%d HP" % amount, "", 1.0)
	modulate = Color(1, 0.3, 0.3, 1)
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
