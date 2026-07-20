extends "res://scripts/Dungeon/BaseRoom.gd"


func _ready():
	super()
	$ExitRight.body_entered.connect(_on_exit_right_body_entered)
	$ExitLeft.body_entered.connect(_on_exit_left_body_entered)


func _on_exit_right_body_entered(body):
	if body.is_in_group("player"):
		_on_exit_used(3)


func _on_exit_left_body_entered(body):
	if body.is_in_group("player"):
		_on_exit_used(2)
