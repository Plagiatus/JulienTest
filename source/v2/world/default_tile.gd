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
	for neighbor in flip_neighbors:
		var pos = pos_2dc + neighbor
		var neighbor_tile = GameData.get_tile(pos)
		if neighbor_tile and neighbor_tile.coin:
			neighbor_tile.coin.flip()

func _on_area_3d_mouse_entered() -> void:
	visuals.material.albedo_color = Color(0.8, 0.8, 0.8)
	hover_start.emit()

func _on_area_3d_mouse_exited() -> void:
	visuals.material.albedo_color = Color(1, 1, 1)
	hover_end.emit()
