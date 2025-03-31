extends Control

class_name Inventory

@export var inventory: Resource = GameStateManager.game_state.inventory

# TODO: See if we can avoid hardcoding this
@export var arrow_width: int

@onready var slot_scene: PackedScene = load("res://inventory/slot.tscn")
@onready var slots: Array[Panel]

@onready var inventory_node = %InventoryContainer
@onready var left_inventory_button = %LeftInventoryButton
@onready var right_inventory_button = %RightInventoryButton
@onready var scroll_container = %ScrollContainer
@onready var tooltip_control = $TooltipControl

func _ready():
	arrow_width = left_inventory_button.get_parent_area_size().x + right_inventory_button.get_parent_area_size().x
	
	slots.resize(inventory.capacity)
	for i in inventory.capacity:
		slots[i] = slot_scene.instantiate()
		slots[i].slot_index = i
		inventory_node.add_child(slots[i])
	
	# Changes to the InventoryResource will call the GUI update function
	inventory.updated.connect(update)
	
	connect_slots_on_swap_signal(swap_items)
	connect_slots_on_hover_signal(tooltip_control.update, tooltip_control.close)

	# Responsive inventory calculations
	get_tree().get_root().size_changed.connect(on_window_resized)

	if inventory_node.get_child_count() > 0:
		inventory_node.get_child(0).get_node("UseItemButton").grab_focus()

	update()
	
	# Need to wait a frame for max scroll to update for whatever reason
	await get_tree().process_frame
	set_arrow_visibility()

func on_window_resized():
	set_arrow_visibility()

func update():

	# Iterating through the slot nodes in the case that there's more nodes than slot resources
	for i in range(slots.size()):
		if i < inventory.slot_resources.size():
			slots[i].update_slot(inventory.slot_resources[i])
		else:
			slots[i].clear_slot()

	set_arrow_visibility()

func swap_items(slot1: Slot, slot2: Slot):
	inventory.swap_items_by_index(slot1.slot_index, slot2.slot_index)

# Check left/right arrows
func set_arrow_visibility():
	print(scroll_container.get_h_scroll_bar().value + get_viewport_rect().size.x, " ", scroll_container.get_h_scroll_bar().min_value, " ", scroll_container.get_h_scroll_bar().max_value)
	if scroll_container.get_h_scroll_bar().value > scroll_container.get_h_scroll_bar().min_value:
		left_inventory_button.visible = true
	else:
		left_inventory_button.visible = false

	if scroll_container.get_h_scroll_bar().value + get_viewport_rect().size.x - arrow_width < scroll_container.get_h_scroll_bar().max_value:
		right_inventory_button.visible = true
	else:
		right_inventory_button.visible = false

func connect_slots_on_hover_signal(update: Callable, close: Callable):
	for slot in inventory_node.get_children():
		slot.hovered.connect(update)
		slot.exited_hover.connect(close)

func connect_slots_on_click_signal(function: Callable):
	for slot in inventory_node.get_children():
		slot.clicked_item.connect(function)

func connect_slots_on_swap_signal(function: Callable):
	for slot in inventory_node.get_children():
		slot.swapped_item.connect(function)

func _on_left_inventory_button_pressed():
	scroll_container.scroll_horizontal -= scroll_container.scroll_horizontal_custom_step
	set_arrow_visibility()

func _on_right_inventory_button_pressed():
	scroll_container.scroll_horizontal += scroll_container.scroll_horizontal_custom_step
	set_arrow_visibility()
		
func _on_scroll_container_scroll_started():
	set_arrow_visibility()

func _on_scroll_container_scroll_ended():
	set_arrow_visibility()
