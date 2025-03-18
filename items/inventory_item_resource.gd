extends Resource

class_name InventoryItemResource

@export var name: String = ""
@export var texture: Texture2D
@export var maxAmount: int

@export var is_usable: bool
@export var is_consumable: bool

@export_category("Stats")
@export var hunger: float
@export var hygiene: float
@export var happiness: float
@export var health: float
@export var rest: float
