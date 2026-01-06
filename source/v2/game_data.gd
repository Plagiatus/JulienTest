extends Node

signal money_changed(new_value: int, change: int)

var money: int = 0:
	set(value):
		var change = value - money
		money = value
		money_changed.emit(value, change)

var floor_plane: Plane = Plane(Vector3.UP, 1)

var _tile_grid: Dictionary = {}

func add_tile(tile: Tile):
	_tile_grid.set("%s,%s" % [roundi(tile.position.x), roundi(tile.position.z)], tile);

func get_tile(pos: Vector2) -> Tile:
	return _tile_grid.get("%s,%s" % [roundi(pos.x), roundi(pos.y)])
