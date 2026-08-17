@tool
@abstract
class_name EffectComponent extends Node2D

var area_of_effect: Area2D
@export var color: Color = Color(1.0, 1.0, 1.0, 0.498):
	set(value):
		color = value
		queue_redraw()

var coins_in_radius: Array[Coin] = []

signal coin_entered_area(coin: Coin)
signal coin_exited_area(coin: Coin)

func _ready() -> void:
	if Engine.is_editor_hint():
		_get_configuration_warnings()
		child_order_changed.connect(update_configuration_warnings)
		return
	
	area_of_effect = _find_first_area_in_children()
	area_of_effect.body_entered.connect(_coin_entered)
	area_of_effect.body_exited.connect(_coin_exited)

func _coin_entered(body: PhysicsBody2D) -> void:
	if not body is Coin: return 
	coin_entered_area.emit(body)
	body.throw.connect(_on_coin_throw.bind(body))
	body.land.connect(_on_coin_landed.bind(body))
	if not coins_in_radius.has(body):
		coins_in_radius.append(body)

func _coin_exited(body: PhysicsBody2D) -> void:
	if not body is Coin: return 
	coin_exited_area.emit(body)
	body.throw.disconnect(_on_coin_throw)
	body.land.disconnect(_on_coin_landed)
	coins_in_radius.erase(body)

func _on_coin_throw(_toss: TossResource, _coin: Coin): pass
func _on_coin_landed(_toss_result: TossResultResource, _coin: Coin): pass

func _draw() -> void:
	var col_shape: CollisionShape2D = _find_first_area_in_children().find_children("", "CollisionShape2D")[0]
	if not col_shape: return
	
	col_shape.debug_color = color
	
	var shape = col_shape.shape
	if shape is CircleShape2D:
		draw_circle(position, shape.radius, color, false, 1)
	if shape is RectangleShape2D:
		draw_rect(shape.get_rect(), color, false)


func _get_configuration_warnings() -> PackedStringArray:
	if get_children().size() == 0 or not _find_first_area_in_children(): return ["This node needs an Area2D as a child"]
	return []

func _find_first_area_in_children() -> Area2D:
	var foundArea = find_children("", "Area2D", false)[0]
	return foundArea
