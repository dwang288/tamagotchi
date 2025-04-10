extends Button

@export var items: Array[InventoryItemResource]
@export var gacha_cost: int = GameStateManager.game_state.item_gacha_cost

signal sent_item(item: InventoryItemResource)
# Called when the node enters the scene tree for the first time.

# TODO: Should send signal to CoinManager with the gacha cost
func _on_pressed():
	if items.size() > 0 and GameStateManager.game_state.coins.modify_coins(-gacha_cost):
		var item = items.pick_random()
		sent_item.emit(item)
