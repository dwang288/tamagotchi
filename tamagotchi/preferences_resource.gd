extends Resource

class_name PreferencesResource

## discovered?
#{ <resource>:  false }
@export var foods_liked: Dictionary[InventoryItemResource, bool]
@export var foods_disliked: Dictionary[InventoryItemResource, bool]

func discover_preference(item: InventoryItemResource) -> bool:
	if item in foods_liked and !foods_liked[item]:
		foods_liked[item] = true
		return true
	if item in foods_disliked and !foods_disliked[item]:
		foods_disliked[item] = true
		return true
	return false
