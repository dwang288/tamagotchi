extends Control

class_name GrabbableControl

@export var node: Node2D
@export var success_callback: Callable

@onready var node_container: MarginContainer = $NodeContainer
# Called when the node enters the scene tree for the first time.

var is_grabbed = false
var position_offset = Vector2.ZERO  # Offset between mouse and node position

func _ready():
	MouseManager.set_cursor(MouseManager.HAND_GRAB)
	node_container.add_child(node)
	if node.has_node("GrabMarker"):
		node.position = node.get_node("GrabMarker").position
	is_grabbed = true

func _input(event):
	if event is InputEventMouseButton:
		if not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			MouseManager.set_default()
			queue_free()
			# Check if there's an area overlap at this location and if the area's parent has a drop method
			#	if yes then run drop method of parent, passing the node and the success method?
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_grabbed:
		MouseManager.set_cursor(MouseManager.HAND_GRAB)
		global_position = get_global_mouse_position() - position_offset
