extends Area2D
class_name HitboxComponent

var damage: int = 1

func get_targets() -> Array[Node2D]:
    var targets: Array[Node2D] = []
    for body in get_overlapping_bodies():
        if body.is_in_group("player"):
            targets.append(body)
    for area in get_overlapping_areas():
        var parent := area.get_parent()
        if parent and parent.is_in_group("player"):
            targets.append(parent)
    return targets
