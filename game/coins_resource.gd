extends Resource

class_name CoinsResource

@export var coins: int
@export var max_coins: int

signal updated_coins(coins: int)

func update_coins(coins_amount: int):
	coins += coins_amount
	coins = max(min(coins, max_coins), 0)
	updated_coins.emit(coins)
