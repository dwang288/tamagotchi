extends Resource

class_name TamagotchiResource

# Resource change signals
signal stat_changed(tamagotchi: TamagotchiResource)
signal item_consumed(slot: InventorySlotResource)
signal interacted_with(interaction_distance: float)

# Animation signals
signal item_used(liked: bool)

# Level signals
signal leveled_up(resource: TamagotchiResource)
signal exp_changed(resource: TamagotchiResource)
signal max_exp_change(resource: TamagotchiResource)

signal max_stat_increased(resource: StatsResource, stat: StatsResource.StatTypes, increased_amount: int)

signal discovered_preference(resource: TamagotchiResource)

@export var name: String
@export var profile_large: Texture2D

@export var preferences: PreferencesResource

@export var stat_growth_rates: StatGrowthRatesResource
@export var stat_drain_rates: StatDrainRatesResource
@export var stats: StatsResource
# TODO: Move stats_low_threshold and stats_low into stats resource
@export var stats_low_threshold: float = 0.3
@export var stats_low: Dictionary
@export var is_awake: bool

@export var animation_library: AnimationLibrary
@export var emote_animation_library: AnimationLibrary
@export var profile_icon: Texture2D
@export var cursor_effect_type: CursorEffect.EffectType

# TODO: Move all stat functionality into stats resource

func add_exp(additional_exp: int):
	stats.exp += additional_exp
	if stats.exp >= stats.exp_cap:
		level_up()
	exp_changed.emit(self)

func level_up():

	while stats.exp >= stats.exp_cap:
		stats.exp -= stats.exp_cap
		stats.level += 1
		leveled_up.emit(self)
		all_stat_roll()
		stats.exp_cap = stats.get_exp_cap(stats.level)


# TODO: This is gross. Should be able to iterate through these
func all_stat_roll():
	var hunger_increase = calculate_stat_increase(stats.StatTypes.HUNGER)
	if hunger_increase > 0:
		stats.max_hunger += hunger_increase
		max_stat_increased.emit(stats, stats.StatTypes.HUNGER, hunger_increase)
	var hygiene_increase = calculate_stat_increase(stats.StatTypes.HYGIENE)
	if hygiene_increase > 0:
		stats.max_hygiene += hygiene_increase
		max_stat_increased.emit(stats, stats.StatTypes.HYGIENE, hygiene_increase)
	var happiness_increase = calculate_stat_increase(stats.StatTypes.HAPPINESS)
	if happiness_increase > 0:
		stats.max_happiness += happiness_increase
		max_stat_increased.emit(stats, stats.StatTypes.HAPPINESS, happiness_increase)
	var health_increase = calculate_stat_increase(stats.StatTypes.HEALTH)
	if health_increase > 0:
		stats.max_health += health_increase
		max_stat_increased.emit(stats, stats.StatTypes.HEALTH, health_increase)
	#var rest_increase = calculate_stat_increase(stats.StatTypes.REST)
	#if rest_increase > 0:
		#stats.max_rest += rest_increase
		#max_stat_increased.emit(stats, stats.StatTypes.REST, rest_increase)

func calculate_stat_increase(stat: StatsResource.StatTypes) -> int:
	var growth_rate: float
	match stat:
		stats.StatTypes.HUNGER:
			growth_rate = stat_growth_rates.hunger_growth
		stats.StatTypes.HYGIENE:
			growth_rate = stat_growth_rates.hygiene_growth
		stats.StatTypes.HAPPINESS:
			growth_rate = stat_growth_rates.happiness_growth
		stats.StatTypes.HEALTH:
			growth_rate = stat_growth_rates.health_growth
		stats.StatTypes.REST:
			growth_rate = stat_growth_rates.rest_growth

	var stat_increase = 0
	while growth_rate >= 100:
		stat_increase += 10 # TODO: Put this number in a resource somewhere
		growth_rate -= 100
	var roll = randi() % 100
	if roll < growth_rate:
		stat_increase += 10

	return stat_increase


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta):
	if is_awake:
		process_hunger(delta)
		process_hygiene(delta)
	process_happiness(delta)
	process_health(delta)
	process_rest(delta)
	process_low_stats(delta)

	stats.set_valid_stats()

	stat_changed.emit(self)

func process_hunger(delta):
	if is_awake:
		stats.hunger -= delta * stat_drain_rates.hunger

func process_hygiene(delta):
	# TODO: Tamagotchi gets the dirty sprite when hygiene 0
	if is_awake:
		stats.hygiene -= stat_drain_rates.hygiene * delta

func process_happiness(delta):
	# if some other stats at 0 then decay
	pass

func process_health(delta):
	if stats.hunger <= 0:
		stats.health -= stat_drain_rates.health * delta
	if stats.hygiene <= 0:
		stats.health -= stat_drain_rates.health * delta

	# Recover health while asleep
	if stats.hunger > 0 and stats.hygiene > 0 and !is_awake:
		# TODO: Gain rate should be separate
		stats.health += stat_drain_rates.health * delta
	
func process_rest(delta):
	if stats.rest <= 0 && is_awake:
		is_awake = false
	if stats.rest >= stats.max_rest && !is_awake:
		is_awake = true

	if is_awake:
		stats.rest -= stat_drain_rates.rest * delta
	else:
		# TODO: Sleep Gain rate should be a separate value
		stats.rest += stat_drain_rates.rest * delta


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

# mouse_distance_traveled is optional, only passed in if it's a draggable item
func apply_item_stats(item: InventoryItemResource, mouse_distance_traveled: float = 1) -> Dictionary:
	is_awake = true
	var stat_deltas = {
		stats.StatTypes.HUNGER: stats.apply_stat_change(stats.StatTypes.HUNGER, item.hunger * mouse_distance_traveled),
		stats.StatTypes.HYGIENE: stats.apply_stat_change(stats.StatTypes.HYGIENE, item.hygiene * mouse_distance_traveled),
		stats.StatTypes.HAPPINESS: stats.apply_stat_change(stats.StatTypes.HAPPINESS, item.happiness * mouse_distance_traveled),
		stats.StatTypes.HEALTH: stats.apply_stat_change(stats.StatTypes.HEALTH, item.health * mouse_distance_traveled),
		stats.StatTypes.REST: stats.apply_stat_change(stats.StatTypes.REST, item.rest * mouse_distance_traveled)
	}
	stats.set_valid_stats()
	return stat_deltas

# TODO: Make this generic in the future for interactions that don't involve items
func apply_interaction_stats(mouse_distance_traveled: float):
	is_awake = true
	stats.apply_stat_change(stats.StatTypes.HAPPINESS, 0.1 * mouse_distance_traveled) # TODO: take multiplier out into rates
	stats.set_valid_stats()
	
	interacted_with.emit(mouse_distance_traveled)

func use_item_in_slot(slot: InventorySlotResource):
	if slot.item.is_usable:
		if preferences.discover_preference(slot.item):
			discovered_preference.emit(self)
		var stat_deltas = apply_item_stats(slot.item)
		var liked = true if stat_deltas[stats.StatTypes.HAPPINESS] >= 0 else false
		item_used.emit(liked)
		add_exp(slot.item.get_exp())
		if slot.item.is_consumable:
			item_consumed.emit(slot)
