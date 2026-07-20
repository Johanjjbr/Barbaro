extends Node
class_name Logger

enum Level { DEBUG, INFO, WARN, ERROR, FATAL }

var enabled: bool = true

func debug(context: String, message: String) -> void:
    _log(Level.DEBUG, context, message)

func info(context: String, message: String) -> void:
    _log(Level.INFO, context, message)

func warn(context: String, message: String) -> void:
    _log(Level.WARN, context, message)

func error(context: String, message: String) -> void:
    _log(Level.ERROR, context, message)

func fatal(context: String, message: String) -> void:
    _log(Level.FATAL, context, message)

func _log(level: Level, context: String, message: String) -> void:
    if not enabled:
        return
    var timestamp: String = Time.get_datetime_string_from_system()
    var level_name: String = Level.keys()[level]
    var output: String = "[{0}] [{1}] [{2}] {3}"
    print(output.format([timestamp, level_name, context, message]))
