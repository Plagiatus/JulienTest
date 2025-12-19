extends Node3D
class_name Tile

var coin: Coin

signal hover_start()
signal hover_end()

@onready var visuals: CSGBox3D = $Visuals

func _on_area_3d_mouse_entered() -> void:
	visuals.material.albedo_color = Color(0.8, 0.8, 0.8)
	hover_start.emit()

func _on_area_3d_mouse_exited() -> void:
	visuals.material.albedo_color = Color(1, 1, 1)
	hover_end.emit()
