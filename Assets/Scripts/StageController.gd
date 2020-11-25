extends Node2D

enum Locations {Fortaleza, Caucaia, Sobral, BaixaDaEgua, Messejana}
export(Locations) onready var currentLocation : int = Locations.Fortaleza

var totalDistance : int = 0
export(int) var distancePerRegion : int = 50000

export(float) var MaxHeight = -1080
export(float) var MinHeight = 0

export(PackedScene) var obstacle : PackedScene = preload("res://Assets/Scenes/Obstacle.tscn")
export(float) var obstacleSpawnDistance : float = 100
export(int) var obstacleAmmount : int = 1

func _ready() -> void:
	$AnimationPlayer.play("AnimacaoSol")
	var predios : Array = $Predios.get_children()
	for i in range(len(predios)):
		var textureHeight : int = predios[i].texture.get_height()
		predios[i].global_position.y = MinHeight - float(textureHeight)/2

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		OS.window_fullscreen = !OS.window_fullscreen

func _process(_delta : float) -> void:
	if $RigidBody2D.global_position.x >= distancePerRegion:
		NextLocation()
	$CanvasLayer/Panel/BarcoState.text = str(get_viewport_rect().size)#"State: " + str($RigidBody2D.currentState)
	$CanvasLayer/Panel/BarcoVelocity.text = "Velocity: " + str(int($RigidBody2D.linear_velocity.length()))
	match currentLocation:
		Locations.Fortaleza:
			$CanvasLayer/Panel/Location.text = "Location: " + str("Fortaleza")
		Locations.Caucaia:
			$CanvasLayer/Panel/Location.text = "Location: " + str("Caucaia")
		Locations.Sobral:
			$CanvasLayer/Panel/Location.text = "Location: " + str("Sobral")
		Locations.BaixaDaEgua:
			$CanvasLayer/Panel/Location.text = "Location: " + str("Baixa da Égua")
		Locations.Messejana:
			$CanvasLayer/Panel/Location.text = "Location: " + str("Messejana")
	$CanvasLayer/Panel/Distance.text = "Distance: " + str(int($RigidBody2D.global_position.x + totalDistance))
	$CanvasLayer/Panel/BoostState.text = str($RigidBody2D.boostState)
	$CanvasLayer/Panel/FPS.text = "FPS: " + str(Performance.get_monitor(Performance.TIME_FPS))
	$Sol.global_position = Vector2($RigidBody2D/Camera2D2.global_position.x + 720, -850)



func NextLocation() -> void:
	currentLocation += 1
	totalDistance += distancePerRegion
	$RigidBody2D.global_position = Vector2.ZERO
	$WindPlacement.spawnPosition = Vector2.ZERO
	$WindPlacement.CapPos = 0

func _on_Location_resized():
	$CanvasLayer/Panel/ColorRect2.rect_size.x = $CanvasLayer/Panel/Location.rect_size.x
