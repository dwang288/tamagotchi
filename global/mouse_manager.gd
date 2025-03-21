extends Node

@export var cursor_arrow = load("res://assets/gui/cursors/arrow_cursor.png")
@export var cursor_point = load("res://assets/gui/cursors/hand_point_cursor.png")
@export var cursor_open = load("res://assets/gui/cursors/hand_open_cursor.png")
@export var cursor_grab = load("res://assets/gui/cursors/hand_grab_cursor.png")

@export var cursor_hand_hotspot: Vector2 = Vector2(5, 0)

enum { ARROW, HAND_POINT, HAND_OPEN, HAND_GRAB }

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	
	Input.set_custom_mouse_cursor(cursor_arrow, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(cursor_point, Input.CURSOR_POINTING_HAND, cursor_hand_hotspot)
	Input.set_custom_mouse_cursor(cursor_open, Input.CURSOR_MOVE, cursor_hand_hotspot)
	Input.set_custom_mouse_cursor(cursor_grab, Input.CURSOR_DRAG, cursor_hand_hotspot)

func set_cursor(cursor):
	if cursor == self.ARROW:
		Input.set_custom_mouse_cursor(cursor_arrow)
	if cursor == self.HAND_POINT:
		Input.set_custom_mouse_cursor(cursor_point, Input.CURSOR_ARROW, cursor_hand_hotspot)
	if cursor == self.HAND_OPEN:
		Input.set_custom_mouse_cursor(cursor_open, Input.CURSOR_ARROW, cursor_hand_hotspot)
	if cursor == self.HAND_GRAB:
		Input.set_custom_mouse_cursor(cursor_grab, Input.CURSOR_ARROW, cursor_hand_hotspot)

func set_default():
	Input.set_custom_mouse_cursor(cursor_arrow, Input.CURSOR_ARROW)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
