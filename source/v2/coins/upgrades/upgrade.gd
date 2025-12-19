@abstract
extends Resource
class_name Upgrade

@export var name: String
@export var description: String
@export_range(0, 10000) var cost: int
@export var next_upgrade: Upgrade

@abstract func buy_upgrade(coin: Coin)
