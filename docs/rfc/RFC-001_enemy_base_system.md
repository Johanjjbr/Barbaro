# RFC-001 — Sistema Base de Enemigos

**Estado:** Borrador  
**Autor:** —  
**Fecha:** 2026-07-20  
**Motor:** Godot 4.4 Stable  
**Lenguaje:** GDScript 2.0  

---

## 1. Objetivos del Sistema

- Reemplazar el actual `Goblin.gd` monolítico (130 líneas, stats hardcodeadas, AI inline, detección por `get_tree().get_nodes_in_group()` cada frame) por una arquitectura basada en componentes y datos (Resources).
- Que cualquier nuevo tipo de enemigo se pueda definir creando un `EnemyStats.tres` + una escena hija de `Enemy.tscn`, sin tocar scripts del motor.
- Que la máquina de estados (Idle → Patrol → Chase → Attack → Hurt → Dead) sea un componente reutilizable, no un `match` gigante dentro del enemigo.
- Que la detección del jugador ocurra por `Area2D` (física) en vez de búsqueda en el árbol de escenas.
- Que el loot, los stats y los patrones de ataque sean configurables desde Resources sin hardcodear valores en GDScript.

## 2. Diagrama de Clases

```
┌──────────────────────────────────────────────────────────────┐
│                        Entity (base)                         │
│  extends CharacterBody2D                                     │
│  class_name Entity                                           │
│  @export stats: CharacterStats                               │
│  get_component(type: Script) → Component                     │
│  _apply_stats()                                              │
└──────────────────────────────┬───────────────────────────────┘
                               │ extends
              ┌────────────────┴────────────────┐
              │         Enemy (base)             │
              │  @export enemy_stats: EnemyStats  │
              │  room_ref: Node2D                 │
              │  add_to_group("enemy")            │
              │  _ready → auto-add components     │
              └──────┬──────────────┬────────────┘
                     │              │
          ┌──────────┴──┐    ┌─────┴──────┐
          │ GoblinActor │    │ SkeletonAct│ ...
          │ (extends     │    │ (extends   │
          │  Enemy)      │    │  Enemy)    │
          │  _ready →    │    │  _ready →  │
          │  set anim    │    │  set anim  │
          └──────────────┘    └────────────┘

┌──────────────────────────────────────────────────────────────┐
│                    StateMachine (Component)                   │
│  extends Component                                           │
│  class_name StateMachine                                     │
│  @export initial_state: String                                │
│  @export states: Dictionary                                   │
│  transition(new_state: String)                                │
│  state_changed(old, new)                                      │
│  _physics_update(delta) delegado al estado activo             │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│              EnemyState (Resource - base class)               │
│  @export state_name: String                                   │
│  enter(actor: Enemy, previous: String)                       │
│  exit(actor: Enemy, next: String)                            │
│  update(actor: Enemy, delta: float) → String (next state)    │
│  physics_update(actor: Enemy, delta: float) → String          │
└──────────────────────────────────────────────────────────────┘
         ┌─────────┬──────────┬──────────┬──────────┬──────┐
         │         │          │          │          │      │
     ┌───┴──┐ ┌───┴───┐ ┌───┴────┐ ┌───┴───┐ ┌───┴───┐ ┌──┴───┐
     │ Idle │ │ Patrol │ │ Chase  │ │ Attack│ │ Hurt  │ │ Dead │
     └──────┘ └───────┘ └────────┘ └───────┘ └───────┘ └──────┘
```

## 3. Árbol de Escenas

### 3.1 Escena base — `scenes/entities/enemies/Enemy.tscn`

```
Enemy (CharacterBody2D)          ← script: scripts/entities/enemies/enemy.gd
├── CollisionShape2D             ← hitbox de colisión física
├── Sprite2D (o ColorRect)       ← placeholder visual
├── DetectionArea (Area2D)       ← rango de detección del jugador
│   └── CollisionShape2D         ← círculo (radio = detection_range)
├── AttackArea (Area2D)          ← hitbox de ataque físico
│   └── CollisionShape2D         ← rectángulo (tamaño por enemy_stats)
├── HurtboxComponent (Area2D)    ← receptor de daño (ya existe)
│   └── CollisionShape2D         ← coincide con hitbox físico
├── HealthComponent (Node)       ← maneja HP (ya existe)
├── LootComponent (Node)         ← otorga loot al morir
├── StateMachine (Node)          ← maneja FSM (nuevo)
├── NavigationAgent2D            ← pathfinding (opcional, MVP se omite)
└── MetaKnowledgeComponent (Node)← registro en bestiario (nuevo)
```

