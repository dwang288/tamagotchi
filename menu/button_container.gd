extends MarginContainer

@export var label: String
@onready var label_node: RichTextLabel = %RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	label_node.text += "[center]"
	label_node.text += label
	label_node.text += "[/center]"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_mouse_entered():
	label_node.set("theme_override_constants/outline_size", 3)

func _on_mouse_exited():
	label_node.set("theme_override_constants/outline_size", 0)
