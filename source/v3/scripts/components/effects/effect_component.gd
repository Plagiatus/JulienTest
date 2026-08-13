@abstract
class_name EffectComponent extends Node2D

@export var area_of_effect: Area2D

signal coin_entered_area(coin: Coin)
signal coin_exited_area(coin: Coin)

func _ready() -> void:
	area_of_effect.body_entered.connect(_coin_entered)
	area_of_effect.body_exited.connect(_coin_exited)

func _coin_entered(body: PhysicsBody2D) -> void:
	if not body is Coin: return 
	coin_entered_area.emit(body)
	body.throw.connect(_on_coin_throw.bind(body))
	body.land.connect(_on_coin_landed.bind(body))

func _coin_exited(body: PhysicsBody2D) -> void:
	if not body is Coin: return 
	coin_exited_area.emit(body)
	body.throw.disconnect(_on_coin_throw)
	body.land.disconnect(_on_coin_landed)

func _on_coin_throw(_toss: TossResource, _coin: Coin): pass
func _on_coin_landed(_toss_result: TossResultResource, _coin: Coin): pass

func _draw() -> void:
	draw_circle(position, 80, Color(1.0, 1.0, 1.0, 0.498), false, 1)
