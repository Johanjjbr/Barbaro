extends Node
class_name AudioManager

const MAX_SFX_POOL := 16

var _sfx_pool: Array[AudioStreamPlayer] = []
var _music_player: AudioStreamPlayer

func _ready() -> void:
    _music_player = AudioStreamPlayer.new()
    _music_player.bus = "Music"
    add_child(_music_player)
    _init_sfx_pool()

func _init_sfx_pool() -> void:
    for i in range(MAX_SFX_POOL):
        var player: AudioStreamPlayer = AudioStreamPlayer.new()
        player.bus = "SFX"
        add_child(player)
        _sfx_pool.append(player)

func play_sfx(stream: AudioStream, position: Vector2 = Vector2.ZERO) -> void:
    var player: AudioStreamPlayer = _get_available_player()
    if player == null:
        Logger.warn("AudioManager", "Pool de SFX agotado")
        return
    player.stream = stream
    player.play()

func play_music(stream: AudioStream, fade_time: float = 1.0) -> void:
    _music_player.stream = stream
    _music_player.play()

func stop_music(fade_time: float = 1.0) -> void:
    _music_player.stop()

func _get_available_player() -> AudioStreamPlayer:
    for player in _sfx_pool:
        if not player.playing:
            return player
    return null
