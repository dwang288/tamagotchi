extends Resource

class_name TamagotchiResource

# Resource change signals
signal stat_changed(tamagotchi: TamagotchiResource)
signal item_consumed(slot: InventorySlotResource)

# Animation signals
signal item_used

# Level signals
signal leveled_up
signal exp_changed
signal stats_increased

@export var stat_drain_rates: StatDrainRatesResource
@export var stats: StatsResource
# TODO: Move stats_low_threshold and stats_low into stats resource
@export var stats_low_threshold: float = 0.5
@export var stats_low: Dictionary
@export var is_awake: bool

@export var animation_library: AnimationLibrary
@export var profile_icon: Texture2D

# TODO: Move all stat functionality into stats resource

func add_exp(additional_exp: int):
	stats.exp += additional_exp
	if stats.exp >= stats.max_exp:
		level_up()
	exp_changed.emit(self)

func level_up():
	var stat_increase = {
		stats.StatTypes.HUNGER: 0,
		stats.StatTypes.HYGIENE: 0,
		stats.StatTypes.HAPPINESS: 0,
		stats.StatTypes.HEALTH: 0,
		stats.StatTypes.REST: 0
	}
	while stats.exp >= stats.max_exp:
		stats.exp -= stats.max_exp
		stats.level += 1
		stats.max_exp = stats.get_max_exp(stats.level)

	leveled_up.emit(self)


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
		var new_hunger = stats.hunger - delta * stat_drain_rates.hunger
		stats.hunger = new_hunger if new_hunger >= 0 else 0
	
func process_rest(delta):
	if stats.rest <= 0 && is_awake:
		is_awake = false
	if stats.rest >= stats.max_rest && !is_awake:
		is_awake = true
	if is_awake:
		var new_rest = stats.rest - delta * stat_drain_rates.rest
		stats.rest = new_rest if new_rest >= 0 else 0
	else:
		# TODO: Add real sleep
		var new_rest = stats.rest + delta * stat_drain_rates.rest
		stats.rest = new_rest if new_rest <= stats.max_rest else stats.max_rest

func process_health(delta):
	# should not decay unless there's some condition
	pass

func process_hygiene(delta):
	# hygiene decay unless 0, at whch point tamagotchi gets the dirty sprite
	if is_awake:
		var new_hygiene = stats.hygiene - delta * stat_drain_rates.hygiene
		stats.hygiene = new_hygiene if new_hygiene >= 0 else 0

func process_happiness(delta):
	# if some other stats at 0 then decay
	pass

func process_low_stats(_delta):
	if stats.get_hunger_ratio() < stats_low_threshold:
		stats_low[stats.StatTypes.HUNGER] = true
	else:
		stats_low.erase(stats.StatTypes.HUNGER)
		
	if stats.get_hygiene_ratio() < stats_low_threshold:
		stats_low[stats.StatTypes.HYGIENE] = true
	else:
		stats_low.erase(stats.StatTypes.HYGIENE)

	if stats.get_happiness_ratio() < stats_low_threshold:
		stats_low[stats.StatTypes.HAPPINESS] = true
	else:
		stats_low.erase(stats.StatTypes.HAPPINESS)

	if stats.get_health_ratio() < stats_low_threshold:
		stats_low[stats.StatTypes.HEALTH] = true
	else:
		stats_low.erase(stats.StatTypes.HEALTH)

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
	if slot.item.is_usable:
		apply_item_stats(slot.item)
		item_used.emit()
		
		# TODO: Temporarily adding 10 exp whenever you use an item.
		# Maybe should be placed elsewhere or should calculate sum of all stats on item for exp?
		# Or have a special exp given stat in the item resource?

		add_exp(10)
		
		if slot.item.is_consumable:
			item_consumed.emit(slot)

