extends "res://scripts/dungeon/BaseRoom.gd"

var portal_timer: float = 0.0
var portal_active: bool = false


func _ready():
	super()
	require_clear_for_exit = false
	$Label.text = "SALIDA - Pulsa Espacio para escapar"


func on_player_entered():
	portal_active = true


func _process(delta):
	if portal_active and Input.is_action_just_pressed("interact"):
		escape_dungeon()


func escape_dungeon():
	NotificationSystem.add_notification("¡Has escapado del laberinto!")
	RunData.add_loot("dungeon_clear", "Botín de huida", 100)
	RunData.end_run()
	GameManager.return_to_city()
