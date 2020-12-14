extends Node2D

class_name WindCurrents

export(NodePath) var targetPath : NodePath
var target : Node

var current : PackedScene = preload("res://Assets/Scenes/Current.tscn")

onready var screenSize : Vector2 = get_viewport_rect().size
export(int, 2, 999) var screenDivisions : float = 4.0
var screenDivisionValue : float

export(float) var timeBetweenSpawns : float = 3.0

export(float) var magnitudeStrong : float = 300.0
export(float) var durationStrong : float = 1.0
export(float) var magnitudeWeak : float = 150.0
export(float) var durationWeak : float = 1.0

var activeWindsCurrents : int = 0

var timer : Timer = Timer.new()

var openSpaces : Array = []

func _ready() -> void:
	screenDivisionValue = screenSize.y / screenDivisions
	for i in range(screenDivisions):
		openSpaces.append((i) * screenDivisionValue)
	target = get_node(targetPath)
	var _error : int = timer.connect("timeout", self, "_on_timer_timeout") 
	add_child(timer)
	timer.autostart = false
	timer.wait_time = timeBetweenSpawns

func _physics_process(delta: float) -> void:
	global_position.x = target.global_position.x - screenSize.x/2

func Enable() -> void:
	timer.autostart = true
	timer.start()

func Disable() -> void:
	timer.autostart = false
	timer.stop()

func _on_timer_timeout():
	#for i in range(2):
	if activeWindsCurrents < screenDivisions:
		CreateCurrent()

func CreateCurrent() -> void:
	var newCurrent : Current = current.instance()
	var possibleDirections : Array = [1, -1]
	newCurrent.direction = possibleDirections[randi() % possibleDirections.size()]
	call_deferred('add_child', newCurrent)
	var selectedSpace : int = randi() % openSpaces.size()
	if newCurrent.direction == 1:
		newCurrent.position = Vector2(-screenSize.x, -openSpaces[selectedSpace])
	else:
		newCurrent.position = Vector2(screenSize.x, -openSpaces[selectedSpace])
	openSpaces.remove(selectedSpace)
	newCurrent.currentSpace = selectedSpace
	activeWindsCurrents += 1
