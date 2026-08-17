class_name Coin extends RigidBody2D

signal throw(toss: TossResource)
signal land(result: TossResultResource)

@export var toss_component: TossComponent

static var COIN = preload("uid://dfrs0wikm6o54")
static var COIN_HEAVY = preload("uid://bwinures7hc1")

func _ready() -> void:
	toss_component.throw.connect(throw.emit)
	toss_component.land.connect(land.emit)
