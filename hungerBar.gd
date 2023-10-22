extends TextureProgressBar

func update(tamagotchi: Tamagotchi):
	value = tamagotchi.stats.hunger*100 / tamagotchi.stats.maxHunger
	print(value)
