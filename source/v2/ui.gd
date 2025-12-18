extends CanvasLayer

@onready var coin_upgrade: Control = $CoinUpgrade

func show_upgrades(coin: Coin):
	coin_upgrade.enable(coin)

func hide_upgrades():
	coin_upgrade.disable()
