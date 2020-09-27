extends KinematicBody2D

class_name Player

export(float) var Acelleration : float = 20
export(float) var MaxSpeed : float = 200
var _velocity : Vector2 = Vector2(0, 0)
var _acelleration : Vector2 = Vector2(0, 0)

var _target : Vector2
var _position : Vector2
enum States {Acelerando, Estavel, Desacelerando, Parado}
var currentState : int

func _ready() -> void:
	currentState = States.Parado
	pass

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			currentState = States.Acelerando
		elif event.is_action_released("LClick"):
			currentState = States.Desacelerando
		else:
			pass

func _physics_process(delta) -> void:
	print(_velocity, "/n", _acelleration)
	_target = get_viewport().get_mouse_position()
	_position = get_global_transform_with_canvas()
	
	if(_velocity.length() >= MaxSpeed):
		currentState = States.Estavel
	
	FSM()
	_velocity += _acelleration
	_velocity.clamped(MaxSpeed)
	_velocity = move_and_slide(_velocity, Vector2(0, -1), false, 4, 0.78598, false)

func FSM() -> void:
	if(currentState == States.Acelerando):
		AddForce(_target - global_position, Acelleration)
	elif(currentState == States.Estavel):
		pass
	elif(currentState == States.Desacelerando):
		_velocity = _velocity.linear_interpolate(Vector2.ZERO, Acelleration)
	else:
		pass

func AddForce(direction : Vector2, magnitude : float) -> void:
	_acelleration += direction.normalized() * magnitude
