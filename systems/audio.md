# Audio System

## Objetivo
Gestionar la reproducción de efectos de sonido y música del juego de forma centralizada y eficiente.

## Responsabilidades
- Reproducir SFX al recibir eventos del EventBus
- Gestionar música de fondo por zona (ciudad, dungeon, combate)
- Controlar volúmenes (master, SFX, música) con persistencia
- Pool de AudioStreamPlayer para SFX concurrentes
- Audio espacial 2D para sonidos posicionales

## Dependencias
- `EventBus` — eventos que disparan sonidos
- `AudioData` (Resource) — configuración de sonidos
- `ConfigFile` — persistencia de volúmenes

## Señales Emitidas
- `sfx_played(sfx_name: String)`
- `music_changed(track_name: String)`
- `volume_changed(bus: String, value: float)`
- `audio_settings_updated()`

## Eventos de Audio

| Evento del Juego | Sonido |
|-----------------|--------|
| `player_attacked` | Slash / whoosh |
| `hit_landed` | Impacto |
| `player_damaged` | Dolor / grunt |
| `enemy_killed` | Muerte enemigo |
| `item_collected` | Pickup |
| `item_equipped` | Equip sound |
| `door_opened` | Puerta |
| `ui_button_pressed` | Click UI |
| `dungeon_entered` | Tema dungeon |
| `city_entered` | Tema ciudad |
| `boss_encountered` | Tema boss |

## Arquitectura

```
AudioManager (autoload)
├── Bus Master
│   ├── Bus SFX
│   │   ├── AudioStreamPlayer (pool, hasta 16 instancias)
│   │   └── AudioStreamPlayer2D (para sonidos espaciales)
│   └── Bus Music
│       └── AudioStreamPlayer (1 instancia, crossfade)
```

## Limitaciones
- Sin sistema de reverberación/efectos por zona en MVP
- Sin mezcla dinámica adaptativa en MVP
- Sin soporte para voces / diálogo hablado en MVP

## Posibles Mejoras
- Reverberación y efectos por tipo de sala
- Música adaptativa (capas que se añaden en combate)
- Sistema de diálogo con voces
- Audio en 3D con AttenuationListener2D
- Perfiles de audio por tipo de escena
