extends Resource
class_name Grid

var data: Array = []

var size: Vector2i
var amount_elements: int

func _init(_size: Vector2i, default: Variant = null) -> void:
	size = _size
	amount_elements = size.x * size.y
	data.resize(amount_elements)
	for i in amount_elements:
		data[i] = default

func set_at(x: int, y: int, value: Variant) -> void:
	var index = _get_index(x, y)
	if not is_index_inbound(index):
		push_warning("Tried to add something outside of the grid boundaries")
		return
	data[index] = value

func set_at_vector(v: Vector2i, value: Variant) -> void:
	return set_at(v.x, v.y, value)

func get_at(x: int, y: int) -> Variant:
	var index = _get_index(x, y)
	if not is_index_inbound(index): return null
	return data[_get_index(x, y)]

func get_at_vector(v: Vector2i) -> Variant:
	return get_at(v.x, v.y)

func _get_index(x: int, y: int) -> int:
	return x + y * size.x

func _get_coords_from_index(index: int) -> Vector2i:
	return Vector2i(index / size.x, index % size.x)

func is_pos_inbound(x: int, y: int) -> bool:
	if x < 0 or x >= size.x or y < 0 or y >= size.y: return false
	return true

func is_pos_inbound_vector(v: Vector2i) -> bool:
	return is_pos_inbound(v.x, v.y)

func is_index_inbound(index: int) -> bool:
	if index < 0 or index >= amount_elements: return false
	return true

func get_neighbors_at(x: int, y: int) -> Array[Variant]:
	var neighbors: Array[Variant] = []
	var n = get_at(x + 1, y)
	if n: neighbors.append(n)
	var s = get_at(x - 1, y)
	if s: neighbors.append(n)
	var w = get_at(x, y + 1)
	if w: neighbors.append(n)
	var e = get_at(x, y - 1)
	if e: neighbors.append(n)
	return neighbors

func get_neighbors_at_vector(v: Vector2i) -> Array[Variant]:
	return get_neighbors_at(v.x, v.y)

func erase(value: Variant):
	var index = data.find(value)
	if index < 0: return
	data[index] = null

func get_position_of(value: Variant) -> Vector2i:
	var index = data.find(value)
	if index < 0: 
		var result: Vector2i
		return result
	return _get_coords_from_index(index)
	
	
