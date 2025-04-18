extends Resource

class_name StatsResource

@export_group("Level Info")
@export var level: int
@export var exp: float
@export var exp_cap: float

@export var base_exp: float
@export var exp_cap_growth_factor: float

@export_group("Needs")
@export var hunger: float
@export var hygiene: float
@export var happiness: float
@export var health: float
@export var rest: float

@export_group("Max Needs")
@export var max_hunger: float
@export var max_hygiene: float
@export var max_happiness: float
@export var max_health: float
@export var max_rest: float


enum StatTypes { HUNGER, HYGIENE, HAPPINESS, HEALTH, REST }

@export var stat_dict: Dictionary[StatTypes, Dictionary] = {
	StatTypes.HUNGER: {
		"name": "hunger",
		"value": hunger,
		"max_value": max_hunger,
	},
	StatTypes.HYGIENE: {
		"name": "hygiene",
		"value": hygiene,
		"max_value": max_hygiene,
	},
	StatTypes.HAPPINESS: {
		"name": "happiness",
		"value": happiness,
		"max_value": max_happiness,
	},
	StatTypes.HEALTH: {
		"name": "health",
		"value": health,
		"max_value": max_health,
	},
	StatTypes.REST: {
		"name": "rest",
		"value": rest,
		"max_value": max_rest,
	},
}

# Level functions

func get_exp_ratio() -> float:
	return exp/exp_cap

# TODO: Tweak this
func get_exp_cap(lvl: int) -> float:
	return base_exp * lvl ** exp_cap_growth_factor

# Needs functions

func apply_stat_change(type: StatTypes, amount: float) -> float:
	var change = amount
	match type:
		StatTypes.HUNGER:
			hunger += change
		StatTypes.HYGIENE:
			hygiene += change
		StatTypes.HAPPINESS:
			happiness += change
		StatTypes.HEALTH:
			health += change
		StatTypes.REST:
			rest += change
	return change
	

func get_overall_stats_ratio() -> float:
	return (get_hunger_ratio() + get_hygiene_ratio() + get_happiness_ratio() + get_health_ratio() + get_rest_ratio())/5

func get_hunger_ratio() -> float:
	return hunger/max_hunger

func get_hygiene_ratio() -> float:
	return hygiene/max_hygiene

func get_happiness_ratio() -> float:
	return happiness/max_happiness

func get_health_ratio() -> float:
	return health/max_health

func get_rest_ratio() -> float:
	return rest/max_rest

func set_valid_stats():
	hunger = max(min(hunger, max_hunger), 0)
	hygiene = max(min(hygiene, max_hygiene), 0)
	happiness = max(min(happiness, max_happiness), 0)
	health = max(min(health, max_health), 0)
	rest = max(min(rest, max_rest), 0)
