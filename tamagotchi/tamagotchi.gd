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
	var newHunger = stats.hunger - delta * statDrainRates.hunger
	var newRest = stats.rest - delta * statDrainRates.rest

	stats.hunger = newHunger if newHunger >= 0 else 0
	stats.rest = newRest if newRest >= 0 else 0

	on_stat_change.emit(self)

func use_item(item: InventoryItem):
	var newHunger = stats.hunger + item.hunger
	var newRest = stats.rest + item.rest

	stats.hunger = newHunger if newHunger <= stats.maxHunger else stats.maxHunger
	stats.rest = newRest if newRest <= stats.maxRest else stats.maxRest
