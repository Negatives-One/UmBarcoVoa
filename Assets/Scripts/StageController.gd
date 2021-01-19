extends Node2D

class_name StageController

enum Locations {Ceara, Pernambuco, Bahia}
export(Locations) var currentLocation : int = Locations.Ceara

var isBonusStage : bool = false

enum events {Nothing, FreeStyle, WindCurrent}
export(events) var initialEvent : int = events.FreeStyle
var currentEvent : int = events.Nothing
var previousEvent : int = events.Nothing

var totalDistance : int = 0
export(int) var distancePerRegion : int = 50000

export onready var MaxHeight : int = -ProjectSettings.get_setting("display/window/size/height")
export(float) var MinHeight : int = 0

export(float) var minTimeToChangeEvent : float = 7
export(float) var maxTimeToChangeEvent : float = 10
var timer : Timer = Timer.new()

var counting : bool = true
var canChange : bool = true

var preservedLinearVelocity : Vector2
var preservedYPosition : float

var once : bool = true

func _ready() -> void:
	$BonuStage.Visible(false)
	$ScenePlayer.play("StartAnim")
	MusicController.stageController = self
	ChangeEvent(initialEvent)
	$SunPlayer.play("AnimacaoSol")
	var _error : int = timer.connect("timeout", self, "_on_timer_timeout") 
	add_child(timer)
	timer.autostart = true
	timer.wait_time = rand_range(minTimeToChangeEvent, maxTimeToChangeEvent)
	timer.start()

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		OS.window_fullscreen = !OS.window_fullscreen

func _process(_delta: float) -> void:
	if $RigidBody2D.global_position.x >= distancePerRegion:
		if canChange:
			canChange = false
			# vai para o próximo estado
			if isBonusStage:
				$ScenePlayer.play("Transicao")
				if MusicController.ambienciaMar.playing:
					$TransitionTween.interpolate_property(MusicController.ambienciaMar, "volume_db", 0, -80, MusicController.transitionDuration, MusicController.transitionTypeFadeOut, MusicController.easingTypeFadeOut)
				if currentLocation == Locations.Bahia:
					MusicController.ChangeMusic(Locations.Ceara)
				else:
					MusicController.ChangeMusic(currentLocation + 1)
				#RandomStart()
			else:
				$ScenePlayer.play("AnimacaoBonus")
				ChangeEvent(events.Nothing)
				#MusicController.ambienciaMar.play()
				MusicController.fadeIn(MusicController.ambienciaMar, $TransitionTween)
				MusicController.fadeOut(MusicController.current, $TransitionTween)
				MusicController.fadeOut(MusicController.next, $TransitionTween)
				#$TransitionTween.interpolate_property(MusicController.current, "volume_db", 0, -80, MusicController.transitionDuration, MusicController.transitionTypeFadeOut, MusicController.easingTypeFadeOut)
				#$TransitionTween.interpolate_property(MusicController.next, "volume_db", 0, -80, MusicController.transitionDuration, MusicController.transitionTypeFadeOut, MusicController.easingTypeFadeOut)
				#MusicController.current.stop()
				#MusicController.next.stop()
				#print("Eis o problema")
			if once:
				if !isBonusStage:
					pass
				else:
					pass
				once = false
			counting = false
	$HUD/Panel/BarcoState.text = str(get_viewport_rect().size)#"State: " + str($RigidBody2D.currentState)
	$HUD/Panel/BarcoVelocity.text = "Velocity: " + str(int($RigidBody2D.linear_velocity.x))
	$HUD/Panel/Location.text = "Location: " + GetStringLocation()
	$HUD/Panel/InformationTextureRect/LocationLabel.text = GetStringLocation()
	if counting:
		$HUD/Panel/Distance.text = "Distance: " + str(int($RigidBody2D.global_position.x + totalDistance))
		$HUD/Panel/InformationTextureRect/DistanceLabel.text = str(int($RigidBody2D.global_position.x + totalDistance))
	$HUD/Panel/BoostState.text = str($RigidBody2D.boostState)
	$HUD/Panel/FPS.text = "FPS: " + str(Performance.get_monitor(Performance.TIME_FPS))


