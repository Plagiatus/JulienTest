class_name EffectComponent extends Node

@export var area_of_effect: Area2D

signal coin_entered_area(coin: Coin)
signal coin_exited_area(coin: Coin)

func _ready() -> void:
	area_of_effect.body_entered.connect(coin_entered)

func coin_entered(body: PhysicsBody2D) -> void:
	if not body is Coin: return 
	coin_entered_area.emit(body)

func coin_exited(body: PhysicsBody2D) -> void:
	if not body is Coin: return 
	coin_exited_area.emit(body)
