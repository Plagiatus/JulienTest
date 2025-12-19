extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var upgrade_container: VBoxContainer = $PanelContainer/MarginContainer/UpgradeContainer
const UPGRADE_PATHS = preload("uid://bgaj0qu0cdgkn")

var active_coin: Coin

func enable(coin: Coin):
	if active_coin == coin:
		disable()
		return
	_setup(coin)
	active_coin = coin
	if visible: return
	show()
	animation_player.play("show")

func _setup(coin: Coin):
	for child in upgrade_container.get_children():
		child.queue_free()
	var locked_higher_paths: bool = false
	for progress in coin.upgrade_progress:
		if progress > 2:
			locked_higher_paths = true
			break
	for i in coin.upgrade_paths.size():
		var path = coin.upgrade_paths[i]
		var path_ui = UPGRADE_PATHS.instantiate()
		upgrade_container.add_child(path_ui)
		path_ui.setup(path, coin.upgrade_progress[i], locked_higher_paths)
		path_ui.chosen_upgrade.connect(choose_upgrade.bind(coin))
	
	if active_coin and active_coin.upgrade_applied.is_connected(refresh):
		active_coin.upgrade_applied.disconnect(refresh)
	if not coin.upgrade_applied.is_connected(refresh):
		coin.upgrade_applied.connect(refresh)
	#var next_upgrade = coin.upgrade_path
	#while next_upgrade:
	pass

func disable():
	active_coin = null
	animation_player.play_backwards("show")
	await animation_player.animation_finished
	hide()

func refresh():
	if active_coin:
		_setup(active_coin)

func choose_upgrade(upgrade, coin):
	coin.apply_upgrade(upgrade)
	GameData.money -= upgrade.cost
