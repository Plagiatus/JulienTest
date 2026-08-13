class_name MoveComponent extends Node

@export var click_handler: ClickHandlerComponent
@export var manual_body: CharacterBody2D
@export var regular_body: RigidBody2D

var target_position: Vector2
var needs_to_move: bool = false

const OBJECT_MOVER = preload("uid://bv5ypgokjbu4x")

func _ready() -> void:
	click_handler.grab.connect(start_moving)
	click_handler.move.connect(move_to)
	click_handler.release.connect(end_moving)

var mover: ObjectMover

func start_moving() -> void:
	mover = OBJECT_MOVER.instantiate()
	get_parent().add_child(mover)
	mover.setup(get_parent())
	pass

func move_to(pos: Vector2) -> void:
	target_position = pos
	needs_to_move = true

func _physics_process(_delta: float) -> void:
	if not needs_to_move: return
	mover.global_position = target_position

func end_moving() -> void:
	mover.queue_free()
	needs_to_move = false
	pass
