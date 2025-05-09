extends Resource

class_name InventoryItemResource

@export var name: String = ""
@export var description: String = ""
@export var texture: Texture2D
@export var maxAmount: int

@export var is_usable: bool
@export var is_consumable: bool
@export var is_grabbable: bool

@export_category("Stats")
@export var hunger: float
@export var hygiene: float
@export var happiness: float
@export var health: float
@export var rest: float

func get_exp():
	# Atm just returning sum of all stats
	return hunger + hygiene + happiness + health + rest if is_consumable else 0
