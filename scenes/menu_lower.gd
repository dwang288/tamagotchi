extends Control

@export var inventory = GameStateManager.game_state.inventory
@onready var slots: Array = $HBoxContainer.get_children()

func _ready():

	inventory.updated.connect(update)
	update()

func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update(inventory.slots[i])
