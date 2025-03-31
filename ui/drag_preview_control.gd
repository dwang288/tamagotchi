extends Control

@export var node: Item

@onready var node_container: MarginContainer = $NodeContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	node_container.add_child(node)
	if node.has_node("GrabMarker"):
		node.position = node.get_node("GrabMarker").position
