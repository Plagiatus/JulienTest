extends Node3D

class_name Coin

enum STATE {
	REST,
	AIR
}

var state: STATE = STATE.REST
var first_toss: bool = true

@onready var coin_pivot: Node3D = $CoinPivot
@onready var streak_label: Label3D = $StreakLabel

@export var flight_curve: Curve

@onready var fire_particles: CPUParticles3D = $CoinPivot/FireParticles
@onready var success_particles: CPUParticles3D = $SuccessParticles
@onready var amount_particle: CPUParticles3D = $AmountParticle
@onready var amount_label: Label3D = $AmountLabel

signal streak_hit(amount: int)
signal tossed

func click():
	match state:
		STATE.REST:
			toss()
	pass

var y_height: float
var rotation_speed: float = 0.0
var duration: float = GameData.flip_duration
var time_since_start: float = 0.0
var next_result_is_heads: bool = true
var streak: int = 0

func _ready() -> void:
	y_height = coin_pivot.position.y

func toss():
	GameData.total_tosses += 1
	var prev_result = next_result_is_heads
	next_result_is_heads = randf() < GameData.head_chance
	if first_toss:
		next_result_is_heads = true
		first_toss = false
	duration = GameData.flip_duration
	rotation_speed = 2 * PI * randi_range(2, 3) / duration
	if duration < 0.75:
		rotation_speed = 2 * PI * randi_range(1, 1) / duration
	if prev_result != next_result_is_heads:
		rotation_speed += PI / duration
	time_since_start = 0.0
	state = STATE.AIR
	tossed.emit()


func _process(delta: float) -> void:
	if state == STATE.REST: return
	
	time_since_start += delta
	if time_since_start >= duration:
		land()
		return
	coin_pivot.rotate_x(delta * rotation_speed)
	coin_pivot.position.y = flight_curve.sample(time_since_start / duration)

func land():
	coin_pivot.position.y = y_height
	coin_pivot.rotation_degrees.x = 0 if next_result_is_heads else 180
	state = STATE.REST
	if next_result_is_heads:
		streak += 1
		streak_hit.emit(streak)
		success_particles.emitting = true
		GameData.money += streak * streak * GameData.base_value
		#amount_particle.mesh.text = "%s x %s $" % [streak * streak, GameData.base_value]
		#amount_particle.emitting = true
		amount_label.set_value(streak * streak)
	else:
		streak = 0
	if streak >= 2:
		streak_label.text = "%s" % streak
		streak_label.visible = true
		fire_particles.emitting = true
		fire_particles.amount = clampi(streak * streak / 2, 2, 40)
	else:
		streak_label.visible = false
		fire_particles.emitting = false
	

var left_click_active: bool = false
func _input(event: InputEvent) -> void:
	if not event is InputEventMouseButton: return
	if not event.button_index == 1: return
	left_click_active = event.is_pressed()

func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if not event is InputEventMouseButton: return
	if not event.is_pressed(): return
	click()


func _on_area_3d_mouse_entered() -> void:
	if not GameData.click_drag_enabled: return
	if not left_click_active: return
	click()
