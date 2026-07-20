extends "res://scripts/Dungeon/BaseRoom.gd"

var loot_claimed: bool = false
var possible_loot = [
	{ "id": "gold_coins", "name": "Monedas de oro", "value": 50 },
	{ "id": "silver_ring", "name": "Anillo de plata", "value": 30 },
	{ "id": "old_sword", "name": "Espada vieja", "value": 40 },
	{ "id": "health_potion", "name": "Poción de vida", "value": 25 },
	{ "id": "fury_gem", "name": "Gema de furia", "value": 35 },
]


func _ready():
	super()
	$ExitRight.body_entered.connect(_on_exit_right_body_entered)
	$ExitLeft.body_entered.connect(_on_exit_left_body_entered)


func on_player_entered():
	if not loot_claimed:
		_claim_loot()
		loot_claimed = true
		on_room_cleared()


func _claim_loot():
	var loot = possible_loot[randi() % possible_loot.size()]
	RunData.add_loot(loot.id, loot.name, loot.value)
	NotificationSystem.add_notification("+%d Oro - %s" % [loot.value, loot.name])
	$Label.text = loot.name


func on_room_cleared():
	super()
	$ExitRight/CollisionShape2D.disabled = false
	$ExitLeft/CollisionShape2D.disabled = false


func _on_exit_right_body_entered(body):
	if body.is_in_group("player") and room_cleared:
		_on_exit_used(3)


func _on_exit_left_body_entered(body):
	if body.is_in_group("player") and room_cleared:
		_on_exit_used(2)
