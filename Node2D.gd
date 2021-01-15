extends Node2D

var angle1 : float = 0
var angle2 : float = PI
var ray : float = 10

export(float) var waveVelocity : float = 3

var startPositionNoStroke : Vector2
var startPositionStroke : Vector2
var startPositionYJangada : float

func _ready() -> void:
	$ParallaxBackground/ParallaxLayer3.motion_mirroring.x = $ParallaxBackground/ParallaxLayer3/NoStrokeWave.texture.get_size().x - 20
	$ParallaxBackground/ParallaxLayer2.motion_mirroring.x = $ParallaxBackground/ParallaxLayer2/StrokeWave.texture.get_size().x
	#$ParallaxBackground/ParallaxLayer3/NoStrokeWave.position.x = $ParallaxBackground/ParallaxLayer3/NoStrokeWave.texture.get_size().x/2
	#$ParallaxBackground/ParallaxLayer2/StrokeWave.position.x = $ParallaxBackground/ParallaxLayer2/StrokeWave.texture.get_size().x/2
	startPositionNoStroke = $ParallaxBackground/ParallaxLayer3/NoStrokeWave.position
	startPositionStroke = $ParallaxBackground/ParallaxLayer2/StrokeWave.position
	startPositionYJangada = $ParallaxBackground/ParallaxLayer4/Jangada.position.y
	$ParallaxBackground/ParallaxLayer.motion_mirroring.x = randi() % 4000 + 2520
	$ParallaxBackground/ParallaxLayer4.motion_mirroring.x = randi() % 4000 + 2520
	$AnimationPlayer.play("Barquin")

func _process(delta: float) -> void:
	$ParallaxBackground/ParallaxLayer3/NoStrokeWave.position = Vector2((sin(angle1) * ray) + startPositionNoStroke.x, (cos(angle1) * -ray) + startPositionNoStroke.y)
	$ParallaxBackground/ParallaxLayer4/Jangada.position.y = (cos(angle1 + PI/3) * -ray) + startPositionYJangada
	$ParallaxBackground/ParallaxLayer2/StrokeWave.position = Vector2((sin(angle2) * ray) + startPositionStroke.x, (cos(angle2) * -ray) + startPositionStroke.y)
	angle1 += waveVelocity * delta
	if angle1 > PI*2:
		angle1 = 0
	angle2 += waveVelocity * delta
	if angle2 > PI*2:
		angle2 = 0

func Visible(value : bool) -> void:
	$ParallaxBackground/ParallaxLayer.visible = value
	$ParallaxBackground/ParallaxLayer2.visible = value
	$ParallaxBackground/ParallaxLayer3.visible = value
	$ParallaxBackground/ParallaxLayer4.visible = value
