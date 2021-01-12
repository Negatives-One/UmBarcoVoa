extends RigidBody2D

class_name Player

var receivingInputs : bool = true
 
export(float) var VerticalAcelleration : float = 10
export(float) var HorizontalAcelleration : float = 10
export(float, 0, 9999) var MaxSpeed : float = 300

enum States {Parado, Acelerando, Desacelerando}
enum BoostStates {Usando, Acabou, Estavel}

var boostState : int = BoostStates.Estavel

export(int) var windLoopVelocity : int = 1100
export(int, 0, 1) var windLoopVolume : int = 0.5

var velocity : Vector2
var acelleration : Vector2 = Vector2.ZERO

var currentState : int
var target : Vector2

onready var Sprites = $Jangada.get_children()

onready var sfxBoost : AudioStreamPlayer = $SFX/VentoEmpurrao

var prevCoef : float = 0

var tempoAudio : float = 0

export(float, 0.0, 0.5, 0.01) var cameraPositionRatio : float = 0.38

var physicsState : Physics2DDirectBodyState

var camera : MyCamera

var valoresCoef = []

var line : Line2D

var lineControle : Line2D

export(float, 0, 360) var minAngle : float = 10
export(float, 0, 360) var maxAngle : float = 350

func _ready() -> void:
	line = Line2D.new()
	add_child(line)
	line.add_point(Vector2(0, 0))
	line.add_point(Vector2(200 * cos(linear_velocity.normalized().angle()), 200 * sin(linear_velocity.normalized().angle())))
	
	lineControle = Line2D.new()
	add_child(lineControle)
	lineControle.add_point(Vector2(200 * cos(0.523599), 200 * sin(0.523599)))
	lineControle.add_point(Vector2(0, 0))
	lineControle.add_point(Vector2(200 * cos(5.75959), 200 * sin(5.75959)))
	VentoLoop()
	camera = $Camera2D2
	currentState = States.Parado
	var tam = get_viewport_rect().size
	$Camera2D2.position.x = tam.x * 0.38

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

func _physics_process(_delta: float) -> void:
	if global_position.y < -1040:
		physicsState.linear_velocity.y = 10
	elif global_position.y > -40:
		physicsState.linear_velocity.y = -10

func _unhandled_input(event : InputEvent) -> void:
	if receivingInputs:
		if event is InputEventMouseButton:
			if event.pressed and event.button_index == BUTTON_LEFT:
				currentState = States.Acelerando
			elif event.is_action_released("LClick"):
				currentState = States.Desacelerando
			else:
				pass
			if event.pressed and event.button_index == BUTTON_RIGHT:
				apply_central_impulse(Vector2(1,0)*5000)

func _process(_delta : float) -> void:
	VentoLoop()
	if is_angle_between(minAngle, rad2deg(linear_velocity.normalized().angle()), maxAngle):
		if $SFX/BarcoRuido.playing:
			$SFX/BarcoRuido.stop()
			tempoAudio = $SFX/BarcoRuido.get_playback_position()
	else:
		if !$SFX/BarcoRuido.playing:
			$SFX/BarcoRuido.play(tempoAudio)
		
#	#print(deg2rad(minAngle), " - ", linear_velocity.normalized().angle(), " - ", deg2rad(maxAngle))
#	#print(rad2deg(linear_velocity.normalized().angle()))
#	var coef = abs(abs(linear_velocity.normalized().angle()) - abs(target.normalized().angle()))
#	#var coef = abs(abs(linear_velocity.normalized().angle()) - abs((get_global_mouse_position() - global_position).normalized().angle()))
#	#print(coef)
#	var b = 0
#	var medCoef = 0
#	if valoresCoef.size() != 0:
#		for i in valoresCoef:
#			b += i
#		medCoef = b / valoresCoef.size()
#	if abs(prevCoef - medCoef) > 0.005:
#		#print(true)
#		if !$SFX/BarcoRuido.playing:
#			$SFX/BarcoRuido.play(tempoAudio)
#
#	else:
#		#print(false)
#		if $SFX/BarcoRuido.playing:
#			$SFX/BarcoRuido.stop()
#			tempoAudio = $SFX/BarcoRuido.get_playback_position()

