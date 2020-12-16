extends Node2D

class_name WindCurrents

export(NodePath) var targetPath : NodePath
var target : Node

export(NodePath) var animationWarningPath : NodePath
var animationPlayer : AnimationPlayer

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

var alertRotation : int = 0

#instantiating vars
var dirCurrent : Array = [0, 0, 0]
var selectedSpace : Array = [0, 0, 0]

func _ready() -> void:
	for i in $Warnings.get_children():
		i.self_modulate = Color(1, 0, 0, 0)
	screenDivisionValue = screenSize.y / screenDivisions
	for i in range(screenDivisions):
		openSpaces.append((i) * screenDivisionValue)
	target = get_node(targetPath)
	animationPlayer = get_node(animationWarningPath)
	var _error : int = timer.connect("timeout", self, "_on_timer_timeout") 
	add_child(timer)
	timer.autostart = false
	timer.wait_time = timeBetweenSpawns

func _process(delta: float) -> void:
	global_position.x = target.global_position.x - screenSize.x/2

func Enable() -> void:
	timer.autostart = true
	timer.start()

func Disable() -> void:
	timer.autostart = false
	timer.stop()

func _on_timer_timeout():
	if activeWindsCurrents < 3:
		#PlayWarning()
		CreateCurrent()

func CreateCurrent() -> void:
	randomize()
	var warnings : Array = $Warnings.get_children()
	dirCurrent.append(pow(-1, randi() % 2))
	selectedSpace.append(randi() % openSpaces.size())
	print(warnings[activeWindsCurrents].name)
	if dirCurrent[activeWindsCurrents] == 1: 
		warnings[activeWindsCurrents].position = Vector2(screenSize.x * 0.05, -openSpaces[selectedSpace[activeWindsCurrents]] - screenDivisionValue/2)
	else:
		warnings[activeWindsCurrents].position = Vector2(screenSize.x * 0.95, -openSpaces[selectedSpace[activeWindsCurrents]] - screenDivisionValue/2)
	animationPlayer.play("alert" + str(activeWindsCurrents))
	activeWindsCurrents += 1

#func PlayWarning() -> void:
#	var direction : int = pow(-1, randi() % 2)
#	var selectedSpace : int = randi() % openSpaces.size()
#	if direction == 1:
#		newCurrent.global_position = Vector2(target.global_position.x - screenSize.x*1.5, -openSpaces[selectedSpace])
#	else:
#		newCurrent.position = Vector2(target.global_position.x + screenSize.x/2, -openSpaces[selectedSpace])


func _on_WarningsPlayer_animation_finished(_anim_name: String) -> void:
	var newCurrent : Current = current.instance()
	newCurrent.direction = dirCurrent.pop_front()
	newCurrent.currentSpace = selectedSpace.pop_front()
	newCurrent.isStrong = true
	if randi() % 2:
		newCurrent.isStrong = false
	call_deferred('add_child', newCurrent)
	if newCurrent.direction == 1:
		newCurrent.global_position = Vector2(position.x - screenSize.x, -openSpaces[newCurrent.currentSpace])
	else:
		newCurrent.global_position = Vector2(position.x + screenSize.x, -openSpaces[newCurrent.currentSpace])
	openSpaces.remove(newCurrent.currentSpace)
