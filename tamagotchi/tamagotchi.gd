extends Node2D

class_name Tamagotchi

signal on_stat_change(tamagotchi: Tamagotchi)

@export var statDrainRates: StatDrainRates = preload("res://stats/statDrainRate.tres")
@export var stats: Stats = preload("res://stats/statsStart.tres")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# TODO: only decrease when stat is over 0
	stats.hunger -= delta * statDrainRates.hunger
	stats.rest -= delta * statDrainRates.rest
	on_stat_change.emit(self)

func use_item(item: InventoryItem):
	var newHunger = stats.hunger + item.hunger
	var newRest = stats.rest + item.rest

	# TODO: make less terrible
	if newHunger <= stats.maxHunger:
		stats.hunger = newHunger
	else:
		stats.hunger = stats.maxHunger

	if newRest <= stats.maxRest:
		stats.rest = newRest
	else:
		stats.rest = stats.maxRest
