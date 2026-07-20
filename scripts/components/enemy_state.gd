extends Node
class_name EnemyState

signal finished(next_state: String)

var actor: EnemyController
var state_machine: EnemyStateMachine

func enter() -> void:
    pass

func exit() -> void:
    pass

func update(_delta: float) -> void:
    pass

func physics_update(_delta: float) -> void:
    pass
