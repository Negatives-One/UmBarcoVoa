extends Area2D

class_name Obstacle

var Type : Array = ["Birds", "Kite"]

enum Size {Pequeno = 1, Medio, Grande}

export var currentType : String = Type[0]

export(Size) var currentSize : int = Size.Pequeno

var textureSize : Vector2 = Vector2.ZERO

var baseSlowScale : float = 0.25

var baseSizeScale : float = 1.50

var velocityNerf : Vector2 = Vector2.ZERO 

var player : Player


func _ready() -> void:
	set_physics_process(false)
	if currentSize != Size.Pequeno:
		$Sprite.scale = $Sprite.scale * (currentSize - 1)
		textureSize = Vector2($Sprite.texture.get_width() * $Sprite.scale.x, $Sprite.texture.get_height() * $Sprite.scale.y)
	else:
		textureSize = Vector2($Sprite.texture.get_width(), $Sprite.texture.get_height())
	$CollisionShape2D.shape.extents = Vector2(textureSize.x/2, textureSize.y/2)

func _physics_process(delta):
	NerfVelocity()
	set_physics_process(false)

func _on_Area2D_body_entered(body) -> void:
	if body.is_in_group("Player"):
		print(body)
		player = body
		set_physics_process(true)

func _on_Area2D_body_exited(body) -> void:
	if body.is_in_group("Player"):
		pass

func NerfVelocity() -> void:
	var velocityNerf : Vector2 = Vector2(player.linear_velocity.x - (player.linear_velocity.x * baseSlowScale * currentSize), player.linear_velocity.y - (player.linear_velocity.y * baseSlowScale * currentSize))
	player.apply_central_impulse(-velocityNerf)
