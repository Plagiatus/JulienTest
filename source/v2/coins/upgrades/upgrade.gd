@abstract
extends Resource
class_name Upgrade

@export var name: String
@export var description: String
@export var cost: int
@export var next_upgrade: Upgrade

@abstract func buy_upgrade(coin: Coin)
