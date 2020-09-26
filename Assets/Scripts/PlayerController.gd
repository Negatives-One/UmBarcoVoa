extends KinematicBody2D

class_name Player

export(float) var Acelleration : float = 20
export(float) var MaxSpeed : float = 200
var _velocity : Vector2 = Vector2(0, 0)
var _acelleration : Vector2 = Vector2(0, 0)

var _target : Vector2
var _moving : bool = false

func _ready() -> void:
	pass

func _unhandled_input(event):
	if(event == Input.is_action_just_pressed("LClick")):
		_moving = true
	elif(event == Input.is_action_just_released("LClick")):
		_moving = false

func _physics_process(delta) -> void:
	_target = get_global_mouse_position()
	_velocity = move_and_slide(_velocity, Vector2(0, -1), false, 4, 0.78598, false)
	pass

func AddForce(direction : Vector2, magnitude : float) -> void:
	_acelleration += direction.normalized() * magnitude
