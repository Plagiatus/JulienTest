extends Upgrade
class_name FlipNeighborsUpgrade

@export var neighbors: Array[Vector2] = []
@export var coin_height: float = 0.1

func buy_upgrade(coin: Coin):
	coin.flip_neighbors = neighbors
	coin.coin_cylinder.height = coin_height
	coin.coin_icon.position.y = coin_height / 2 + 0.01
	coin.positioning.position.y = coin_height / 2