### 3.2 Escena variante — `scenes/entities/enemies/Goblin.tscn`

```
Goblin (CharacterBody2D)         ← script: scripts/entities/enemies/goblin.gd
├── (hereda todo de Enemy.tscn con instancing)
├── Sprite2D                     ← color verde (#66CC33)
├── DetectionArea
│   └── CollisionShape2D         ← radio 120px (sobreescribe default)
└── StateMachine
    ├── states/IdleState         ← 2s de espera
    ├── states/PatrolState       ← patrol_path del EnemyStats
    └── ...
```

### 3.3 Instanciación desde Room

Cada `RoomCombat.gd` carga la variante deseada desde `encounter_table.tres` (un Resource que mapea `RoomType → Array[PackedScene]`), la instancia en un `Marker2D` y la añade como hijo.

```
RoomCombat
├── EnemySpawn (Marker2D)        ← posición de instanciación
└── Goblin (instancia de Goblin.tscn)
    ├── ...
```

**Cambio respecto al actual:** La room ya no asigna `enemy_instance.room_ref = self`. En lugar de eso, el enemigo usa `EventBus.dungeon.room_entered` y detecta automáticamente cuándo es el último enemigo vivo para emitir `EventBus.dungeon.room_cleared`.

## 4. Componentes Reutilizables

### 4.1 Existentes (se reutilizan tal cual)

| Componente | Archivo | Uso |
|---|---|---|
| `Entity` | `scripts/entities/entity.gd` | Base de todos los actores |
| `Component` | `scripts/components/component.gd` | Base de componentes |
| `HealthComponent` | `scripts/components/health_component.gd` | HP del enemigo |
| `HurtboxComponent` | `scripts/components/hurtbox_component.gd` | Receptor de daño |

### 4.2 Nuevos

| Componente | Responsabilidad |
|---|---|
| `StateMachine` | Contenedor de estados. Delega `_process` y `_physics_process` al estado activo. Almacena referencia al actor. |
| `LootComponent` | Al morir, consulta `EnemyStats.loot_table` y emite `EventBus.items.collected`. |
| `MetaKnowledgeComponent` | En `_ready()` registra el encuentro en `MetaKnowledge`. En `_die()` incrementa `times_defeated`. |

### 4.3 Resources Nuevos

```gdscript
# scripts/resources/enemy_stats.gd
class_name EnemyStats
extends CharacterStats          # hereda: max_hp, strength, defense, speed, 
                                #          move_speed, attack_speed, critical
@export var detection_range: float = 120.0
@export var attack_range: float = 25.0
@export var attack_cooldown: float = 1.5
@export var xp_value: int = 10
@export var gold_value: int = 10
@export var enemy_id: String = ""
@export var enemy_name: String = ""
@export var loot_table: LootTable
```

```gdscript
# scripts/resources/loot_table.gd
class_name LootTable
extends Resource
@export var entries: Array[LootEntry]

# scripts/resources/loot_entry.gd
class_name LootEntry
extends Resource
@export var item_id: String
@export var item_name: String
@export var gold_value: int
@export var drop_chance: float  # 0.0 - 1.0
```

```gdscript
# scripts/resources/encounter_table.gd
class_name EncounterTable
extends Resource
@export var enemies: Array[EncounterEntry]

# scripts/resources/encounter_entry.gd
class_name EncounterEntry
extends Resource
@export var enemy_scene: PackedScene
@export var weight: int = 1
```

## 5. Resources Necesarios

```
resources/
├── enemies/
│   ├── goblin_stats.tres        ← EnemyStats (HP:30, STR:8, SPD:60...)
│   ├── goblin_loot.tres         ← LootTable (oreja 10oro 80%, nada 20%)
│   ├── skeleton_stats.tres      ← (futuro)
│   └── skeleton_loot.tres       ← (futuro)
├── dungeon/
│   └── encounter_tables.tres    ← EncounterTable por RoomType
└── characters/
    └── barbarian_stats.tres     ← (existente)
```

Cada `EnemyStats.tres` apunta a una `LootTable.tres`. El `EncounterTable.tres` mapea qué escenas de enemigos pueden aparecer en cada tipo de sala.

