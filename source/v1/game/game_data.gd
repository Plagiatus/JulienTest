extends Node

var head_chance: float = 0.3
var flip_duration: float = 1.5
var base_value: float = 0.25
var click_drag_enabled: bool = false
var total_tosses: int = 0

signal money_changed(new_value: float)

var money: float = 0.0:
	set(new_value):
		money = new_value
		money_changed.emit(money)
