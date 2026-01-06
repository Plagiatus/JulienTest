extends Node3D
class_name Tile

var coin: Coin:
	set(value):
		_remove_listeners()
		coin = value
		_add_listeners()
		add_child(coin)

var pos_2d: Vector2:
	get():
		return Vector2(roundi(position.x), roundi(position.z))

signal hover_start()
signal hover_end()

@onready var visuals: CSGBox3D = $Visuals

func _add_listeners():
	coin.end_toss.connect(handle_land)

func _remove_listeners():
	if not coin: return
	coin.end_toss.disconnect(handle_land)

func handle_land(_is_heads: bool, flip_neighbors: Array[Vector2]):
	var pos_2dc = pos_2d;
	# get_tree().get_first_node_in_group("camera").shake(flip_neighbors.size() * 0.02, 20)
	shake(flip_neighbors.size() * 0.04, 15)
	for neighbor in flip_neighbors:
		var pos = pos_2dc + neighbor
		var neighbor_tile = GameData.get_tile(pos)
		if neighbor_tile:
			neighbor_tile.shake(0.04, 15)
			if neighbor_tile.coin:
				neighbor_tile.coin.flip()

func _on_area_3d_mouse_entered() -> void:
	visuals.material.albedo_color = Color(0.8, 0.8, 0.8)
	hover_start.emit()

func _on_area_3d_mouse_exited() -> void:
	visuals.material.albedo_color = Color(1, 1, 1)
	hover_end.emit()

var _current_shake_strength: float = 0.0
var _current_shake_fade: float = 0.0
var original_pos: Vector3 = position

func shake(strength: float, dampening: float):
	if _current_shake_strength < strength:
		_current_shake_strength = strength
		_current_shake_fade = dampening

func _process(delta: float) -> void:
	if _current_shake_strength > 0:
		_current_shake_strength = lerpf(_current_shake_strength, 0.0, _current_shake_fade * delta)
		position.x = original_pos.x + randf_range(-_current_shake_strength, _current_shake_strength)
		position.z = original_pos.z + randf_range(-_current_shake_strength, _current_shake_strength)