func ChangeEvent(event : int) -> void:
	previousEvent = currentEvent
	currentEvent = event
	if currentEvent == events.FreeStyle:
		$StageSpawner.Enable()
		$Sol.Enable()
		$CorrentesDeVento.Disable()
	elif currentEvent == events.WindCurrent:
		$StageSpawner.Disable()
		$Sol.Disable()
		$CorrentesDeVento.Enable()
	elif currentEvent == events.Nothing:
		$StageSpawner.Disable()
		$Sol.Disable()
		$CorrentesDeVento.Disable()

func NextLocation() -> void:
	isBonusStage = false
	$Parallax/ParallaxBackground/BackgroundLayer.visible = true
	$Parallax/ParallaxBackground/BackLayer.visible = true
	$Parallax/ParallaxBackground/MidLayer.visible = true
	$Parallax/ParallaxBackground/FrontLayer.visible = true
	$BonuStage.Visible(false)
	$RigidBody2D.receivingInputs = true
	canChange = true
	counting = true
	totalDistance += distancePerRegion
	$RigidBody2D.global_position = Vector2(0, preservedYPosition)
	$RigidBody2D.linear_velocity = preservedLinearVelocity
	$StageSpawner.spawnPosition = Vector2.ZERO
	$StageSpawner.CapPos = 0
	once = true
	distancePerRegion = 50000

func PrepareToChangeLocation() -> void:
	if isBonusStage == true:
		if currentLocation < Locations.Bahia:
			currentLocation += 1
		else:
			currentLocation = 0
	#$RigidBody2D.currentState = $RigidBody2D.States.Acelerando
	preservedLinearVelocity = $RigidBody2D.linear_velocity
	preservedYPosition = $RigidBody2D.global_position.y
	$RigidBody2D.receivingInputs = false

func ChangeToBonus() -> void:
	isBonusStage = true
	$Parallax/ParallaxBackground/BackgroundLayer.visible = false
	$Parallax/ParallaxBackground/BackLayer.visible = false
	$Parallax/ParallaxBackground/MidLayer.visible = false
	$Parallax/ParallaxBackground/FrontLayer.visible = false
	$BonuStage.Visible(true)
	$RigidBody2D.receivingInputs = true
	canChange = true
	counting = true
	totalDistance += distancePerRegion
	$RigidBody2D.global_position = Vector2(0, preservedYPosition)
	$RigidBody2D.linear_velocity = preservedLinearVelocity
	$StageSpawner.spawnPosition = Vector2.ZERO
	$StageSpawner.CapPos = 0
	once = true
	distancePerRegion = 25000

func _on_Location_resized():
	$HUD/Panel/ColorRect2.rect_size.x = $HUD/Panel/Location.rect_size.x

func _on_timer_timeout():
	if currentEvent == events.FreeStyle:
		ChangeEvent(events.WindCurrent)
	elif currentEvent == events.WindCurrent:
		ChangeEvent(events.FreeStyle)

func GetStringLocation() -> String:
	match currentLocation:
		Locations.Ceara:
			return "Ceará"
		Locations.Pernambuco:
			return "Pernambuco"
		Locations.Bahia:
			return "Bahia"
	return "?"

func NameTransitionLabel() -> void:
	$HUD/ColorRect/Label.text = GetStringLocation()

func RandomStart() -> void:
	randomize()
	ChangeEvent(randi() % 2 + 1)
	pass


func _on_ScenePlayer_animation_finished(anim_name: String) -> void:
	print(anim_name)


func _on_TransitionTween_tween_completed(object, _key):
	if object == MusicController.ambienciaMar and MusicController.ambienciaMar.volume_db < -79:
		MusicController.ambienciaMar.stop()
	if object == MusicController.current and MusicController.current.volume_db < -79:
		MusicController.current.stop()
	if object == MusicController.next and MusicController.next.volume_db < -79:
		MusicController.next.stop()
