class_name InputSetup
extends Object

static func configure() -> void:
    _add_action("move_left", KEY_A)
    _add_action("move_right", KEY_D)
    _add_action("move_up", KEY_W)
    _add_action("move_down", KEY_S)
    _add_action("attack_primary", MOUSE_BUTTON_LEFT)
    _add_action("attack_secondary", MOUSE_BUTTON_RIGHT)
    _add_action("interact", KEY_E)
    _add_action("inventory", KEY_I)
    _add_action("equipment", KEY_C)
    _add_action("pause", KEY_ESCAPE)
    _add_action("map", KEY_M)
    _add_action("quest_log", KEY_Q)
    _add_action("dodge", KEY_SPACE)
    _add_action("use_slot_1", KEY_1)
    _add_action("use_slot_2", KEY_2)
    _add_action("use_slot_3", KEY_3)

static func _add_action(action_name: String, keycode: Key) -> void:
    if InputMap.has_action(action_name):
        return
    InputMap.add_action(action_name)
    var event: InputEventKey = InputEventKey.new()
    event.keycode = keycode
    InputMap.action_add_event(action_name, event)
