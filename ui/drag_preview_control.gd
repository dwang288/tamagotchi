extends Control


@export var node: Node2D

@onready var node_container: MarginContainer = $NodeContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	node_container.add_child(node)
	if node.has_node("GrabMarker"):
		print("does this even  run")
		node.position = node.get_node("GrabMarker").position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
