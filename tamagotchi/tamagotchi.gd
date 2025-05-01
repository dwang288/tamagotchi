extends Node2D

class_name Tamagotchi

@export var resource: TamagotchiResource
@onready var collision_area: Area2D = $Area2D
@onready var active_indicator: AnimatedSprite2D = %ActiveIndicator

@onready var emote: Sprite2D = %Emote
@onready var sprite: Sprite2D = %Sprite2D

@onready var toast_notifications: VBoxContainer = %ToastNotifications
@onready var drop_space: Control = %DropSpace

@onready var is_active: bool
@onready var is_being_pet: bool
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
	connection_setup()

func initialize(r: TamagotchiResource):
	resource = r

func _process(delta):
	resource.process(delta)
	interaction_process()
	animation_process()

func interaction_process():
	check_clicked_interaction()
	check_dragging_item_interaction()
	check_petting_interaction()

func set_active(active: bool):
	is_active = active
	active_indicator.visible = active

func connection_setup():
	resource.max_stat_increased.connect(toast_notifications.on_max_stat_change)
	resource.leveled_up.connect(toast_notifications.on_level_up)
	drop_space.item_dropped.connect(resource.use_item_in_slot)

# Click interaction

func check_clicked_interaction():
	if mouse_collision && Input.is_action_just_pressed("mouse_button_left"): # Check for click to switch active
		mouse_clicked.emit(self)

# Calculating petting logic

func check_petting_interaction():
	if (
		is_active and
		mouse_collision and
		!collided_item_area and # TODO: Even when dragging item, collided_item_area is still null sometimes
		Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and
		get_mouse_distance_traveled() > 20
	):
		if !is_being_pet:
			is_being_pet = true
			MouseManager.set_cursor_trail(resource.cursor_effect_type)
			# TODO: Clear emote too when petting
		resource.apply_interaction_stats(get_mouse_distance_traveled())
		reset_distance_data()
	if (
		is_active and
		Input.is_action_just_released("mouse_button_left") and
		is_being_pet
	):
		is_being_pet = false
		MouseManager.remove_cursor_trail()
		reset_distance_data(true)
		play_animation_heart()

# Calculating draggable items logic

func check_dragging_item_interaction():
	if (
		is_active and
		mouse_collision and
		Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and
		collided_item_area and
		collision_area.overlaps_area(collided_item_area) and
		collided_item_area.get_parent().item_resource.is_grabbable
	): # Check and apply draggables
		# TODO: Clear emote too when cleaning
		if !is_being_cleaned and collided_item_area.get_parent().item_resource.hygiene > 0:
			is_being_cleaned = true
			MouseManager.set_cursor_trail(CursorEffect.EffectType.BUBBLE)
		resource.apply_item_stats(collided_item_area.get_parent().item_resource, get_mouse_distance_traveled())
		reset_distance_data()
	if (
		is_active and
		Input.is_action_just_released("mouse_button_left") and
		is_being_cleaned
	):
		is_being_cleaned = false
		MouseManager.remove_cursor_trail()
		reset_distance_data(true)
		play_animation_heart()

func reset_distance_data(all: bool = false):
	if all:
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

	sprite.animation_setup(resource)
	emote.animation_setup(resource)

	resource.item_used.connect(play_post_item_animation)

func animation_process():
	# print(emote_nested_idle_state_machine.get_current_node())
	if resource.stats_low.keys().size() > 0:
		is_unwell = true
	else:
		is_unwell = false

func play_post_item_animation(liked: bool):
	if liked:
		play_animation_heart()
	else:
		play_animation_unhappy()

# TODO: After splitting up animation state machines into separate components, create functions within
# component classes to take in an enum of the animation state to travel to
# Component classes should have a map of enums to state name strings
func play_animation_heart():
	sprite.state_machine.travel("happy")
	emote.emote_state_machine.travel("love")

func play_animation_unhappy():
	sprite.state_machine.travel("unhappy")
	emote.emote_state_machine.travel("unhappy")

# GUI Signal functions

func _on_area_2d_mouse_entered():
	mouse_collision = true
	if not collided_item_area:
		MouseManager.set_cursor(MouseManager.HAND_OPEN)

func _on_area_2d_mouse_exited():
	mouse_collision = false
	if not collided_item_area:
		MouseManager.set_default()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Item:
		collided_item_area = area

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.get_parent() is Item:
		collided_item_area = null
