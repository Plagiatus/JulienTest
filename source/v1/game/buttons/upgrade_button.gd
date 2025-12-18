@abstract
extends Button
class_name UpgradeButton

@export var visible_limit: float = 0.0
## use %0 for the price, %1 for the new value (if applicable)
@export var text_format: String = ""
@export var prices: Array[int]

var current_item: int = 0
var current_price: float = 0.0
var sold_out: bool = false

func _ready() -> void:
	GameData.money_changed.connect(_update_disabled)
	pressed.connect(_click)
	visible = false
	current_price = prices[0]
	_update_disabled(GameData.money)
	_update_text()

func _update_disabled(money_amount):
	if visible == false:
		visible = money_amount >= visible_limit
	if sold_out:
		disabled = true
		return
	disabled = money_amount < current_price

func _next_item():
	var price = current_price
	current_item+=1
	if current_item < prices.size():
		current_price = prices[current_item]
	else:
		sold_out = true
	GameData.money -= price
	
	_update_text()

func _update_text():
	pass

func _click():
	pass
