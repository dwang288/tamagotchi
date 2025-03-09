extends Control

func update(tamagotchi: Tamagotchi):
	var hungerValue = tamagotchi.stats.hunger / tamagotchi.stats.maxHunger
	var restValue = tamagotchi.stats.rest / tamagotchi.stats.maxRest
	
	# TODO: Iterate through children
	get_node("HBoxContainer/HungerPanel/Indicator").update(hungerValue)
	get_node("HBoxContainer/RestPanel/Indicator").update(restValue)
