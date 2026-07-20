extends CharacterBody2D

var enemy_id: String = "goblin"
var enemy_name: String = "Goblin"
var hp: int = 30
var max_hp: int = 30
var damage: int = 8
var speed: float = 60.0
var attack_range: float = 25.0
var attack_cooldown: float = 1.5
var attack_timer: float = 0.0
var is_dead: bool = false
var debuff_timers: Dictionary = {}
var player_ref: Node2D = null
var room_ref: Node2D = null

@onready var sprite = $Sprite
@onready var hurtbox = $Hurtbox
@onready var attack_area = $AttackArea


func _ready():
	add_to_group("enemy")
	hurtbox.area_entered.connect(_on_hurtbox_area_entered)
	meta_telegraph()


func meta_telegraph():
	if MetaKnowledge.bestiary.has(enemy_id):
		var entry = MetaKnowledge.bestiary[enemy_id]
		if entry.attack_patterns.size() > 0:
			modulate = Color(1, 1, 0.8, 1)


func _process(delta):
	if is_dead or GameManager.current_state == GameManager.GameState.PAUSED:
		return
	attack_timer -= delta
	_handle_debuffs(delta)
	_handle_ai(delta)


func _handle_debuffs(delta):
	var to_remove = []
	for debuff in debuff_timers:
		debuff_timers[debuff] -= delta
		if debuff_timers[debuff] <= 0:
			to_remove.append(debuff)
	for d in to_remove:
		debuff_timers.erase(d)
		if d == "weakened":
			damage = 8


func _handle_ai(delta):
	if player_ref == null or not is_instance_valid(player_ref):
		player_ref = _find_player()
		return
	var direction = player_ref.global_position - global_position
	var distance = direction.length()
	if distance > attack_range:
		velocity = direction.normalized() * speed
	else:
		velocity = Vector2.ZERO
		if attack_timer <= 0:
			_attack_player()
	if direction.x != 0:
		sprite.scale.x = sign(direction.x)
		attack_area.position.x = 17 * sign(direction.x)
	move_and_slide()


func _find_player():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		return players[0]
	return null


func _attack_player():
	attack_timer = attack_cooldown
	for body in attack_area.get_overlapping_bodies():
		if body.is_in_group("player"):
			body.take_damage(damage)
	for area in attack_area.get_overlapping_areas():
		if area.get_parent().is_in_group("player"):
			area.get_parent().take_damage(damage)
	sprite.color = Color(0.8, 1, 0.5, 1)
	await get_tree().create_timer(0.1).timeout
	if not is_dead:
		sprite.color = Color(0.4, 0.7, 0.2, 1)


func take_damage(amount: int):
	if is_dead:
		return
	hp -= amount
	RunData.add_fury(3)
	sprite.color = Color(1, 0.3, 0.3, 1)
	await get_tree().create_timer(0.1).timeout
	if not is_dead:
		sprite.color = Color(0.4, 0.7, 0.2, 1)
	if hp <= 0:
		_die()


func _die():
	is_dead = true
	velocity = Vector2.ZERO
	MetaKnowledge.bestiary[enemy_id].times_defeated += 1
	MetaKnowledge.record_weakness(enemy_id, "Contundente")
	MetaKnowledge.record_pattern(enemy_id, "Ataca cada 1.5s - esquivar justo antes")
	NotificationSystem.add_notification("+10 Oro - Goblin derrotado")
	RunData.add_loot("goblin_ear", "Oreja de goblin", 10)
	if room_ref and room_ref.has_method("on_room_cleared"):
		room_ref.on_room_cleared()
	queue_free()


func apply_debuff(debuff: String, duration: float):
	debuff_timers[debuff] = duration
	match debuff:
		"weakened":
			damage = int(damage * 0.5)
			sprite.color = Color(0.6, 0.4, 0.8, 1)


func _on_hurtbox_area_entered(area):
	if area.get_parent().is_in_group("player"):
		pass
