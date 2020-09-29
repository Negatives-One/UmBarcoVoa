extends RigidBody2D

class_name Player

export(float) var VerticalAcelleration : float = 10
export(float) var HorizontalAcelleration : float = 10
export(float, 0, 9999) var MaxSpeed : float = 300

enum States {Parado, Acelerando, Desacelerando}
enum BoostStates {Usando, Acabou, Estavel}

var boostState : int = BoostStates.Estavel

var velocity : Vector2
var acelleration : Vector2

var currentState : int
var target : Vector2

func _ready() -> void:
	currentState = States.Parado

func _integrate_forces(state : Physics2DDirectBodyState):
	pass

func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			currentState = States.Acelerando
		elif event.is_action_released("LClick"):
			currentState = States.Desacelerando
		else:
			pass

func _physics_process(delta : float) -> void:
	applied_force = Vector2.ZERO
	FSM()
	linear_velocity = linear_velocity.normalized() * linear_velocity.length()
	if boostState == BoostStates.Usando:
		pass
	elif boostState == BoostStates.Acabou:
		linear_damp = 1.5
		if linear_velocity.length() <= linear_velocity.clamped(MaxSpeed).length():
			boostState = BoostStates.Estavel
			linear_damp = -1
	else:
		linear_velocity = linear_velocity.clamped(MaxSpeed)
		

func _process(delta : float) -> void:
	$barco.rotation = linear_velocity.normalized().angle()
	if(linear_velocity.x > 0):
		$barco.flip_v = false
	elif(linear_velocity.x < 0):
		$barco.flip_v = true
	else:
		pass

func FSM() -> void:
	
	if(currentState == States.Acelerando):
		linear_damp = -1
		target = get_global_mouse_position()
		add_central_force((target - global_position).normalized() * HorizontalAcelleration)
	
	elif(currentState == States.Desacelerando):
		linear_damp = 1.5
		if linear_velocity.length() < 10:
			linear_velocity = linear_velocity.normalized() / 10
			currentState = States.Parado
			linear_damp = -1
	
	else:
		pass
