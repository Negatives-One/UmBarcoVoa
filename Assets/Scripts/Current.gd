extends Area2D

class_name Current

# warning-ignore:unused_class_variable
var player : Player

var currentController

# warning-ignore:unused_class_variable
var currentSpace : int = 0

var direction : int = 0

var isStrong : bool = false

func _ready() -> void:
	$AnimatedSprite.scale.x = (get_viewport_rect().size.x / 2560) * direction
	$AnimatedSprite.scale.y = -(get_parent().screenDivisionValue / 360)
	$AnimatedSprite.position = Vector2((get_viewport_rect().size.x /2), -(((get_parent().screenDivisionValue / 360) * 360) / 2))
	gravity_vec = Vector2(direction, 0)
	gravity = currentController.magnitude
	$CollisionShape2D.shape.extents = Vector2(get_viewport_rect().size.x/2, 270/2)
	$CollisionShape2D.position.x = get_viewport_rect().size.x/2

func _on_Area2D_body_entered(body: Node) -> void:
	if body is Player:
		if !body.sfxBoost.playing:
			body.VentoEmpurrao()
