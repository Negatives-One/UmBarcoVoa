extends Node2D

class_name Vento

var player : Player

export(float) var PotenciaForte : float = 2.0
export(float) var DuracaoForte : float = 4.0
export(float) var PotenciaFraco : float = 1.0
export(float) var DuracaoFraco : float = 2.0

var isStrong : bool

var direction : Vector2
var magnitude : float
var duration : float

var angle : float = 0
var ray : float = 100

func start():
	var rand = int(rand_range(0, 2))
	if rand == 0:
		isStrong = false
	else:
		isStrong = true
	self.global_position = Vector2(0, 0)
	var posBaseInAngle : Vector2
	posBaseInAngle.x = ray * cos(angle)
	posBaseInAngle.y = ray * sin(angle)
	direction = (Vector2(0, 0) - posBaseInAngle).normalized()
	if isStrong:
		magnitude = PotenciaForte
		duration = DuracaoForte
	else:
		magnitude = PotenciaFraco
		duration = DuracaoFraco
	$Timer.wait_time = duration
	$Timer.start()
	set_physics_process(true)

func _physics_process(delta):
	player.AddForce(direction * magnitude)

func _on_Timer_timeout():
	set_physics_process(true)
