class_name MoveComponent extends Node

@export var click_handler: ClickHandlerComponent
@export var manual_body: CharacterBody2D
@export var regular_body: RigidBody2D

var target_position: Vector2
var needs_to_move: bool = false

func _ready() -> void:
	click_handler.grab.connect(start_moving)
	click_handler.move.connect(move_to)
	click_handler.release.connect(end_moving)

func start_moving() -> void:
	#regular_body.process_mode = Node.PROCESS_MODE_DISABLED
	#manual_body.process_mode = Node.PROCESS_MODE_INHERIT
	pass

func move_to(pos: Vector2) -> void:
	target_position = pos
	needs_to_move = true
	#regular_body.process_mode = Node.PROCESS_MODE_DISABLED
	#manual_body.process_mode = Node.PROCESS_MODE_INHERIT

func _physics_process(delta: float) -> void:
	if not needs_to_move: return
	var parent_position : Vector2 = get_parent().global_position
	if target_position.distance_squared_to(parent_position) < 1:
		needs_to_move = false
		regular_body.freeze = true
		await Engine.get_physics_frames()
		regular_body.call_deferred("set", "freeze", false)
		#manual_body.process_mode = Node.PROCESS_MODE_DISABLED
		#regular_body.process_mode = Node.PROCESS_MODE_INHERIT
		return
	var direction = target_position - parent_position
	regular_body.apply_force(direction  /delta)
	#manual_body.velocity = direction / delta
	#prints(direction)
	#manual_body.move_and_slide()
	#get_parent().global_position = manual_body.global_position
	#manual_body.position = Vector2.ZERO

func end_moving() -> void:
	#get_parent().add_child(regular_body)
	#manual_body.process_mode = Node.PROCESS_MODE_DISABLED
	#regular_body.process_mode = Node.PROCESS_MODE_INHERIT
	pass
