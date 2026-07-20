# Progression System

## Objetivo
Gestionar la progresión del personaje a largo plazo — niveles, habilidades, experiencia, y desbloqueos persistentes entre runs.

## Responsabilidades
- Otorgar experiencia al derrotar enemigos y completar misiones
- Subir de nivel al alcanzar el umbral de EXP
- Otorgar puntos de stat y habilidad por nivel
- Gestionar árbol de habilidades (desbloqueo y mejora)
- Trackear hitos de progresión (runs completadas, jefes derrotados)
- Progresión permanente entre runs (meta-progresión)

## Dependencias
- `StatsComponent` — modificación de stats al subir nivel
- `CombatSystem` — fuente de experiencia
- `QuestManager` — fuente de experiencia
- `SkillData` (Resource) — definición de habilidades
- `LevelCurve` (Resource) — curva de experiencia por nivel
- `SaveManager` — persistencia

## Señales Emitidas
- `experience_gained(amount: int, total: int)`
- `leveled_up(new_level: int)`
- `skill_unlocked(skill_id: String)`
- `skill_upgraded(skill_id: String, new_level: int)`
- `milestone_reached(milestone_id: String)`
- `progression_updated()`

## Curva de Nivel

```gdscript
# LevelCurve Resource
@export var base_experience: int = 100
@export var exponent: float = 1.5

func experience_for_level(level: int) -> int:
    return int(base_experience * pow(level, exponent))
```

## Sistema de Habilidades

| Habilidad | Tipo | Efecto | Requisito |
|-----------|------|--------|-----------|
| `power_strike` | Activa | Golpe potente (+50% daño) | Nivel 2 |
| `war_cry` | Activa | Buff temporal (+20% stats) | Nivel 5 |
| `toughness` | Pasiva | +10% vida máxima | Nivel 3 |
| `iron_skin` | Pasiva | +5% reducción de daño | Nivel 7 |
| `frenzy` | Activa | Aumento de velocidad por tiempo | Nivel 10 |

## Meta-Progresión (entre runs)

| Tipo | Ejemplo | Persistencia |
|------|---------|-------------|
| Stats base | +1 a todos los stats | Permanente |
| Habilidades desbloqueadas | Permanente | Permanente |
| Equipo en almacén | Items guardados en casa | Permanente |
| Reputación | Relaciones con facciones | Permanente |
| Conocimiento | Información sobre enemigos/mazmorra | Permanente |
| Run actual | Progreso en la run actual | Solo durante la run |

## Limitaciones
- Sin reseteo de habilidades (respec) en MVP
- Árbol de habilidades lineal (no ramificado) en MVP
- Sin sinergias entre habilidades en MVP
- Sin progresión de equipo legendario/único en MVP

## Posibles Mejoras
- Reseteo de habilidades con costo
- Árbol de habilidades ramificado con especializaciones
- Sinergias y combos entre habilidades
- Items legendarios con efectos únicos
- Sistema de prestigio (reset con bonificaciones)
- Logros y recompensas por hitos
