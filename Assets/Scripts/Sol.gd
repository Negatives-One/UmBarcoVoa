extends Sprite

export(int) var maxWaitTime : int = 2
export(int) var minWaitTime : int = 1
var obstacle : PackedScene = preload("res://Assets/Scenes/Obstacle.tscn")
var direction : Vector2
export(float) var shotSpeed : float = 500.0

var shots : Array = []
var directions : Array = []

export(NodePath) var playerPath : NodePath

var player : Player

export(NodePath) var targetPath : NodePath
var target : Node

func _ready() -> void:
	if $"..".currentEvent == $"..".events.FreeStyle:
		$Timer.start(randi() % maxWaitTime + minWaitTime)
	player = get_node(playerPath)
	target = get_node(targetPath)

func _physics_process(delta: float) -> void:
	self.global_position = Vector2($"../RigidBody2D/Camera2D2".global_position.x + 720, -850)
	if !shots.empty():
		for i in range(shots.size()):
			if is_instance_valid(shots[i]):
				shots[i].global_position += (directions[i] * shotSpeed) * delta

func _on_Timer_timeout() -> void:
	CreateShot()
	$Timer.wait_time = randi() % maxWaitTime + minWaitTime

func CreateShot() -> void:
	var lastShot = obstacle.instance()
	shots.append(lastShot)
	directions.append((player.global_position - self.global_position).normalized())
	$"..".add_child(lastShot)
	lastShot.global_position = self.global_position
	lastShot.currentSize = lastShot.Size.Medio

func Enable() -> void:
	$Timer.start(randi() % maxWaitTime + minWaitTime)

func Disable() -> void:
	$Timer.stop()
	$Timer.wait_time = randi() % maxWaitTime + minWaitTime
