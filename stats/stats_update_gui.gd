extends Control

class_name MenuUpper

@export var coins_resource: CoinsResource = GameStateManager.game_state.coins

@onready var coin_container_node: CoinsContainer = %CoinsContainer
@onready var profile_button_node: Button = %ActiveProfileButton

func _ready():
	coins_resource.updated_coins.connect(coin_container_node.update)

func update_active_profile(tamagotchi_resource: TamagotchiResource):
	profile_button_node.icon = tamagotchi_resource.profile_icon

func update_stats(tamagotchi_resource: TamagotchiResource):

	%Stats/HungerPanel.update(tamagotchi_resource.stats.get_hunger_ratio())
	%Stats/HygienePanel.update(tamagotchi_resource.stats.get_hygiene_ratio())
	%Stats/HappinessPanel.update(tamagotchi_resource.stats.get_happiness_ratio())
	%Stats/HealthPanel.update(tamagotchi_resource.stats.get_health_ratio())
	%Stats/RestPanel.update(tamagotchi_resource.stats.get_rest_ratio())
