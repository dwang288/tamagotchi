extends Control

class_name MenuUpper

@export var coins_resource: CoinsResource = GameStateManager.game_state.coins
@export var active_tamagotchi_resource: TamagotchiResource

@onready var coin_container_node: CoinsContainer = %CoinsContainer
@onready var profile_button_node: Button = %ActiveProfileButton

@onready var level_label: RichTextLabel = %LevelLabel
@onready var exp_progress_bar: TextureProgressBar = %ExpProgressBar

# TODO: Break ProfileContainer node into own scene tree

func _ready():
	coins_resource.updated_coins.connect(coin_container_node.update)

func update_active_tamagotchi(tamagotchi_resource: TamagotchiResource):
	
	profile_button_node.icon = tamagotchi_resource.profile_icon
	
	# Disconnect previous tamagotchi's signals from GUI
	if active_tamagotchi_resource:
		if active_tamagotchi_resource.stat_changed.is_connected(update_stats):
			active_tamagotchi_resource.stat_changed.disconnect(update_stats)
		if active_tamagotchi_resource.exp_changed.is_connected(update_exp):
			active_tamagotchi_resource.exp_changed.disconnect(update_exp)
		if active_tamagotchi_resource.leveled_up.is_connected(update_level):
			active_tamagotchi_resource.leveled_up.disconnect(update_level)

	active_tamagotchi_resource = tamagotchi_resource
	
	# Connect new signals to GUI
	active_tamagotchi_resource.stat_changed.connect(update_stats)
	active_tamagotchi_resource.exp_changed.connect(update_exp)
	active_tamagotchi_resource.leveled_up.connect(update_level)
	
	# Update the GUI once
	update_level(active_tamagotchi_resource)
	update_exp(active_tamagotchi_resource)
	update_stats(active_tamagotchi_resource)

func update_level(tamagotchi_resource: TamagotchiResource):
	level_label.update_level(tamagotchi_resource.stats.level)
	exp_progress_bar.max_value = tamagotchi_resource.stats.max_exp

func update_exp(tamagotchi_resource: TamagotchiResource):
	exp_progress_bar.value = tamagotchi_resource.stats.exp
	%ExpValue.text = str(floor(tamagotchi_resource.stats.get_exp_ratio()*100))

func update_stats(tamagotchi_resource: TamagotchiResource):

	%Stats/HungerPanel.update(tamagotchi_resource.stats.get_hunger_ratio())
	%Stats/HygienePanel.update(tamagotchi_resource.stats.get_hygiene_ratio())
	%Stats/HappinessPanel.update(tamagotchi_resource.stats.get_happiness_ratio())
	%Stats/HealthPanel.update(tamagotchi_resource.stats.get_health_ratio())
	%Stats/RestPanel.update(tamagotchi_resource.stats.get_rest_ratio())
