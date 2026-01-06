extends Node

func get_mouse_world_plane_position(camera: Camera3D, mouse_pos: Vector2) -> Vector3:
	var origin = camera.project_ray_origin(mouse_pos)
	var normal = camera.project_ray_normal(mouse_pos)

	return GameData.floor_plane.intersects_ray(origin, normal)