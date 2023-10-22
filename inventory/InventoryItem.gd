extends Resource

class_name InventoryItem

@export var name: String = ""
@export var texture: Texture2D
@export var maxAmount: int

# TODO: Should contain a reference to an actual item, which then stores the
# stats
@export var hunger: float
@export var rest: float
