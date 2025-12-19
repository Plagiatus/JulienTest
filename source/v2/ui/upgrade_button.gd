extends Button
class_name UpgradeButton

var should_be_enabled: bool = false
var linked_upgrade: Upgrade
const LOCKED_OVERLAY = preload("uid://dabm5o4c7dmgb")
const BOUGHT_OVERLAY = preload("uid://dabg8chb7k7x3")


func _ready() -> void:
	GameData.money_changed.connect(check_money)

func setup(upgrade: Upgrade, enabled: bool, bought: bool, locked: bool):
	should_be_enabled = enabled && not locked && not bought
	text = "%s\n%s $" % [upgrade.name, upgrade.cost]
	tooltip_text = upgrade.description
	linked_upgrade = upgrade
	check_money(GameData.money, 0)

	# overlays
	if locked:
		var overlay = LOCKED_OVERLAY.instantiate() as PanelContainer
		add_child(overlay)
	elif bought:
		var overlay = BOUGHT_OVERLAY.instantiate() as PanelContainer
		add_child(overlay)

	
func check_money(amount, _c):
	if not should_be_enabled:
		disabled = true
		return
	disabled = amount < linked_upgrade.cost
