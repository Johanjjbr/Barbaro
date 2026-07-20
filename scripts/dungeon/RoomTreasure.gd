extends "res://scripts/dungeon/BaseRoom.gd"

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
