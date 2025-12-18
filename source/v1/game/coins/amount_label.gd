extends Label3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	visible = false

func set_value(value: int):
	text = "%s x %s $" % [value, GameData.base_value]
	animation_player.play("rise")
