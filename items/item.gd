extends Node2D

class_name Item

@export var item_resource: InventoryItemResource

@onready var item_texture: TextureRect = $TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	item_texture.texture = item_resource.texture
