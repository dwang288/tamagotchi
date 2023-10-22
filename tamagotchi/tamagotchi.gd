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
	stats.hunger -= delta * statDrainRates.hunger
	stats.rest -= delta * statDrainRates.rest
	on_stat_change.emit(self)
