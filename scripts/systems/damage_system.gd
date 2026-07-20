extends Node
class_name DamageSystem

static func apply_hit(target: Node, amount: int, source: Node = null) -> void:
    if target == null:
        return
    var hurtbox: HurtboxComponent = _find_hurtbox(target)
    if hurtbox == null:
        return
    hurtbox.apply_damage(amount, source)
    EventBus.combat.hit_landed.emit(source, target, amount)

static func _find_hurtbox(node: Node) -> HurtboxComponent:
    if node is HurtboxComponent:
        return node
    for child in node.get_children():
        var found: HurtboxComponent = child as HurtboxComponent
        if found:
            return found
        var deeper: HurtboxComponent = _find_hurtbox(child)
        if deeper:
            return deeper
    return null
