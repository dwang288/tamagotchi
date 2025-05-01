extends Resource

class_name PreferencesResource

signal discovered_preference(item: InventoryItemResource)

## discovered?
#{ <resource>:  false }
@export var foods_liked: Dictionary[InventoryItemResource, bool]
@export var foods_disliked: Dictionary[InventoryItemResource, bool]

func discover_preference(item: InventoryItemResource):
	if item in foods_liked:
		foods_liked[item] = true
	if item in foods_disliked:
		foods_disliked[item] = true
	discovered_preference.emit(item)
