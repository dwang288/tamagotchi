extends Control

class_name MenuUpper

@export var coins_resource: CoinsResource = GameStateManager.game_state.coins
@export var active_tamagotchi_resource: TamagotchiResource

@onready var profile_container_node: ProfileContainer = %ProfileContainer
@onready var coin_container_node: CoinsContainer = %CoinsContainer
@onready var menu_container_node: ButtonContainer = %MenuContainer

# TODO: Split StatsContainer into its own thing

func _ready():
	coins_resource.updated_coins.connect(coin_container_node.update)

func connect_menu_button_signal(function: Callable):
	menu_container_node.connect_on_click_signal(function)

func update_active_tamagotchi(tamagotchi_resource: TamagotchiResource):

	profile_container_node.update_active_tamagotchi(tamagotchi_resource)

	# Disconnect previous tamagotchi's signals from GUI
	if active_tamagotchi_resource:
		if active_tamagotchi_resource.stat_changed.is_connected(update_stats):
			active_tamagotchi_resource.stat_changed.disconnect(update_stats)

	active_tamagotchi_resource = tamagotchi_resource
	
	# Connect new signals to GUI
	active_tamagotchi_resource.stat_changed.connect(update_stats)
	
	# Update the GUI once
	update_stats(active_tamagotchi_resource)

func update_stats(tamagotchi_resource: TamagotchiResource):

	%Stats/HungerPanel.update(tamagotchi_resource.stats.get_hunger_ratio())
	%Stats/HygienePanel.update(tamagotchi_resource.stats.get_hygiene_ratio())
	%Stats/HappinessPanel.update(tamagotchi_resource.stats.get_happiness_ratio())
	%Stats/HealthPanel.update(tamagotchi_resource.stats.get_health_ratio())
	%Stats/RestPanel.update(tamagotchi_resource.stats.get_rest_ratio())
