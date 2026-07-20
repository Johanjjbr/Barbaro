extends Node

enum GameState { MAIN_MENU, CITY, DUNGEON, DEATH_SCREEN, PAUSED }

var current_state: GameState = GameState.MAIN_MENU

signal state_changed(new_state: GameState)


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


func change_state(new_state: GameState):
	current_state = new_state
	state_changed.emit(new_state)
	match new_state:
		GameState.DUNGEON:
			get_tree().change_scene_to_file("res://scenes/dungeon/Dungeon.tscn")
		GameState.CITY:
			get_tree().change_scene_to_file("res://scenes/city/City.tscn")
		GameState.DEATH_SCREEN:
			RunData.end_run()
			get_tree().change_scene_to_file("res://scenes/ui/DeathScreen.tscn")
		GameState.MAIN_MENU:
			get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")


func enter_dungeon():
	RunData.start_new_run()
	change_state(GameState.DUNGEON)


func player_died():
	change_state(GameState.DEATH_SCREEN)


func return_to_city():
	change_state(GameState.CITY)


func toggle_pause():
	if current_state == GameState.PAUSED:
		current_state = GameState.DUNGEON
		get_tree().paused = false
	elif current_state == GameState.DUNGEON:
		current_state = GameState.PAUSED
		get_tree().paused = true
