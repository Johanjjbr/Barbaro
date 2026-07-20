extends Node
class_name ConfigManager

const CONFIG_PATH := "user://settings.cfg"

var _config: ConfigFile

var master_volume: float = 1.0
var sfx_volume: float = 1.0
var music_volume: float = 1.0
var fullscreen: bool = false
var resolution: Vector2i = Vector2i(1920, 1080)

func _ready() -> void:
    _config = ConfigFile.new()
    load_settings()

func save_settings() -> void:
    _config.set_value("audio", "master_volume", master_volume)
    _config.set_value("audio", "sfx_volume", sfx_volume)
    _config.set_value("audio", "music_volume", music_volume)
    _config.set_value("video", "fullscreen", fullscreen)
    _config.set_value("video", "resolution", resolution)
    _config.save(CONFIG_PATH)
    Logger.info("ConfigManager", "Configuración guardada")

func load_settings() -> void:
    var err: Error = _config.load(CONFIG_PATH)
    if err != OK:
        Logger.info("ConfigManager", "No se encontró configuración previa, usando defaults")
        return
    master_volume = _config.get_value("audio", "master_volume", 1.0)
    sfx_volume = _config.get_value("audio", "sfx_volume", 1.0)
    music_volume = _config.get_value("audio", "music_volume", 1.0)
    fullscreen = _config.get_value("video", "fullscreen", false)
    resolution = _config.get_value("video", "resolution", Vector2i(1920, 1080))
    _apply_settings()
    Logger.info("ConfigManager", "Configuración cargada")

func _apply_settings() -> void:
    var master_idx: int = AudioServer.get_bus_index("Master")
    AudioServer.set_bus_volume_db(master_idx, linear_to_db(master_volume))
    var sfx_idx: int = AudioServer.get_bus_index("SFX")
    AudioServer.set_bus_volume_db(sfx_idx, linear_to_db(sfx_volume))
    var music_idx: int = AudioServer.get_bus_index("Music")
    AudioServer.set_bus_volume_db(music_idx, linear_to_db(music_volume))
    if fullscreen:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
    else:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
        DisplayServer.window_set_size(resolution)
