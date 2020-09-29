extends Area2D

export(float) var slow : float = 20
var player : Player

func _ready():
	pass

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		player.apply_central_impulse(Vector2(-slow, 0))
