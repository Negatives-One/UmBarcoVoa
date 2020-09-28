extends KinematicBody2D

class_name Player

export(float) var Acelleration : float = 1
export(float, 0, 9999) var MaxSpeed : float = 100
var _velocity : Vector2 = Vector2(0, 0)
var _acelleration : Vector2 = Vector2(0, 0)

var _target : Vector2
var _position : Vector2
enum States {Acelerando, Desacelerando, Parado}
var currentState : int

func _ready() -> void:
	currentState = States.Parado
	pass

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			currentState = States.Acelerando
		elif event.is_action_released("LClick"):
			_target = global_position + _velocity
			currentState = States.Desacelerando
		else:
			pass
		if event.pressed and event.button_index == BUTTON_RIGHT:
			AddForce(Vector2(-100, 0))

func _physics_process(delta) -> void:
	
	FSM()
	_velocity += _acelleration
	_acelleration = Vector2.ZERO
	_velocity = _velocity.clamped(MaxSpeed)
	_velocity = move_and_slide(_velocity, Vector2(0, -1), false, 4, 0.78598, false)

func FSM() -> void:
	if(currentState == States.Acelerando):
		_target = get_global_mouse_position()
		AddForce(Vector2(_target.x - self.global_position.x, 0).normalized())
		AddForce(Vector2(0, _target.y - self.global_position.y).normalized())
	elif(currentState == States.Desacelerando):
		
		var coeficient : float = 0.01
		
		if(_velocity.length() < 7):
			coeficient = 1
		elif(_velocity.length() < MaxSpeed/4):
			coeficient = 0.04
		elif(_velocity.length() < MaxSpeed/2):
			coeficient = 0.02
			
		_velocity = _velocity.linear_interpolate(Vector2.ZERO, coeficient)
		if _velocity.length() == 0:
			currentState = States.Parado
	else:
		pass

func AddForce(direction : Vector2) -> void:
	_acelleration += direction
