extends Node
class_name EnemyStateMachine

signal state_changed(old_state: String, new_state: String)

@export var initial_state: String = ""

var states: Dictionary = {}
var current_state: EnemyState
var previous_state_name: String = ""

func _ready() -> void:
    _register_states()
    if initial_state != "" and states.has(initial_state):
        transition(initial_state)

func _register_states() -> void:
    for child in get_children():
        var state := child as EnemyState
        if not state:
            continue
        states[state.name] = state
        state.state_machine = self
        state.actor = _find_actor()
        state.finished.connect(_on_state_finished)

func _find_actor() -> EnemyController:
    var current: Node = get_parent()
    while current != null:
        if current is EnemyController:
            return current
        current = current.get_parent()
    return null

func _on_state_finished(next_state: String) -> void:
    transition(next_state)

func transition(state_name: String) -> void:
    if not states.has(state_name) or states[state_name] == current_state:
        return
    previous_state_name = current_state.name if current_state else ""
    if current_state:
        current_state.exit()
    current_state = states[state_name]
    current_state.enter()
    state_changed.emit(previous_state_name, state_name)

func get_state(state_name: String) -> EnemyState:
    return states.get(state_name)

func _process(delta: float) -> void:
    if GameManager.current_state == GameManager.GameState.PAUSED:
        return
    if current_state:
        current_state.update(delta)

func _physics_process(delta: float) -> void:
    if GameManager.current_state == GameManager.GameState.PAUSED:
        return
    if current_state:
        current_state.physics_update(delta)
