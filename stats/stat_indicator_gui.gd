extends PanelContainer

@export var icon_texture: Texture2D
@onready var indicator_node: ColorRect = $Indicator

@export_category("Indicator colors")
@export var value: float
@export var fullColor: Color
@export var midColor: Color
@export var emptyColor: Color

func _ready():
	$Icon.texture = icon_texture

func update(value: float):
	# Color should change from green at 100 to yellow at 50% to red at 0%
	# and then to flashing
	# TODO: Use the set colors instead of hardcoding
	if value < .5 && value > 0:
		indicator_node.color.r = 1
		indicator_node.color.g = value*2
		indicator_node.color.b = 0
	elif value == .5:
		indicator_node.color.r = 1
		indicator_node.color.g = 1
		indicator_node.color.b = 0
	elif value > .5 && value <= 1:
		indicator_node.color.r = (1-value)*2
		indicator_node.color.g = 1
		indicator_node.color.b = 0
	elif value <= 0:
		# TODO: replace this option with flashing red
		# alpha increasing and decreasing
		indicator_node.color.r = 0
		indicator_node.color.g = 0
		indicator_node.color.b = 1
	else:
		# Should never hit this case, error case
		indicator_node.color.r = 0
		indicator_node.color.g = 0
		indicator_node.color.b = 1
