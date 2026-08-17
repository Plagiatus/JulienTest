@tool
class_name ValueMultiplierEffectComponent extends EffectComponent

@export var multiplier: float = 2

func _on_coin_throw(_toss: TossResource, _coin: Coin):
	_toss.heads_value *= multiplier
