class_name ValueMultiplierEffectComponent extends EffectComponent

func _on_coin_throw(_toss: TossResource, _coin: Coin):
	_toss.heads_value *= 2
