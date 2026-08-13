class_name Game extends Node2D

var money: float = 0:
	set(value): 
		money = value
		money_changed.emit(money)

signal money_changed(new_value: float)

func _ready() -> void:
	var windowsize = get_viewport().get_visible_rect().size
	for i in 4:
		var coin = Coin.COIN.instantiate() as Coin
		$Coins.add_child(coin)
		coin.land.connect(coin_landed)
		coin.position = Vector2(randf_range(0, windowsize.x), randf_range(0, windowsize.y))

func coin_landed(info: TossResultResource) -> void:
	money += info.value
