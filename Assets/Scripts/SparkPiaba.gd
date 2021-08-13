extends AnimatedSprite

class_name Spark

var player

var yPos : float

var velocityY : float

var initialVelocity : float

export(float) var fadeTime = 0.5;

func _ready() -> void:
	play("default", false)
	initialVelocity = velocityY
	yPos = player.global_position.y
	global_position = Vector2(player.global_position.x - 140, yPos - 120)#yPos - 100)
	$Tween.interpolate_property(self, "velocityY", initialVelocity, 0, fadeTime, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _physics_process(delta: float) -> void:
	global_position.x = player.global_position.x - 140
	global_position.y += velocityY * delta

func _on_AnimatedSprite_animation_finished() -> void:
	self.queue_free()