#	#print(abs(prevCoef - medCoef))
#	prevCoef = medCoef
#	valoresCoef.append(coef)
#	if valoresCoef.size() > 60:
#		valoresCoef.remove(0)

#	if $Jangada.rotation != linear_velocity.normalized().angle():
#		if !$SFX/BarcoRuido.playing:
#			$SFX/BarcoRuido.play()
#	else:
#		$SFX/BarcoRuido.stop()
	$Tween.interpolate_property($Jangada, "rotation", $Jangada.rotation, linear_velocity.normalized().angle(), 0.05,Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	$Tween.interpolate_property($CollisionPolygon2D, "rotation", $CollisionPolygon2D.rotation, linear_velocity.normalized().angle(), 0.05, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
#	$Jangada.rotation = linear_velocity.normalized().angle()
#	$CollisionPolygon2D.rotation = linear_velocity.normalized().angle()
	if(linear_velocity.x < -0.1):
		var _error : int = get_tree().change_scene("res://Assets/Scenes/Menu.tscn")
	
	line.set_point_position(0, Vector2(0, 0))
	line.set_point_position(1, Vector2(200 * cos(target.normalized().angle()), 200 * sin(linear_velocity.normalized().angle())))
	
	lineControle.set_point_position(0, Vector2(200 * cos(deg2rad(minAngle)), 200 * sin(deg2rad(minAngle))))
	lineControle.set_point_position(1, Vector2(0, 0))
	lineControle.set_point_position(2, Vector2(200 * cos(deg2rad(maxAngle)), 200 * sin(deg2rad(maxAngle))))
	
	print(is_angle_between(minAngle, rad2deg(target.normalized().angle()), maxAngle))
	#print(IsBetweenAngles(maxAngle, minAngle, rad2deg(linear_velocity.normalized().angle())))

func FSM() -> void:
	
	if(currentState == States.Acelerando):
		linear_damp = -1
		target = get_global_mouse_position()
#		var verticalDiference : float = (get_viewport_rect().size.y * 1.2) - get_viewport_rect().size.y
#		target.y = Map(target.y, 0, -get_viewport_rect().size.y, verticalDiference, -get_viewport_rect().size.y)
		target = Vector2($Camera2D2.global_position.x - 400, target.y)
		acelleration = (target - global_position).normalized()
		acelleration.x *= HorizontalAcelleration
		acelleration.y *= VerticalAcelleration
		
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

func Batida() -> void:
	$SFX/Batida.play()

func VentoEmpurrao() -> void:
	$SFX/VentoEmpurrao.play()

func VentoLoop() -> void:
	$SFX/VentoLoop.autoplay = true
	var velocityX = linear_velocity.x
	if linear_velocity.x > windLoopVelocity:
		velocityX = windLoopVelocity
	var volumePercentageWind : float = velocityX / windLoopVelocity
	$SFX/VentoLoop.volume_db = linear2db(volumePercentageWind )

func IsBetweenAngles(start, end, mid) -> bool:
	if (end - start) < 0.0:
		end = end - start + 360.0
	else:
		end = end - start
	if (mid - start) < 0.0:
		mid = mid - start + 360.0
	else:
		mid = mid - start
	return (mid < end)

func is_angle_between(alpha : float, theta : float, beta : float):
	while( abs(beta - alpha) > 180 ):
		if(beta > alpha):
			alpha += 360;
		else:
			beta += 360;
	if(alpha > beta):
		var phi : float = alpha;
		alpha = beta;
		beta = phi;
	var threeSixtyMultiple : int = (beta - theta)/360;
	theta += 360 * threeSixtyMultiple;
	return (alpha < theta) && (theta < beta)

