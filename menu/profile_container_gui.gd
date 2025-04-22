extends MarginContainer

class_name ProfileContainer

@export var active_tamagotchi_resource: TamagotchiResource

@onready var profile_button_node: Button = %ActiveProfileButton
@onready var level_label: RichTextLabel = %LevelLabel
@onready var exp_progress_bar: TextureProgressBar = %ExpProgressBar

signal profile_button_pressed

func connect_on_profile_click_signal(function: Callable):
	profile_button_pressed.connect(function)

# TODO: Progress bar is filled visually but not numerically

func update_active_tamagotchi(tamagotchi_resource: TamagotchiResource):
	
	profile_button_node.icon = tamagotchi_resource.profile_icon

	if active_tamagotchi_resource:
		if active_tamagotchi_resource.exp_changed.is_connected(update_exp):
			active_tamagotchi_resource.exp_changed.disconnect(update_exp)
		if active_tamagotchi_resource.leveled_up.is_connected(update_level):
			active_tamagotchi_resource.leveled_up.disconnect(update_level)

	active_tamagotchi_resource = tamagotchi_resource

	active_tamagotchi_resource.exp_changed.connect(update_exp)
	active_tamagotchi_resource.leveled_up.connect(update_level)

	update_level(active_tamagotchi_resource)
	update_exp(active_tamagotchi_resource)

func update_level(tamagotchi_resource: TamagotchiResource):
	level_label.update_level(tamagotchi_resource.stats.level)
	exp_progress_bar.max_value = tamagotchi_resource.stats.exp_cap

func update_exp(tamagotchi_resource: TamagotchiResource):
	exp_progress_bar.value = tamagotchi_resource.stats.exp
	%ExpValue.text = str(floor(tamagotchi_resource.stats.get_exp_ratio()*100))

func _on_active_profile_button_pressed() -> void:
	profile_button_pressed.emit()
