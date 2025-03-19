extends Control

func update(tamagotchi_resource: TamagotchiResource):
	var hungerValue = tamagotchi_resource.stats.hunger / tamagotchi_resource.stats.maxHunger
	var hygieneValue = tamagotchi_resource.stats.hygiene / tamagotchi_resource.stats.maxHygiene
	var happinessValue = tamagotchi_resource.stats.happiness / tamagotchi_resource.stats.maxHappiness
	var healthValue = tamagotchi_resource.stats.health / tamagotchi_resource.stats.maxHealth
	var restValue = tamagotchi_resource.stats.rest / tamagotchi_resource.stats.maxRest
	
	# TODO: Iterate through children
	%Stats/HungerPanel/Indicator.update(hungerValue)
	%Stats/HygienePanel/Indicator.update(hygieneValue)
	%Stats/HappinessPanel/Indicator.update(happinessValue)
	%Stats/HealthPanel/Indicator.update(healthValue)
	%Stats/RestPanel/Indicator.update(restValue)
