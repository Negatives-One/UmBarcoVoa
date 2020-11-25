extends Node2D

export(NodePath) var WindsNode : NodePath

onready var screenSize : Vector2 = get_viewport_rect().size

export(float) var MaxHeight = -1080
export(float) var MinHeight = 0

var timer : Timer = Timer.new()

export(PackedScene) var wind : PackedScene = preload("res://Assets/Scenes/Vento.tscn")
export(float) var windSpawnDistance : float = 300
export(int) var windAmmount : int = 1
var spawnPosition : Vector2 = Vector2.ZERO
var CapPos : float = 0
var previousWind : Wind = Wind.new()
var repeatedDirection : int = 0
var windCount : int = 0

func _ready() -> void:
	print(screenSize)
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer)
	timer.autostart = true
	timer.wait_time = 0.1
	timer.start()

func _on_timer_timeout():
	if $"../RigidBody2D/Camera2D2".global_position.x + screenSize.x/2 + 100 > CapPos:
		for i in range(windAmmount):
			PlaceWinds()
		windCount += 1

func PlaceWinds() -> void:
	randomize()
	spawnPosition = Vector2(($"../RigidBody2D/Camera2D2".global_position.x + screenSize.x/2) + 100, rand_range(MaxHeight, MinHeight))
	if !CheckNear(spawnPosition):
		CreateWind(spawnPosition)
	else:
		print("opa")
		PlaceWinds()

func CreateWind(pos : Vector2) -> void:
	var newWind : Wind = wind.instance()
	get_node(WindsNode).call_deferred('add_child', newWind)
	newWind.index = windCount
	newWind.global_position = pos
	randomize()
	var randIndex : int = randi() % newWind.possibleAngles.size()
	newWind.SetDirection(deg2rad(newWind.possibleAngles[randIndex]))
	
	if is_instance_valid(newWind) and is_instance_valid(previousWind):
		if newWind.GetDirection() == previousWind.GetDirection():
			repeatedDirection += 1
		else:
			repeatedDirection = 0
		if repeatedDirection >= 3:
			randIndex += 1
			if randIndex >= newWind.possibleAngles.size():
				randIndex = 0
			newWind.SetDirection(deg2rad(newWind.possibleAngles[randIndex]))
	
	CapPos = pos.x + windSpawnDistance
	previousWind = newWind

func CheckNear(pos : Vector2) -> bool:
	var nearWind : Array = []
	for i in range(get_node(WindsNode).get_child_count()):
		if get_node(WindsNode).get_children()[i].index + 1 == windCount:
			nearWind.append(get_node(WindsNode).get_children()[i])
	for i in range(nearWind.size()):
		print(nearWind[i].global_position.distance_to(pos))
		if nearWind[i].global_position.distance_to(pos) < 300:
			return true
	return false