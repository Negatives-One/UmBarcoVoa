extends Node2D

class_name WindCurrents

export(NodePath) var targetPath : NodePath
var target : Node

export(NodePath) var playerPath : NodePath
var player : Player

var current : PackedScene = preload("res://Assets/Scenes/Current.tscn")

onready var screenSize : Vector2 = Vector2(get_viewport_rect().size.x, 1080-160)
export(int, 2, 999) var screenDivisions : float = 4.0
var screenDivisionValue : float

export(float) var timeBetweenSpawns : float = 3.0

export(float) var timeToCrossScreen : float = 4.0

export(float) var magnitudeStrong : float = 300.0
export(float) var durationStrong : float = 1.0
export(float) var magnitudeWeak : float = 150.0
export(float) var durationWeak : float = 1.0

var activeWindsCurrents : int = 0

var timer : Timer = Timer.new()

var openSpaces : Array = []

#instantiating vars
var dirCurrent : Array = [0, 0, 0]
var selectedSpace : Array = [0, 0, 0]

func _ready() -> void:
	screenDivisionValue = screenSize.y / screenDivisions
	for i in range(screenDivisions):
		openSpaces.append((i) * screenDivisionValue)
	target = get_node(targetPath)
	player = get_node(playerPath)
	var _error : int = timer.connect("timeout", self, "_on_timer_timeout") 
	add_child(timer)
	timer.autostart = false
	timer.wait_time = 1

func _physics_process(_delta: float) -> void:
	global_position.x = target.global_position.x - screenSize.x/2

func Enable() -> void:
	timer.autostart = true
	timer.start()

func Disable() -> void:
	timer.wait_time = 1
	timer.autostart = false
	timer.stop()

func _on_timer_timeout():
	timer.wait_time = timeBetweenSpawns
	if activeWindsCurrents > 1:
		return
	var quantity : int = 0
	if activeWindsCurrents == 0:
		quantity = randi() % 2 + 1
		for _i in range(quantity):
			CreateCurrent()
	elif activeWindsCurrents == 1:
		CreateCurrent()
#	openSpaces.clear()
#	for i in range(screenDivisions):
#		openSpaces.append((i) * screenDivisionValue)

func CreateCurrent() -> void:
	randomize()
	var warnings : Array = $Warnings.get_children()
	dirCurrent[int(warnings[activeWindsCurrents].name)] = pow(-1, randi() % 2)
	var randomSpace : int = randi() % openSpaces.size()
	selectedSpace[int(warnings[activeWindsCurrents].name)] = openSpaces[randomSpace]
	
	if dirCurrent[activeWindsCurrents] == 1: 
		warnings[activeWindsCurrents].position = Vector2(screenSize.x * 0.01, -openSpaces[randomSpace] - screenDivisionValue/2)
		warnings[activeWindsCurrents].scale.x = -0.6
	else:
		warnings[activeWindsCurrents].position = Vector2(screenSize.x * 0.99, -openSpaces[randomSpace] - screenDivisionValue/2)
		warnings[activeWindsCurrents].scale.x = 0.6
	$Warnings.get_node(str(activeWindsCurrents)).play()
	activeWindsCurrents += 1
	openSpaces.remove(randomSpace)

func SpawnCurrent(animNumber : int):
	var newCurrent : Current = current.instance()
	newCurrent.direction = dirCurrent[animNumber]#int(anim_name[anim_name.length()-1])]
	newCurrent.currentSpace = selectedSpace[animNumber]#int(anim_name[anim_name.length()-1])]
	newCurrent.currentController = self
	newCurrent.player = self.player
	newCurrent.isStrong = true
	self.call_deferred('add_child', newCurrent)
	if randi() % 2:
		newCurrent.isStrong = false
	#newCurrent.global_position = Vector2(global_position.x + (screenSize.x * -newCurrent.direction), -selectedSpace[animNumber])
	newCurrent.position = Vector2(screenSize.x * -newCurrent.direction, -selectedSpace[animNumber])
	$CurrentsTween.interpolate_property(newCurrent, "position", newCurrent.position, Vector2(screenSize.x * newCurrent.direction, newCurrent.position.y), timeToCrossScreen, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$CurrentsTween.start()

func _on_CurrentsTween_tween_completed(object: Object, _key: NodePath) -> void:
	var corrente : Current = object
	openSpaces.append(corrente.currentSpace)
	object.call_deferred("queue_free")
	activeWindsCurrents -= 1

func _on_0_animation_finished() -> void:
	SpawnCurrent(0)
	$Warnings.get_node("0").stop()
	$Warnings.get_node("0").frame = 0

func _on_1_animation_finished() -> void:
	SpawnCurrent(1)
	$Warnings.get_node("1").stop()
	$Warnings.get_node("1").frame = 0
