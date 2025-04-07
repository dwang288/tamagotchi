extends Resource

class_name CoinsResource

@export var coins: int
@export var max_coins: int

signal updated_coins(coins: int)

func modify_coins(coins_amount: int) -> bool:
	if coins + coins_amount >= 0:
		coins += coins_amount
		coins = max(min(coins, max_coins), 0)
		updated_coins.emit(coins)
		return true
	return false
