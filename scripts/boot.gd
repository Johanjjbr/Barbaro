extends Node

func _ready() -> void:
    _initialize_audio_buses()
    InputSetup.configure()
    _apply_settings()
    Logger.info("Boot", "Sistemas de infraestructura listos")
    EventBus.game.started.emit()
    GameManager.change_state(GameManager.GameState.CITY)

func _initialize_audio_buses() -> void:
    if AudioServer.bus_count == 1:
        AudioServer.add_bus()
        AudioServer.set_bus_name(1, "SFX")
        AudioServer.add_bus()
        AudioServer.set_bus_name(2, "Music")
    Logger.info("Boot", "Buses de audio: Master, SFX, Music")

func _apply_settings() -> void:
    ConfigManager.load_settings()
