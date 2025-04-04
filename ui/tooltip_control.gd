extends Control


@export var icon_dict: Dictionary = {
	"hunger" = load("res://assets/gui/status_icons/hunger_icon.png"),
	"hygiene" = load("res://assets/gui/status_icons/hygiene_icon.png"),
	"happiness" = load("res://assets/gui/status_icons/happiness_icon.png"),
	"health" = load("res://assets/gui/status_icons/health_icon.png"),
	"rest" = load("res://assets/gui/status_icons/rest_icon.png")
}
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
	for keyword in icon_dict.keys():
		var texture = icon_dict[keyword]
		text = text.replace("<<" + keyword + ">>", "[img]" + texture.resource_path + "[/img]")
	return text
