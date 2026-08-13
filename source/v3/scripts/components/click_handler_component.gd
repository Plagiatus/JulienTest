class_name ClickHandlerComponent extends Node2D

@export var clickable_shape: CollisionObject2D
@export var grab_distance: int = 1
var grab_distance_squared: int = 1

enum STATE {
	IDLE,
	WAITING,
	GRABBED,
}
var state: STATE = STATE.IDLE

signal grab
signal release
signal tap
signal move(to: Vector2)

func _ready() -> void:
	grab_distance_squared = grab_distance ** 2
	if not clickable_shape:
		return
	
	clickable_shape.input_pickable = true
	clickable_shape.input_event.connect(_on_input_event)

var is_grabbed: bool = false
var start_point: Vector2
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	match state:
		STATE.IDLE:
			if event.is_action_pressed("interact"):
				start_point = get_global_mouse_position()
				state = STATE.WAITING
				# prints("waiting")

func _unhandled_input(event: InputEvent) -> void:
	if state == STATE.IDLE:
		return
	match state:
		STATE.WAITING:
			if event.is_action_released("interact"):
				# prints("tap")
				tap.emit()
				state = STATE.IDLE
			
			elif event is InputEventMouseMotion and start_point:
				var current_pos = get_global_mouse_position()
				if current_pos.distance_squared_to(start_point) > grab_distance_squared:
					state = STATE.GRABBED
					grab.emit()
					move.emit(current_pos)
					# prints("grab")
		STATE.GRABBED:
			if event.is_action_released("interact"):
				release.emit()
				# prints("release")
				state = STATE.IDLE
			elif event is InputEventMouseMotion:
				move.emit(get_global_mouse_position())
				# prints("move")
