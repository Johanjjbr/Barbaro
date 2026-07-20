# Save System

## Objetivo
Persistir el estado completo del juego entre sesiones — progresión permanente, estado de ciudad, inventario.

## Responsabilidades
- Serializar cada sistema participante a Dictionary
- Escribir/leer archivos de guardado en disco
- Validar integridad de datos al cargar
- Gestionar slots de guardado (nuevo, continuar, borrar)
- Diferenciar entre datos de run (temporales) y datos persistentes

## Dependencias
- Todos los sistemas que implementan `save() -> Dictionary`
- `GameManager` — estado global
- `ConfigFile` o JSON — formato de guardado

## Señales Emitidas
- `save_started(slot: int)`
- `save_completed(slot: int, success: bool)`
- `load_started(slot: int)`
- `load_completed(slot: int, success: bool)`
- `save_corrupted(slot: int, error: String)`

## Estructura de Guardado

```gdscript
# save_file_0.json
{
    "version": "1.0.0",
    "timestamp": 1234567890,
    "run_count": 5,
    "player": {
        "stats": { "strength": 10, "endurance": 8, ... },
        "health": { "current": 80, "max": 100 },
        "inventory": [ { "id": "iron_sword", "quantity": 1 }, ... ],
        "equipment": { "weapon": "iron_sword", "armor": null }
    },
    "city": {
        "reputation": { "merchant_guild": 50, "fighters_guild": 30 },
        "day": 15,
        "completed_quests": ["quest_01", "quest_02"]
    },
    "progression": {
        "level": 3,
        "experience": 450,
        "unlocked_skills": ["power_strike", "war_cry"]
    }
}
```

## Datos de Run (temporales)
- Posición actual en dungeon
- Estado de enemigos en sala actual
- Items no asegurados
- Progreso de la run actual

## Datos Persistentes
- Stats base del personaje
- Oro en banco
- Equipo en almacén
- Reputación
- Misiones completadas
- Nivel y habilidades

## Limitaciones
- Sin guardado en medio de combate en MVP
- Sin guardado en la nube
- Sin compresión de datos
- Sin backup automático

## Posibles Mejoras
- Guardado rápido en zonas seguras
- Guardado en la nube (Godot: HTTPRequest)
- Compresión de datos (ZIP)
- Backup automático antes de operaciones críticas
- Sistema de versión de migración de datos
