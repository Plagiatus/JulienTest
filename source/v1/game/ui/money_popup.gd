extends Label
class_name MoneyPopup

func set_value(amount: float):
	text = ""
	if amount > 0: text = "+"
	else: add_theme_color_override("font_color", Color.CRIMSON)
	if amount == int(amount):
		text += "%s$" % int(amount)
	else:
		text += "%s$" % amount
	
	position.x += randi_range(-50, 50)
	scale = Vector2i.ONE * clamp(log(abs(amount)) / log(100), 0.5, 5)
	
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(position.x + randf_range(-10, 10), position.y + -randf_range(30, 70) * sign(amount)), 1)
	tween.tween_callback(queue_free)
