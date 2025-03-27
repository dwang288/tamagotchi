extends Node2D

@export var node: Item
@export var success_callback: Callable

# Called when the node enters the scene tree for the first time.


func _ready():
	MouseManager.set_cursor(MouseManager.HAND_GRAB)
	add_child(node)
	if node.has_node("GrabMarker"):
		node.position = node.get_node("GrabMarker").position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	MouseManager.set_cursor(MouseManager.HAND_GRAB)
	global_position = get_global_mouse_position()
