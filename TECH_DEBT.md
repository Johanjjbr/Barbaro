# Technical Debt

## Critical

- **C1 — Room `Script` child node breaks inheritance chain.** All 5 room `.tscn` files (`CombatRoom`, `EliteRoom`, `ExitRoom`, `StartRoom`, `TreasureRoom`) have the root node's script set to `BaseRoom.gd` and a child `[node name="Script" type="Script"]` node with the subclass script. In Godot, a child `Script` node does *not* extend the root's script — the subclass logic (`_spawn_enemy`, `_claim_loot`, `on_room_cleared` overrides) is completely dead code. Room scenes must be rebuilt so the root node's `script=` directly references the subclass (e.g. `RoomCombat.gd`), with `BaseRoom` given a `class_name` for typed inheritance. **Blocking:** any room-specific behaviour (enemy spawning, loot, start-room free exit) does not work.

- **C2 — `HUD.tscn` is missing 10+ child nodes that `HUD.gd` accesses via `$`.** The scene file contains only a `HPBar` ColorRect, but `HUD.gd` references `$HPBarFill`, `$HPBar/HPText`, `$FuryBarFill`, `$FuryBar/FuryText`, `$BerserkerIndicator`, `$SkillsContainer/SkillHeavy`, `$SkillsContainer/SkillBash`, `$SkillsContainer/SkillRoar`, `$DepthLabel`, and `$NotificationContainer`. All will produce null-reference errors at runtime.

- **C3 — `BaseRoom.gd` declares `@onready var exit_up = $ExitUp` and `@onready var exit_down = $ExitDown`, but no room `.tscn` contains `ExitUp` or `ExitDown` child nodes.** Both `@onready` lines will error on instantiation.

- **C4 — Input action mismatch: `DungeonManager.gd` checks `Input.is_action_just_pressed("ui_cancel")` but `project.godot` defines the action as `"pause"`.** Pressing Escape in the dungeon never toggles pause.

- **C5 — No error handling in save/load.** `FileAccess.open()` returns `null` on failure, but `MetaKnowledge`, `PlayerData`, and `ConfigManager` never log *which* file failed or provide fallback defaults. Corrupted saves or disk-full conditions cause silent data loss.

## High

- **H1 — Enemies are monolithic; no ECS migration.** `Goblin.gd` is a single 130-line script with hardcoded stats, inline AI, manual debuff management, direct player lookup (`get_tree().get_nodes_in_group("player")` every frame), and hardcoded loot strings. The `Entity` base class and `Component` infrastructure exist but Goblin ignores them entirely. **Derived refactor:** R1 — Migrate enemies to ECS.

- **H2 — HUD polls `RunData` directly every frame, violating the event-driven architecture.** `AGENTS.md` mandates "UI must use events; never directly access Player", but `HUD._process()` reads `RunData.current_hp`, `RunData.fury`, `RunData.berserker_active`, etc. every tick. **Derived refactor:** R4 — Rebuild HUD to be event-driven.

- **H3 — 34 of 36 EventBus signals are declared but never emitted.** The bus defines 36 signals across 10 categories; only `game.started` and `combat.hit_landed` are ever `emit()`ed anywhere. 94% of the event infrastructure is dead code, and the architecture's intended decoupling is not enforced.

- **H4 — `GameManager.change_state()` calls `change_scene_to_file` with no transition system.** The signal is emitted *before* the scene loads. There is no loading screen, no preload, no lifecycle hooks. Hard to add transitions or state-persistence logic. **Derived refactor:** R2 — Replace with a SceneManager.

- **H5 — `character_stats.gd` has duplicated `health` and `max_hp` fields + 5 unused fields.** Both `max_hp` (old dict key) and `health` (new ECS field) are exported; only `max_hp` is consumed. `agility`, `vitality`, `attack_speed`, `critical`, `armor` are exported in the `.tres` but never read by any system. 35% of the resource is dead data.

- **H6 — Room subclass scripts use string-path `extends` instead of `class_name`.** All 5 subclasses use `extends "res://scripts/dungeon/BaseRoom.gd"`. Renaming or moving `BaseRoom.gd` breaks all subclasses silently.

- **H7 — No testing infrastructure.** The `tests/` directory is empty. Every change risks regression with no automated verification. **Derived refactor:** R7 — Implement tests.

- **H8 — No centralized resource cache.** `Goblin.tscn` is preloaded in both `RoomCombat.gd` and `RoomElite.gd`. Room template preloads live in an `@onready` dictionary in `DungeonManager`. Duplicated preloads and scattered resource management. **Derived refactor:** R5 — Create a resource cache.

## Medium

- **M1 — Hardcoded magic numbers throughout.** HUD bar widths, enemy stats, dungeon room counts, gold rewards, loot IDs, fury thresholds — all hardcoded instead of using Resources. Violates `AGENTS.md`: "All configurable data must use Resource."

- **M2 — Inconsistent signal connection patterns.** Some via `.connect()` in `_ready()`, some via inspector (none set up), many not connected at all (`HealthComponent`, `HurtboxComponent` signals). Mix of styles makes maintenance harder.

- **M3 — No signal cleanup on node exit.** All `.connect()` calls use default flags. `queue_free()`d nodes can receive emissions to freed instances.

- **M4 — Direct `$` path lookups instead of `@onready` cached references.** `HUD.gd`, `City.gd`, `MainMenu.gd` resolve node paths via `$` in `_process()` and `_ready()` without caching. No type safety, repeated string lookups.

