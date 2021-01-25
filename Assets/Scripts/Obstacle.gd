extends Area2D

class_name Obstacle

export(Array) var images : Array = []
export(Array) var sizes : Array = [1.0, 1.5, 2.0]
export(Array) var slow : Array = [0.25, 0.50, 0.75]

enum Size {Pequeno = 0, Medio, Grande}
export(Size) var currentSize : int

var baseSlowScale : float = 0.25
var baseSizeScale : float = 1.50

var player : Player

var index : int = 0

func _ready() -> void:
	$Position2D.position = Vector2(500, 1080)#global_position = Vector2(global_position.x - 300, 0)
	var collisionShape : CollisionShape2D = CollisionShape2D.new()
	var shape : RectangleShape2D = RectangleShape2D.new()
	add_child(collisionShape)
	$CollisionShape2D.call_deferred("queue_free")
	SelectAnimation(collisionShape, shape)
	collisionShape.shape = shape

func SelectAnimation(collisionShape : CollisionShape2D, shape : RectangleShape2D) -> void:
	$AnimatedSprite.scale = Vector2(0.8, 0.8)
	if currentSize == Size.Pequeno:
		shape.extents = Vector2(64, 64)/2
		collisionShape.position = Vector2(0, -3.5)
		$AnimatedSprite.play("pipa")
		$Line2D.visible = true
	elif currentSize == Size.Medio:
		randomize()
		if randi() % 2:
			shape.extents = Vector2(96, 96)/2
			collisionShape.position = Vector2(12, -8)
			$AnimatedSprite.play("coruja")
		else:
			shape.extents = Vector2(96, 96)/2
			collisionShape.position = Vector2(16, -20)
			$AnimatedSprite.play("pombo")
	elif currentSize == Size.Grande:
		shape.extents = Vector2(144, 144)/2
		collisionShape.position = Vector2(0, -12)
		$AnimatedSprite.play("urubu")

func _on_Area2D_body_entered(body) -> void:
	if body is Player:
		player = body
		player.physicsState.apply_central_impulse(NerfVelocity())
		var camera : MyCamera = player.camera
		player.Batida()
		camera.shake(1, (currentSize+1)*10, (currentSize+1)*10)
		call_deferred("queue_free")

func NerfVelocity() -> Vector2:
	#var velocityNerf : Vector2 = Vector2(player.linear_velocity.x - (player.linear_velocity.x * baseSlowScale * currentSize), player.linear_velocity.y - (player.linear_velocity.y * baseSlowScale * currentSize))
	var velocityNerf : Vector2 = Vector2(player.physicsState.linear_velocity.x * slow[currentSize], player.physicsState.linear_velocity.y * slow[currentSize])
	return -velocityNerf

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
