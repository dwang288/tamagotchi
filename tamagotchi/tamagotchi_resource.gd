extends Resource

class_name TamagotchiResource

# Resource change signals
signal stat_changed(tamagotchi: TamagotchiResource)
signal item_consumed(slot: InventorySlotResource)
signal interacted_with(interaction_distance: float)

# Animation signals
signal item_used

# Level signals
signal leveled_up
signal exp_changed
signal stats_increased

@export var stat_drain_rates: StatDrainRatesResource
@export var stats: StatsResource
# TODO: Move stats_low_threshold and stats_low into stats resource
@export var stats_low_threshold: float = 0.3
@export var stats_low: Dictionary
@export var is_awake: bool

@export var animation_library: AnimationLibrary
@export var profile_icon: Texture2D
@export var cursor_effect_type: CursorEffect.EffectType

# TODO: Move all stat functionality into stats resource

func add_exp(additional_exp: int):
	stats.exp += additional_exp
	if stats.exp >= stats.exp_cap:
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
	while stats.exp >= stats.exp_cap:
		stats.exp -= stats.exp_cap
		stats.level += 1
		# TODO: Maybe stats increases should be done off individual growth rates like in Fire Emblem
		# TODO: Every stat increase should be added to a queue in order to play the animation
		stats.exp_cap = stats.get_exp_cap(stats.level)

	leveled_up.emit(self)


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
func apply_item_stats(item: InventoryItemResource, mouse_distance_traveled: float = 1):
	is_awake = true
	stats.hunger += item.hunger * mouse_distance_traveled
	stats.hygiene += item.hygiene * mouse_distance_traveled
	stats.happiness += item.happiness * mouse_distance_traveled
	stats.health += item.health * mouse_distance_traveled
	stats.rest += item.rest * mouse_distance_traveled

	stats.set_valid_stats()

# TODO: Make this generic in the future for interactions that don't involve items
func apply_interaction_stats(mouse_distance_traveled: float):
	is_awake = true
	stats.happiness += 0.1 * mouse_distance_traveled # TODO: take multiplier out into rates
	stats.set_valid_stats()
	
	# TODO: Hook this up to CoinManager
	interacted_with.emit(mouse_distance_traveled)

func use_item_in_slot(slot: InventorySlotResource):
	if slot.item.is_usable:
		apply_item_stats(slot.item)
		item_used.emit()
		add_exp(slot.item.get_exp())

		if slot.item.is_consumable:
			item_consumed.emit(slot)
