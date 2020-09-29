extends Area2D

class_name Vento2

var player : Player

export(float) var PotenciaForte : float = 100
export(float) var DuracaoForte : float = 4.0
export(float) var PotenciaFraco : float = 50
export(float) var DuracaoFraco : float = 2.0

var isStrong : bool
var isIn : bool = false

var direction : Vector2
var magnitude : float
var duration : float

var angle : float = 0

func _ready() -> void:
	randomize()
	set_physics_process(false)
	var rand = int(rand_range(0, 2))
	if rand == 0:
		isStrong = false
	else:
		isStrong = true
	randomize()
	direction = (Vector2(rand_range(-1, 1), rand_range(-1, 1))).normalized()
	angle = direction.angle()
	if isStrong:
		magnitude = PotenciaForte
		duration = DuracaoForte
	else:
		magnitude = PotenciaFraco
		duration = DuracaoFraco
	$Sprite.rotation = angle;
	if !isStrong:
		$Sprite.self_modulate = Color(1,1,1, 0.5)

func _physics_process(delta):
	player.add_central_force(direction * magnitude)


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		player.boostState = player.BoostStates.Usando
		set_physics_process(true)


func _on_Area2D_body_exited(body):
	if body.is_in_group("Player"):
		player.boostState = player.BoostStates.Acabou
		set_physics_process(false)
