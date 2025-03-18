extends Node2D

class_name Tamagotchi

@export var resource: TamagotchiResource
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]
# Called when the node enters the scene tree for the first time.
func _ready():

	animation_player.add_animation_library("animation", resource.animation_library)

	if state_machine is AnimationNodeStateMachinePlayback:
		var state_machine_node = animation_tree.tree_root

		state_machine_node.get_node("idle").animation = "animation/idle"
		state_machine_node.get_node("feed").animation = "animation/feed"
		state_machine_node.get_node("sleep").animation = "animation/sleep"

	resource.fed.connect(feed)

func initialize(r: TamagotchiResource):
	resource = r

func _process(delta):
	if resource.is_awake:
		animation_tree["parameters/conditions/awake"] = true
		animation_tree["parameters/conditions/sleeping"] = false
	elif !resource.is_awake:
		animation_tree["parameters/conditions/awake"] = false
		animation_tree["parameters/conditions/sleeping"] = true
	
func feed():
	state_machine.travel("feed")
