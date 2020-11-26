extends Area2D

class_name Obstacle

export(Array) var sizes : Array = [1.0, 1.5, 2.0]
export(Array) var slow : Array = [0.25, 0.50, 0.75]

enum Size {Pequeno = 0, Medio, Grande}
export(Size) var currentSize : int

var textureSize : Vector2 = Vector2.ZERO
var baseSlowScale : float = 0.25
var baseSizeScale : float = 1.50

var player : Player


func _ready() -> void:
	if currentSize != Size.Pequeno:
		$Sprite.scale = $Sprite.scale * sizes[currentSize]
		textureSize = Vector2($Sprite.texture.get_width() * $Sprite.scale.x, $Sprite.texture.get_height() * $Sprite.scale.y)
	else:
		textureSize = Vector2($Sprite.texture.get_width(), $Sprite.texture.get_height())
	$CollisionShape2D.shape.extents = Vector2(textureSize.x/2, textureSize.y/2)

func _on_Area2D_body_entered(body) -> void:
	if body.is_in_group("Player"):
		player = body
		player.physicsState.apply_central_impulse(NerfVelocity())

func _on_Area2D_body_exited(body) -> void:
	if body.is_in_group("Player"):
		pass

func NerfVelocity() -> Vector2:
	#var velocityNerf : Vector2 = Vector2(player.linear_velocity.x - (player.linear_velocity.x * baseSlowScale * currentSize), player.linear_velocity.y - (player.linear_velocity.y * baseSlowScale * currentSize))
	var velocityNerf : Vector2 = Vector2(player.physicsState.linear_velocity.x * slow[currentSize], player.physicsState.linear_velocity.y * slow[currentSize])
	return -velocityNerf
