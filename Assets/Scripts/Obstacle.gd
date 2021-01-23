extends Area2D

class_name Obstacle

export(Array) var images : Array = []
export(Array) var sizes : Array = [1.0, 1.5, 2.0]
export(Array) var slow : Array = [0.25, 0.50, 0.75]

enum Size {Pequeno = 0, Medio, Grande}
export(Size) var currentSize : int

var textureSize : Vector2 = Vector2.ZERO
var baseSlowScale : float = 0.25
var baseSizeScale : float = 1.50

var player : Player

var index : int = 0

var possibleSkins : Array = [0]
var currentSkin

func _ready() -> void:
	$CollisionShape2D.call_deferred("queue_free")
	for i in range(3):
		var a : Resource = load("res://icon" + str(i) + ".png")
		images.append(a)
	$Sprite.texture = images[currentSize]
	textureSize = $Sprite.texture.get_size()
	var collisionShape : CollisionShape2D = CollisionShape2D.new()
	var shape : RectangleShape2D = RectangleShape2D.new()
	shape.extents = textureSize/2
	collisionShape.shape = shape
	add_child(collisionShape)
	
	$VisibilityNotifier2D.rect = Rect2(-($Sprite.texture.get_size().x/2), -($Sprite.texture.get_size().y/2), $Sprite.texture.get_size().x, $Sprite.texture.get_size().y)

func _on_Area2D_body_entered(body) -> void:
	if body is Player:
		player = body
		player.physicsState.apply_central_impulse(NerfVelocity())
		var camera : MyCamera = player.camera
		if $Sprite.visible:
			player.Batida()
		else:
			player.VentoEmpurrao()
		camera.shake(1, (currentSize+1)*10, (currentSize+1)*10)
		call_deferred("queue_free")

func NerfVelocity() -> Vector2:
	#var velocityNerf : Vector2 = Vector2(player.linear_velocity.x - (player.linear_velocity.x * baseSlowScale * currentSize), player.linear_velocity.y - (player.linear_velocity.y * baseSlowScale * currentSize))
	var velocityNerf : Vector2 = Vector2(player.physicsState.linear_velocity.x * slow[currentSize], player.physicsState.linear_velocity.y * slow[currentSize])
	return -velocityNerf

func GetSkin() -> int:
	return 1

func SetSkin(skin : String, rotation : float, scale : Vector2) -> void:
	$Sprite.visible = false
	$AnimatedSprite.frames = load(skin)
	$AnimatedSprite.rotation = rotation
	$AnimatedSprite.scale = scale


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
