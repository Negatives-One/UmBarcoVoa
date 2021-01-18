extends Node2D

class_name WindCurrents

export(NodePath) var targetPath : NodePath
var target : Node

var animationPlayer : String = "WarningsPlayer"

export(NodePath) var playerPath : NodePath
var player : Player

var current : PackedScene = preload("res://Assets/Scenes/Current.tscn")

onready var screenSize : Vector2 = get_viewport_rect().size
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
	for i in $Warnings.get_children():
		i.self_modulate = Color(1, 0, 0, 0)
	screenDivisionValue = screenSize.y / screenDivisions
	for i in range(screenDivisions):
		openSpaces.append((i) * screenDivisionValue)
	target = get_node(targetPath)
	player = get_node(playerPath)
	var _error : int = timer.connect("timeout", self, "_on_timer_timeout") 
	add_child(timer)
	timer.autostart = false
	timer.wait_time = 1
	get_physics_process_delta_time()

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
	if activeWindsCurrents > 2:
		return
	var quantity : int = 0
	if activeWindsCurrents == 0:
		quantity = randi() % 3 + 1
		for _i in range(quantity):
			CreateCurrent()
	elif activeWindsCurrents == 1:
		quantity = randi() % 2 + 1
		for _i in range(quantity):
			CreateCurrent()
	elif activeWindsCurrents == 2:
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
		warnings[activeWindsCurrents].position = Vector2(screenSize.x * 0.05, -openSpaces[randomSpace] - screenDivisionValue/2)
	else:
		warnings[activeWindsCurrents].position = Vector2(screenSize.x * 0.95, -openSpaces[randomSpace] - screenDivisionValue/2)
	get_node("WarningsPlayer" + str(activeWindsCurrents)).play("alert" + str(activeWindsCurrents))
	activeWindsCurrents += 1
	openSpaces.remove(randomSpace)

func _on_WarningsPlayer1_animation_finished(anim_name: String) -> void:
	SpawnCurrent(int(anim_name[anim_name.length()-1]))

func _on_WarningsPlayer2_animation_finished(anim_name: String) -> void:
	SpawnCurrent(int(anim_name[anim_name.length()-1]))

func _on_WarningsPlayer0_animation_finished(anim_name: String) -> void:
	SpawnCurrent(int(anim_name[anim_name.length()-1]))

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
