extends Node

var current_suspicion: int = 0
var max_suspicion: int = 100
var suspicion_levels: Dictionary = {
	0: "Confianza total",
	25: "Ligera curiosidad",
	50: "Comienzan a observar",
	75: "Rumores en la ciudad",
	100: "¡INTERROGATORIO!"
}

signal suspicion_changed(value: int, level: String)
signal interrogacion_triggered()


func _ready():
	current_suspicion = PlayerData.suspicion


func add_suspicion(amount: int):
	current_suspicion = clampi(current_suspicion + amount, 0, max_suspicion)
	PlayerData.add_suspicion(amount)
	PlayerData.save_data()
	var level = get_current_level()
	suspicion_changed.emit(current_suspicion, level)
	if current_suspicion >= max_suspicion:
		interrogacion_triggered.emit()


func get_current_level() -> String:
	var level = ""
	var threshold = 0
	for t in suspicion_levels.keys():
		if current_suspicion >= t and t >= threshold:
			threshold = t
			level = suspicion_levels[t]
	return level


func reset_suspicion():
	current_suspicion = 0
	PlayerData.suspicion = 0
	PlayerData.save_data()
