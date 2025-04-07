extends PanelContainer

@export var icon_texture: Texture2D

@onready var indicator_node: ColorRect = $Indicator
@onready var icon_node: TextureRect = $Icon
@onready var dimmer_node: ColorRect = $Dimmer
@onready var value_node: Label = $Value

@export_category("Indicator colors")
@export var value: float
@export var full_color: Color
@export var mid_color: Color
@export var empty_color: Color

@export var FLASH_TIME: float = 0.5  # Time interval in seconds
@export var TIME_PASSED: float = 0.0  # Accumulator

func _ready():
	icon_node.texture = icon_texture

func _process(delta):
	# TODO: Clean up. Potentially use a Timer node on the parent container
	# Flash icon if value is at 0
	TIME_PASSED += delta
	if TIME_PASSED >= FLASH_TIME:
		if self.value == 0:
			icon_node.visible = !icon_node.visible
		else:
			icon_node.visible = true
		TIME_PASSED = 0.0  # Reset timer

func update(stat_value: float):
	self.value = stat_value
	value_node.text = str(floor(value*100))
	# Color should change from green at 100 to yellow at 50% to red at 0%
	# and then to flashing
	if value < .5 && value >= 0:
		indicator_node.color = empty_color.lerp(mid_color, value*2)
	elif value == .5:
		indicator_node.color = mid_color
	elif value > .5 && value <= 1:
		indicator_node.color = mid_color.lerp(full_color, (value-.5)*2)
	else:
		# Should never hit this case, error case
		indicator_node.color = Color.BLUE


func _on_mouse_entered():
	dimmer_node.visible = true
	value_node.visible = true


func _on_mouse_exited():
	dimmer_node.visible = false
	value_node.visible = false
