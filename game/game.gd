extends Control

class_name Game

@onready var tamagotchi_scene = preload("res://tamagotchi/tamagotchi.tscn")

@onready var tamagotchis_node: Node2D = %Tamagotchis
@onready var menu_upper_node: Control = %MenuUpper
@onready var menu_lower_node: Control = %MenuLower


func _ready():
	connection_setup()
	setup_active()

func connection_setup():
	# Test add serum button
	$TestButton/HBoxContainer/Button.sent_item.connect(menu_lower_node.inventory.insert)
	$TestButton/HBoxContainer/Button2.new_game.connect(GameStateManager.new_game)
	$TestButton/HBoxContainer/Button3.add_coins.connect(GameStateManager.game_state.coins.update_coins)
	
	# Connect active tamagotchi switch to stats gui
	tamagotchis_node.active_tamagotchi_changed.connect(menu_upper_node.update_active_tamagotchi)

	# Connect on click signal between menu item and inventory slot
	menu_lower_node.connect_slots_on_click_signal(tamagotchis_node.click_item)

	# Connect item consumed success to inventory deletion of item
	for tamagotchi_node in tamagotchis_node.get_children():
		if tamagotchi_node is Tamagotchi:
			tamagotchi_node.resource.item_consumed.connect(menu_lower_node.inventory.delete)

# Initial game setup for active tamagotchi
func setup_active():
	var active_tamagotchi_resource = tamagotchis_node.tamagotchi_nodes[tamagotchis_node.active_tamagotchi_index].resource

	menu_upper_node.update_active_tamagotchi(active_tamagotchi_resource)
