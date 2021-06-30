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

# warning-ignore:unused_class_variable
export onready var MaxHeight : int = -ProjectSettings.get_setting("display/window/size/height")
# warning-ignore:unused_class_variable
export(float) var MinHeight : int = 0

export(float) var minTimeToChangeEvent : float = 7
export(float) var maxTimeToChangeEvent : float = 10
var timer : Timer = Timer.new()

var counting : bool = true
var canChange : bool = true

var preservedLinearVelocity : Vector2
var preservedYPosition : float

var once : bool = true

export(float) var bonusLength : float = 50000

signal bonusEntered(value)

var coletados : int = 0

func _ready() -> void:
	GameManager.StageControll = self
	MusicController.get_node("Current").stream = load("res://Assets/Sounds/CearaLoop.ogg")
	MusicController.get_node("Current").play()
	MusicController.fadeIn(MusicController.get_node("Current"), MusicController.get_node("TweenCurrent"))
	$StageSpawner.CapPos = $RigidBody2D/Camera2D2.global_position.x + get_viewport_rect().size.x/2 + 100
	$BonuStage.Visible(false)
	$ScenePlayer.play("StartAnim")
	MusicController.stageController = self
	#ChangeEvent(initialEvent)
	$SunPlayer.play("AnimacaoSolGame")
	var _error : int = timer.connect("timeout", self, "_on_timer_timeout") 
	add_child(timer)
	timer.autostart = true
	timer.wait_time = rand_range(minTimeToChangeEvent, maxTimeToChangeEvent)
	timer.start()

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		OS.window_fullscreen = !OS.window_fullscreen

func _process(_delta: float) -> void:
	#print($CorrentesDeVento.activeWindsCurrents)
	if $RigidBody2D.global_position.x >= distancePerRegion:
		if canChange:
			canChange = false
			# vai para o próximo estado
			if isBonusStage:
				$ScenePlayer.play("Transicao")
				$TransitionTween.interpolate_property(MusicController.ambienciaMar, "volume_db", 0, -80, MusicController.transitionDuration, MusicController.transitionTypeFadeOut, MusicController.easingTypeFadeOut)
				$TransitionTween.start()
				if currentLocation == Locations.Bahia:
					MusicController.ChangeMusic(Locations.Ceara)
				else:
					MusicController.ChangeMusic(currentLocation + 1)
				#RandomStart()
			else:
				$ScenePlayer.play("AnimacaoBonus")
				ChangeEvent(events.Nothing)
				$TransitionTween.interpolate_property(MusicController.ambienciaMar, "volume_db", -80, 0, MusicController.transitionDuration, MusicController.transitionTypeFadeOut, MusicController.easingTypeFadeOut)
				$TransitionTween.start()
				MusicController.fadeOut(MusicController.current, $TransitionTween)
				MusicController.fadeOut(MusicController.next, $TransitionTween)
				#$TransitionTween.interpolate_property(MusicController.current, "volume_db", 0, -80, MusicController.transitionDuration, MusicController.transitionTypeFadeOut, MusicController.easingTypeFadeOut)
				#$TransitionTween.interpolate_property(MusicController.next, "volume_db", 0, -80, MusicController.transitionDuration, MusicController.transitionTypeFadeOut, MusicController.easingTypeFadeOut)
				#MusicController.current.stop()
				#MusicController.next.stop()
			if once:
				if !isBonusStage:
					pass
				else:
					pass
				once = false
			counting = false
	$HUD/Panel/InformationTextureRect/LocationLabel.text = GetStringLocation()
	if counting:
# warning-ignore:integer_division
		$HUD/Panel/InformationTextureRect/DistanceLabel.text = str(int($RigidBody2D.global_position.x + totalDistance) / 1000 +1) + " KM"
	$HUD/Panel/FPS.text = "FPS: " + str(Performance.get_monitor(Performance.TIME_FPS))

func ChangeEvent(event : int) -> void:
	previousEvent = currentEvent
	currentEvent = event
	if currentEvent == events.FreeStyle:
		$StageSpawner.CapPos = $RigidBody2D/Camera2D2.global_position.x + get_viewport_rect().size.x/2 + 100
		$StageSpawner.Enable()
		#$Sol.Enable()
		$CorrentesDeVento.Disable()
	elif currentEvent == events.WindCurrent:
		$StageSpawner.Disable()
		#$Sol.Disable()
		$CorrentesDeVento.Enable()
	elif currentEvent == events.Nothing:
		$StageSpawner.Disable()
		#$Sol.Disable()
		$CorrentesDeVento.Disable()

