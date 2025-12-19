extends Node

signal money_changed(new_value: int, change: int)

var money: int = 0:
	set(value):
		var change = value - money
		money = value
		money_changed.emit(value, change)

var floor_plane: Plane = Plane(Vector3.UP, 1)
