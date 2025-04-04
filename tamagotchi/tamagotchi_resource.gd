extends Resource

class_name TamagotchiResource

# Resource change signals
signal stat_changed(tamagotchi: TamagotchiResource)
signal item_consumed(slot: InventorySlotResource)

# Animation signals
signal item_used

@export var level: int
@export var exp: int
@export var exp_cap: int

@export var stat_drain_rates: StatDrainRatesResource
@export var stats: StatsResource
# TODO: Move stats_low_threshold and stats_low into stats resource
@export var stats_low_threshold: float = 0.5
@export var stats_low: Dictionary
@export var is_awake: bool

@export var animation_library: AnimationLibrary
@export var profile_icon: Texture2D

enum StatTypes { HUNGER, HYGIENE, HAPPINESS, HEALTH, REST }

# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta):
	process_hunger(delta)
	process_hygiene(delta)
	process_happiness(delta)
	process_health(delta)
	process_rest(delta)
	process_low_stats(delta)

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

func process_low_stats(_delta):
	if stats.get_hunger_ratio() < stats_low_threshold:
		stats_low[StatTypes.HUNGER] = true
	else:
		stats_low.erase(StatTypes.HUNGER)
		
	if stats.get_hygiene_ratio() < stats_low_threshold:
		stats_low[StatTypes.HYGIENE] = true
	else:
		stats_low.erase(StatTypes.HYGIENE)

	if stats.get_happiness_ratio() < stats_low_threshold:
		stats_low[StatTypes.HAPPINESS] = true
	else:
		stats_low.erase(StatTypes.HAPPINESS)

	if stats.get_health_ratio() < stats_low_threshold:
		stats_low[StatTypes.HEALTH] = true
	else:
		stats_low.erase(StatTypes.HEALTH)

# mouse_distance_traveled is optional in case it's a draggable item
func apply_item_stats(item: InventoryItemResource, mouse_distance_traveled: float = 1):
	is_awake = true
	stats.hunger += item.hunger * mouse_distance_traveled
	stats.hygiene += item.hygiene * mouse_distance_traveled
	stats.happiness += item.happiness * mouse_distance_traveled
	stats.health += item.health * mouse_distance_traveled
	stats.rest += item.rest * mouse_distance_traveled

	stats.set_valid_stats()

func use_item_in_slot(slot: InventorySlotResource):
	# TODO: Make sure stat can't drop below 0
	if slot.item.is_usable:
		apply_item_stats(slot.item)
		item_used.emit()

		if slot.item.is_consumable:
			item_consumed.emit(slot)

