extends Node2D

class_name StageController

enum Locations {Fortaleza, Paraiba, Pernambuco, Bahia}
export(Locations) var currentLocation : int = Locations.Fortaleza

enum events {Nothing, FreeStyle, WindCurrent}
export(events) var initialEvent : int = events.FreeStyle
var currentEvent : int = events.Nothing
var previousEvent : int = events.Nothing

var totalDistance : int = 0
export(int) var distancePerRegion : int = 50000

export(float) var MaxHeight = -1080
export(float) var MinHeight = 0

export(float) var minTimeToChangeEvent : float = 7
export(float) var maxTimeToChangeEvent : float = 10
var timer : Timer = Timer.new()

var counting : bool = true
var canChange : bool = true

var preservedLinearVelocity : Vector2
var preservedYPosition : float

var once : bool = true

func _ready() -> void:
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
			$ScenePlayer.play("FadeIn")
			if once:
				MusicController.ChangeMusic()
				once = false
			counting = false
	$HUD/Panel/BarcoState.text = str(get_viewport_rect().size)#"State: " + str($RigidBody2D.currentState)
	$HUD/Panel/BarcoVelocity.text = "Velocity: " + str(int($RigidBody2D.linear_velocity.x))
	$HUD/Panel/Location.text = "Location: " + GetStringLocation()
	if counting:
		$HUD/Panel/Distance.text = "Distance: " + str(int($RigidBody2D.global_position.x + totalDistance + 100))
	$HUD/Panel/BoostState.text = str($RigidBody2D.boostState)
	$HUD/Panel/FPS.text = "FPS: " + str(Performance.get_monitor(Performance.TIME_FPS))
	if Input.is_action_just_pressed("ui_down"):
		$RigidBody2D.sleeping = true

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

func NextLocation() -> void:
	$RigidBody2D.receivingInputs = true
	canChange = true
	counting = true
	totalDistance += distancePerRegion
	$RigidBody2D.global_position = Vector2(0, preservedYPosition)
	$RigidBody2D.linear_velocity = preservedLinearVelocity
	$StageSpawner.spawnPosition = Vector2.ZERO
	$StageSpawner.CapPos = 0
	once = true

func PrepareToChangeLocation() -> void:
	if currentLocation < Locations.Bahia:
		currentLocation += 1
	else:
		currentLocation = 0
	#$RigidBody2D.currentState = $RigidBody2D.States.Acelerando
	preservedLinearVelocity = $RigidBody2D.linear_velocity
	preservedYPosition = $RigidBody2D.global_position.y
	$RigidBody2D.sleeping = true
	$RigidBody2D.receivingInputs = false

func _on_Location_resized():
	$HUD/Panel/ColorRect2.rect_size.x = $HUD/Panel/Location.rect_size.x

func _on_timer_timeout():
	if currentEvent == events.FreeStyle:
		ChangeEvent(events.WindCurrent)
	elif currentEvent == events.WindCurrent:
		ChangeEvent(events.FreeStyle)


func _on_ScenePlayer_animation_finished(anim_name : String) -> void:
	if anim_name == "FadeIn":
		$ScenePlayer.play("ShowName")
	elif anim_name == "ShowName":
		$ScenePlayer.play("FadeOut")

func GetStringLocation() -> String:
	match currentLocation:
		Locations.Fortaleza:
			return "Fortaleza"
		Locations.Paraiba:
			return "Paraíba"
		Locations.Pernambuco:
			return "Pernambuco"
		Locations.Bahia:
			return "Bahia"
	return "?"

func NameTransitionLabel() -> void:
	$HUD/ColorRect/Label.text = GetStringLocation()
