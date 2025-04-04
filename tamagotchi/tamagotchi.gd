extends Node2D

class_name Tamagotchi

@export var resource: TamagotchiResource
@onready var collision_area: Area2D = $Area2D
@onready var active_indicator: AnimatedSprite2D = %ActiveIndicator

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]

@onready var emote_animation_player: AnimationPlayer = $Emote/AnimationPlayer
@onready var emote_animation_tree: AnimationTree = $Emote/AnimationTree
@onready var emote_state_machine: AnimationNodeStateMachinePlayback = emote_animation_tree["parameters/playback"]

@onready var is_being_cleaned: bool
@onready var is_unwell: bool

signal mouse_clicked(tamagotchi: Tamagotchi)

var mouse_collision: bool
var last_mouse_position = Vector2.ZERO
var current_mouse_position = Vector2.ZERO
var mouse_distance_traveled = 0.0

var collided_item_area: Area2D

# For debugging purposes
var emote_nested_idle_state_machine

func _ready():
	animation_setup()

func initialize(r: TamagotchiResource):
	resource = r

func _process(delta):
	resource.process(delta)
	interaction_process()
	animation_process()

func interaction_process():
	check_clicked_interaction()
	check_dragging_item_interaction()

# Click interaction

func check_clicked_interaction():
	if mouse_collision && Input.is_action_just_pressed("mouse_button_left"): # Check for click to switch active
		mouse_clicked.emit(self)

# Calculating draggable items logic

func check_dragging_item_interaction():
	if mouse_collision and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and collision_area.overlaps_area(collided_item_area): # Check and apply draggables
		if collided_item_area and collided_item_area.get_parent().item_resource.is_grabbable:
			is_being_cleaned = true
			resource.apply_item_stats(collided_item_area.get_parent().item_resource, get_mouse_distance_traveled())
	if Input.is_action_just_released("mouse_button_left") && self.mouse_distance_traveled != 0:
		is_being_cleaned = false
		play_animation_heart()
		reset_mouse_data()

func reset_mouse_data():
	self.last_mouse_position = Vector2.ZERO
	self.current_mouse_position = Vector2.ZERO
	self.mouse_distance_traveled = 0.0

func get_mouse_distance_traveled():
	self.current_mouse_position = get_global_mouse_position()
	if self.last_mouse_position != Vector2.ZERO:
		self.mouse_distance_traveled += self.last_mouse_position.distance_to(self.current_mouse_position)
	self.last_mouse_position = self.current_mouse_position
	
	return mouse_distance_traveled

# Animation functions

func animation_setup():
	animation_player.add_animation_library("animation", resource.animation_library)
	emote_animation_player.add_animation_library("emote", load("res://emotes/emote.res"))

	# TODO: Sprite state machine and emote state machine nodes should be in two different subcomponents

	if state_machine is AnimationNodeStateMachinePlayback:
		var state_machine_node = animation_tree.tree_root

		state_machine_node.get_node("idle").get_node("idle").animation = "animation/idle"
		state_machine_node.get_node("idle").get_node("unwell").animation = "animation/unwell"
		state_machine_node.get_node("feed").animation = "animation/feed"
		state_machine_node.get_node("clean").animation = "animation/clean"
		state_machine_node.get_node("sleep").animation = "animation/sleep"

	if emote_state_machine is AnimationNodeStateMachinePlayback:
		var emote_state_machine_node = emote_animation_tree.tree_root

		# TODO: Change advance conditions in state machine to use the enum
		emote_state_machine_node.get_node("idle").get_node("idle").animation = "emote/idle"
		emote_state_machine_node.get_node("idle").get_node("reset").animation = "emote/reset"
		emote_state_machine_node.get_node("idle").get_node("hunger").animation = "emote/hunger"
		emote_state_machine_node.get_node("idle").get_node("hygiene").animation = "emote/hygiene"
		emote_state_machine_node.get_node("idle").get_node("happiness").animation = "emote/happiness"
		emote_state_machine_node.get_node("idle").get_node("health").animation = "emote/health"
		emote_state_machine_node.get_node("love").animation = "emote/love"
		emote_state_machine_node.get_node("sleep").animation = "emote/sleep"

	resource.item_used.connect(play_animation_heart)

	emote_nested_idle_state_machine = emote_animation_tree["parameters/idle/playback"]

func animation_process():
	# print(emote_nested_idle_state_machine.get_current_node())
	if resource.stats_low.keys().size() > 0:
		is_unwell = true
	else:
		is_unwell = false

# TODO: After splitting up animation state machines into separate components, create functions within
# component classes to take in an enum of the animation state to travel to
# Component classes should have a map of enums to state name strings
func play_animation_heart():
	state_machine.travel("feed")
	emote_state_machine.travel("love")

# GUI Signal functions

func _on_area_2d_mouse_entered():
	mouse_collision = true
	if not MouseManager.grabbed_item:
		MouseManager.set_cursor(MouseManager.HAND_OPEN)

func _on_area_2d_mouse_exited():
	mouse_collision = false
	MouseManager.set_default()

func _on_area_2d_area_entered(area):
	if area.get_parent() is Item and area.get_parent().item_resource.is_grabbable:
		collided_item_area = area
