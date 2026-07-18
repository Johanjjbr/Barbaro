extends Node2D

var room_index: int = 0
var room_type: int = 0
var has_exit_up: bool = false
var has_exit_down: bool = false
var has_exit_left: bool = false
var has_exit_right: bool = false
var dungeon_manager: Node2D
var room_cleared: bool = false

@onready var spawn_point = $SpawnPoint
@onready var exit_up = $ExitUp
@onready var exit_down = $ExitDown
@onready var exit_left = $ExitLeft
@onready var exit_right = $ExitRight


func _ready():
	if spawn_point == null:
		spawn_point = $SpawnPoint if has_node("SpawnPoint") else null
	if exit_up:
		$ExitUp.visible = true if has_node("ExitUp") else false
	if exit_down:
		$ExitDown.visible = true if has_node("ExitDown") else false
	if exit_left:
		$ExitLeft.visible = true if has_node("ExitLeft") else false
	if exit_right:
		$ExitRight.visible = true if has_node("ExitRight") else false


func get_player_spawn_position() -> Vector2:
	if spawn_point:
		return spawn_point.position + position
	return position + Vector2(160, 120)


func get_left_spawn_position() -> Vector2:
	if exit_left:
		return exit_left.position + position + Vector2(-30, 0)
	return get_player_spawn_position()


func get_right_spawn_position() -> Vector2:
	if exit_right:
		return exit_right.position + position + Vector2(30, 0)
	return get_player_spawn_position()


func get_up_spawn_position() -> Vector2:
	if exit_up:
		return exit_up.position + position + Vector2(0, -30)
	return get_player_spawn_position()


func get_down_spawn_position() -> Vector2:
	if exit_down:
		return exit_down.position + position + Vector2(0, 30)
	return get_player_spawn_position()


func on_player_entered():
	pass


func on_room_cleared():
	room_cleared = true


func _on_exit_used(direction: int):
	var current_idx = dungeon_manager.current_room_index
	var next_idx = current_idx + 1
	if direction == 2:
		next_idx = current_idx - 1
	if next_idx >= 0 and next_idx < dungeon_manager.rooms.size():
		dungeon_manager.move_player_to_room(next_idx, direction)
