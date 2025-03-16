extends Node2D

class_name Game

@export var inventory: InventoryResource
@export var tamagotchi_resources: Array[TamagotchiResource]
# TODO: save the active index in a resource so i can load it
@onready var active_tamagotchi_index: int = 0
@onready var tamagotchi_scene = preload("res://tamagotchi/tamagotchi.tscn")
# TODO: Add types in 4.4 [index, PackedScene]
@onready var tamagotchi_nodes: Dictionary = {}
@onready var tamagotchis: Node2D = $Tamagotchis


# TODO: move all the tamagotchi handling logic into its own collection node
func _ready():
	# Test add serum button
	get_node("TestButton/Button").sent_serum.connect(inventory.insert)
	$Tamagotchis.active_tamagotchi_changed.connect(connect_to_stats_gui)
	
	# TODO: Calling this manually once because Stats hasn't been initialized yet, clean up
	connect_to_stats_gui($Tamagotchis.tamagotchi_nodes[$Tamagotchis.active_tamagotchi_index])
	
	# Connect on click signal between menu item and inventory slot
	for slot in $MenuLower/HBoxContainer.get_children():
		slot.clicked_item.connect($Tamagotchis.click_item)
		print("connected")

	$MenuLower/HBoxContainer/Slot1/ButtonUseItem.grab_focus()

	for tamagotchi_node in $Tamagotchis.get_children():
		if tamagotchi_node is Tamagotchi:
			tamagotchi_node.resource.item_consumed.connect(inventory.delete)

	# TODO: Clean this up
	inventory.insert(load("res://items/itemResources/lollipop.tres"))

func connect_to_stats_gui(tamagotchi: Tamagotchi):
	print("i'm in")
	tamagotchi.resource.stat_changed.connect($Stats.update)
