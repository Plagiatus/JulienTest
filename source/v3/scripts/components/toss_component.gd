class_name TossComponent extends Node

 
@export var toss_info: TossResource

@export_category("Nodes")
@export var click_handler_comp: ClickHandlerComponent
@export var collision_shape: CollisionShape2D
@export var visuals: AnimatedSprite2D
@export var shadow: Sprite2D

var is_throwing: bool

signal throw(toss: TossResource)
signal land(result: TossResultResource)

func _ready() -> void:
	click_handler_comp.tap.connect(try_throw)

func try_throw() -> void:
	if is_throwing: return
	start_throw()

func start_throw() -> void:
	var toss_data := toss_info.duplicate()
	throw.emit(toss_data)
	visuals.play("throw")
	visuals.offset.y = -10
	visuals.z_index += 2
	shadow.z_index += 1
	collision_shape.set_deferred("disabled", true)
	await get_tree().create_timer(toss_data.throw_duration, false).timeout
	end_throw(toss_data)

func end_throw(toss_data: TossResource) -> void:
	visuals.z_index -= 2
	visuals.offset.y = 0
	shadow.z_index -= 1
	collision_shape.set_deferred("disabled", false)

	var throw_outcome: TossResultResource.TOSS_OUTCOME
	var throw_value: float
	if toss_data.heads_chance > randf():
		visuals.play("head")
		throw_outcome = TossResultResource.TOSS_OUTCOME.HEAD
		throw_value = toss_data.heads_value
	else:
		visuals.play("tail")
		throw_outcome = TossResultResource.TOSS_OUTCOME.TAIL
		throw_value = toss_data.tails_value
	var result: TossResultResource = TossResultResource.new(throw_outcome, throw_value)
	land.emit(result)
