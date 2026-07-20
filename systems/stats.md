# Stats System

## Objetivo
Definir y gestionar las estadísticas de personajes (jugador, enemigos, NPCs).

## Responsabilidades
- Almacenar stats base y actuales en un Resource
- Aplicar modificadores de equipo, buffs y efectos
- Calcular stats derivadas (velocidad de ataque, capacidad de carga)
- Proveer interfaz para lectura/escritura de stats

## Dependencias
- `StatsData` (Resource) — definición de stats base
- `EquipmentComponent` — modificadores de equipo
- `SaveManager` — persistencia

## Señales Emitidas
- `stat_changed(stat_name: String, old_value: int, new_value: int)`
- `stats_updated()`

## Stats Base

| Stat | Rol | Range típico |
|------|-----|-------------|
| `strength` | Daño físico, capacidad de carga | 1-99 |
| `endurance` | Vida, resistencia a efectos | 1-99 |
| `speed` | Velocidad de movimiento y ataque | 1-99 |
| `skill` | Precisión, requisitos de equipo | 1-99 |

## Stats Derivadas
- `max_health = endurance * 10`
- `carry_capacity = strength * 5`
- `attack_speed = 1.0 + speed * 0.01`
- `move_speed = 100 + speed * 2`

## Limitaciones
- Stats fijas por tipo de personaje (configurable en Resource)
- Sin stats secundarias (crit, dodge, block) en MVP
- Sin sistema de niveles integrado (ver Progression)

## Posibles Mejoras
- Stats defensivas (armor, magic resist)
- Stats secundarias (crit chance, dodge, block, lifesteal)
- Sistema de buffs/debuffs temporales
- Sinergias entre stats por clase
