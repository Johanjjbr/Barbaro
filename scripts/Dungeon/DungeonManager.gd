extends Node2D

const ROOM_WIDTH = 320
const ROOM_HEIGHT = 240
const GRID_COLS = 4
const GRID_ROWS = 3

enum RoomType { COMBAT, TREASURE, EVENT, ELITE, BOSS, START, EXIT }
enum Direction { NONE, LEFT, RIGHT, UP, DOWN }

var room_scenes: Dictionary = {}
var dungeon_seed: int
var rooms: Array = []
var current_room_index: int = 0
var player: Node2D
var rooms_container: Node2D

@onready var room_templates: Dictionary = {
	RoomType.COMBAT: [
		preload("res://scenes/Dungeon/Rooms/CombatRoom.tscn"),
	],
	RoomType.TREASURE: [
		preload("res://scenes/Dungeon/Rooms/TreasureRoom.tscn"),
	],
	RoomType.ELITE: [
		preload("res://scenes/Dungeon/Rooms/EliteRoom.tscn"),
	],
	RoomType.START: [
		preload("res://scenes/Dungeon/Rooms/StartRoom.tscn"),
	],
	RoomType.EXIT: [
		preload("res://scenes/Dungeon/Rooms/ExitRoom.tscn"),
	],
}


func _ready():
	player = $Player
	rooms_container = $RoomsContainer
	dungeon_seed = randi()
	seed(dungeon_seed)
	_generate_dungeon()
	MetaKnowledge.save_knowledge()


func _generate_dungeon():
	var rooms_data = _generate_room_graph(10 + randi() % 6)
	for i in rooms_data.size():
		var data = rooms_data[i]
		var room_type = data.type
		var template = room_templates[room_type][0]
		var room_instance = template.instantiate()
		var col = i % GRID_COLS
		var row = i / GRID_COLS
		room_instance.position = Vector2(col * ROOM_WIDTH + 100, row * ROOM_HEIGHT + 80)
		room_instance.room_index = i
		room_instance.room_type = room_type
		room_instance.dungeon_manager = self
		if data.exits & Direction.UP:
			room_instance.has_exit_up = true
		if data.exits & Direction.DOWN:
			room_instance.has_exit_down = true
		if data.exits & Direction.LEFT:
			room_instance.has_exit_left = true
		if data.exits & Direction.RIGHT:
			room_instance.has_exit_right = true
		rooms_container.add_child(room_instance)
		rooms.append(room_instance)
		room_instance.visible = i == 0
	rooms[0].visible = true
	current_room_index = 0
	player.position = rooms[0].get_player_spawn_position()


func _generate_room_graph(num_rooms: int) -> Array:
	var rooms_data = []
	var start = { "type": RoomType.START, "exits": 0, "col": 0, "row": 0 }
	rooms_data.append(start)
	var exit_placed = false
	var combat_count = 0
	for i in range(1, num_rooms - 1):
		var room_type = RoomType.COMBAT
		if randi() % 5 == 0:
			room_type = RoomType.TREASURE
		elif randi() % 8 == 0:
			room_type = RoomType.ELITE
		rooms_data.append({ "type": room_type, "exits": 0, "col": i % GRID_COLS, "row": i / GRID_COLS })
		combat_count += 1
	if num_rooms > 1:
		rooms_data.append({ "type": RoomType.EXIT, "exits": 0, "col": (num_rooms - 1) % GRID_COLS, "row": (num_rooms - 1) / GRID_COLS })
		exit_placed = true
	for i in rooms_data.size():
		var exits = 0
		if i > 0:
			exits |= Direction.LEFT
		if i < rooms_data.size() - 1:
			exits |= Direction.RIGHT
		rooms_data[i].exits = exits
	return rooms_data


func move_player_to_room(room_index: int, spawn_direction: int):
	var old_room = rooms[current_room_index]
	if old_room:
		old_room.visible = false
	current_room_index = room_index
	var new_room = rooms[room_index]
	new_room.visible = true
	match spawn_direction:
		Direction.LEFT:
			player.position = new_room.get_right_spawn_position()
		Direction.RIGHT:
			player.position = new_room.get_left_spawn_position()
		Direction.UP:
			player.position = new_room.get_down_spawn_position()
		Direction.DOWN:
			player.position = new_room.get_up_spawn_position()
		_:
			player.position = new_room.get_player_spawn_position()
	MetaKnowledge.record_room_explored("room_%d" % room_index, RoomType.keys()[new_room.room_type])


func get_current_room():
	if current_room_index >= 0 and current_room_index < rooms.size():
		return rooms[current_room_index]
	return null


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		GameManager.toggle_pause()
