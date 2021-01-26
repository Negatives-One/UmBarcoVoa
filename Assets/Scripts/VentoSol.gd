extends Area2D

var dir : Vector2

var speed : float

func _ready() -> void:
	$AnimatedSprite.rotation = (dir * speed).angle()

func _physics_process(delta: float) -> void:
	global_position += (dir * speed) * delta


func _on_Area2D_body_entered(body: Node) -> void:
	if body is Player:
		var player : Player = body
		var velocityNerf : Vector2 = Vector2(player.physicsState.linear_velocity.x * 0.5, player.physicsState.linear_velocity.y * 0.5)
		player.physicsState.apply_central_impulse(-velocityNerf)
		var camera : MyCamera = player.camera
		camera.shake(1, (2)*10, (2)*10)
		player.VentoEmpurrao()
		call_deferred("queue_free")
