extends Control

class_name TooltipControl

@export var icon_dict: IconBBCodeDictResource
@export var text: String
@onready var label_node: RichTextLabel = %RichTextLabel
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func update(text):
	label_node.parse_bbcode(replace_keywords(text))
	visible = true

func close():
	visible = false
	label_node.text = ""

func replace_keywords(text: String) -> String:
	for keyword in icon_dict.mapping.keys():
		var texture = icon_dict.mapping[keyword]
		text = text.replace("<<" + keyword + ">>", "[img]" + texture.resource_path + "[/img]")
	return text
