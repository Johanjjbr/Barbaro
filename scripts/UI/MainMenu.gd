extends Control


func _ready():
	$VBoxContainer/StartButton.pressed.connect(_on_start_pressed)
	$VBoxContainer/ContinueButton.pressed.connect(_on_continue_pressed)
	$VBoxContainer/ExitButton.pressed.connect(_on_exit_pressed)


func _on_start_pressed():
	PlayerData.gold = 0
	PlayerData.reputation = 50
	PlayerData.suspicion = 0
	PlayerData.save_data()
	MetaKnowledge.total_runs = 0
	MetaKnowledge.total_deaths = 0
	MetaKnowledge.save_knowledge()
	GameManager.change_state(GameManager.GameState.CITY)


func _on_continue_pressed():
	GameManager.change_state(GameManager.GameState.CITY)


func _on_exit_pressed():
	get_tree().quit()
