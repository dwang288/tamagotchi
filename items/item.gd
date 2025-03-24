extends Node2D

class_name Item

@export var item_resource: InventoryItemResource

@onready var item_texture: TextureRect = $TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	# Currently erroring out bc child nodes get loaded before parent nodes, and since item_resouce is passed in from the parent, item_resource is still null at this point
	item_texture.texture = item_resource.texture
