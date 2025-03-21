extends Resource

class_name TamagotchiResource

# Resource change signals
signal stat_changed(tamagotchi: TamagotchiResource)
signal item_consumed(slot: InventorySlotResource)

# Animation signals
signal item_used

@export var stat_drain_rates: StatDrainRatesResource
@export var stats: StatsResource
@export var is_awake: bool
@export var animation_library: AnimationLibrary

# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta):
	process_hunger(delta)
	process_hygiene(delta)
	process_happiness(delta)
	process_health(delta)
	process_rest(delta)

	stat_changed.emit(self)

# TODO: Stop initializing new variables within the process loop
func process_hunger(delta):
	if is_awake:
		var newHunger = stats.hunger - delta * stat_drain_rates.hunger
		stats.hunger = newHunger if newHunger >= 0 else 0
	
func process_rest(delta):
	if stats.rest <= 0 && is_awake:
		is_awake = false
	if stats.rest >= stats.maxRest && !is_awake:
		is_awake = true
	if is_awake:
		var newRest = stats.rest - delta * stat_drain_rates.rest
		stats.rest = newRest if newRest >= 0 else 0
	else:
		# TODO: Add real sleep
		var newRest = stats.rest + delta * stat_drain_rates.rest
		stats.rest = newRest if newRest <= stats.maxRest else stats.maxRest

func process_health(delta):
	# should not decay unless there's some condition
	pass

func process_hygiene(delta):
	# hygiene decay unless 0, at whch point tamagotchi gets the dirty sprite
	if is_awake:
		var newHygiene = stats.hygiene - delta * stat_drain_rates.hygiene
		stats.hygiene = newHygiene if newHygiene >= 0 else 0

func process_happiness(delta):
	# if some other stats at 0 then decay
	pass


func increase_hygiene(mouse_distance_traveled: float):
	is_awake = true
	# TODO: Add hygiene gain rate to tamagotchi stat rates
	var hygiene_increase = mouse_distance_traveled * .005
	if stats.hygiene < stats.maxHygiene:
		stats.hygiene = min(stats.hygiene + hygiene_increase, stats.maxHygiene)
	

func use_item_in_slot(slot: InventorySlotResource):
	# TODO: loop through item properties and apply so I can add
	# new stats in peace
	if slot.item.is_usable:
		var newHunger = stats.hunger + slot.item.hunger
		var newHygiene = stats.hygiene + slot.item.hygiene
		var newHappiness = stats.happiness + slot.item.happiness
		var newHealth = stats.health + slot.item.health
		var newRest = stats.rest + slot.item.rest

		stats.hunger = newHunger if newHunger <= stats.maxHunger else stats.maxHunger
		stats.hygiene = newHygiene if newHygiene <= stats.maxHygiene else stats.maxHygiene
		stats.happiness = newHappiness if newHappiness <= stats.maxHappiness else stats.maxHappiness
		stats.health = newHealth if newHealth <= stats.maxHealth else stats.maxHealth
		stats.rest = newRest if newRest <= stats.maxRest else stats.maxRest

		item_used.emit()
		is_awake = true
		if slot.item.is_consumable:
			item_consumed.emit(slot)
