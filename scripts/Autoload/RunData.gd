extends Node

var current_hp: int = 100
var max_hp: int = 100
var fury: int = 0
var max_fury: int = 100
var strength: int = 10
var defense: int = 5
var speed: int = 8
var dungeon_depth: int = 0
var rooms_cleared: int = 0
var loot_pouch: Array[Dictionary] = []
var current_room_id: String = ""
var berserker_active: bool = false
var berserker_timer: float = 0.0
var is_alive: bool = true


func _ready():
	pass


func start_new_run():
	current_hp = PlayerData.stats.max_hp
	max_hp = PlayerData.stats.max_hp
	fury = 0
	max_fury = 100
	strength = PlayerData.stats.strength
	defense = PlayerData.stats.defense
	speed = PlayerData.stats.speed
	dungeon_depth = 0
	rooms_cleared = 0
	loot_pouch.clear()
	current_room_id = ""
	berserker_active = false
	berserker_timer = 0.0
	is_alive = true
	MetaKnowledge.add_run()


func take_damage(amount: int) -> bool:
	if not is_alive:
		return false
	var actual_damage = maxi(1, amount - defense)
	current_hp -= actual_damage
	add_fury(5)
	if current_hp <= 0:
		current_hp = 0
		is_alive = false
		GameManager.player_died()
		return false
	return true


func add_fury(amount: int):
	fury = clampi(fury + amount, 0, max_fury)
	if fury >= max_fury and not berserker_active:
		activate_berserker()


func activate_berserker():
	berserker_active = true
	berserker_timer = 5.0
	strength = PlayerData.stats.strength * 2
	NotificationSystem.add_notification("¡FURIA DESATADA! Daño duplicado por 5 segs")


func deactivate_berserker():
	berserker_active = false
	strength = PlayerData.stats.strength
	fury = 0


func _process(delta):
	if berserker_active:
		berserker_timer -= delta
		if berserker_timer <= 0:
			deactivate_berserker()


func heal(amount: int):
	current_hp = min(current_hp + amount, max_hp)


func add_loot(item_id: String, item_name: String, value: int):
	loot_pouch.append({
		"id": item_id,
		"name": item_name,
		"value": value
	})


func end_run():
	is_alive = false
	if loot_pouch.size() > 0:
		var total_gold = 0
		for item in loot_pouch:
			total_gold += item.value
		PlayerData.add_gold(total_gold)
	MetaKnowledge.add_death()
	MetaKnowledge.save_knowledge()
	PlayerData.save_data()
