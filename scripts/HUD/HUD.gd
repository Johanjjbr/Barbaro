extends CanvasLayer

var notification_pool: Array = []


func _ready():
	NotificationSystem.notification_added.connect(_on_notification_added)
	NotificationSystem.notification_removed.connect(_on_notification_removed)


func _process(delta):
	_update_bars()
	_update_skills()
	_update_depth()


func _update_bars():
	var hp_ratio = float(RunData.current_hp) / float(RunData.max_hp) if RunData.max_hp > 0 else 0
	$HPBarFill.size.x = 200 * hp_ratio
	$HPBar/HPText.text = "%d/%d" % [RunData.current_hp, RunData.max_hp]
	var fury_ratio = float(RunData.fury) / float(RunData.max_fury) if RunData.max_fury > 0 else 0
	$FuryBarFill.size.x = 200 * fury_ratio
	$FuryBar/FuryText.text = "%d/%d" % [RunData.fury, RunData.max_fury]
	if RunData.berserker_active:
		$BerserkerIndicator.text = "¡BERSERKER! %.1fs" % RunData.berserker_timer
	else:
		$BerserkerIndicator.text = ""


func _update_skills():
	var can_heavy = RunData.fury >= 20
	$SkillsContainer/SkillHeavy.modulate = Color(1, 1, 1, 1) if can_heavy else Color(0.5, 0.5, 0.5, 0.5)
	var can_bash = RunData.fury >= 30
	$SkillsContainer/SkillBash.modulate = Color(1, 1, 1, 1) if can_bash else Color(0.5, 0.5, 0.5, 0.5)
	var can_roar = RunData.fury >= 25
	$SkillsContainer/SkillRoar.modulate = Color(1, 1, 1, 1) if can_roar else Color(0.5, 0.5, 0.5, 0.5)


func _update_depth():
	$DepthLabel.text = "Piso: %d | Salas: %d" % [RunData.dungeon_depth, RunData.rooms_cleared]


func _on_notification_added(notification):
	var label = Label.new()
	label.text = notification.text
	label.add_theme_color_override("font_color", Color(0.8, 0.9, 1, 1))
	label.add_theme_font_size_override("font_size", 12)
	label.modulate = Color(1, 1, 1, 1)
	$NotificationContainer.add_child(label)
	notification_pool.append(label)
	if $NotificationContainer.get_child_count() > 5:
		var old = $NotificationContainer.get_child(0)
		$NotificationContainer.remove_child(old)
		old.queue_free()


func _on_notification_removed(index: int):
	if index < $NotificationContainer.get_child_count():
		var child = $NotificationContainer.get_child(index)
		child.modulate = Color(1, 1, 1, 0)
		var tween = create_tween()
		tween.tween_property(child, "modulate", Color(1, 1, 1, 0), 0.5)
		await tween.finished
		$NotificationContainer.remove_child(child)
		child.queue_free()
