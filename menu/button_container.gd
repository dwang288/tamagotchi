extends Control

class_name ButtonContainer

@export var label: String
@export var icon_closed: Texture2D
@export var icon_closed_hover: Texture2D
@export var icon_open: Texture2D
@export var icon_open_hover: Texture2D

@onready var label_node: RichTextLabel = %RichTextLabel
@onready var icon_node: TextureRect = %Icon

@onready var is_icon_hovered: bool
@onready var is_icon_open: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Use label if available
	if label:
		label_node.text += "[center]"
		label_node.text += label
		label_node.text += "[/center]"
	else:
		label_node.visible = false
	
	# Use icon if availa
	if icon_closed:
		icon_node.texture = icon_closed
	else:
		icon_node.visible = false

func _on_mouse_entered():
	label_node.set("theme_override_constants/outline_size", 3)
	if icon_closed_hover:
		icon_node.texture = icon_closed_hover
#	label_node.set("theme_override_constants/default_color", Color(Color.WHITE))
#	label_node.set("theme_override_constants/font_outline_color", Color.hex(0x545770ff))
	MouseManager.set_cursor(MouseManager.HAND_POINT)

func _on_mouse_exited():
	label_node.set("theme_override_constants/outline_size", 0)
	if icon_closed:
		icon_node.texture = icon_closed
#	label_node.set("theme_override_constants/default_color", Color.hex(0x545770ff))
	MouseManager.set_default()
