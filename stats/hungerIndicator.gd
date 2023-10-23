extends ColorRect

@export var value: float
@export var fullColor: Color
@export var midColor: Color
@export var emptyColor: Color

# TODO: move script to Panel level, have it act on children's properties
func update(tamagotchi: Tamagotchi):
	value = tamagotchi.stats.hunger / tamagotchi.stats.maxHunger
	# Color should change from green at 100 to yellow at 50% to red at 0%
	# and then to flashing
	# TODO: Use the set colors instead of hardcoding
	if value < .5 && value > 0:
		color.r = 1
		color.g = value*2
		color.b = 0
	elif value == .5:
		color.r = 1
		color.g = 1
		color.b = 0
	elif value > .5 && value <= 1:
		color.r = (1-value)*2
		color.g = 1
		color.b = 0
	elif value <= 0:
		# TODO: replace this option with flashing red
		# alpha increasing and decreasing
		color.r = 0
		color.g = 0
		color.b = 1
	else:
		# Should never hit this case, error case
		color.r = 0
		color.g = 0
		color.b = 1