## 6. Máquina de Estados

### 6.1 Definición

La `StateMachine` itera sobre un `Dictionary[String, EnemyState]`. Cada `EnemyState` es un `Resource` con métodos `enter`, `exit`, `update`, `physics_update`. El estado devuelve el nombre del siguiente estado, o `""` para permanecer.

### 6.2 Transiciones

```
                     Idle
                      │
                      │ timer agotado
                      ↓
                    Patrol ←────────────────────┐
                      │                         │
                      │ detection_area          │ jugador fuera de
                      │ body_entered            │ detection_range (perdió)
                      ↓                         │
                    Chase ──────────────────────┘
                      │
                      │ distancia ≤ attack_range
                      │ AND cooldown ≤ 0
                      ↓
                   Attack ──────────────────────┐
                      │                         │
                      │ recibe daño              │ jugador sale de
                      ↓                         │ attack_range
                    Hurt                        │
                      │                         │
                      │ animación hurt termina   │
                      └──→ vuelve a Chase ──────┘

   Cualquier estado → Dead (cuando health_component emite health_depleted)
```

### 6.3 Detalles por estado

| Estado | Entrada | Update | Salida |
|---|---|---|---|
| **Idle** | Inicia timer aleatorio (1-3s). | Espera. Si timer=0 → Patrol. Si detection_area.body_entered(id=player) → Chase. | — |
| **Patrol** | Toma siguiente punto de patrol_path. | `move_and_slide()` hacia punto. Al llegar → Idle. Si detection_area.body_entered → Chase. | — |
| **Chase** | Cachea player_ref. | `move_and_slide()` hacia player_ref. Si distancia ≤ attack_range → Attack. Si pierde contacto visual (detection_area.body_exited + 2s grace) → Patrol. | — |
| **Attack** | Calcula daño, llama a `DamageSystem.apply_hit()`. Inicia cooldown. | Espera. Si cooldown=0 y distancia ≤ attack_range → Attack. Si distancia > attack_range → Chase. | — |
| **Hurt** | Reproduce flash/blink. Timer 0.2s. | Espera timer. Al terminar → Chase. | — |
| **Dead** | Detiene `process_mode`. Ejecuta animación de muerte. Emite eventos. `queue_free()` tras animación. | No ejecuta nada. | N/A (terminal). |

### 6.4 Comportamiento de grupo (opcional, diferido)

No se incluye en MVP. Para futura iteración: cuando un enemigo entra en Chase, emite `EventBus.combat.alert_nearby`. Los vecinos en Idle/Patrol que lo reciban pasan a Chase también.

## 7. Flujo de Eventos con EventBus

### 7.1 Eventos consumidos por el enemigo

| Evento | Emisor | Suscriptor | Acción |
|---|---|---|---|
| `EventBus.dungeon.room_entered` | Room | Enemy | Activa AI (si no está en Dead). |
| — | DamageSystem (vía HurtboxComponent) | Enemy (directo) | Transición a Hurt. |

### 7.2 Eventos emitidos por el enemigo

| Evento | Cuándo | Payload | Consumidores esperados |
|---|---|---|---|
| `EventBus.combat.hit_landed` | Enemy ataca a Player | `(attacker, target, damage)` | DamageSystem (ya existe), HUD (futuro), Audio (futuro) |
| `EventBus.combat.enemy_killed` | Enemy._die() | `(enemy, killer)` | Room, HUD, MetaKnowledge, Quest |
| `EventBus.dungeon.room_cleared` | Último enemigo de la sala muere | `(room)` | Room (activa salidas), HUD |
| `EventBus.combat.alert_nearby` | Enemy pasa a Chase | `(position, enemy_type)` | Vecinos (futuro, grupo) |

### 7.3 Diagrama de secuencia — Ataque enemigo

```
Player                Enemy              StateMachine      DamageSystem        EventBus
  │                     │                     │                 │               │
  │                     │  distancia ≤ 25     │                 │               │
  │                     │ ←────────────────── │                 │               │
  │                     │  "attack"           │                 │               │
  │                     │ ──────────────────→ │                 │               │
  │                     │                     │                 │               │
  │                     │  apply_hit(player)  │                 │               │
  │                     │ ───────────────────────────────────→ │               │
  │                     │                     │                 │               │
  │                     │                     │       hit_landed(emit)          │
  │                     │                     │                 │ ────────────→ │
  │                     │                     │                 │               │
  │  take_damage(8)     │                     │                 │               │
  │ ←───────────────────────────────────────────────────────────│               │
  │                     │                     │                 │               │
```

