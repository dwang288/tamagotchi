extends Resource

class_name TamagotchiResource

signal stat_changed(tamagotchi: TamagotchiResource)
signal item_consumed(slot: InventorySlotResource)

@export var statDrainRates: StatDrainRates = preload("res://stats/stat_drain_rate.tres")
@export var stats: Stats = preload("res://stats/stats_start.tres")
@export var is_awake: bool
@export var animation_library: AnimationLibrary


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta):
	process_hunger(delta)
	process_rest(delta)

	stat_changed.emit(self)

# TODO: Process functions should be in another class/node
func process_hunger(delta):
	if is_awake:
		var newHunger = stats.hunger - delta * statDrainRates.hunger
		stats.hunger = newHunger if newHunger >= 0 else 0
	
func process_rest(delta):
	if stats.rest <= 0 && is_awake:
		is_awake = false
	if stats.rest >= stats.maxRest && !is_awake:
		is_awake = true
	if is_awake:
		var newRest = stats.rest - delta * statDrainRates.rest
		stats.rest = newRest if newRest >= 0 else 0
	else:
		# TODO: Add real sleep
		var newRest = stats.rest + delta * statDrainRates.rest
		stats.rest = newRest if newRest <= stats.maxRest else stats.maxRest

func process_health(delta):
	# should not decay unless there's some condition
	pass
func process_hygiene(delta):
	# hygiene decay unless 0, at whch point tamagotchi gets the dirty sprite
	pass
func process_happiness(delta):
	# if some other stats at 0 then decay
	pass
func use_item_in_slot(slot: InventorySlotResource):
	# TODO: loop through item properties and apply so I can add
	# new stats in peace
	if !is_awake:
		return
	if slot.item.is_usable:
		var newHunger = stats.hunger + slot.item.hunger
		var newRest = stats.rest + slot.item.rest

		stats.hunger = newHunger if newHunger <= stats.maxHunger else stats.maxHunger
		stats.rest = newRest if newRest <= stats.maxRest else stats.maxRest
		if slot.item.is_consumable:
			item_consumed.emit(slot)
