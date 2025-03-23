extends Control

@export var inventory: Resource = GameStateManager.game_state.inventory
@export var columns: int = 6
@export var slot_offset: int = 0

@onready var slot_scene: PackedScene = load("res://inventory/slot.tscn")
@onready var slots: Array[Panel]

@onready var left_inventory_button = $MarginContainer/HBoxContainer/LeftButtonContainer/LeftInventoryButton
@onready var right_inventory_button = $MarginContainer/HBoxContainer/RightButtonContainer/RightInventoryButton

@onready var min_offset: int = 0
@onready var max_offset: int = max(inventory.slot_resources.size() - columns, 0)


func _ready():
	# TODO: slots initialized should be a multiple of columns
	slots.resize(columns)
	for i in columns:
		slots[i] = slot_scene.instantiate()
		%InventoryContainer.add_child(slots[i])
	inventory.updated.connect(update)
	update()

	if %InventoryContainer.get_child_count() > 0:
		%InventoryContainer.get_child(0).get_node("UseItemButton").grab_focus()

func update():

	set_valid_offsets()
	
	# Iterating through the slot nodes in the case that there's more nodes than slot resources
	for i in range(slots.size()):
		if i < inventory.slot_resources.size():
			slots[i].update_slot(inventory.slot_resources[i + slot_offset])
		else:
			slots[i].clear_slot()

	set_arrow_visibility()


# Check left/right offset arrows
# Show right arrow if there's more resources in front
#	Check if inventory.slot_resources.size() is > current offset + slots.size()
# Show left arrow if there's more resources behind
#	Just an offset check
func set_arrow_visibility():
	
	# Check if offset at all
	if slot_offset <= min_offset:
		left_inventory_button.visible = false
	else:
		left_inventory_button.visible = true

	# print("condition 1: ", inventory.slot_resources.size() <= (slot_offset + slots.size(), " condition 2: ", slot_offset >= max_offset)
	# print("slot_offset: ", slot_offset, " max_offset: ", max_offset)
	if inventory.slot_resources.size() <= (slot_offset + slots.size()) || slot_offset >= max_offset:
		right_inventory_button.visible = false
	else:
		right_inventory_button.visible = true


func connect_slots_on_click_signal(function: Callable):
	for slot in %InventoryContainer.get_children():
		slot.clicked_item.connect(function)


func set_valid_offsets():
	# Set max offset depending on # of slot_resources
	max_offset = max(inventory.slot_resources.size() - slots.size(), 0)
	
	if slot_offset > max_offset:
		slot_offset = max_offset


func _on_left_inventory_button_pressed():
	if slot_offset > min_offset:
		slot_offset -= 1
		update()


func _on_right_inventory_button_pressed():
	if slot_offset < max_offset:
		slot_offset += 1
		update()
		
