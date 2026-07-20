extends Component
class_name HealthComponent

signal health_changed(current: int, previous: int)
signal health_depleted

@export var max_health: int = 100

var current_health: int : set = _set_current_health

func _ready() -> void:
    current_health = max_health

func _set_current_health(value: int) -> void:
    var previous: int = current_health
    current_health = clampi(value, 0, max_health)
    if current_health != previous:
        health_changed.emit(current_health, previous)
    if current_health <= 0:
        health_depleted.emit()

func heal(amount: int) -> void:
    current_health += amount

func take_damage(amount: int) -> void:
    current_health -= amount

func setup(data: Resource) -> void:
    if data is CharacterStats:
        set_max_health(data.max_hp)

func set_max_health(value: int) -> void:
    max_health = maxi(value, 1)
    current_health = mini(current_health, max_health)

func get_health_percent() -> float:
    if max_health == 0:
        return 0.0
    return float(current_health) / float(max_health)
