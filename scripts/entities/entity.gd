extends CharacterBody2D
class_name Entity

@export var stats: CharacterStats

func _ready() -> void:
    if stats:
        _apply_stats()

func _apply_stats() -> void:
    for child in get_children():
        var component := child as Component
        if component:
            component.setup(stats)

func get_component(component_type: Script) -> Component:
    for child in get_children():
        var component := child as Component
        if component and component.get_script() == component_type:
            return component
    return null
