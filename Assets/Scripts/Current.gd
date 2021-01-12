extends Area2D

class_name Current

var currentController

var player : Player

enum states {Idle, Moving}

var currentState : int = states.Idle

var currentSpace : int = 0

var direction : int = 0

var isStrong : bool = false

func _ready() -> void:
	gravity_vec = Vector2(direction, 0)
	if isStrong:
		gravity = currentController.magnitudeStrong
		$pixel.self_modulate = Color(1, 0, 0, 0.8)
	else:
		gravity = currentController.magnitudeWeak
		$pixel.self_modulate = Color(1, 0, 0, 0.4)
	$CollisionShape2D.shape.extents = Vector2(get_viewport_rect().size.x/2, 270/2)
	$CollisionShape2D.position.x = get_viewport_rect().size.x/2
	$pixel.scale.x = get_viewport_rect().size.x #d(Vector2(get_viewport_rect().size.x, 270))
	#$VisibilityNotifier2D.rect = Rect2(0, 0, get_viewport_rect().size.x, -270)

func _physics_process(_delta: float) -> void:
	pass
#	if direction == 1:
#		position.x += (direction * (speed + player.linear_velocity.x)) * delta
#	else:
#		position.x += (direction * (speed/2 + player.linear_velocity.x)) * delta
	#LinearXInterpolation(targetXPosition, speed, delta)

#func LinearXInterpolation(targetPos : float, velocity : float, physicsDelta : float) -> void:
#	currentState = states.Moving
#	position.x += direction * velocity * physicsDelta
#	if initialXPosition > targetPos:
#		position.x = targetPos
#		currentState = states.Idle


func _on_Area2D_body_entered(body: Node) -> void:
	if body is Player:
		if !body.sfxBoost.playing:
			body.VentoEmpurrao()
