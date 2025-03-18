extends Node2D

class_name Tamagotchis

signal active_tamagotchi_changed(tamagotchi: Tamagotchi)

@export var tamagotchi_resources: Array[TamagotchiResource]
# TODO: save the active index in a resource so i can load it
@onready var active_tamagotchi_index: int = 0
@onready var tamagotchi_scene = preload("res://tamagotchi/tamagotchi.tscn")
# TODO: Add types in 4.4 [index, PackedScene]
@onready var tamagotchi_nodes: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	# Instantiate and add tamagotchi node
	tamagotchi_resources = GameStateManager.game_state.tamagotchis
	print(tamagotchi_resources)
	for i in tamagotchi_resources.size():

		tamagotchi_nodes[i] = tamagotchi_scene.instantiate()
		tamagotchi_nodes[i].position = $TamagotchiMarker2D.position
		tamagotchi_nodes[i].initialize(tamagotchi_resources[i])
		add_child(tamagotchi_nodes[i])

	set_active_tamagotchi(active_tamagotchi_index)

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
	set_inactive_tamagotchi(prev_active_tamagotchi_index)
	set_active_tamagotchi(active_tamagotchi_index)

# Remove old tamagotchi from being able to affect the stats UI, set to inactive
func set_inactive_tamagotchi(tamagotchi_index: int):
	for connection in tamagotchi_nodes[tamagotchi_index].resource.stat_changed.get_connections():
		tamagotchi_nodes[tamagotchi_index].resource.stat_changed.disconnect(connection["callable"])
	tamagotchi_nodes[tamagotchi_index].visible = false

# Connect new tamagotchi, set to active
func set_active_tamagotchi(tamagotchi_index: int):
	active_tamagotchi_changed.emit(tamagotchi_nodes[tamagotchi_index])
	tamagotchi_nodes[tamagotchi_index].visible = true

func click_item(slot: InventorySlotResource):
	tamagotchi_nodes[active_tamagotchi_index].resource.use_item_in_slot(slot)

func _process(delta):
	for node in tamagotchi_nodes.values():
		node.resource.process(delta)
