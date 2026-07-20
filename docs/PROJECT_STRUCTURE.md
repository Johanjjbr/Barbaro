# PROJECT_STRUCTURE.md — Estructura del Proyecto

## Jerarquía de Carpetas

```
el_barbaro/
├── docs/                   # Documentación del proyecto
│   ├── GDD.md
│   ├── AGENTS.md
│   ├── ARCHITECTURE.md
│   ├── ROADMAP.md
│   ├── CODING_STANDARDS.md
│   └── PROJECT_STRUCTURE.md
│
├── systems/                # Documentación de cada sistema
│   ├── player.md
│   ├── combat.md
│   ├── inventory.md
│   ├── stats.md
│   ├── equipment.md
│   ├── ai.md
│   ├── dungeon.md
│   ├── city.md
│   ├── save_system.md
│   ├── ui.md
│   ├── audio.md
│   └── progression.md
│
├── assets/                 # Recursos artísticos y de audio
│   ├── sprites/
│   │   ├── characters/
│   │   ├── environment/
│   │   ├── items/
│   │   └── ui/
│   ├── audio/
│   │   ├── sfx/
│   │   └── music/
│   └── fonts/
│
├── resources/              # Recursos Godot (Resources)
│   ├── characters/         # Stats de personajes
│   ├── items/              # Datos de items
│   ├── skills/             # Datos de habilidades
│   ├── dungeon/            # Tablas de generación
│   └── progression/        # Curvas de nivel, árboles
│
├── scenes/                 # Escenas Godot
│   ├── entities/           # Player, Enemy, NPC, Chest
│   │   ├── player/
│   │   ├── enemy/
│   │   └── npc/
│   ├── ui/                 # Interfaces de usuario
│   │   ├── hud/
│   │   ├── inventory/
│   │   ├── dialogue/
│   │   └── menus/
│   ├── dungeon/            # Salas, tiles, minimapa
│   │   ├── rooms/
│   │   └── minimap/
│   ├── city/               # Edificios, NPCs, tiendas
│   │   ├── buildings/
│   │   └── shops/
│   └── effects/            # Efectos visuales
│
├── scripts/                # Código fuente
│   ├── core/               # Autoloads, managers
│   │   ├── event_bus.gd
│   │   ├── game_manager.gd
│   │   └── save_manager.gd
│   ├── components/         # Componentes reutilizables
│   │   ├── health_component.gd
│   │   ├── stats_component.gd
│   │   ├── inventory_component.gd
│   │   └── movement_component.gd
│   ├── systems/            # Lógica de sistemas
│   │   ├── combat_system.gd
│   │   └── ai_system.gd
│   ├── entities/           # Scripts de entidades
│   │   ├── player_controller.gd
│   │   ├── enemy_controller.gd
│   │   └── npc_controller.gd
│   ├── ui/                 # Lógica de UI
│   │   ├── hud.gd
│   │   ├── inventory_ui.gd
│   │   └── dialogue_ui.gd
│   ├── dungeon/            # Generación de mazmorras
│   │   ├── dungeon_generator.gd
│   │   └── room_templates.gd
│   └── city/               # Lógica de ciudad
│       ├── city_manager.gd
│       └── shop_manager.gd
│
├── tests/                  # Tests (si aplica)
│
├── AGENTS.md               # Reglas para IA (raíz)
├── GDD_El_Barbaro.md       # GDD original de referencia
├── Referencia_Fuente_y_Gap_Analysis.md
├── project.godot           # Archivo de proyecto Godot
└── README.md               # Instrucciones del proyecto
```

## Escenas y sus Componentes

| Escena | Componentes | Responsabilidad |
|--------|------------|----------------|
| `Player.tscn` | MovementComponent, StatsComponent, HealthComponent, InventoryComponent, EquipmentComponent | Control del personaje principal |
| `Enemy.tscn` | StatsComponent, HealthComponent, AIComponent, LootComponent | Enemigos del dungeon |
| `NPC.tscn` | DialogueComponent, ShopComponent, QuestComponent | Interacción en ciudad |
| `HealthBar.tscn` | (solo UI) | Barra de vida |
| `Room.tscn` | TileMap, SpawnerComponent | Habitación de dungeon |
| `ItemPickup.tscn` | Sprite, Area2D | Item en el suelo |

## Autoloads (Singleton)

| Script | Propósito |
|--------|-----------|
| `EventBus` | Señales globales entre sistemas |
| `GameManager` | Estado global del juego |
| `SaveManager` | Persistencia |
| `AudioManager` | Reproducción de sonido |
| `DungeonManager` | Estado de la mazmorra activa |
| `CityManager` | Estado de la ciudad |
