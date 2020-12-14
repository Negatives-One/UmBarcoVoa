extends Area2D

class_name Current

enum states {Idle, Moving}

var currentState : int = states.Idle

var currentSpace : int = 0

signal currentEnded

var direction : int = 0

var targetXPosition : float

var initialXPosition : float

export(float) var speed : float = 1000

func _ready() -> void:
	$CollisionShape2D.shape.extents = Vector2(get_viewport_rect().size.x/2, 270/2)
	$CollisionShape2D.position.x = get_viewport_rect().size.x/2
	$pixel.scale.x = get_viewport_rect().size.x #d(Vector2(get_viewport_rect().size.x, 270))
	pass

func _physics_process(delta: float) -> void:
	LinearXInterpolation(targetXPosition, speed, delta)

func LinearXInterpolation(targetPos : float, velocity : float, physicsDelta : float) -> void:
	currentState = states.Moving
	position.x += direction * velocity * physicsDelta
	if initialXPosition > targetPos:
		position.x = targetPos
		currentState = states.Idle
