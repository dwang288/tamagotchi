extends Resource

class_name GameStateResource

@export var tamagotchis: Array[TamagotchiResource]
@export var inventory: InventoryResource
@export var coins: CoinsResource
# TODO: Split this off into a shop thing once we introduce that
@export var item_gacha_cost: int
