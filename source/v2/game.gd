extends Node3D
@onready var ui: CanvasLayer = $UI

@onready var grid: Node3D = $Grid
const DEFAULT_TILE = preload("uid://cj4lp0vpnu438")
const COIN = preload("uid://u8d2vs780hgk")
const COIN_VIEWPORT = preload("uid://wusm4xl41ovt")

var next_coin_cost: int = 0

func _ready() -> void:
	for child in grid.get_children():
		grid.remove_child(child)
		child.queue_free()
	
	instantiate_new_tile(Vector3(0, 0, 0))

func instantiate_new_tile(pos: Vector3):
	var tile = DEFAULT_TILE.instantiate() as Node3D
	grid.add_child(tile)
	tile.position = pos
	await get_tree().create_timer(1).timeout
	instantiate_new_coin(pos)

func instantiate_new_coin(pos: Vector3):
	var coin = COIN.instantiate() as Coin
	grid.add_child(coin)
	coin.position = pos
	coin.select_upgrade.connect(show_upgrade_view.bind(coin))

func show_upgrade_view(coin: Coin):
	ui.show_upgrades(coin)

func _on_buy_coin_button_button_down() -> void:
	if next_coin_cost > GameData.money: return
	var preview = COIN_VIEWPORT.instantiate()
	add_child(preview)
	
