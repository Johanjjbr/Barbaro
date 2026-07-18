extends Node

class EnemyEntry:
	var enemy_id: String
	var enemy_name: String
	var encountered: bool = false
	var weaknesses: Array[String] = []
	var attack_patterns: Array[String] = []
	var times_defeated: int = 0

class RoomEntry:
	var room_id: String
	var room_type: String
	var explored: bool = false
	var trap_type: String = ""
	var loot_claimed: bool = false

var bestiary: Dictionary = {}
var explored_rooms: Dictionary = {}
var dungeon_seeds_visited: Array[int] = []
var total_runs: int = 0
var total_deaths: int = 0


func _ready():
	load_knowledge()


func record_enemy_encounter(enemy_id: String, enemy_name: String):
	if not bestiary.has(enemy_id):
		var entry = EnemyEntry.new()
		entry.enemy_id = enemy_id
		entry.enemy_name = enemy_name
		bestiary[enemy_id] = entry
	bestiary[enemy_id].encountered = true


func record_weakness(enemy_id: String, weakness: String):
	if bestiary.has(enemy_id):
		if not weakness in bestiary[enemy_id].weaknesses:
			bestiary[enemy_id].weaknesses.append(weakness)


func record_pattern(enemy_id: String, pattern: String):
	if bestiary.has(enemy_id):
		if not pattern in bestiary[enemy_id].attack_patterns:
			bestiary[enemy_id].attack_patterns.append(pattern)


func record_room_explored(room_id: String, room_type: String, trap: String = ""):
	if not explored_rooms.has(room_id):
		var entry = RoomEntry.new()
		entry.room_id = room_id
		entry.room_type = room_type
		entry.explored = true
		entry.trap_type = trap
		explored_rooms[room_id] = entry


func add_run():
	total_runs += 1


func add_death():
	total_deaths += 1


func save_knowledge():
	var save_data = {
		"bestiary": {},
		"explored_rooms": {},
		"total_runs": total_runs,
		"total_deaths": total_deaths
	}
	for eid in bestiary:
		var e = bestiary[eid]
		save_data["bestiary"][eid] = {
			"enemy_name": e.enemy_name,
			"encountered": e.encountered,
			"weaknesses": e.weaknesses,
			"attack_patterns": e.attack_patterns,
			"times_defeated": e.times_defeated
		}
	for rid in explored_rooms:
		var r = explored_rooms[rid]
		save_data["explored_rooms"][rid] = {
			"room_type": r.room_type,
			"explored": r.explored,
			"trap_type": r.trap_type,
			"loot_claimed": r.loot_claimed
		}
	var file = FileAccess.open("user://meta_knowledge.save", FileAccess.WRITE)
	if file:
		file.store_var(save_data)


func load_knowledge():
	var file = FileAccess.open("user://meta_knowledge.save", FileAccess.READ)
	if file:
		var data = file.get_var()
		for eid in data.get("bestiary", {}):
			var e_data = data["bestiary"][eid]
			var entry = EnemyEntry.new()
			entry.enemy_id = eid
			entry.enemy_name = e_data["enemy_name"]
			entry.encountered = e_data["encountered"]
			entry.weaknesses = e_data["weaknesses"]
			entry.attack_patterns = e_data["attack_patterns"]
			entry.times_defeated = e_data["times_defeated"]
			bestiary[eid] = entry
		for rid in data.get("explored_rooms", {}):
			var r_data = data["explored_rooms"][rid]
			var entry = RoomEntry.new()
			entry.room_id = rid
			entry.room_type = r_data["room_type"]
			entry.explored = r_data["explored"]
			entry.trap_type = r_data["trap_type"]
			entry.loot_claimed = r_data["loot_claimed"]
			explored_rooms[rid] = entry
		total_runs = data.get("total_runs", 0)
		total_deaths = data.get("total_deaths", 0)
