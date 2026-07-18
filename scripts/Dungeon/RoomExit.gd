extends "res://scripts/Dungeon/BaseRoom.gd"

var portal_timer: float = 0.0
var portal_active: bool = false


func _ready():
	super()
	$ExitLeft.body_entered.connect(_on_exit_left_body_entered)
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


func _on_exit_left_body_entered(body):
	if body.is_in_group("player"):
		_on_exit_used(2)
