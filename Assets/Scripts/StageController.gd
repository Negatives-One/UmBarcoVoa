extends Node2D

class_name StageController

enum Locations {Fortaleza, Caucaia, Sobral, BaixaDaEgua, Messejana}
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

func _ready() -> void:
	ChangeEvent(initialEvent)
	$SunPlayer.play("AnimacaoSol")
	var predios : Array = $Predios.get_children()
	for i in range(len(predios)):
		var textureHeight : int = predios[i].texture.get_height()
		predios[i].global_position.y = MinHeight - float(textureHeight)/2
	var _error : int = timer.connect("timeout", self, "_on_timer_timeout") 
	add_child(timer)
	timer.autostart = true
	timer.wait_time = rand_range(minTimeToChangeEvent, maxTimeToChangeEvent)
	timer.start()

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		OS.window_fullscreen = !OS.window_fullscreen

func _physics_process(_delta: float) -> void:
	if $RigidBody2D.global_position.x >= distancePerRegion:
		if canChange:
			canChange = false
			$ScenePlayer.play("FadeIn")
			counting = false
	$CanvasLayer/Panel/BarcoState.text = str($CorrentesDeVento.activeWindsCurrents)#str(get_viewport_rect().size)#"State: " + str($RigidBody2D.currentState)
	$CanvasLayer/Panel/BarcoVelocity.text = "Velocity: " + str(int($RigidBody2D.linear_velocity.x))
	$CanvasLayer/Panel/Location.text = "Location: " + GetStringLocation()
	if counting:
		$CanvasLayer/Panel/Distance.text = "Distance: " + str(int($RigidBody2D.global_position.x + totalDistance + 100))
	$CanvasLayer/Panel/BoostState.text = str($RigidBody2D.boostState)
	$CanvasLayer/Panel/FPS.text = "FPS: " + str(Performance.get_monitor(Performance.TIME_FPS))
	$Sol.global_position = Vector2($RigidBody2D/Camera2D2.global_position.x + 720, -850)
	if Input.is_action_just_pressed("ui_down"):
		$RigidBody2D.sleeping = true

func ChangeEvent(event : int) -> void:
	previousEvent = currentEvent
	currentEvent = event
	if currentEvent == events.FreeStyle:
		$StageSpawner.Enable()
		$CorrentesDeVento.Disable()
	elif currentEvent == events.WindCurrent:
		$StageSpawner.Disable()
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

func PrepareToChangeLocation() -> void:
	currentLocation += 1
	#$RigidBody2D.currentState = $RigidBody2D.States.Acelerando
	preservedLinearVelocity = $RigidBody2D.linear_velocity
	preservedYPosition = $RigidBody2D.global_position.y
	$RigidBody2D.sleeping = true
	$RigidBody2D.receivingInputs = false

func _on_Location_resized():
	$CanvasLayer/Panel/ColorRect2.rect_size.x = $CanvasLayer/Panel/Location.rect_size.x

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
		Locations.Caucaia:
			return "Caucaia"
		Locations.Sobral:
			return "Sobral"
		Locations.BaixaDaEgua:
			return "Baixa da Égua"
		Locations.Messejana:
			return "Messejana"
	return "?"

func NameTransitionLabel() -> void:
	$CanvasLayer/ColorRect/Label.text = GetStringLocation()