### 7.4 Diagrama de secuencia — Muerte enemiga

```
Enemy           HealthComponent      StateMachine       EventBus               Room
  │                     │                  │               │                    │
  │  health_depleted    │                  │               │                    │
  │ ←────────────────── │                  │               │                    │
  │                     │                  │               │                    │
  │  "dead"             │                  │               │                    │
  │ ────────────────────────────────────→  │               │                    │
  │                     │                  │               │                    │
  │  enemy_killed(emit) │                  │               │                    │
  │ ────────────────────────────────────────────────→      │                    │
  │                     │                  │               │                    │
  │  check_last_enemy   │                  │               │                    │
  │ ────────────────────────────────────────────────────────────────────────→   │
  │                     │                  │               │  room_cleared(emit)│
  │                     │                  │               │ ←───────────────── │
  │  queue_free()       │                  │               │                    │
  │ ───────────────────────────────────────────────────────────────────────────→ │
```

## 8. Integración con CharacterStats y HealthComponent

### 8.1 EnemyStats como extensión de CharacterStats

`EnemyStats` hereda de `CharacterStats` para reutilizar los campos base (max_hp, strength, defense, move_speed, attack_speed, critical) y añade los específicos de enemigo (detection_range, attack_range, attack_cooldown, xp_value, gold_value, loot_table).

El `Entity._apply_stats()` itera componentes y llama `component.setup(stats)`. Como `EnemyStats` es subtipo de `CharacterStats`, el `stats` exportado en `Entity` acepta cualquiera de los dos. El `HealthComponent` puede leer `max_hp`, `strength` etc. desde el mismo recurso sin cambios.

```
     CharacterStats                    EnemyStats
  ┌──────────────────┐             ┌──────────────────────┐
  │ max_hp           │◄────hereda──│ detection_range       │
  │ strength         │             │ attack_range          │
  │ defense          │             │ attack_cooldown       │
  │ move_speed       │             │ xp_value              │
  │ attack_speed     │             │ gold_value            │
  │ critical         │             │ loot_table            │
  │ ...              │             │ enemy_id              │
  └──────────────────┘             │ enemy_name            │
                                   └──────────────────────┘
```

### 8.2 Flujo de daño

```
Golpe enemigo al jugador:
  1. Enemy (Attack state) calcula daño con stats.strength
  2. Llama a DamageSystem.apply_hit(player, damage, self)
  3. DamageSystem busca HurtboxComponent en el player
  4. HurtboxComponent.apply_damage() → HealthComponent.take_damage()
  5. HealthComponent emite health_changed (conectado → HUD vía EventBus)
  6. DamageSystem emite EventBus.combat.hit_landed

Golpe del jugador al enemigo:
  1. (Futuro — PlayerController ataca, mismo flujo invertido)
  2. DamageSystem.apply_hit(enemy, damage, player)
  3. → HurtboxComponent → HealthComponent.take_damage()
  4. HealthComponent emite health_depleted si ≤ 0
  5. HealthComponent notifica a Enemy (vía parent lookup o señal)
  6. Enemy.StateMachine → Dead
```

### 8.3 Inicialización de HealthComponent desde EnemyStats

`HealthComponent` ya tiene `max_health: int` y `current_health`. El `Entity._apply_stats()` llama a `component.setup(stats)` para cada `Component`. El `HealthComponent._setup()` haría:

```gdscript
func setup(data: Resource) -> void:
    if data is CharacterStats:
        max_health = data.max_hp
        current_health = max_health
```

## 9. Sistema de Detección del Jugador

### 9.1 Mecanismo

Cada enemigo tiene un `DetectionArea (Area2D)` hijo. Este `Area2D` tiene:
- `collision_mask = 1` (detecta a la capa del player)
- Una `CollisionShape2D` circular con `radius = enemy_stats.detection_range`
- Sin colisiones de física (solo detección área-área/cuerpo-área)
- Señales conectadas: `body_entered`, `body_exited`
- Cachea `player_ref` cuando `body.is_in_group("player")`

**El enemigo NUNCA llama a `get_tree().get_nodes_in_group("player")`.**

### 9.2 Transparencia de paredes (MVP)

