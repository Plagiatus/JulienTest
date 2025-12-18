extends Upgrade
class_name ValueUpgrade

@export var heads_value: int = 0
@export var icon: CompressedTexture2D
@export var material: StandardMaterial3D


func buy_upgrade(coin: Coin):
	coin.heads_value = heads_value
	
	coin.coin_icon.texture = icon
	coin.coin_cylinder.material = material