func NextLocation() -> void:
	isBonusStage = false
	emit_signal("bonusEntered", false)
	$GeradorColetavel.Disable()
	#MusicController.get_node("AmbienciaMar").stop()
	
	$Sol.visible = true
	
	$Parallax/ParallaxBackground/BackgroundLayer/BG_01.visible = true
	$Parallax/ParallaxBackground/BackgroundLayer/BG_02.visible = true
	$Parallax/ParallaxBackground/BackgroundLayer/BG_03.visible = true
	$Parallax/ParallaxBackground/BackgroundLayer/BG_04.visible = true
	
	$Parallax/ParallaxBackground/BackgroundLayer/BGN_01.visible = false
	$Parallax/ParallaxBackground/BackgroundLayer/BGN_02.visible = false
	$Parallax/ParallaxBackground/BackgroundLayer/BGN_03.visible = false
	$Parallax/ParallaxBackground/BackgroundLayer/BGN_04.visible = false
	
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
	$CorrentesDeVento.activeWindsCurrents = 0
	once = true
	distancePerRegion = 100000

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
	ChangeEvent(events.Nothing)
	#MusicController.get_node("AmbienciaMar").play()
	#$TransitionTween.interpolate_property(MusicController.get_node("AmbienciaMar"), "volume_db", -80, 0, MusicController.transitionDuration , MusicController.transitionTypeFadeIn, MusicController.easingTypeFadeIn)
	#$TransitionTween.start()
	#MusicController.fadeIn(MusicController.get_node("AmbienciaMar"), MusicController.get_node("TweenNext"))
	for i in $CorrentesDeVento.get_children():
		if i is Current:
			i.call_deferred("queue_free")
	isBonusStage = true
	emit_signal("bonusEntered", true)
	$GeradorColetavel.Enable()
	
	$Sol.visible = false
	
	$Parallax/ParallaxBackground/BackgroundLayer/BG_01.visible = false
	$Parallax/ParallaxBackground/BackgroundLayer/BG_02.visible = false
	$Parallax/ParallaxBackground/BackgroundLayer/BG_03.visible = false
	$Parallax/ParallaxBackground/BackgroundLayer/BG_04.visible = false
	
	$Parallax/ParallaxBackground/BackgroundLayer/BGN_01.visible = true
	$Parallax/ParallaxBackground/BackgroundLayer/BGN_02.visible = true
	$Parallax/ParallaxBackground/BackgroundLayer/BGN_03.visible = true
	$Parallax/ParallaxBackground/BackgroundLayer/BGN_04.visible = true
	
	$Parallax/ParallaxBackground/BackLayer.visible = false
	$Parallax/ParallaxBackground/MidLayer.visible = false
	$Parallax/ParallaxBackground/FrontLayer.visible = false
	$BonuStage.Visible(true)
	$RigidBody2D.receivingInputs = true
	canChange = true
	counting = true
	#totalDistance += distancePerRegion
	#$RigidBody2D.global_position = Vector2(0, preservedYPosition)
	$RigidBody2D.linear_velocity = preservedLinearVelocity
	$StageSpawner.spawnPosition = Vector2.ZERO
	$StageSpawner.CapPos = 0
	$CorrentesDeVento.activeWindsCurrents = 0
	once = true
	distancePerRegion = 100000 + bonusLength

func _on_Location_resized():
	$HUD/Panel/ColorRect2.rect_size.x = $HUD/Panel/Location.rect_size.x

func _on_timer_timeout():
	if currentEvent == events.FreeStyle:
		timer.wait_time = 0.5
		timer.autostart = true
		timer.start()
		$StageSpawner.ended = true
		if $RigidBody2D.global_position.x > $StageSpawner.CapPos:
			ChangeEvent(events.WindCurrent)
			timer.autostart = true
			timer.wait_time = rand_range(minTimeToChangeEvent, maxTimeToChangeEvent)
			timer.start()
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

func _on_TransitionTween_tween_completed(object, _key):
	if object == MusicController.current and MusicController.current.volume_db < -79:
		MusicController.current.stop()
	if object == MusicController.next and MusicController.next.volume_db < -79:
		MusicController.next.stop()

func Collected() -> void:
	coletados += 1
	$"HUD/Panel/Panel2/Label".text = str(coletados)


func _on_Button_pressed() -> void:
	var a = $RigidBody2D.physicsState.get_transform() 
	a.origin = Vector2(97000, -500)
	$RigidBody2D.physicsState.set_transform(a)
	$"HUD/Panel/Button".queue_free()
