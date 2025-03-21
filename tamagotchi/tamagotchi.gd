extends Node2D

class_name Tamagotchi

@export var resource: TamagotchiResource
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]

@onready var mouse_collision: bool
@onready var last_mouse_position = Vector2.ZERO
@onready var current_mouse_position = Vector2.ZERO
@onready var mouse_distance_traveled = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_setup()

func initialize(r: TamagotchiResource):
	resource = r

func _process(delta):
	resource.process(delta)
	
	interaction_process()
	animation_process()

func interaction_process():
	if mouse_collision && Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		current_mouse_position = get_global_mouse_position()
		if last_mouse_position != Vector2.ZERO:
			mouse_distance_traveled += last_mouse_position.distance_to(current_mouse_position)
		last_mouse_position = current_mouse_position
		resource.increase_hygiene(mouse_distance_traveled)
	if Input.is_action_just_released("mouse_button_left"):
		last_mouse_position = Vector2.ZERO
		current_mouse_position = Vector2.ZERO
		mouse_distance_traveled = 0.0

# Animation functions

func animation_setup():
	animation_player.add_animation_library("animation", resource.animation_library)

	if state_machine is AnimationNodeStateMachinePlayback:
		var state_machine_node = animation_tree.tree_root

		state_machine_node.get_node("idle").animation = "animation/idle"
		state_machine_node.get_node("feed").animation = "animation/feed"
		state_machine_node.get_node("sleep").animation = "animation/sleep"
	
	resource.item_used.connect(feed)

func animation_process():
	if resource.is_awake:
		animation_tree["parameters/conditions/awake"] = true
		animation_tree["parameters/conditions/sleeping"] = false
	elif !resource.is_awake:
		animation_tree["parameters/conditions/awake"] = false
		animation_tree["parameters/conditions/sleeping"] = true

func feed():
	state_machine.travel("feed")

# GUI Signal functions

func _on_area_2d_mouse_entered():
	mouse_collision = true

func _on_area_2d_mouse_exited():
	mouse_collision = false
