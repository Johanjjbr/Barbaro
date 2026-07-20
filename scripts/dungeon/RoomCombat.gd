extends "res://scripts/dungeon/BaseRoom.gd"

var enemy_instance: Node2D = null
var enemy_scenes = [
	preload("res://scenes/dungeon/enemies/Goblin.tscn"),
]


func _ready():
	super()
	_spawn_enemy()


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
