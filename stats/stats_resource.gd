extends Resource

class_name StatsResource

@export_group("Level Info")
@export var level: int
@export var exp: float
@export var max_exp: float

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

# Level functions

func get_exp_ratio() -> float:
	return exp/max_exp

# TODO: Add max exp calculation based off level
func get_max_exp(lvl: int) -> float:
	return 100
	

# Needs functions

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
