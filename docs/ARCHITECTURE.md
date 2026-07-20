# ARCHITECTURE.md — Visión Técnica

## Arquitectura General

**Patrón:** Component Based + Data Driven  
**Motor:** Godot 4.4 Stable  
**Lenguaje:** GDScript 2.0

---

## Principios Arquitectónicos

### 1. Composición sobre Herencia
Las entidades se construyen ensamblando componentes independientes.  
Un `Player` no hereda de una clase gigante — tiene componentes de `Health`, `Stats`, `Inventory`, `Equipment`.

### 2. Datos sobre Lógica
Todo valor configurable vive en recursos `Resource` de Godot.  
Los scripts solo contienen lógica. Los datos se cargan desde assets.

### 3. Comunicación débilmente acoplada
- **Signals** para eventos entre sistemas.
- **EventBus** global para eventos transversales.
- **Referencias directas** solo dentro del mismo sistema.

---

## Capas del Sistema

```
┌─────────────────────────────┐
│  UI Layer (event-driven)     │
├─────────────────────────────┤
│  Systems Layer (lógica)      │
│  Player / Combat / AI / etc  │
├─────────────────────────────┤
│  Data Layer (Resources)      │
│  StatsData / ItemData / etc  │
├─────────────────────────────┤
│  Engine Layer (Godot 4.4)   │
│  SceneTree / Physics / Input │
└─────────────────────────────┘
```

---

## Diagrama de Flujo de Datos

```
Input → PlayerController → StatsComponent
         ↓                      ↓
    CombatSystem ← → EquipmentSystem
         ↓
    HitSignal → HealthComponent → DeathSignal
         ↓
    EventBus → UI / Audio / Save
```

---

## Sistema de Recursos (Data Driven)

Cada entidad configurable usa un recurso:

```
resources/
├── characters/
│   ├── barbarian_stats.tres
│   └── enemy_stats.tres
├── items/
│   ├── iron_sword.tres
│   └── leather_armor.tres
├── dungeon/
│   ├── room_templates.tres
│   └── encounter_tables.tres
└── progression/
    ├── level_curves.tres
    └── skill_trees.tres
```

---

## Sistema de Señales (Event Bus)

Cada sistema emite eventos. Otros sistemas se suscriben sin conocerse.

```
EventBus (autoload singleton)
├── player_damaged
├── enemy_killed
├── item_collected
├── dungeon_entered
├── dungeon_exited
├── day_passed
├── tax_collected
├── quest_completed
├── save_requested
├── load_requested
└── ui_notification
```

---

## Patrón de Componente

```gdscript
# Base class for all components
class_name Component
extends Node

signal component_ready

func setup(data: Resource) -> void:
    pass

func teardown() -> void:
    pass
```

---

## Gestión de Escenas

Cada escena es una unidad funcional mínima:

```
scenes/
├── entities/       # Player, Enemy, NPC, Chest
├── ui/             # HUD, Inventory, Dialogue
├── dungeon/        # Rooms, tiles, minimap
├── city/           # Buildings, NPCs, shops
└── systems/        # Autoloads, managers
```

---

## Seguridad y Performance

- Referencias cacheadas en `_ready()`, no búsquedas en caliente.
- Groups usados solo para tagging inicial.
- Pool de objetos para proyectiles y efectos.
- Lazy loading de recursos pesados.
