extends Node3D
class_name Coin

@export var flight_curve: Curve

@export var upgrade_paths: Array[Upgrade]
@onready var positioning: Node3D = $Positioning
@onready var coin_cylinder: CSGCylinder3D = $Positioning/Visuals/coin_cylinder
@onready var coin_icon: Sprite3D = $Positioning/Visuals/coin_cylinder/coin_icon

enum STATE {
	REST,
	AIR
}

var upgrade_progress: Array[int] = []

var state: STATE = STATE.REST
var heads_chance: float = 0.5
var heads_value: int = 1
var next_result_is_heads: bool = true
var streak: int = 0
var flip_duration: float = 1
var rotation_speed: float = PI
var time_since_start: float = 0.0
var flip_neighbors: Array[Vector2] = []

var sale_value: int = 0

@onready var _3d_coin: Node3D = $Positioning/Visuals

signal start_toss()
signal end_toss(is_heads: bool, flip_neighbors: Array[Vector2])
#signal start_relocation()
signal select_upgrade()
signal upgrade_applied()

func _ready() -> void:
	upgrade_progress.resize(upgrade_paths.size())
	upgrade_progress.fill(0)

func flip():
	if state == STATE.AIR: return
	var prev_result = next_result_is_heads
	next_result_is_heads = randf() < heads_chance
	rotation_speed = 2 * PI * randi_range(3, 3) / flip_duration
	if prev_result != next_result_is_heads:
		rotation_speed += PI / flip_duration
	time_since_start = 0.0
	state = STATE.AIR
	start_toss.emit()

func _process(delta: float) -> void:
	time_since_start += delta
	if state == STATE.REST:
		#if time_since_start > flip_duration * 3:
			#flip()
		return
	if time_since_start >= flip_duration:
		land()
		return
	
	_3d_coin.position.y = flight_curve.sample(time_since_start / flip_duration)
	_3d_coin.rotate_x(delta * rotation_speed)

func land():
	state = STATE.REST
	_3d_coin.position.y = 0
	_3d_coin.rotation_degrees.x = 0 if next_result_is_heads else 180
	if next_result_is_heads:
		GameData.money += heads_value
	end_toss.emit(next_result_is_heads, flip_neighbors)

func apply_upgrade(upgrade: Upgrade):
	for i in upgrade_progress.size():
		var depth = upgrade_progress[i]
		var available_upgrade: Upgrade = upgrade_paths[i]
		while depth > 0 and available_upgrade:
			available_upgrade = available_upgrade.next_upgrade
			depth -= 1
		if not available_upgrade:
			continue
		if available_upgrade == upgrade:
			upgrade.buy_upgrade(self)
			upgrade_progress[i] += 1
			upgrade_applied.emit()
			break


func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if not event is InputEventMouseButton: return
	if not event.is_pressed(): return
	match event.button_index:
		MouseButton.MOUSE_BUTTON_LEFT:
			if state == STATE.REST:
				flip()
		MouseButton.MOUSE_BUTTON_RIGHT:
			select_upgrade.emit()

func set_next_pass(mat: Material):
	coin_cylinder.material_overlay = mat
