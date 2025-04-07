extends Button

@export var items: Array[InventoryItemResource]
@export var gacha_cost: int

signal sent_item(item: InventoryItemResource)
# Called when the node enters the scene tree for the first time.

func _on_pressed():
	if items.size() > 0:
		var item = items.pick_random()
		sent_item.emit(item)
		GameStateManager.game_state.coins.modify_coins(-gacha_cost)
