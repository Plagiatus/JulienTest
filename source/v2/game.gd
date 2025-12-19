extends Node3D
@onready var ui: CanvasLayer = $UI

@onready var grid: Node3D = $Grid
const DEFAULT_TILE = preload("uid://cj4lp0vpnu438")
const COIN = preload("uid://u8d2vs780hgk")
const COIN_VIEWPORT = preload("uid://wusm4xl41ovt")

var next_coin_cost: int = 0
var dragging_coin: bool = false
@onready var dragged_coin: TextureRect = $UI/GameOverlay/DraggedCoin
var hovered_tile: Tile
var current_tile_area_size: int = 0

func _ready() -> void:
	for child in grid.get_children():
		grid.remove_child(child)
		child.queue_free()
	
	dragged_coin.hide()
	increase_area()

func _process(_delta: float) -> void:
	if dragging_coin:
		if not Input.is_mouse_button_pressed(MouseButton.MOUSE_BUTTON_LEFT):
			# try to drop
			dragged_coin.hide()
			dragging_coin = false
			if hovered_tile && not hovered_tile.coin:
				instantiate_new_coin(hovered_tile)
		else:
			dragged_coin.position = get_viewport().get_mouse_position() - dragged_coin.size / 2

func increase_area():
	current_tile_area_size += 1
	for x in current_tile_area_size:
		instantiate_new_tile(Vector3(x, 0, current_tile_area_size - 1))
	for y in current_tile_area_size - 1:
		instantiate_new_tile(Vector3(current_tile_area_size - 1, 0, y))

func instantiate_new_tile(pos: Vector3):
	var tile = DEFAULT_TILE.instantiate() as Tile
	grid.add_child(tile)
	tile.position = pos
	tile.hover_start.connect(tile_hover_start.bind(tile))
	tile.hover_end.connect(tile_hover_end.bind(tile))

func instantiate_new_coin(tile: Tile):
	var coin = COIN.instantiate() as Coin
	tile.add_child(coin)
	# coin.position = tile.position
	coin.select_upgrade.connect(show_upgrade_view.bind(coin))
	tile.coin = coin
	# todo increase price
	# todo charge money

func show_upgrade_view(coin: Coin):
	ui.show_upgrades(coin)

func _on_buy_coin_button_button_down() -> void:
	if next_coin_cost > GameData.money: return
	dragging_coin = true
	dragged_coin.show()

func tile_hover_start(tile: Tile):
	hovered_tile = tile

func tile_hover_end(tile: Tile):
	if hovered_tile == tile:
		hovered_tile = null


func _on_buy_tile_button_pressed() -> void:
	increase_area()
