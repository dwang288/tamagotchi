extends Control

class_name TooltipControl

@export var text: String
@onready var label_node: RichTextLabel = %RichTextLabel
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func update(text):
	label_node.parse_bbcode(Utils.replace_keywords(text))
	visible = true

func close():
	visible = false
	label_node.text = ""
