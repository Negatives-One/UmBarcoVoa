extends Node2D

enum Locations {Fortaleza, Caucaia}
export(Locations) onready var currentLocation : int = Locations.Fortaleza

export(float) var MaxHeight = -540
export(float) var MinHeight = 540

var timer : Timer = Timer.new()
export(float) var windSpawnRatio : float = 100
var spawnPosition : Vector2 = Vector2.ZERO
var CapPos : float = 0

var wind : PackedScene = preload("res://Assets/Scenes/Vento.tscn")
var previousWind : Wind
var repeatedDirection : int = 0
#3350

func _ready() -> void:
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer)
	timer.autostart = true
	timer.wait_time = 0.1
	timer.start()
	$AnimationPlayer.play("AnimacaoSol")
	var predios : Array = $Predios.get_children()
	for i in range(len(predios)):
		var textureHeight : int = predios[i].texture.get_height()
		predios[i].global_position.y = 540
		predios[i].global_position.y -= textureHeight/2

func PlaceWinds() -> void:
	spawnPosition = Vector2(($RigidBody2D/Camera2D2.global_position.x + 1920/2) + 100, rand_range(MaxHeight, MinHeight))
	CreateWind(spawnPosition)

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		OS.window_fullscreen = !OS.window_fullscreen

func _process(delta : float) -> void:
	if $RigidBody2D.global_position.x >= 50000:
		NextLocation()
	$CanvasLayer/Panel/BarcoState.text = str($RigidBody2D.currentState)
	$CanvasLayer/Panel/BarcoVelocity.text = str(int($RigidBody2D.linear_velocity.length()))
	match currentLocation:
		Locations.Fortaleza:
			$CanvasLayer/Panel/Location.text = str("Fortaleza")
		Locations.Caucaia:
			$CanvasLayer/Panel/Location.text = str("Caucaia")
	$CanvasLayer/Panel/BoostState.text = str($RigidBody2D.boostState)
	$CanvasLayer/Panel/FPS.text = str(Performance.get_monitor(Performance.TIME_FPS))
	$Sol.global_position = Vector2($RigidBody2D/Camera2D2.global_position.x + 720, -350)

func _on_timer_timeout():
	if $RigidBody2D/Camera2D2.global_position.x + 1920/2 + 100 > CapPos:
		PlaceWinds()

func CreateWind(pos : Vector2) -> void:
	var newWind : Wind = wind.instance()
	$Ventos.call_deferred('add_child', newWind)
	newWind.global_position = pos
	randomize()
	newWind.SetDirection(deg2rad(newWind.possibleAngles[randi() % newWind.possibleAngles.size()]))
	CapPos = pos.x + windSpawnRatio
	previousWind = newWind

func NextLocation() -> void:
	currentLocation += 1
	$RigidBody2D.global_position = Vector2.ZERO
	spawnPosition = Vector2.ZERO
	CapPos = 0
