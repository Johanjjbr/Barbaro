extends Node

var gold: int = 0
var reputation: int = 50
var suspicion: int = 0
var max_suspicion: int = 100
var gear: Array[String] = []
var learned_skills: Array[String] = ["basic_attack", "heavy_strike"]
var base_stats: Dictionary = {
	"max_hp": 100,
	"strength": 10,
	"defense": 5,
	"speed": 8
}
var tax_paid: bool = false
var days_until_tax: int = 30
var citizen_tier: String = "medium"
var current_season: int = 1


func _ready():
	load_data()


func add_gold(amount: int):
	gold += amount


func spend_gold(amount: int) -> bool:
	if gold >= amount:
		gold -= amount
		return true
	return false


func modify_reputation(amount: int):
	reputation = clampi(reputation + amount, 0, 100)


func add_suspicion(amount: int):
	suspicion = clampi(suspicion + amount, 0, max_suspicion)
	if suspicion >= max_suspicion:
		trigger_interrogation_event()


func trigger_interrogation_event():
	pass


func add_skill(skill_id: String):
	if not skill_id in learned_skills:
		learned_skills.append(skill_id)


func save_data():
	var file = FileAccess.open("user://player_data.save", FileAccess.WRITE)
	if file:
		file.store_var({
			"gold": gold,
			"reputation": reputation,
			"suspicion": suspicion,
			"gear": gear,
			"learned_skills": learned_skills,
			"base_stats": base_stats,
			"days_until_tax": days_until_tax,
			"citizen_tier": citizen_tier,
			"current_season": current_season
		})


func load_data():
	var file = FileAccess.open("user://player_data.save", FileAccess.READ)
	if file:
		var data = file.get_var()
		gold = data.get("gold", 0)
		reputation = data.get("reputation", 50)
		suspicion = data.get("suspicion", 0)
		gear = data.get("gear", [])
		learned_skills = data.get("learned_skills", ["basic_attack", "heavy_strike"])
		base_stats = data.get("base_stats", base_stats)
		days_until_tax = data.get("days_until_tax", 30)
		citizen_tier = data.get("citizen_tier", "medium")
		current_season = data.get("current_season", 1)
