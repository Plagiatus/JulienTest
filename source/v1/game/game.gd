extends Node3D
class_name Game

const BASE_COIN = preload("uid://b1timayblmllq")
@onready var coins: Node3D = $Coins
@onready var coin_amount_label: Label = $UI/MainUI/VBoxContainer/StatsContainer/CoinAmount/Amount
var coin_amount_in_depth: int = 0
var coin_depth: int = 0
var coin_amount: int = 0

var max_streak: int = 0
@onready var max_streak_label: Label = $UI/MainUI/VBoxContainer/HBoxContainer/MarginContainer2/VBoxContainer/MaxStreakLabel
@onready var total_tosses_label: Label = $UI/MainUI/VBoxContainer/HBoxContainer/MarginContainer2/VBoxContainer/TotalTossesLabel

var automatic_coins_per_second: float = 0
@onready var automatic: Timer = $Automatic

func _ready():
	for coin in coins.get_children():
		coin.queue_free()
	
	automatic.timeout.connect(trigger_one_coin)

func add_coin():
	var new_coin = BASE_COIN.instantiate() as Coin
	coins.add_child(new_coin)
	
	new_coin.position.z = -1 * coin_depth
	new_coin.position.x = 1 * coin_depth - coin_amount_in_depth * 2
	new_coin.streak_hit.connect(streak_check)
	new_coin.tossed.connect(toss_check)
	
	coin_amount_in_depth += 1
	if coin_amount_in_depth > coin_depth:
		coin_amount_in_depth = 0
		coin_depth += 1
	coin_amount += 1
	coin_amount_label.text = str(coin_amount)

func add_automatic():
	automatic_coins_per_second += 1
	automatic.start(1.0 / automatic_coins_per_second)

func trigger_one_coin():
	var candidates = coins.get_children()
	while(candidates.size() > 0):
		var candidate = candidates.pick_random() as Coin
		if candidate.state == Coin.STATE.REST:
			candidate.toss()
			break
		candidates.erase(candidate)

func streak_check(amount: int):
	if amount <= max_streak: return
	max_streak = amount
	max_streak_label.text = "Highest Streak: %s" % max_streak

func toss_check():
	total_tosses_label.text = "Total Tosses: %s" % GameData.total_tosses
