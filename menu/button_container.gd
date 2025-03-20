extends MarginContainer

@export var label: String

# Called when the node enters the scene tree for the first time.
func _ready():
	%RichTextLabel.text += "[center]"
	%RichTextLabel.text += label
	%RichTextLabel.text += "[/center]"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_mouse_entered():
	%RichTextLabel.set("theme_override_constants/outline_size", 3)

func _on_mouse_exited():
	%RichTextLabel.set("theme_override_constants/outline_size", 0)
