extends Node

class Notification:
	var text: String
	var icon: String
	var duration: float
	var time_remaining: float
	
	func _init(t: String, i: String = "", d: float = 2.0):
		text = t
		icon = i
		duration = d
		time_remaining = d

var notifications: Array[Notification] = []
var max_notifications: int = 5

signal notification_added(notification: Notification)
signal notification_removed(index: int)


func add_notification(text: String, icon: String = "", duration: float = 2.0):
	var notif = Notification.new(text, icon, duration)
	notifications.append(notif)
	if notifications.size() > max_notifications:
		notifications.pop_front()
	notification_added.emit(notif)


func _process(delta):
	var i = 0
	while i < notifications.size():
		notifications[i].time_remaining -= delta
		if notifications[i].time_remaining <= 0:
			notifications.remove_at(i)
			notification_removed.emit(i)
		else:
			i += 1
