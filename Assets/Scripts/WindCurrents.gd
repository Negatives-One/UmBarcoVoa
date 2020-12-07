extends Node2D

class_name WindCurrents

export(NodePath) var playerPath : NodePath
var player : Player

onready var screenSize : Vector2 = get_viewport_rect().size
export(int, 2, 999) var screenDivisions : float = 4.0
var screenDivisionValue : float

export(float) var timeBetweenSpawns : float = 1.0

export(float) var magnitudeStrong : float = 300.0
export(float) var durationStrong : float = 1.0
export(float) var magnitudeWeak : float = 150.0
export(float) var durationWeak : float = 1.0

var timer : Timer = Timer.new()

var openSpaces : Array = []


func _ready() -> void:
	screenDivisionValue = screenSize.y / screenDivisions
	for i in range(screenDivisions):
		openSpaces.append((i) * screenDivisionValue)
	player = get_node(playerPath)
	var _error : int = timer.connect("timeout", self, "_on_timer_timeout") 
	add_child(timer)
	timer.autostart = false
	timer.wait_time = timeBetweenSpawns

func Enable() -> void:
	timer.autostart = true
	timer.start()

func Disable() -> void:
	timer.autostart = false
	timer.stop()

func _on_timer_timeout():
	print('vento')
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
