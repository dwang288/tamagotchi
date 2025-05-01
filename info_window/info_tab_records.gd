extends VBoxContainer

@export var active_tamagotchi_resource: TamagotchiResource

@onready var liked_container: FlowContainer = %LikedContainer
@onready var disliked_container: FlowContainer = %DislikedContainer

func update_active_tamagotchi(tamagotchi_resource: TamagotchiResource):

	# Disconnect previous tamagotchi's signals from GUI
	if active_tamagotchi_resource:
		if active_tamagotchi_resource.discovered_preference.is_connected(update_preferences):
			active_tamagotchi_resource.discovered_preference.disconnect(update_preferences)

	active_tamagotchi_resource = tamagotchi_resource
	
	# Connect new signals to GUI
	active_tamagotchi_resource.discovered_preference.connect(update_preferences)
	
	# Update the GUI once
	update_preferences(active_tamagotchi_resource)

func update_preferences(tamagotchi_resource: TamagotchiResource):
	for child in liked_container.get_children():
		child.queue_free()
	for child in disliked_container.get_children():
		child.queue_free()

	for liked_item in tamagotchi_resource.preferences.foods_liked:
		if tamagotchi_resource.preferences.foods_liked[liked_item]:
			var texture_rect = TextureRect.new()
			texture_rect.texture = liked_item.texture
			liked_container.add_child(texture_rect)

	for disliked_item in tamagotchi_resource.preferences.foods_disliked:
		if tamagotchi_resource.preferences.foods_disliked[disliked_item]:
			var texture_rect = TextureRect.new()
			texture_rect.texture = disliked_item.texture
			disliked_container.add_child(texture_rect)
