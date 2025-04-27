extends TabContainer

@export var active_tamagotchi_resource: TamagotchiResource

func update_active_tamagotchi(tamagotchi_resource: TamagotchiResource):
	var tabs = get_children()
	for tab in tabs:
		if tab.has_method("update_active_tamagotchi"):
			tab.update_active_tamagotchi(tamagotchi_resource)
