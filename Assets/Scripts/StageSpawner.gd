extends Node2D

class_name StageSpawner

export(int, 1, 9999) var horizontalLines : float = 0
export(NodePath) var WindsNode : NodePath
export(NodePath) var ObstaclesNode : NodePath

onready var screenSize : Vector2 = Vector2(get_viewport_rect().size.x, 1080 - 220)

export onready var MaxHeight = $"..".MaxHeight
export(float) var MinHeight = 0

export(NodePath) var StageControllerPath : NodePath
onready var StageController : StageController = get_node(StageControllerPath)

var CapPos : float = 0
var spawnPosition : Vector2 = Vector2.ZERO

#region Wind
export(PackedScene) var wind : PackedScene = preload("res://Assets/Scenes/Vento.tscn")
export(float) var verticalLinesDistance : float = 500
export(int) var windAmmount : int = 1
var previousWindDirection : float = 0
var previousWindPlace : int = 0
var repeatedDirection : int = 0
var windCountIndex : int = 0
#endregion Wind

#region Obstacle
export(PackedScene) var obstacle : PackedScene = preload("res://Assets/Scenes/Obstacle.tscn")
export(float) var obstacleSpawnDistance : float = 100
export(int) var obstacleAmmount : int = 1
var obstacleCountIndex : int = 0
var previousObstacleSize : int = 10
var repeatedObstacleSize : int = 0
var repeatedSkin : int = 0
#endregion Obstacle

var openSpaces : Array = []

var ended : bool

func _ready() -> void:
	set_process(false)
	if obstacleAmmount + windAmmount > horizontalLines:
# warning-ignore:narrowing_conversion
		obstacleAmmount = horizontalLines/2
# warning-ignore:narrowing_conversion
		windAmmount = horizontalLines/2
	FillArray()

func FillArray() -> void:
	openSpaces.clear()
	for i in range(horizontalLines):
		openSpaces.append((screenSize.y / horizontalLines * (i + 1)) - 80)

func _process(_delta: float) -> void:
	if $"../RigidBody2D/Camera2D2".global_position.x + screenSize.x/2 < $"..".distancePerRegion - 1500:
		if !ended:
			CheckCollumnSpawner()

func CheckCollumnSpawner() -> void:
	if $"../RigidBody2D/Camera2D2".global_position.x + screenSize.x/2 + 100 > CapPos and $"../CorrentesDeVento".activeWindsCurrents == 0:
		for _i in range(windAmmount):
			PlaceWinds()
		windCountIndex += 1
		for _i in range(obstacleAmmount):
			PlaceObstacles()
		obstacleCountIndex += 1
	FillArray()
	CapPos = spawnPosition.x + verticalLinesDistance

func PlaceWinds() -> void:
	randomize()
	var selectedPos : int = randi() % openSpaces.size()
	while selectedPos == previousWindPlace:

		selectedPos = randi() % openSpaces.size()
	spawnPosition = Vector2(($"../RigidBody2D/Camera2D2".global_position.x + screenSize.x/2) + 100, -openSpaces[selectedPos])
	openSpaces.remove(selectedPos)
	CreateWind(spawnPosition)
	previousWindPlace = selectedPos

func CreateWind(pos : Vector2) -> void:
	var newWind : Wind = wind.instance()
	get_node(WindsNode).call_deferred('add_child', newWind)
	newWind.index = windCountIndex
	newWind.global_position = pos
	randomize()
	var randIndex : int = randi() % newWind.possibleAngles.size()
	var newWindDirection : float = deg2rad(newWind.possibleAngles[randIndex])
	newWind.SetDirection(newWindDirection)
	if newWindDirection == previousWindDirection:
		repeatedDirection += 1
	else:
		repeatedDirection = 0
	if repeatedDirection >= 3:
		randIndex += 1
		if randIndex >= newWind.possibleAngles.size():
			randIndex = 0
		newWind.SetDirection(deg2rad(newWind.possibleAngles[randIndex]))
			
	#CapPos = pos.x + verticalLinesDistance
	previousWindDirection = newWindDirection

func PlaceObstacles() -> void:
	if horizontalLines > 0:
		var selectedPos : int = randi() % openSpaces.size()
		spawnPosition = Vector2(($"../RigidBody2D/Camera2D2".global_position.x + screenSize.x/2) + 100, -openSpaces[selectedPos])
		openSpaces.remove(selectedPos)
		CreateObstacle(spawnPosition)
	else:
		pass

func CreateObstacle(pos : Vector2) -> void:
	var newObstacle : Obstacle = obstacle.instance()
	newObstacle.index = obstacleCountIndex
	newObstacle.global_position = pos
	var newObstacleSize : int = randi() % (newObstacle.Size.Grande+1)
	if newObstacleSize == previousObstacleSize:
		repeatedObstacleSize += 1
	else:
		repeatedObstacleSize = 0
	if repeatedObstacleSize >= 3:
		var sizes : Array = [0, 1, 2]
		sizes.erase(previousObstacleSize)
		newObstacleSize = randi() % (sizes.size()+1)
	newObstacle.currentSize = newObstacleSize
	randomize()
	######var randIndex : int = randi() % newObstacle.possibleSkins.size()
	
#	if is_instance_valid(newObstacle) and is_instance_valid(previousObstacleSize):
#		if newObstacle.GetSkin() == previousObstacleSize.GetSkin():
#			repeatedSkin += 1
#		else:
#			print("opa")
#			repeatedSkin = 0
#		if repeatedDirection >= 3:
#			randIndex += 1
#			if randIndex >= newObstacle.possibleSkins.size(): 
#				randIndex = 0
#			newObstacle.SetSkin(newObstacle.possibleSkins[randIndex])
			
	get_node(ObstaclesNode).call_deferred('add_child', newObstacle)
	previousObstacleSize = newObstacleSize


func Enable() -> void:
	ended = false
	set_process(true)

func Disable() -> void:
	set_process(false)
