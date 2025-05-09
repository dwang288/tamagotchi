extends Node

@export var timer: Timer = Timer.new()
@export var SAVE_INTERVAL: float = 5.0
@export var skipped_types: Array = [ Texture2D, AnimationLibrary ]
@export var game_state: GameStateResource = load("res://game_states/default_save.tres")


func _ready():
	timer.wait_time = SAVE_INTERVAL
	timer.autostart = true
	timer.timeout.connect(save_game)
	add_child(timer)

func new_game():
	# create a new GameState resource with default child resources (unique)
	print("creating new game")
	pause_autosave()
	# overwrite existing file
	var new_resource = deep_duplicate_resource(load("res://game_states/default_save_backup.tres"))
	# print(new_resource.tamagotchis[0].resource_path)
	ResourceSaver.save(new_resource, game_state.get_path())
	# quit window
	get_tree().quit()

func pause_autosave():
	timer.stop()

func resume_autosave():
	timer.start()

func save_game():
	print("Saving")
	ResourceSaver.save(game_state, game_state.get_path())

func deep_duplicate_resource(resource: Resource) -> Resource:
	if resource == null:
		return null

	var copy = resource.duplicate(false)

	for property in resource.get_property_list():
		if property.usage & PROPERTY_USAGE_STORAGE == 0:
			continue

		var name = property.name
		var value = resource.get(name)

		if name == "script":
			continue

		if (
			value is Texture2D or
			value is AnimationLibrary or
			value is InventoryItemResource
		):
			continue

		if value is Resource:
			var nested_copy = deep_duplicate_resource(value)
			if nested_copy != null:
				nested_copy.resource_path = ""
			copy.set(name, nested_copy)
			#print(name, " ", nested_copy.resource_path)
			#print(name, " ", copy.resource_path)

		# TODO: Add save type for dictionaries
		elif typeof(value) == TYPE_ARRAY:
			print(value)
			var new_array = value.duplicate()
			new_array.clear()
			for item in value:
				if item is Resource:
					var item_copy = deep_duplicate_resource(item)
					if item_copy != null:
						item_copy.resource_path = ""
					new_array.append(item_copy)
				else:
					new_array.append(item)
			#print(name)
			copy.set(name, new_array)
			#print(name, " ", new_array[0].resource_path)
			#print(name, " ", copy.tamagotchis[0].resource_path)

		else:
			copy.set(name, value)

	copy.resource_path = ""
	return copy
