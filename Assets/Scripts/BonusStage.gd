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
onready var farol : Array = [$ParallaxBackground/Farol0/Farol, $ParallaxBackground/Farol1/Farol, $ParallaxBackground/Farol2/Farol]
onready var jangada : Array = [$ParallaxBackground/Jangada0/Jangada, $ParallaxBackground/Jangada1/Jangada]
var jangadaPos : Array = []

var coberturaPos : Vector2

func _ready() -> void:
	randomize()
	$ParallaxBackground/Jangada0/Jangada.position.x = rand_range(0, get_viewport_rect().size.x)
	$ParallaxBackground/Jangada1/Jangada.position.x = rand_range(0, get_viewport_rect().size.x)
	$ParallaxBackground/Farol0/Farol.position.x = rand_range(0, get_viewport_rect().size.x)
	$ParallaxBackground/Farol1/Farol.position.x = rand_range(0, get_viewport_rect().size.x)
	$ParallaxBackground/Farol2/Farol.position.x = rand_range(0, get_viewport_rect().size.x)
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
	$ParallaxBackground/Jangada0.motion_mirroring.x = randi() % 3000 + int(get_viewport_rect().size.x)
	$ParallaxBackground/Jangada1.motion_mirroring.x = randi() % 3000 + int(get_viewport_rect().size.x)
	$ParallaxBackground/Farol0.motion_mirroring.x = 3000 + int(get_viewport_rect().size.x)
	$ParallaxBackground/Farol1.motion_mirroring.x = 3000 + int(get_viewport_rect().size.x)
	$ParallaxBackground/Farol2.motion_mirroring.x = 3000 + int(get_viewport_rect().size.x)
	
	$AnimationPlayer.play("Barquin")

func _process(delta: float) -> void:
	for i in range(len(onda)):
		onda[i].position = Vector2(sin(angle1 + (i+1)) * rayX + ondaStartPos[i].x, cos(angle1 + (i+1)) * -rayY + ondaStartPos[i].y)#Vector2((sin(angle1 + ((i+1) * 1.5)) * rayX) + ondaStartPos[i].x, (cos(angle2) * -rayY) + ondaStartPos[i].y)
		if i == 0:
			$ParallaxBackground/FrontWave/ColorRect.rect_position = Vector2(sin(angle1 + (i+1)) * rayX + coberturaPos.x, cos(angle1 + (i+1)) * -rayY + coberturaPos.y)
	$ParallaxBackground/Jangada1/Jangada.position.y = (cos(angle1 + PI/3) * -rayY) + jangadaPos[1]
	$ParallaxBackground/Jangada0/Jangada.position.y = (cos(angle1 +PI) * (-rayY-10)) + jangadaPos[0]
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