- **M5 — `ExitRoom._process()` polls input every frame.** `Input.is_action_just_pressed("interact")` runs in `_process` instead of `_unhandled_input()`. One extra polling call per frame.

- **M6 — Logger `enabled` field is dead code, `fade_time` on `AudioManager` is unused.** `Logger.enabled` is never toggled anywhere. `AudioManager.play_music()` and `stop_music()` accept `fade_time` but ignore it.

- **M7 — `DungeonManager.room_templates` uses `Dictionary` with single-element `Array` values but only ever accesses `[0]`.** Over-engineered data structure.

- **M8 — `Entity.get_component()` uses linear child iteration every call.** No dictionary cache. For scenes with many entities this is wasteful.

- **M9 — `project.godot` defines input actions that `InputSetup.gd` attempts to duplicate.** Both define identical actions. If `InputSetup` runs before project is parsed, there could be conflicts.

## Low

- **L1 — Empty `pass` stubs left in production code:** `Component.setup()`, `Component.teardown()`, `BaseRoom.on_player_entered()`, `RunData._ready()`, `PlayerData.trigger_interrogation_event()`, `Goblin._on_hurtbox_area_entered()`.

- **L2 — Mixed Spanish and English in strings:** UI text is Spanish, log messages are mixed, code comments are English. `AGENTS.md` does not define a language policy.

- **L3 — `MetaKnowledge.dungeon_seeds_visited` declared but never written or read.** Dead field.

- **L4 — Redundant empty `_ready()` in `RunData.gd`.** Contains only `pass`.

- **L5 — No `@tool` annotations on any script.** No script can run in the editor for designer tooling.

- **L6 — `CharacterStats.defense` and `CharacterStats.armor` are semantically redundant.** Both track the same concept (damage reduction). Only `defense` is consumed by `RunData`.

## Planned Refactors

- **R1 — Migrate enemies to ECS.** Refactor `Goblin.gd` (and future enemy types) to extend `Entity`, use `CharacterStats` resource for stats, use `HealthComponent` + `HurtboxComponent`, extract AI into a separate state machine, use loot-table Resources. **Driven by:** H1.

- **R2 — Create a SceneManager autoload.** Replace `GameManager.change_state()`'s direct `change_scene_to_file` calls with a transition system that supports loading screens, preloading, and lifecycle signals (`scene_about_to_change`, `scene_changed`). **Driven by:** H4.

- **R3 — Fix room inheritance chain.** Rebuild all 5 room `.tscn` files so root node `script=` points to the subclass (e.g. `RoomCombat.gd`), not `BaseRoom.gd`. Add `class_name BaseRoom` for typed extends. **Driven by:** C1, H6.

- **R4 — Event-driven HUD.** Eliminate `_process()` polling. Connect HUD updates to EventBus signals for health, fury, berserker, depth, skills, notifications. **Driven by:** H2.

- **R5 — Centralized resource cache.** Create a static `ResourceCache` class to manage all preloads. Replace scattered `preload()` calls. **Driven by:** H8.

- **R6 — Save/load hardening.** Add logging, error reporting, checksum validation, and structured fallback defaults to all `FileAccess` operations. **Driven by:** C5.

- **R7 — Set up testing infrastructure.** Use GUT or Godot's built-in test runner. Cover damage calculation, stat application, save serialization, dungeon generation. **Driven by:** H7.

- **R8 — Dead code audit.** Remove or implement: unused EventBus signals, unused CharacterStats fields, unused `MetaKnowledge.dungeon_seeds_visited`, unused Logger.enabled, unused AudioManager.fade_time, redundant `CharacterStats.armor` vs `defense`. **Driven by:** H3, H5, L3, L6.

- **R9 — Standardise cross-system communication.** Audit all direct autoload calls (HUD→RunData, City→PlayerData, DungeonManager→GameManager) and migrate to EventBus where appropriate. **Driven by:** H2, H3.

## Accepted Tradeoffs

- **No `StateMachine` for the Player yet.** The ECS PlayerController has only movement + damage bridge. Attack combos, dodge, blocking, and input buffering are deferred until the combat system is designed and enemies are migrated. Moving now would pre-empt an uninformed design.

- **Scene transitions use fire-and-forget.** No loading screen, no preload, no transition animation. Adding these layers before the game loop (dungeon → city → death screen) is stable would add overhead before we know what transitions actually need.

- **`HealthComponent` exists but damage still routes through `RunData`.** The component is wired in the scene tree but `RunData.take_damage()` (with defense calculation, fury gain, and death handling) is the authoritative damage pipeline. Activating `HealthComponent` as the primary damage handler requires migrating the entire combat stack (enemies, buffs, debuffs, berserker, loot-on-death) — a larger refactor gated by R1.

- **No unit tests yet.** The architecture and core gameplay loop are still settling. Writing tests before the component hierarchy stabilises would create high churn. GUT / Godot test runner setup is planned after the next round of refactors.

- **Mixed `extends "res://..."` string paths in Room subclasses.** These are accepted until R3 rebuilds the room scenes, at which point `class_name BaseRoom` will be added and the string paths replaced with typed extends.

- **`character_stats.gd` carries unused fields (`agility`, `vitality`, `attack_speed`, `critical`, `armor`).** These fields document the intended stat system even though no system consumes them yet. Removing them now would create rework when combat, dodging, and crit mechanics are implemented.
