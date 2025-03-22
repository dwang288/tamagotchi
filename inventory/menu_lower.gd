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
	slots.resize(columns)
	for i in range(min(inventory.slot_resources.size(), columns)):
		slots[i] = slot_scene.instantiate()
		%InventoryContainer.add_child(slots[i])
	inventory.updated.connect(update)
	update()
	
	# TODO: Check if that node exists first
	%InventoryContainer.get_child(0).get_node("UseItemButton").grab_focus()

func update():
	for i in range(min(inventory.slot_resources.size(), slots.size())):
		slots[i].update(inventory.slot_resources[i + slot_offset])
	
	check_slot_offset()



# Check left/right offset arrows
func check_slot_offset():
	if slot_offset <= min_offset:
		left_inventory_button.visible = false
	else:
		left_inventory_button.visible = true
	
	if slot_offset >= max_offset:
		right_inventory_button.visible = false
	else:
		right_inventory_button.visible = true

func connect_slots_on_click_signal(function: Callable):
	for slot in %InventoryContainer.get_children():
		slot.clicked_item.connect(function)

func _on_left_inventory_button_pressed():
	if slot_offset > min_offset:
		slot_offset -= 1
		update()

func _on_right_inventory_button_pressed():
	if slot_offset < max_offset:
		slot_offset += 1
		update()
		
