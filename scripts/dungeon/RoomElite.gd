extends "res://scripts/dungeon/BaseRoom.gd"

var enemy_instance: Node2D = null


func _ready():
	super()
	_spawn_elite_enemy()


func _spawn_elite_enemy():
	var goblin_scene = preload("res://scenes/dungeon/enemies/Goblin.tscn")
	enemy_instance = goblin_scene.instantiate()
	enemy_instance.position = $EnemySpawn.position
	enemy_instance.hp = 80
	enemy_instance.max_hp = 80
	enemy_instance.damage = 15
	enemy_instance.speed = 80
	enemy_instance.attack_cooldown = 1.0
	enemy_instance.enemy_id = "goblin_elite"
	enemy_instance.enemy_name = "Goblin Élite"
	enemy_instance.room_ref = self
	add_child(enemy_instance)
	MetaKnowledge.record_enemy_encounter("goblin_elite", "Goblin Élite")
	NotificationSystem.add_notification("¡Un enemigo de élite aparece!", "", 2.0)


func on_room_cleared():
	super()
	NotificationSystem.add_notification("¡+50 Oro - Élite derrotado!", "")
	RunData.add_loot("elite_trophy", "Trofeo de élite", 50)
