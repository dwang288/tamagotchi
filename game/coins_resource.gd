extends Resource

class_name CoinsResource

@export var coins: float
@export var max_coins: float
@export var gain_rate: float

signal updated_coins(coins: int)

func modify_coins(coins_amount: float) -> bool:
	if coins + coins_amount >= 0:
		coins += coins_amount
		coins = max(min(coins, max_coins), 0)
		updated_coins.emit(floor(coins))
		# print(coins_amount)
		return true
	return false
