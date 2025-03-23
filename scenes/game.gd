extends Control

class_name Game

@onready var tamagotchi_scene = preload("res://tamagotchi/tamagotchi.tscn")

@onready var tamagotchis_node: Node2D = %Tamagotchis
@onready var menu_upper_node: Control = $MenuUpper
@onready var menu_lower_node: Control = $MenuLower


func _ready():
	connection_setup()

func connection_setup():
	# Test add serum button
	$TestButton/Button.sent_item.connect(menu_lower_node.inventory.insert)
	$TestButton/Button2.new_game.connect(GameStateManager.new_game)
	
	# Connect active tamagotchi switch to stats gui
	tamagotchis_node.active_tamagotchi_changed.connect(connect_to_stats_gui)
	# TODO: Calling this manually once because Stats hasn't been initialized yet, clean up
	connect_to_stats_gui(tamagotchis_node.tamagotchi_nodes[tamagotchis_node.active_tamagotchi_index])

	# Connect on click signal between menu item and inventory slot
	menu_lower_node.connect_slots_on_click_signal(tamagotchis_node.click_item)

	# Connect item consumed success to inventory deletion of item
	for tamagotchi_node in tamagotchis_node.get_children():
		if tamagotchi_node is Tamagotchi:
			tamagotchi_node.resource.item_consumed.connect(menu_lower_node.inventory.delete)

func connect_to_stats_gui(tamagotchi: Tamagotchi):
	tamagotchi.resource.stat_changed.connect(menu_upper_node.update)
