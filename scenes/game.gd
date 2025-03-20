extends Node2D

class_name Game

@onready var tamagotchi_scene = preload("res://tamagotchi/tamagotchi.tscn")
@onready var tamagotchis: Node2D = %Tamagotchis

func _ready():
	connection_setup()

func connection_setup():
	# Test add serum button
	$TestButton/Button.sent_item.connect($MenuLower.inventory.insert)
	$TestButton/Button2.new_game.connect(GameStateManager.new_game)
	
	# Connect active tamagotchi switch to stats gui
	%Tamagotchis.active_tamagotchi_changed.connect(connect_to_stats_gui)
	# TODO: Calling this manually once because Stats hasn't been initialized yet, clean up
	connect_to_stats_gui(%Tamagotchis.tamagotchi_nodes[%Tamagotchis.active_tamagotchi_index])

	# Connect on click signal between menu item and inventory slot
	for slot in $MenuLower/HBoxContainer.get_children():
		slot.clicked_item.connect(%Tamagotchis.click_item)

	# Connect item consumed success to inventory deletion of item
	for tamagotchi_node in %Tamagotchis.get_children():
		if tamagotchi_node is Tamagotchi:
			tamagotchi_node.resource.item_consumed.connect($MenuLower.inventory.delete)

func connect_to_stats_gui(tamagotchi: Tamagotchi):
	tamagotchi.resource.stat_changed.connect($MenuUpper.update)
