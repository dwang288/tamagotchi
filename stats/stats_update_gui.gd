extends Control

func update(tamagotchi_resource: TamagotchiResource):
	var hungerValue = tamagotchi_resource.stats.hunger / tamagotchi_resource.stats.maxHunger
	var restValue = tamagotchi_resource.stats.rest / tamagotchi_resource.stats.maxRest
	
	# TODO: Iterate through children
	get_node("HBoxContainer/HungerPanel/Indicator").update(hungerValue)
	get_node("HBoxContainer/RestPanel/Indicator").update(restValue)
