# AI System

## Objetivo
Controlar el comportamiento de enemigos y NPCs mediante una máquina de estados finitos.

## Responsabilidades
- Implementar estados: Idle, Patrol, Follow, Attack, Dead
- Detectar al jugador (rango visual, umbral de ruido)
- Decidir transiciones entre estados según condiciones
- Ejecutar acciones por estado (moverse, atacar, huir)
- Ser configurable por tipo de enemigo via Resource

## Dependencias
- `StatsComponent` — velocidad, rango de detección
- `HealthComponent` — transición a Dead
- `CombatSystem` — ejecutar ataques
- `NavigationAgent2D` — pathfinding (si aplica)
- `AIData` (Resource) — configuración por tipo

## Señales Emitidas
- `state_changed(old_state: String, new_state: String)`
- `target_detected(target: Node)`
- `target_lost(target: Node)`
- `ai_dead()`

## Máquina de Estados

```
            ┌─────────┐
            │  Idle   │ ←── Patrulla termina / Pierde target
            └────┬────┘
                 │ Detecta jugador
                 ↓
            ┌─────────┐
            │ Follow  │ ←── Jugador en rango
            └────┬────┘
                 │ Jugador en rango ataque
                 ↓
            ┌─────────┐
            │ Attack  │ ←── Jugador muere / se aleja
            └────┬────┘
                 │ Health <= 0
                 ↓
            ┌─────────┐
            │  Dead   │
            └─────────┘
```

## Configuración por Enemigo (AIData Resource)

```gdscript
@export var detection_range: float = 150.0
@export var attack_range: float = 30.0
@export var patrol_path: Array[Vector2]
@export var patrol_speed: float = 50.0
@export var chase_speed: float = 120.0
@export var attack_cooldown: float = 1.5
@export var damage: int = 10
```

## Limitaciones
- Sin comportamientos de grupo (coordinar entre enemigos) en MVP
- Sin AI para NPCs aliados (escorts, compañeros)
- Sin sistema de aggro avanzado (tabla de amenaza)

## Posibles Mejoras
- Sistema de alerta entre enemigos cercanos
- Comportamientos de grupo (flanqueo, emboscada)
- AI para NPCs aliados
- Sistema de personalidad/emociones para NPCs
- Árbol de comportamiento (Behavior Tree) como alternativa a FSM
