extends Control

class_name MenuUpper

@export var coins_resource: CoinsResource = GameStateManager.game_state.coins

@onready var coin_container_node: CoinsContainer = %CoinsContainer

func _ready():
	coins_resource.updated_coins.connect(coin_container_node.update)

func update_active_profile(tamagotchi_resource: TamagotchiResource):
	pass


func update(tamagotchi_resource: TamagotchiResource):
	# TODO: Should be calculating this in a script attached to Stats, return percentage

	var hungerValue = tamagotchi_resource.stats.hunger / tamagotchi_resource.stats.maxHunger
	var hygieneValue = tamagotchi_resource.stats.hygiene / tamagotchi_resource.stats.maxHygiene
	var happinessValue = tamagotchi_resource.stats.happiness / tamagotchi_resource.stats.maxHappiness
	var healthValue = tamagotchi_resource.stats.health / tamagotchi_resource.stats.maxHealth
	var restValue = tamagotchi_resource.stats.rest / tamagotchi_resource.stats.maxRest

	%Stats/HungerPanel.update(hungerValue)
	%Stats/HygienePanel.update(hygieneValue)
	%Stats/HappinessPanel.update(happinessValue)
	%Stats/HealthPanel.update(healthValue)
	%Stats/RestPanel.update(restValue)
