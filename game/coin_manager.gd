extends Node2D

@export var coins_resource: CoinsResource = GameStateManager.game_state.coins
@export var tama_resources: Array[TamagotchiResource] = GameStateManager.game_state.tamagotchis

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_coin_gain(delta)

# TODO: BS calculation lol
func process_coin_gain(delta):
	var sum: float
	for resource in tama_resources:
		sum += resource.stats.get_overall_stats_ratio() * resource.stats.level ** coins_resource.gain_rate * delta
	var additional_coins = sum/tama_resources.size()

	coins_resource.modify_coins(additional_coins)

func increase_coins_from_interaction(mouse_traveled):
	coins_resource.modify_coins(mouse_traveled/10) # TODO: Pull this number out
