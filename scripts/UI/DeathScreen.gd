extends Control


func _ready():
	$VBoxContainer/KnowledgeGained.text = "Runs totales: %d\nMuertes: %d\nEnemigos registrados: %d\nHabitaciones exploradas: %d" % [
		MetaKnowledge.total_runs,
		MetaKnowledge.total_deaths,
		MetaKnowledge.bestiary.size(),
		MetaKnowledge.explored_rooms.size()
	]
	$VBoxContainer/RestartButton.pressed.connect(_on_restart_pressed)


func _on_restart_pressed():
	GameManager.change_state(GameManager.GameState.CITY)
