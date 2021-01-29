extends Sprite

export(int) var maxWaitTime : int = 2
export(int) var minWaitTime : int = 1
export(float) var shotSpeed : float = 500.0

enum states {IDLE, SHOOTING}
var currentState : int = states.IDLE

var solarShot = preload("res://Assets/Scenes/VentoSol.tscn")

export(NodePath) var playerPath : NodePath

var player : Player

export(NodePath) var targetPath : NodePath
var target : Node

func _ready() -> void:
	if $"..".currentEvent == $"..".events.FreeStyle:
		$Timer.start(randi() % maxWaitTime + minWaitTime)
	player = get_node(playerPath)
	target = get_node(targetPath)

func _process(_delta: float) -> void:
	if $"../RigidBody2D/Camera2D2".global_position.x + get_viewport_rect().size.x/2 < $"..".distancePerRegion - 1500:
		$AnimatedSprite.playing = true
	else:
		$AnimatedSprite.playing = false
		$AnimatedSprite.frame = 0
	self.global_position = Vector2($"../RigidBody2D/Camera2D2".global_position.x + 720, -850)
	$"../VentosSolares".global_position = Vector2(0, 540)

func _on_Timer_timeout() -> void:
	$AnimatedSprite.frame = 0
	#CreateShot()
	$Timer.wait_time = randi() % maxWaitTime + minWaitTime

func CreateShot() -> void:
	var lastShot = solarShot.instance()
	var dir : Vector2 = player.global_position - self.global_position
	dir += player.linear_velocity
	lastShot.dir = dir.normalized()
	lastShot.speed = shotSpeed
	lastShot.player = self.player
	$"../VentosSolares".add_child(lastShot)
	lastShot.global_position = self.global_position
	SetShader(lastShot.get_node("AnimatedSprite"))

func Enable() -> void:
	currentState = states.SHOOTING
	$Timer.start(randi() % maxWaitTime + minWaitTime)

func Disable() -> void:
	currentState = states.IDLE
	$Timer.stop()


func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.frame == 5 and currentState == states.SHOOTING:
		CreateShot()

func SetShader(alvo : AnimatedSprite) -> void:
	var shaderMaterial : ShaderMaterial = ShaderMaterial.new()
	shaderMaterial.shader = load("res://Assets/Shaders/Outline.shader")
	shaderMaterial.set_shader_param("width", 5)
	shaderMaterial.set_shader_param("outline_color", Color(1, 1, 1, 1))
	alvo.material = shaderMaterial
