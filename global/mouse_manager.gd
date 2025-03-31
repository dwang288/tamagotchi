extends Node

@export var cursor_arrow = load("res://assets/gui/cursors/arrow_cursor.png")
@export var cursor_point = load("res://assets/gui/cursors/hand_point_cursor.png")
@export var cursor_open = load("res://assets/gui/cursors/hand_open_cursor.png")
@export var cursor_grab = load("res://assets/gui/cursors/hand_grab_cursor.png")

@export var CURSOR_HAND_HOTSPOT: Vector2 = Vector2(5, 0)
@export var grabbed_item: Node2D

enum { ARROW, HAND_POINT, HAND_OPEN, HAND_GRAB }

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

	# Overrid default mouse cursors
	Input.set_custom_mouse_cursor(cursor_arrow, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(cursor_point, Input.CURSOR_POINTING_HAND, CURSOR_HAND_HOTSPOT)
	Input.set_custom_mouse_cursor(cursor_open, Input.CURSOR_MOVE, CURSOR_HAND_HOTSPOT)
	Input.set_custom_mouse_cursor(cursor_grab, Input.CURSOR_DRAG, CURSOR_HAND_HOTSPOT)
	Input.set_custom_mouse_cursor(cursor_grab, Input.CURSOR_CAN_DROP, CURSOR_HAND_HOTSPOT)
	Input.set_custom_mouse_cursor(cursor_grab, Input.CURSOR_FORBIDDEN, CURSOR_HAND_HOTSPOT)

# Set cursor when it enters the viewport
func _notification(notif):
	# TODO: Doesn't always work? Kind of buggy
	if notif == NOTIFICATION_WM_MOUSE_ENTER:
		# Reapply cursor
		Input.set_custom_mouse_cursor(cursor_arrow)

func _process(_delta):
	if grabbed_item:
		# TODO: For some reason, global_position isn't being set
		grabbed_item.global_position = get_viewport().get_mouse_position()

func set_cursor(cursor):
	if cursor == self.ARROW:
		Input.set_custom_mouse_cursor(cursor_arrow)
	if cursor == self.HAND_POINT:
		Input.set_custom_mouse_cursor(cursor_point, Input.CURSOR_ARROW, CURSOR_HAND_HOTSPOT)
	if cursor == self.HAND_OPEN:
		Input.set_custom_mouse_cursor(cursor_open, Input.CURSOR_ARROW, CURSOR_HAND_HOTSPOT)
	if cursor == self.HAND_GRAB:
		Input.set_custom_mouse_cursor(cursor_grab, Input.CURSOR_ARROW, CURSOR_HAND_HOTSPOT)

func set_default():
	Input.set_custom_mouse_cursor(cursor_arrow, Input.CURSOR_ARROW)

func set_grabbed_item(item: Node2D):
	grabbed_item = item

func clear_grabbed_item():
	grabbed_item.queue_free()
	grabbed_item = null
