# Dungeon System

## Objetivo
Generar y gestionar la mazmorra procedural — el escenario principal de combate y exploración.

## Responsabilidades
- Generar habitaciones proceduralmente con seed reproducible
- Conectar habitaciones con puertas/corredores
- Poblar habitaciones con enemigos, tesoros, eventos
- Escalar dificultad con profundidad
- Gestionar transiciones entre salas
- Mantener el estado de la sala activa (enemigos vivos, cofres abiertos)
- Mini-mapa de la mazmorra

## Dependencias
- `RoomData` (Resource) — plantillas de habitaciones
- `EncounterTable` (Resource) — tablas de encuentros por profundidad
- `DungeonManager` (autoload) — estado global
- `EnemyController` — instanciación de enemigos

## Señales Emitidas
- `dungeon_generated(seed: int, depth: int)`
- `room_entered(room: Node)`
- `room_cleared(room: Node)`
- `dungeon_exited()`
- `player_died_in_dungeon()`

## Tipos de Habitación

| Tipo | Descripción | Contenido |
|------|-------------|-----------|
| `START` | Sala de entrada | Segura, punto de spawn |
| `COMBAT` | Combate obligatorio | Enemigos, obstáculos |
| `TREASURE` | Recompensa | Cofres, items |
| `REST` | Descanso | Fogata, curación |
| `EVENT` | Evento especial | NPC, altar, trampa |
| `BOSS` | Jefe | Jefe único, recompensa mayor |
| `EXIT` | Salida | Portal a ciudad o siguiente nivel |

## Generación

```
1. Generar layout (grid, graph, o room placement)
2. Seleccionar tipos de habitación según profundidad
3. Conectar habitaciones (puertas/corredores)
4. Poblar según encounter tables
5. Cachear seed para reproducción
```

## Limitaciones
- Sin generación vertical (múltiples pisos) en MVP
- Sin salas secretas en MVP
- Sin dinámicas (puertas que se cierran, inundaciones) en MVP

## Posibles Mejoras
- Variedad de biomas por profundidad
- Salas secretas con requisitos de entrada
- Trampas y puzzles
- Eventos dinámicos (derrumbe, invasión)
- Mapas más grandes con ramas y atajos
- Modificador de mazmorra por ciclo mensual
