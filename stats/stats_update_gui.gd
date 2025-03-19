extends Control

func update(tamagotchi_resource: TamagotchiResource):
	var hungerValue = tamagotchi_resource.stats.hunger / tamagotchi_resource.stats.maxHunger
	var hygieneValue = tamagotchi_resource.stats.hygiene / tamagotchi_resource.stats.maxHygiene
	var happinessValue = tamagotchi_resource.stats.happiness / tamagotchi_resource.stats.maxHappiness
	var healthValue = tamagotchi_resource.stats.health / tamagotchi_resource.stats.maxHealth
	var restValue = tamagotchi_resource.stats.rest / tamagotchi_resource.stats.maxRest

	%Stats/HungerPanel.update(hungerValue)
	%Stats/HygienePanel.update(hygieneValue)
	%Stats/HappinessPanel.update(happinessValue)
	%Stats/HealthPanel.update(healthValue)
	%Stats/RestPanel.update(restValue)
