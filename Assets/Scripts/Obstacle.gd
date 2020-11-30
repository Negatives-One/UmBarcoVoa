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

func GetSkin() -> int:
	return 1;

func SetSkin(skin : int) -> void:
	pass


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
