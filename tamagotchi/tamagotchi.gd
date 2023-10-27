extends Node2D

class_name Tamagotchi

signal on_stat_change(tamagotchi: Tamagotchi)

@export var statDrainRates: StatDrainRates = preload("res://stats/statDrainRate.tres")
@export var stats: Stats = preload("res://stats/statsStart.tres")
@export var is_awake: bool
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_hunger(delta)
	process_rest(delta)

	on_stat_change.emit(self)
	
func process_hunger(delta):
	var newHunger = stats.hunger - delta * statDrainRates.hunger
	stats.hunger = newHunger if newHunger >= 0 else 0
	
func process_rest(delta):
	if stats.rest <= 0 && is_awake:
		is_awake = false
		animation_tree["parameters/conditions/awake"] = false
		animation_tree["parameters/conditions/sleeping"] = true
	if stats.rest >= stats.maxRest/2 && !is_awake:
		is_awake = true
		animation_tree["parameters/conditions/sleeping"] = false
		animation_tree["parameters/conditions/awake"] = true
	if is_awake:
		var newRest = stats.rest - delta * statDrainRates.rest
		stats.rest = newRest if newRest >= 0 else 0	
	else:
		# TODO: Add real sleep
		var newRest = stats.rest + delta * statDrainRates.rest
		stats.rest = newRest if newRest <= stats.maxRest else stats.maxRest

func use_item(item: InventoryItem):
	# TODO: loop through item properties and apply so I can add
	# new stats in peace
	if is_awake:
		var newHunger = stats.hunger + item.hunger
		var newRest = stats.rest + item.rest

		stats.hunger = newHunger if newHunger <= stats.maxHunger else stats.maxHunger
		stats.rest = newRest if newRest <= stats.maxRest else stats.maxRest

		#animation_tree["parameters/conditions/eating"] = true
		state_machine.travel("Feed")

