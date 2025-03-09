extends Control

# TODO: Really shouldn't be loading it in here, should pass it in at
# the base class level on initialization
@onready var inventory: InventoryResource = preload("res://inventory/inventory.tres")
@onready var slots: Array = $HBoxContainer.get_children()

func _ready():
	# TODO: This should be connected at a shared ancestor's node
	inventory.updated.connect(update)
	update()

func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update(inventory.slots[i])
