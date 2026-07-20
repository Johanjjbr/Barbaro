extends Node
class_name EventBus

class GameEvents extends Node:
    signal started()
    signal paused()
    signal resumed()
    signal game_over()

class PlayerEvents extends Node:
    signal damaged(amount: int, source: Node)
    signal died()
    signal interacted(target: Node)

class CombatEvents extends Node:
    signal attack_started(attacker: Node, target: Node)
    signal hit_landed(attacker: Node, target: Node, damage: int)
    signal enemy_killed(enemy: Node, killer: Node)

class ItemEvents extends Node:
    signal collected(item: Resource, quantity: int)
    signal equipped(item: Resource, slot: String)
    signal unequipped(item: Resource, slot: String)

class DungeonEvents extends Node:
    signal entered(depth: int)
    signal exited()
    signal room_entered(room: Node)
    signal room_cleared(room: Node)

class CityEvents extends Node:
    signal entered()
    signal exited()
    signal day_passed(day: int)
    signal tax_collected(amount: int)

class QuestEvents extends Node:
    signal accepted(quest: Resource)
    signal completed(quest: Resource)
    signal failed(quest: Resource)

class ProgressionEvents extends Node:
    signal experience_gained(amount: int, total: int)
    signal leveled_up(new_level: int)
    signal skill_unlocked(skill_id: String)

class UIEvents extends Node:
    signal notification(message: String, notification_type: String)
    signal opened(panel_name: String)
    signal closed(panel_name: String)

class SaveEvents extends Node:
    signal requested(slot: int)
    signal loaded(slot: int)
    signal save_completed(slot: int, success: bool)
    signal load_completed(slot: int, success: bool)

var game: GameEvents
var player: PlayerEvents
var combat: CombatEvents
var items: ItemEvents
var dungeon: DungeonEvents
var city: CityEvents
var quest: QuestEvents
var progression: ProgressionEvents
var ui: UIEvents
var save: SaveEvents

func _ready() -> void:
    game = GameEvents.new()
    game.name = "GameEvents"
    add_child(game)

    player = PlayerEvents.new()
    player.name = "PlayerEvents"
    add_child(player)

    combat = CombatEvents.new()
    combat.name = "CombatEvents"
    add_child(combat)

    items = ItemEvents.new()
    items.name = "ItemEvents"
    add_child(items)

    dungeon = DungeonEvents.new()
    dungeon.name = "DungeonEvents"
    add_child(dungeon)

    city = CityEvents.new()
    city.name = "CityEvents"
    add_child(city)

    quest = QuestEvents.new()
    quest.name = "QuestEvents"
    add_child(quest)

    progression = ProgressionEvents.new()
    progression.name = "ProgressionEvents"
    add_child(progression)

    ui = UIEvents.new()
    ui.name = "UIEvents"
    add_child(ui)

    save = SaveEvents.new()
    save.name = "SaveEvents"
    add_child(save)
