extends Node

func _ready() -> void:
    Logger.info("Main", "Escena principal cargada")
    GameManager.change_state(GameManager.GameState.CITY)

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("pause"):
        GameManager.toggle_pause()
