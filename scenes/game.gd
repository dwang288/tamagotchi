extends Node2D

class_name Game

@export var inventory: InventoryResource
@export var tamagotchi_resources: Array[TamagotchiResource]
# TODO: save the active index in a resource so i can load it
@onready var active_tamagotchi_index: int = 0
@onready var tamagotchi_scene = preload("res://tamagotchi/tamagotchi.tscn")
# TODO: Add types in 4.4 [index, PackedScene]
@onready var tamagotchi_nodes: Dictionary = {}


# TODO: move all the tamagotchi handling logic into its own collection node
func _ready():
	# Test add serum button
	get_node("TestButton/Button").sent_serum.connect(inventory.insert)
	
	# Connect on click signal between menu item and inventory slot
	for slot in $MenuLower/HBoxContainer.get_children():
		slot.clicked_item.connect(click_item)
		print("connected")

	$MenuLower/HBoxContainer/Slot1/ButtonUseItem.grab_focus()

	# Instantiate and add tamagotchi node
	for i in tamagotchi_resources.size():
		tamagotchi_resources[i].item_consumed.connect(inventory.delete)

		tamagotchi_nodes[i] = tamagotchi_scene.instantiate()
		tamagotchi_nodes[i].position = $TamagotchiMarker2D.position
		tamagotchi_nodes[i].initialize(tamagotchi_resources[i])
		add_child(tamagotchi_nodes[i])

	tamagotchi_nodes[active_tamagotchi_index].set_active_tamagotchi($Stats)

	# TODO: Clean this up
	inventory.insert(load("res://items/itemResources/lollipop.tres"))

func _unhandled_input(event):
	if event.is_action_pressed("switch_active_tamagotchi"):
		switch_active_tamagotchi()

# Tab to set the active tamagotchi to the next one
func switch_active_tamagotchi():
	var prev_active_tamagotchi_index = active_tamagotchi_index
	if active_tamagotchi_index >= tamagotchi_resources.size() - 1:
		active_tamagotchi_index = 0
	else:
		active_tamagotchi_index += 1
	tamagotchi_nodes[prev_active_tamagotchi_index].set_inactive_tamagotchi()
	tamagotchi_nodes[active_tamagotchi_index].set_active_tamagotchi($Stats)
	print(tamagotchi_nodes[active_tamagotchi_index].resource.is_awake)

func click_item(slot: InventorySlotResource):
	tamagotchi_nodes[active_tamagotchi_index].resource.use_item_in_slot(slot)

func _process(delta):
	for node in tamagotchi_nodes.values():
		node.resource.process(delta)
