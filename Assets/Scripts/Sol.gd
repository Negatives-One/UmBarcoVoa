extends Sprite

export(int) var maxWaitTime : int = 2
export(int) var minWaitTime : int = 1
var obstacle : PackedScene = preload("res://Assets/Scenes/Obstacle.tscn")
var direction : Vector2
export(float) var shotSpeed : float = 500.0

enum states {IDLE, SHOOTING}
var currentState : int = states.IDLE

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
	$AnimatedSprite.frame = 0
	#CreateShot()
	$Timer.wait_time = randi() % maxWaitTime + minWaitTime

func CreateShot() -> void:
	var lastShot : Obstacle = obstacle.instance()
	shots.append(lastShot)
	var dir : Vector2 = player.global_position - self.global_position
	dir += player.linear_velocity
	directions.append(dir.normalized())
	$"..".add_child(lastShot)
	lastShot.global_position = self.global_position
	lastShot.currentSize = lastShot.Size.Medio
	lastShot.SetSkin("res://Assets/Images/Animations/VentoQuente/VentoQuente.tres", dir.normalized().angle(), Vector2(-0.5, 0.5))

func Enable() -> void:
	$Timer.start(randi() % maxWaitTime + minWaitTime)

func Disable() -> void:
	for i in shots:
		if is_instance_valid(i):
			i.queue_free()
	shots.clear()
	directions.clear()
	$Timer.stop()
	$Timer.wait_time = randi() % maxWaitTime + minWaitTime


func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.frame == 5:
		CreateShot()
