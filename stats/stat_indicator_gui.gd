extends PanelContainer

@export var icon_texture: Texture2D
@onready var indicator_node: ColorRect = $Indicator

@export_category("Indicator colors")
@export var value: float
@export var fullColor: Color
@export var midColor: Color
@export var emptyColor: Color

@export var flash_time: float = 0.5  # Time interval in seconds
@export var time_passed: float = 0.0  # Accumulator

func _ready():
	$Icon.texture = icon_texture

func _process(delta):
	# TODO: Clean up. Potentially use a Timer node on the parent container
	# Flash icon if value is at 0
	time_passed += delta
	if time_passed >= flash_time:
		if self.value == 0:
			$Icon.visible = !$Icon.visible
		else:
			$Icon.visible = true
		time_passed = 0.0  # Reset timer

func update(stat_value: float):
	self.value = stat_value
	$Value.text = str(floor(value*100))
	# Color should change from green at 100 to yellow at 50% to red at 0%
	# and then to flashing
	# TODO: Use the set colors instead of hardcoding
	if value < .5 && value >= 0:
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
	else:
		# Should never hit this case, error case
		indicator_node.color.r = 0
		indicator_node.color.g = 0
		indicator_node.color.b = 1


func _on_mouse_entered():
	$Dimmer.visible = true
	$Value.visible = true


func _on_mouse_exited():
	$Dimmer.visible = false
	$Value.visible = false
