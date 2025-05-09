extends VBoxContainer

class_name ToastNotifications

@export var notif_queue: Array[String] = []

# TODO: Every stat increase should be added to a queue in order to play the animation
#func _process(delta):
		#create_toast_notification(notif_queue.pop_front())

func on_level_up(resource: TamagotchiResource):
	var str = "Level up!"
	notif_queue.push_back(str)
	create_toast_notification(str)

func on_max_stat_change(resource: StatsResource, stat: StatsResource.StatTypes, amount: int):
	var str = Utils.replace_keywords("<<" + resource.stat_dict[stat]["name"] + ">> +" + str(amount))
	notif_queue.push_back(str)
	create_toast_notification(str)

func create_toast_notification(str: String):
	var msg_scene = SceneManager.scenes["toast_notification"]
	var new_msg = msg_scene.instantiate()
	new_msg.text = str
	self.add_child(new_msg)
