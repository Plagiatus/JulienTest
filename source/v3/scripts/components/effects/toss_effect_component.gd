@tool
class_name TossEffectComponent extends EffectComponent

func toss():
	var this_coin: Node2D = get_parent()
	for coin in coins_in_radius:
		if coin == this_coin: continue
		var toss_comp: TossComponent = coin.find_children("", "TossComponent")[0]
		if not toss_comp: continue
		if toss_comp.try_throw():
			var direction = this_coin.global_position.direction_to(coin.global_position)
			var distance = this_coin.global_position.distance_to(coin.global_position)
			coin.apply_impulse(direction * 1000 / distance)
