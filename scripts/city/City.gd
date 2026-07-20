extends Node2D


func _ready():
	_update_ui()
	$ButtonContainer/DungeonButton.pressed.connect(_on_dungeon_pressed)
	$ButtonContainer/ShopButton.pressed.connect(_on_shop_pressed)
	$ButtonContainer/ForgeButton.pressed.connect(_on_forge_pressed)
	$ButtonContainer/TrainerButton.pressed.connect(_on_trainer_pressed)
	$ButtonContainer/CompendiumButton.pressed.connect(_on_compendium_pressed)


func _update_ui():
	$StatsLabel.text = "Oro: %d | Reputación: %d | Sospecha: %d" % [PlayerData.gold, PlayerData.reputation, PlayerData.suspicion]
	$TaxLabel.text = "Impuestos en: %d días | Rango: %s" % [PlayerData.days_until_tax, PlayerData.citizen_tier.capitalize()]


func _on_dungeon_pressed():
	GameManager.enter_dungeon()


func _on_shop_pressed():
	NotificationSystem.add_notification("Tienda: Próximamente...")


func _on_forge_pressed():
	NotificationSystem.add_notification("Forja: Próximamente...")


func _on_trainer_pressed():
	NotificationSystem.add_notification("Entrenador: Próximamente...")


func _on_compendium_pressed():
	NotificationSystem.add_notification("Compendio: %d enemigos registrados, %d habitaciones exploradas" % [MetaKnowledge.bestiary.size(), MetaKnowledge.explored_rooms.size()])
