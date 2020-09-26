extends KinematicBody2D

export(float) var speed : float = 200
var _velocity : Vector2 = Vector2(0, 0)
var _aceleration : Vector2 = Vector2(0, 0)

func _ready() -> void:
	pass

func _physics_process(delta) -> void:
	pass

func AddForce(direction : Vector2, magnitude : float) -> void:
	_aceleration += direction.normalized() * magnitude
