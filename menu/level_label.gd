extends RichTextLabel

@export var level: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func update_level(new_level: int):
	level = new_level
	parse_bbcode("Lvl." + str(level))
