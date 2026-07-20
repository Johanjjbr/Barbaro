extends Area2D
class_name HurtboxComponent

signal hurt(amount: int, source: Node)

@export var health_component: HealthComponent

func _ready() -> void:
    if health_component == null:
        health_component = _resolve_health_component()

func apply_damage(amount: int, source: Node = null) -> void:
    if health_component == null:
        return
    health_component.take_damage(amount)
    hurt.emit(amount, source)

func _resolve_health_component() -> HealthComponent:
    var current: Node = get_parent()
    while current:
        var found: HealthComponent = current.get_node_or_null("HealthComponent") as HealthComponent
        if found:
            return found
        current = current.get_parent()
    return null
