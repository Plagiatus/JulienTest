extends Control

@onready var button_container: HBoxContainer = $VBoxContainer/ButtonContainer

signal chosen_upgrade(upgrade: Upgrade)

func setup(base_upgrade: Upgrade, progress: int, lock_high_tiers: bool) -> void:
	var upgrade = base_upgrade
	var depth = 0
	while upgrade:
		var new_button = UpgradeButton.new()
		new_button.setup(upgrade, progress == depth, progress > depth, lock_high_tiers and progress <= 2 and depth >= 2)
		new_button.pressed.connect(clicked_upgrade.bind(upgrade))
		button_container.add_child(new_button)
		depth += 1
		upgrade = upgrade.next_upgrade

func clicked_upgrade(upgrade: Upgrade):
	chosen_upgrade.emit(upgrade)
