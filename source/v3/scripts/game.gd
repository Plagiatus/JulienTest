class_name Game extends Node2D

var money: float = 0:
	set(value): 
		money = value
		money_changed.emit(money)

signal money_changed(new_value: float)

func _ready() -> void:
	var windowsize = get_viewport().get_visible_rect().size
	var coins = [load("uid://dfrs0wikm6o54"), load("uid://bwinures7hc1")]
	for coin_type in coins:
		for i in 4:
			var coin = coin_type.instantiate() as Coin
			$Coins.add_child(coin)
			coin.land.connect(coin_landed)
			coin.position = Vector2(randf_range(0, windowsize.x), randf_range(0, windowsize.y))

func coin_landed(info: TossResultResource) -> void:
	money += info.value
