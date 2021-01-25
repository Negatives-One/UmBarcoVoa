extends Node2D

var angle1 : float = 0
var angle2 : float = PI
export(float) var rayX : float = 20
export(float) var rayY : float = 10

export(float) var waveVelocity : float = 3

var startPositionNoStroke : Vector2
var startPositionStroke : Vector2
var startPositionYJangada : float

onready var onda : Array = [$ParallaxBackground/FrontWave/NoStrokeWave, $ParallaxBackground/MidWave/StrokeWave, $ParallaxBackground/BackWave/NoStrokeWave]
var ondaStartPos : Array = []
onready var farol : Array = [$ParallaxBackground/Farol0/Farol, $ParallaxBackground/Farol1/Farol, $ParallaxBackground/Farol2/Farol, $ParallaxBackground/Farol3/Farol]
onready var jangada : Array = [$ParallaxBackground/Jangada0/Jangada, $ParallaxBackground/Jangada1/Jangada]
var jangadaPos : Array = []

var coberturaPos : Vector2

func _ready() -> void:
	randomize()
#	$ParallaxBackground/ParallaxLayer4/Jangada.position.x = rand_range(0, get_viewport_rect().size.x)
#	$ParallaxBackground/ParallaxLayer/Farol.position.x = rand_range(0, get_viewport_rect().size.x)
	coberturaPos = $ParallaxBackground/FrontWave/ColorRect.rect_position
	for i in range(len(onda)):
		ondaStartPos.append(onda[i].position)
		onda[i].get_parent().motion_mirroring.x = onda[i].texture.get_size().x
	
	for j in range(len(jangada)):
		if randf() > 0.5:
			jangada[j].scale.x *= 1
		else:
			jangada[j].scale.x *= -1
		jangadaPos.append(jangada[j].position.y)
#	$ParallaxBackground/ParallaxLayer3.motion_mirroring.x = $ParallaxBackground/ParallaxLayer3/NoStrokeWave.texture.get_size().x - 20
#	$ParallaxBackground/ParallaxLayer2.motion_mirroring.x = $ParallaxBackground/ParallaxLayer2/StrokeWave.texture.get_size().x
#	#$ParallaxBackground/ParallaxLayer3/NoStrokeWave.position.x = $ParallaxBackground/ParallaxLayer3/NoStrokeWave.texture.get_size().x/2
#	#$ParallaxBackground/ParallaxLayer2/StrokeWave.position.x = $ParallaxBackground/ParallaxLayer2/StrokeWave.texture.get_size().x/2
#	startPositionNoStroke = $ParallaxBackground/ParallaxLayer3/NoStrokeWave.position
#	startPositionStroke = $ParallaxBackground/ParallaxLayer2/StrokeWave.position
#	startPositionYJangada = $ParallaxBackground/ParallaxLayer4/Jangada.position.y
#	$ParallaxBackground/ParallaxLayer.motion_mirroring.x = randi() % 4000 + 2520
#	$ParallaxBackground/ParallaxLayer4.motion_mirroring.x = randi() % 4000 + 2520
#	$AnimationPlayer.play("Barquin")
	pass

func _process(delta: float) -> void:
	for i in range(len(onda)):
		onda[i].position = Vector2((sin(angle1 + ((i+1) * 1.5)) * rayX) + ondaStartPos[i].x, (cos(angle1) * -rayY) + ondaStartPos[i].y)
		if i == 0:
			$ParallaxBackground/FrontWave/ColorRect.rect_position = Vector2((sin(angle1 + ((i+1) * 1.5)) * rayX) + coberturaPos.x, (cos(angle1) * -rayY) + coberturaPos.y)
			$ParallaxBackground/Jangada1/Jangada.position.y = (cos(angle1 + PI/3) * -rayY) + jangadaPos[1]
	#$ParallaxBackground/ParallaxLayer3/NoStrokeWave.position = Vector2((sin(angle1) * rayX) + startPositionNoStroke.x, (cos(angle1) * -rayY) + startPositionNoStroke.y)
	#$ParallaxBackground/ParallaxLayer2/StrokeWave.position = Vector2((sin(angle2) * rayX) + startPositionStroke.x, (cos(angle2) * -rayY) + startPositionStroke.y)
	angle1 += waveVelocity * delta
	if angle1 > PI*2:
		angle1 = 0
	angle2 += waveVelocity * delta
	if angle2 > PI*2:
		angle2 = 0

func Visible(value : bool) -> void:
	for i in $ParallaxBackground.get_children():
		i.visible = value
