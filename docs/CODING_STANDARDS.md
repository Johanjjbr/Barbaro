# CODING_STANDARDS.md — Convenciones de Código

## Nomenclatura

| Elemento | Convención | Ejemplo |
|----------|-----------|---------|
| Archivos | `snake_case` | `player_controller.gd` |
| Clases | `PascalCase` | `class_name PlayerController` |
| Funciones | `snake_case` | `func move(delta: float) -> void` |
| Variables | `snake_case` | `var current_health: int` |
| Constantes | `UPPER_CASE` | `const MAX_SPEED := 300.0` |
| Señales | `snake_case` | `signal player_damaged(amount: int)` |
| Escenas | `PascalCase` | `Player.tscn` |
| Recursos | `snake_case` | `barbarian_stats.tres` |

## Estructura de Scripts

```gdscript
extends Node
class_name MyComponent

# --- Señales ---
signal my_signal

# --- Enumeraciones ---
enum State { IDLE, ACTIVE }

# --- Constantes ---
const MAX_VALUE := 100

# --- Recursos exportados ---
@export var data: Resource

# --- Variables públicas ---
var current_value: int

# --- Variables privadas ---
var _internal_value: int

# --- Métodos de ciclo de vida ---
func _ready() -> void:
    pass

# --- Métodos públicos ---
func do_something() -> void:
    pass

# --- Métodos privados ---
func _internal_logic() -> void:
    pass
```

## Reglas por Tipo

### Scripts
- Máximo 300 líneas. Si supera, proponer división.
- Un `class_name` por script.
- `@export` para dependencias configurables.

### Escenas
- Una responsabilidad por escena.
- Prefijo de sistema en el nombre: `Player.tscn`, `HealthBar.tscn`.
- No mezclar lógica de UI con lógica de juego.

### Recursos
- `@export` en todos los campos que deban ser editables.
- Usar `@tool` solo cuando sea necesario.
- Valores por defecto sensatos siempre.

## Signals

- Preferir signals a referencias directas.
- Una signal por evento significativo.
- Nombrar en pasado: `item_collected`, `enemy_killed`.

## Input

- Solo teclas vía `InputMap`.
- No strings hardcodeados de teclas.
- Acciones mapeadas con nombre descriptivo: `move_left`, `attack_primary`.

## Física

- `CharacterBody2D` para entidades móviles.
- `move_and_slide()` siempre, nunca `position +=`.
- `Area2D` para hitboxes y detección.

## Rendimiento

- Cachear referencias en `_ready()`.
- `get_node()` una vez, guardar referencia.
- No `get_tree().get_nodes_in_group()` cada frame.
- Pooling para objetos frecuentes (proyectiles, efectos).

## Guardado

- Cada sistema implementa `save() -> Dictionary` y `load(data: Dictionary) -> void`.
- Recurso `SaveData` central que agrega todos los sistemas.

## Código Limpio

- No código muerto comentado.
- No duplicación — extraer a función o componente.
- Comentarios solo para lógica no obvia.
- Preferir composición sobre herencia.
