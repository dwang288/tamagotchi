extends Control

class_name TamaInfoWindow

@export var active_tamagotchi_resource: TamagotchiResource

@onready var button_container: ButtonContainer = %ButtonContainer
@onready var profile_container: MarginContainer = %ProfileContainer
@onready var tab_container: TabContainer = %TabContainer

func _ready():
	button_container.connect_on_click_signal(toggle_tama_info_window)

func update_active_tamagotchi(tamagotchi_resource: TamagotchiResource):

	profile_container.update_active_tamagotchi(tamagotchi_resource)
	tab_container.update_active_tamagotchi(tamagotchi_resource)

func toggle_tama_info_window():
	visible = !visible
