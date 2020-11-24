extends Area2D

class_name Wind

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

var possibleAngles : Array = [0, 45, 90, 135, 180, 225, 270, 315]

var angle : float = 0 setget SetDirection, GetDirection

func GetDirection() -> float:
	return angle

func _ready() -> void:
	randomize()
	set_physics_process(false)
	var rand = int(rand_range(0, 2))
	
	if rand == 0:
		isStrong = false
	else:
		isStrong = true
		
	if isStrong:
		magnitude = PotenciaForte
	else:
		magnitude = PotenciaFraco
	if !isStrong:
		$Sprite.self_modulate = Color(1,1,1, 0.5)

func _physics_process(delta):
	player.add_central_force(direction * magnitude)

func SetDirection(angulo : float) -> void:
	direction = Vector2(cos(angulo), sin(angulo))
	rotation = angulo

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		player.boostState = player.BoostStates.Usando
		set_physics_process(true)


func _on_Area2D_body_exited(body):
	if body.is_in_group("Player"):
		player.boostState = player.BoostStates.Acabou
		set_physics_process(false)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
