extends Resource

class_name StatsResource

@export_group("Needs")
@export var hunger: float
@export var hygiene: float
@export var happiness: float
@export var health: float
@export var rest: float

@export var maxHunger: float
@export var maxHygiene: float
@export var maxHappiness: float
@export var maxHealth: float
@export var maxRest: float

func get_hunger_ratio() -> float:
	return hunger/maxHunger

func get_hygiene_ratio() -> float:
	return hygiene/maxHygiene

func get_happiness_ratio() -> float:
	return happiness/maxHappiness

func get_health_ratio() -> float:
	return health/maxHealth

func get_rest_ratio() -> float:
	return rest/maxRest

func set_valid_stats():
	hunger = max(min(hunger, maxHunger), 0)
	hygiene = max(min(hygiene, maxHygiene), 0)
	happiness = max(min(happiness, maxHappiness), 0)
	health = max(min(health, maxHealth), 0)
	rest = max(min(rest, maxRest), 0)