En MVP la detección atraviesa paredes (no hay raycast de verificación). Esto es un *tradeoff aceptado* (ver sección 10). Para mejorarlo, añadir un `RayCast2D` entre enemigo y jugador en cada frame de Chase; si el raycast golpea una pared, el enemigo pierde el target.

### 9.3 Grace period

Cuando `body_exited` se dispara para el player, el enemigo no pasa inmediatamente a Patrol. En lugar de eso, inicia un timer de 2 segundos. Si el jugador no es redetectado en ese lapso, la transición ocurre. Esto evita que un enemigo "olvide" al jugador por un frame de separación.

### 9.4 Cacheo y limpieza

```
player_ref: Node2D          ← cacheada en body_entered, null en body_exited
detection_timer: float      ← cuenta regresiva de grace period
```

En cada frame de Chase:
1. Si `player_ref` es `null` o no `is_instance_valid()` → Patrol.
2. Si distancia > `detection_range * 1.5` → agota el grace period más rápido.
3. Si `RayCast2D` (futuro) detecta pared → pierde target inmediato.

## 10. Riesgos y Alternativas

| Riesgo | Impacto | Mitigación |
|---|---|---|
| **R1 — StateMachine como Resource (EnemyState) no funciona bien en Godot si los estados necesitan referencias a nodos.** Los Resources no tienen `_process()` y no pueden acceder al árbol de escenas directamente. | Medio. Los estados no podrían hacer `move_and_slide()` por sí mismos. | **Decisión:** Los estados NO ejecutan lógica directamente. Son objetos de datos que devuelven intenciones ("mover hacia", "atacar", "esperar X seg"). La `StateMachine` (Node) ejecuta esas intenciones en nombre del estado activo. Alternativa: que los estados sean Nodes hijos de StateMachine (en vez de Resources), pero eso rompe la serialización y dificulta la reutilización. |
| **R2 — EnemyStats hereda de CharacterStats, arrastrando campos que el enemigo no usa (`health`, `agility`, `vitality`, `armor`).** Posible confusión. | Bajo. | Aceptado. Los campos sobran pero no estorban. Se limpiarán cuando se implemente el sistema de stats completo. |
| **R3 — DetectionArea con body_entered no funciona si el jugador ya está dentro al instanciar el enemigo.** | Alto. El enemigo no detecta al jugador si aparece dentro de su rango. | **Mitigación:** En `Enemy._ready()`, tras añadirse al árbol, iterar `detection_area.get_overlapping_bodies()`. Si el player está entre ellos, cachear y transicionar a Chase inmediatamente. |
| **R4 — Múltiples enemigos atacando al mismo frame pueden saturar `DamageSystem.apply_hit()`.** | Bajo. Godot maneja bien llamadas secuenciales. | No requiere mitigación en MVP. Si surgen problemas de rendimiento, añadir cola de hits procesada por frame. |
| **R5 — Room no sabe cuándo todos los enemigos han muerto** si el enemigo muere sin emitir señal o la señal se pierde. | Alto. Room nunca se limpia. | El enemigo emite `EventBus.combat.enemy_killed` en `_die()`. La Room escucha este evento, cuenta bajas y compara contra el total de enemigos spawnheados. Si hay desajuste, un timer de seguridad (30s) fuerza el room_cleared. |
| **R6 — Un enemigo puede quedar en Dead pero no ser liberado** si `queue_free()` se retrasa o falla. | Medio. Fuga de memoria leve. | `Dead` estado llama a `actor.queue_free()` tras la animación. Si `is_queued_for_deletion()` es true, no procesar más frames. |
| **R7 — El `Script` child node anti-patrón en las rooms actuales (C1 de TECH_DEBT.md) haría que `_spawn_enemy()` nunca se ejecute.** | Crítico (bloqueante). | **Bloqueante:** RFC-001 debe implementarse DESPUÉS de que C1 esté resuelto (rooms con herencia correcta). Ver TECH_DEBT.md > Critical > C1. |

## 11. Criterios de Aceptación

