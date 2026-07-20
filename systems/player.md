# Player System

## Objetivo
Controlar al personaje jugable — movimiento, interacción con el mundo, y punto de entrada de input del usuario.

## Responsabilidades
- Recibir input del jugador vía InputMap
- Ejecutar movimiento con `CharacterBody2D` y `move_and_slide()`
- Detectar e iniciar interacciones (NPCs, cofres, objetos)
- Cachear referencias a componentes propios (Health, Stats, Inventory)
- Emitir señales de estado al EventBus

## Dependencias
- `StatsComponent` — stats del personaje
- `HealthComponent` — vida y muerte
- `InventoryComponent` — items cargados
- `EquipmentComponent` — equipo activo
- `InputMap` — acciones mapeadas

## Señales Emitidas
- `player_moved(direction: Vector2)`
- `player_interacted(target: Node)`
- `player_attacked(damage: int)`
- `player_died()`

## Limitaciones
- No contiene lógica de combate directamente — delega a CombatSystem
- No gestiona UI — solo emite eventos
- No conoce la estructura del dungeon — solo navega

## Posibles Mejoras
- Añadir dash / esquiva como componente separado
- Sistema de animaciones basado en estados (idle, walk, attack, hurt)
- Soporte para monturas o vehículos
- Multiplayer: replicación de estado
