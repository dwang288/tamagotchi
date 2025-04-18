extends Node2D

class_name Tamagotchis

signal active_tamagotchi_changed(tamagotchi: Tamagotchi)

@export var tamagotchi_resources: Array[TamagotchiResource]
# TODO: save the active index in a resource so i can load it
@onready var active_tamagotchi_index: int = 0
@onready var tamagotchi_scene = preload("res://tamagotchi/tamagotchi.tscn")
@onready var tamagotchi_nodes: Dictionary[int, Tamagotchi] = {}
# Array for where to position tamas when they're loaded in
@onready var tamagotchi_marker_nodes: Array[Marker2D]

# Called when the node enters the scene tree for the first time.
func _ready():
	# Instantiate and add tamagotchi node
	tamagotchi_resources = GameStateManager.game_state.tamagotchis
	
	# TODO: Save positions of tamagotchis somehow
	var tamagotchi_position_interval_x = get_viewport_rect().size.x/(tamagotchi_resources.size()+1)
	var tamagotchi_position_y = 0
	tamagotchi_marker_nodes.resize(tamagotchi_resources.size())

	for i in tamagotchi_resources.size():

		tamagotchi_marker_nodes[i] = Marker2D.new()
		tamagotchi_marker_nodes[i].position.x = tamagotchi_position_interval_x * (i+1)
		tamagotchi_marker_nodes[i].position.y = tamagotchi_position_y

		tamagotchi_nodes[i] = tamagotchi_scene.instantiate()
		tamagotchi_nodes[i].position = tamagotchi_marker_nodes[i].position
		tamagotchi_nodes[i].initialize(tamagotchi_resources[i])

		tamagotchi_nodes[i].mouse_clicked.connect(switch_active_tamagotchi)
		add_child(tamagotchi_nodes[i])

	set_active_tamagotchi(active_tamagotchi_index)

func _unhandled_input(event):
	if event.is_action_pressed("switch_active_tamagotchi"):
		switch_active_tamagotchi()

# Tab to set the active tamagotchi to the next one
# TODO: Split up cycling and selecting cases into two diff functions?
func switch_active_tamagotchi(tama: Tamagotchi = null):
	var prev_active_tamagotchi_index = active_tamagotchi_index
	if tama: # for when a specific signal is sent
		active_tamagotchi_index = tamagotchi_nodes.find_key(tama)
	else: # for when tabbing through
		if active_tamagotchi_index >= tamagotchi_resources.size() - 1:
			active_tamagotchi_index = 0
		else:
			active_tamagotchi_index += 1
	set_inactive_tamagotchi(prev_active_tamagotchi_index)
	set_active_tamagotchi(active_tamagotchi_index)

# Remove old tamagotchi from being able to affect the stats UI, set to inactive
func set_inactive_tamagotchi(tamagotchi_index: int):
	tamagotchi_nodes[tamagotchi_index].set_active(false)

# Connect new tamagotchi, set to active
func set_active_tamagotchi(tamagotchi_index: int):
	tamagotchi_nodes[tamagotchi_index].set_active(true)
	active_tamagotchi_changed.emit(tamagotchi_nodes[tamagotchi_index].resource)

func click_item(slot: InventorySlotResource):
	tamagotchi_nodes[active_tamagotchi_index].resource.use_item_in_slot(slot)
