extends Resource

class_name InventoryItem

@export var name: String = ""
@export var texture: Texture2D
@export var maxAmount: int

@export var is_usable: bool
@export var is_consumable: bool

# TODO: Should contain a reference to an actual resource, which then stores the
# stats
@export_category("Stats")
@export var hunger: float
@export var hygiene: float
@export var happiness: float
@export var health: float
@export var rest: float
