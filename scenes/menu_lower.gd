extends Control

@export var inventory: InventoryResource
@onready var slots: Array = $HBoxContainer.get_children()

func _ready():
	# TODO: This should be connected at a shared ancestor's node
	inventory.updated.connect(update)
	update()

func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update(inventory.slots[i])
