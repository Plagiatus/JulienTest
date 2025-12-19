extends Upgrade
class_name HeadsChanceUpgrade

@export var new_heads_chance: float = 0.5


func buy_upgrade(coin: Coin):
	coin.heads_chance = new_heads_chance
