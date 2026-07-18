extends "res://scripts/Dungeon/BaseRoom.gd"

var enemy_instance: Node2D = null
var enemy_scenes = [
	preload("res://scenes/Dungeon/Enemies/Goblin.tscn"),
]


func _ready():
	super()
	_spawn_enemy()
	$ExitRight.body_entered.connect(_on_exit_right_body_entered)
	$ExitLeft.body_entered.connect(_on_exit_left_body_entered)


func _spawn_enemy():
	var idx = randi() % enemy_scenes.size()
	var scene = enemy_scenes[idx]
	enemy_instance = scene.instantiate()
	enemy_instance.position = $EnemySpawn.position
	enemy_instance.room_ref = self
	add_child(enemy_instance)
	notify_meta_knowledge(enemy_instance.enemy_id, enemy_instance.enemy_name)


func notify_meta_knowledge(eid: String, ename: String):
	MetaKnowledge.record_enemy_encounter(eid, ename)


func on_room_cleared():
	super()
	$ExitRight/CollisionShape2D.disabled = false
	$ExitLeft/CollisionShape2D.disabled = false


func _on_exit_right_body_entered(body):
	if body.is_in_group("player") and room_cleared:
		_on_exit_used(3)


func _on_exit_left_body_entered(body):
	if body.is_in_group("player") and room_cleared:
		_on_exit_used(2)