1. Un `Goblin.tscn` instanciado en una sala entra en **Idle**, al detectar al jugador por `DetectionArea` pasa a **Chase**, al alcanzar distancia de ataque pasa a **Attack** y golpea al jugador aplicando daño real a su `HealthComponent`.
2. Al recibir daño, el goblin entra en **Hurt** (flash visual) y regresa a **Chase**.
3. Al llegar a 0 HP, el goblin entra en **Dead**, emite `EventBus.combat.enemy_killed`, la sala detecta que todos los enemigos han muerto y activa las salidas.
4. El goblin suelta loot según su `LootTable` al morir.
5. Al instanciar un goblin CON el jugador ya dentro de su `DetectionArea`, lo detecta inmediatamente (sin esperar a que el jugador se mueva).
6. Al instanciar un goblin SIN el jugador dentro de su rango, permanece en Idle hasta que el jugador se aproxime.
7. Si el jugador sale del rango de detección, el goblin espera 2 segundos antes de volver a Patrol.
8. Un enemigo `Skeleton` (o segundo tipo) puede definirse con solo crear un `SkeletonStats.tres` + `Skeleton.tscn` que herede de `Enemy.tscn`, sin modificar ningún script del motor.
9. Todos los valores numéricos del enemigo (HP, daño, velocidad, rangos, cooldowns, loot) están en `EnemyStats.tres`, no hardcodeados en GDScript.
10. `get_tree().get_nodes_in_group("player")` no aparece en ningún script de enemigos.

## Apéndice A — Archivos a crear (solo referencia, no implementar)

```
scripts/
├── entities/
│   └── enemies/
│       ├── enemy.gd               ← base del enemigo
│       ├── goblin.gd              ← variante goblin (mínimo)
│       └── skeleton.gd            ← variante skeleton (futuro)
├── components/
│   ├── state_machine.gd           ← FSM genérico
│   ├── loot_component.gd          ← otorga loot al morir
│   └── meta_knowledge_component.gd← registro en bestiario
├── resources/
│   ├── enemy_stats.gd             ← recurso de stats
│   ├── loot_table.gd              ← recurso de loot
│   ├── loot_entry.gd              ← entrada individual de loot
│   ├── encounter_table.gd         ← tabla de encuentros
│   └── encounter_entry.gd         ← entrada de encuentro
├── states/
│   ├── idle_state.gd
│   ├── patrol_state.gd
│   ├── chase_state.gd
│   ├── attack_state.gd
│   ├── hurt_state.gd
│   └── dead_state.gd
resources/
├── enemies/
│   ├── goblin_stats.tres
│   ├── goblin_loot.tres
│   ├── skeleton_stats.tres
│   ├── skeleton_loot.tres
│   └── encounter_tables.tres
scenes/
├── entities/
│   ├── enemies/
│   │   ├── Enemy.tscn
│   │   ├── Goblin.tscn
│   │   └── Skeleton.tscn
│   └── player/
│       └── Player.tscn
```

## Apéndice B — Archivos a modificar (solo referencia)

| Archivo | Cambio |
|---|---|
| `scripts/dungeon/RoomCombat.gd` | Usar `EncounterTable` para instanciar enemigos, no preload directo. No asignar `room_ref`. |
| `scripts/dungeon/RoomElite.gd` | Ibídem. |
| `scripts/dungeon/BaseRoom.gd` | Escuchar `EventBus.combat.enemy_killed` para detectar limpieza de sala. |
| `scenes/dungeon/rooms/CombatRoom.tscn` | Tras resolver C1 (herencia correcta), añadir `SpawnPoints` como hijos de Marker2D. |
| `scenes/dungeon/enemies/Goblin.tscn` | Reemplazar contenido por instancia de `Enemy.tscn` con variante Goblin. |

## Apéndice C — Tradeoffs aceptados

- **Sin pathfinding en MVP.** `NavigationAgent2D` está en el árbol de escenas pero deshabilitado. Enemies se mueven en línea recta hacia el jugador. Cuando se añada navegación, solo cambiará Chase state.
- **Sin raycast de verificación de línea de visión.** La detección atraviesa paredes. Se mitigará con un `RayCast2D` opcional en futura iteración.
- **EnemyState como Resource sin lógica de escena.** Esto limita lo que un estado puede hacer (no puede acceder directamente a nodos). La `StateMachine` (Node) interpreta las intenciones del estado. Esto mantiene los estados serializables y reutilizables entre tipos de enemigo.
- **LootComponent atómico.** Cada enemigo tiene su propio LootComponent. No hay "loot compartido" entre enemigos del mismo tipo; cada instancia tiene su propia tirada. El `LootTable` Resource se puede compartir, pero la tirada es por instancia.
