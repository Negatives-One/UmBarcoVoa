extends RigidBody2D

class_name Player
 
export(float) var VerticalAcelleration : float = 10
export(float) var HorizontalAcelleration : float = 10
export(float, 0, 9999) var MaxSpeed : float = 300

enum States {Parado, Acelerando, Desacelerando}
enum BoostStates {Usando, Acabou, Estavel}

var boostState : int = BoostStates.Estavel

var velocity : Vector2
var acelleration : Vector2 = Vector2.ZERO

var currentState : int
var target : Vector2

onready var Sprites = $Jangada.get_children()

export(float, 0.0, 0.5, 0.01) var cameraPositionRatio : float = 0.38

var physicsState : Physics2DDirectBodyState

var camera : MyCamera


func _ready() -> void:
	camera = $Camera2D2
	currentState = States.Parado
	var tam = get_viewport_rect().size
	$Camera2D2.position.x = tam.x * 0.38
	var a = $Camera2D2/icons.get_children()
	a[0].position = Vector2(tam.x/2, tam.y/2)
	a[1].position = Vector2(tam.x/2, -tam.y/2)
	a[2].position = Vector2(-tam.x/2, tam.y/2)
	a[3].position = Vector2(-tam.x/2, -tam.y/2)

func _integrate_forces(state : Physics2DDirectBodyState):
	physicsState = state
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
	set_applied_force(acelleration + state.total_gravity)

func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			currentState = States.Acelerando
		elif event.is_action_released("LClick"):
			currentState = States.Desacelerando
		else:
			pass
		if event.pressed and event.button_index == BUTTON_RIGHT:
			apply_central_impulse(Vector2(-1,0)*5000)

func _process(delta : float) -> void:
	$Jangada.rotation = linear_velocity.normalized().angle()
	$CollisionPolygon2D.rotation = linear_velocity.normalized().angle()
	if(linear_velocity.x > 0):
		$Jangada.scale.y = 0.5
		$CollisionPolygon2D.scale.y = 0.5
#		for i in range(len(Sprites)):
#			Sprites[i].flip_v = false
	elif(linear_velocity.x < 0):
		$Jangada.scale.y = -0.5
		$CollisionPolygon2D.scale.y = -0.5
#		for i in range(len(Sprites)):
#			Sprites[i].flip_v = true
	else:
		pass

func FSM() -> void:
	
	if(currentState == States.Acelerando):
		linear_damp = -1
		target = get_global_mouse_position()
		var verticalDiference : float = (get_viewport_rect().size.y * 1.2) - get_viewport_rect().size.y
		target.y = Map(target.y, 0, -get_viewport_rect().size.y, verticalDiference, -get_viewport_rect().size.y)
		target = Vector2($Camera2D2.global_position.x, target.y * 1.2)
		acelleration = (target - global_position).normalized() 
		acelleration.x *= HorizontalAcelleration
		acelleration.y *= VerticalAcelleration
		#add_central_force((target - global_position).normalized() * HorizontalAcelleration)
		
	elif(currentState == States.Desacelerando):
		acelleration = Vector2.ZERO
		linear_damp = 1.5
		if linear_velocity.length() < 10:
			linear_velocity = linear_velocity.normalized() / 10
			currentState = States.Parado
			linear_damp = -1
		
	else:
		pass

func ApplyImpulse(Impulse : Vector2):
	physicsState.apply_central_impulse(Impulse)

func Map(value : float, start1 : float, stop1 : float, start2 : float, stop2 : float) -> float:
	var outgoing : float = start2 + (stop2 - start2) * ((value - start1) / (stop1 - start1))
	return outgoing;
