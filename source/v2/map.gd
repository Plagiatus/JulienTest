extends TileMapLayer

const TILE_SOURCE = 3
const FLOOR_ATLAS_COORDS = Vector2i(0, 0)
@onready var camera: Camera2D = $"../Camera2D"
const COIN = preload("uid://u8d2vs780hgk")

var size: Vector2i = Vector2i(3, 3)
var coin_grid: Grid = Grid.new(size, null)

func _ready():
	for x in range(size.x):
		for y in range(size.y):
			set_cell(Vector2i(x, y), TILE_SOURCE, FLOOR_ATLAS_COORDS)
	camera.position = map_to_local(( size ) / 2)
	init_coin(Vector2i(1, 1))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_RIGHT:
			if not event.is_pressed():
				if dragged_coin:
					end_dragging(event)
				#else:
					#end_moving()
			#else:
				#start_moving()


func init_coin(pos: Vector2i):
	var coin = COIN.instantiate() as Coin
	place_coin(pos, coin)
	#coin.start_toss.connect()
	#coin.end_toss.connect()
	coin.start_relocation.connect(start_dragging.bind(coin))

func place_coin(pos: Vector2i, coin: Coin):
	if coin.get_parent():
		coin.reparent(self)
	else:
		add_child(coin)
	coin.position = map_to_local(pos)
	coin_grid.erase(coin)
	coin_grid.set_at_vector(pos, coin)

var dragged_coin: Coin = null

func start_dragging(coin):
	if dragged_coin: return
	dragged_coin = coin

func end_dragging(event: InputEventMouseButton):
	prints(local_to_map(get_local_mouse_position()), get_local_mouse_position(), event.position)
	var map_pos = local_to_map(get_local_mouse_position())
	if not coin_grid.is_pos_inbound_vector(map_pos):
		dragged_coin = null
		return
	var existing_coin = coin_grid.get_at_vector(map_pos)
	if existing_coin:
		dragged_coin = null
		return
	place_coin(map_pos, dragged_coin)
	dragged_coin = null
