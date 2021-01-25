extends RigidBody2D

class_name Player

var receivingInputs : bool = true
var acelerando : bool = true
 
export(float) var VerticalAcelleration : float = 10
export(float) var HorizontalAcelleration : float = 10
export(float, 0, 9999) var MaxSpeed : float = 300

export(int) var windLoopVelocity : int = 1100

var acelleration : Vector2 = Vector2.ZERO

var target : Vector2

# warning-ignore:unused_class_variable
onready var sfxBoost : AudioStreamPlayer = $SFX/VentoEmpurrao

var tempoAudio : float = 0

export(float, 0.0, 0.5, 0.01) var cameraPositionRatio : float = 0.38

var physicsState : Physics2DDirectBodyState

var camera : MyCamera

export(float, 0, 360) var minAngle : float = 10
export(float, 0, 360) var maxAngle : float = 350

var lose : bool = false

func _init() -> void:
	linear_velocity.x = 300

func _ready() -> void:
	target = Vector2(global_position.x+1, -get_viewport_rect().size.y/2)
	acelleration = (target - global_position).normalized()
	acelleration.x *= HorizontalAcelleration
	acelleration.y *= VerticalAcelleration
	VentoLoop()
	camera = $Camera2D2
	var tam = get_viewport_rect().size
	$Camera2D2.position.x = tam.x * cameraPositionRatio

func _integrate_forces(state : Physics2DDirectBodyState):
	physicsState = state
	FSM()
	linear_velocity = linear_velocity.normalized() * linear_velocity.length()
	linear_velocity = linear_velocity.clamped(MaxSpeed)
	if !lose:
		set_applied_force(acelleration + state.total_gravity)

func _physics_process(_delta: float) -> void:
	if !lose:
		if global_position.y < -1080 + 240:
			physicsState.linear_velocity.y = 10
		elif global_position.y > -40:
			physicsState.linear_velocity.y = -10

func _unhandled_input(event : InputEvent) -> void:
	if receivingInputs:
		if event is InputEventMouseButton:
			if event.pressed and event.button_index == BUTTON_LEFT:
				acelerando = true
			if event.pressed and event.button_index == BUTTON_RIGHT:
				apply_central_impulse(Vector2(-1, 0) * 5000)

func _process(_delta : float) -> void:
	var coeficienteDaVela : float = float(windLoopVelocity) / 3
	if linear_velocity.x / coeficienteDaVela <= 1:
		$Jangada/AnimatedSprite.frame = 0
	elif linear_velocity.x / coeficienteDaVela <= 2:
		$Jangada/AnimatedSprite.frame = 1
	elif linear_velocity.x / coeficienteDaVela > 2:
		$Jangada/AnimatedSprite.frame = 2
	VentoLoop()
	RuidoBarco()
	if !lose:
		$Tween.interpolate_property($Jangada, "rotation", $Jangada.rotation, linear_velocity.normalized().angle(), 0.05,Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
		$Tween.interpolate_property($CollisionPolygon2D, "rotation", $CollisionPolygon2D.rotation, linear_velocity.normalized().angle(), 0.05, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
	else:
#		$Tween.interpolate_property($Jangada, "rotation", $Jangada.rotation, 0, 2,Tween.TRANS_LINEAR, Tween.EASE_IN)
#		$Tween.start()
		self.sleeping = true
	#	$Jangada.rotation = linear_velocity.normalized().angle()
#	$CollisionPolygon2D.rotation = linear_velocity.normalized().angle()
	if(linear_velocity.x < 100) and !lose:
		lose = true
		Lose()

func Lose() -> void:
	$"..".ChangeEvent($"..".events.Nothing)
	MusicController.LoseSound()
	$CollisionPolygon2D.disabled = true
	$"../HUD/Panel/TryAgain".visible = true
	$"../HUD/Panel/PauseTextureButton".visible = false
	var score : String = $"../HUD/Panel/InformationTextureRect/DistanceLabel".text
	score.erase(score.length() - 3, 3)
	if int(GameManager.readData("highScore", 0)) < int(score):
		GameManager.saveData({"highScore" : score})
		$"../HUD/Panel/TryAgain/RecordLabel".text = "Novo Record: " + str(GameManager.readData("highScore", 0)) + " KM"
	else:
		$"../HUD/Panel/TryAgain/RecordLabel".text = "Não foi dessa vez, Seu Record é: " + str(GameManager.readData("highScore", 0)) + " KM"
	GameManager.onlySaveData(true)
	receivingInputs = false
	self.sleeping = true
	#linear_velocity = Vector2.ZERO
	#self.sleeping = true
	$Tween.interpolate_property(self, "global_position", self.global_position, Vector2(global_position.x, -40), 3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()
	$Tween.interpolate_property($Jangada, "rotation", $Jangada.rotation, 0.9, 2.2, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.start()
	yield(get_tree().create_timer(2.3), "timeout")
	$Tween.interpolate_property($Jangada, "rotation", $Jangada.rotation, 0, 0.7, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func FSM() -> void:
	if acelerando:
		linear_damp = -1
		target = get_global_mouse_position()
#		var verticalDiference : float = (get_viewport_rect().size.y * 1.2) - get_viewport_rect().size.y
#		target.y = Map(target.y, 0, -get_viewport_rect().size.y, verticalDiference, -get_viewport_rect().size.y)
		target = Vector2($Camera2D2.global_position.x - 400, target.y)
		acelleration = (target - global_position).normalized()
		acelleration.x *= HorizontalAcelleration
		acelleration.y *= VerticalAcelleration
	else:
		acelleration = Vector2.ZERO
		linear_damp = -1

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
	$SFX/VentoLoop.volume_db = linear2db(abs(volumePercentageWind))

func RuidoBarco() -> void:
	if is_angle_between(minAngle, rad2deg(linear_velocity.normalized().angle()), maxAngle):
		if $SFX/BarcoRuido.playing:
			$SFX/BarcoRuido.stop()
			tempoAudio = $SFX/BarcoRuido.get_playback_position()
	else:
		if !$SFX/BarcoRuido.playing:
			$SFX/BarcoRuido.play(tempoAudio)

func is_angle_between(alpha : float, theta : float, beta : float) -> bool:
	while(abs(beta - alpha) > 180):
		if(beta > alpha):
			alpha += 360
		else:
			beta += 360
	if(alpha > beta):
		var phi : float = alpha;
		alpha = beta
		beta = phi
# warning-ignore:narrowing_conversion
	var threeSixtyMultiple : int = (beta - theta) / 360
	theta += 360 * threeSixtyMultiple
	return (alpha < theta) && (theta < beta)
