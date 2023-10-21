extends Control


@onready var inventory: Inventory = preload("res://inventory/inventory.tres")
@onready var slots: Array = $HBoxContainer.get_children()

func _ready():
	inventory.updated.connect(update)
	update()

func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update(inventory.slots[i])
