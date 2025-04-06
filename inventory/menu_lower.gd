extends Control

class_name Inventory

@export var inventory: Resource = GameStateManager.game_state.inventory
# For when there's only one row of inventory
@export var columns: int = 12
@export var rows: int = 1
@export var slot_offset: int = 0

@onready var slot_scene: PackedScene = load("res://inventory/slot.tscn")
@onready var slots: Array[Panel]

@onready var inventory_node = %InventoryContainer
@onready var left_inventory_button = %LeftInventoryButton
@onready var right_inventory_button = %RightInventoryButton
@onready var tooltip_control = $TooltipControl

@onready var min_offset: int = 0
@onready var max_offset: int = max(inventory.slot_resources.size() - page_slot_count, 0)

var page_slot_count: int = columns * rows

func _ready():
	# TODO: slots initialized should be a multiple of columns
	slots.resize(page_slot_count)
	for i in page_slot_count:
		slots[i] = slot_scene.instantiate()
		slots[i].slot_index = i
		inventory_node.add_child(slots[i])
	
	# Changes to the InventoryResource will call the GUI update function
	inventory.updated.connect(update)
	
	connect_slots_on_swap_signal(swap_items)
	connect_slots_on_hover_signal(tooltip_control.update, tooltip_control.close)
	
	update()

	if inventory_node.get_child_count() > 0:
		inventory_node.get_child(0).get_node("UseItemButton").grab_focus()


func connect_slots_on_hover_signal(hovering_function: Callable, exited_function: Callable):
	for slot in inventory_node.get_children():
		slot.hovered.connect(hovering_function)
		slot.exited_hover.connect(exited_function)

func connect_slots_on_click_signal(function: Callable):
	for slot in inventory_node.get_children():
		slot.clicked_item.connect(function)

func connect_slots_on_swap_signal(function: Callable):
	for slot in inventory_node.get_children():
		slot.swapped_item.connect(function)

func update():

	set_valid_offsets()
	
	# Iterating through the slot nodes in the case that there's more nodes than slot resources
	for i in range(slots.size()):
		if i < inventory.slot_resources.size():
			slots[i].update_slot(inventory.slot_resources[i + slot_offset])
		else:
			slots[i].clear_slot()

	set_arrow_visibility()

func swap_items(slot1: Slot, slot2: Slot):
	inventory.swap_items_by_index(slot1.slot_index + slot_offset, slot2.slot_index + slot_offset)

# Offset logic

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


func set_valid_offsets():
	# Set max offset depending on # of slot_resources
	max_offset = max(inventory.slot_resources.size() - slots.size(), 0)
	
	if slot_offset > max_offset:
		slot_offset = max_offset
	if slot_offset < min_offset:
		slot_offset = min_offset


func _on_left_inventory_button_pressed():
	if slot_offset > min_offset:
		slot_offset -= page_slot_count
		update()


func _on_right_inventory_button_pressed():
	if slot_offset < max_offset:
		slot_offset += page_slot_count
		update()
		
