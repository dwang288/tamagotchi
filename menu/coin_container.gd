extends MarginContainer

class_name CoinsContainer

@export var coin_icon: Texture2D
@export var coins: int = GameStateManager.game_state.coins.coins

@onready var label: RichTextLabel = %RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	update(coins)

func update(coins: int):
	label.clear()
	label.add_image(coin_icon)
	label.add_text(" x ")
	label.add_text(str(coins))
