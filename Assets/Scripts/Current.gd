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

var isStrong : bool = false

func _ready() -> void:
	gravity_vec = Vector2(direction, 0)
	if isStrong:
		gravity = get_parent().magnitudeStrong
		$pixel.self_modulate = Color(1, 0, 0, 0.8)
	else:
		gravity = get_parent().magnitudeWeak
		$pixel.self_modulate = Color(1, 0, 0, 0.4)
	$CollisionShape2D.shape.extents = Vector2(get_viewport_rect().size.x/2, 270/2)
	$CollisionShape2D.position.x = get_viewport_rect().size.x/2
	$pixel.scale.x = get_viewport_rect().size.x #d(Vector2(get_viewport_rect().size.x, 270))
	$VisibilityNotifier2D.rect = Rect2(0, 0, get_viewport_rect().size.x, -270)

func _physics_process(delta: float) -> void:
	position.x += direction * (speed + get_parent().target.get_parent().linear_velocity.x) * delta
	#LinearXInterpolation(targetXPosition, speed, delta)

func LinearXInterpolation(targetPos : float, velocity : float, physicsDelta : float) -> void:
	currentState = states.Moving
	position.x += direction * velocity * physicsDelta
	if initialXPosition > targetPos:
		position.x = targetPos
		currentState = states.Idle


func _on_VisibilityNotifier2D_screen_exited() -> void:
	var value : int = currentSpace * (get_viewport_rect().size.y/4)
	if !get_parent().openSpaces.has(value):
		get_parent().openSpaces.insert(currentSpace, value)
		get_parent().activeWindsCurrents -= 1
		call_deferred("queue_free")
