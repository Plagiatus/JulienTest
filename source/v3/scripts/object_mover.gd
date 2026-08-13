class_name ObjectMover extends Node2D
@onready var pin: PinJoint2D = $Pin
@onready var body: StaticBody2D = $Body

func setup(obj: PhysicsBody2D) -> void:
	global_position = obj.global_position
	pin.node_b = obj.get_path()
