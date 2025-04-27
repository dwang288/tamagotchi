extends MarginContainer

@export var active_tamagotchi_resource: TamagotchiResource

@onready var name_label: RichTextLabel = %NameLabel
@onready var portrait: TextureRect = %PortraitTexture
@onready var prev_profile_button: Button = %PrevProfileButton
@onready var next_profile_button: Button = %NextProfileButton

signal active_profile_changed(step: int)

func update_active_tamagotchi(tamagotchi_resource: TamagotchiResource):
	# Disconnect previous tamagotchi's signals from GUI

	active_tamagotchi_resource = tamagotchi_resource
	# Update the GUI once
	update_profile(active_tamagotchi_resource)

func update_profile(tamagotchi_resource):
	name_label.text = Utils.replace_keywords(tamagotchi_resource.name)
	portrait.texture = tamagotchi_resource.profile_large

func _on_prev_profile_button_pressed() -> void:
	active_profile_changed.emit(-1)

func _on_next_profile_button_pressed() -> void:
	active_profile_changed.emit(1)
