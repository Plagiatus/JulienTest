extends Upgrade
class_name HeadsChanceUpgrade

@export var new_heads_chance: float = 0.5
@export var coin_sides: int = 8


func buy_upgrade(coin: Coin):
	coin.heads_chance = new_heads_chance
	coin.coin_cylinder.sides = coin_sides