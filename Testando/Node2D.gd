extends Node2D

var C3_Chances : Dictionary = {"C3": 0.05, "D3": 0.15, "E3": 0.35, "F3": 0.4, "G3": 0.6, "A3": 0.65, "Bb3": 0.85, "C4": 0.9, "D4": 0.95, "E4": 1}

export(int) var speed : int = 100

var noteSpacing : float = speed/2.0/4.0

var widthN = 1000

var pontos = [Vector2(200, 600)]

var pontinho : Vector2 = Vector2(200, 600)

func _ready() -> void:
	for i in C3_Chances:
		print(C3_Chances.get(i))
	pontos = GenerateCubicCurve(Vector2(200, 600), widthN, 10)

func _draw() -> void:
	for i in range(pontos.size()):
		draw_circle(pontos[i], 20, Color.green)
	
	draw_circle(pontinho, 20, Color.red)


func _process(delta: float) -> void:
	pontos = GenerateCubicCurve(Vector2(200, 600), widthN, 10)
	
	pontinho = CubicCurve(Vector2(200, 600), Vector2(500, 200), Vector2(800, 800), Vector2(1200, 600), $HSlider.value)
	#widthN = $HSlider.value
	update()

func GenerateCubicCurve(pos : Vector2, width : float, quantity : int) -> Array:
	randomize()
	var positions : Array = []
	
	var spacing : float = noteSpacing
	var tempo : float = 0
	var points : Array = []
	
	var distanceBetween : float = width / 3
	
	for j in range(4):
		var pointPos : Vector2 = Vector2(pos.x + distanceBetween*(j), pos.y)#rand_range(-50, -750))
		points.append(pointPos)
	
	for i in range(quantity + 1):
		var step : float = 1.0 / quantity
		positions.append(CubicCurve(points[0], points[1], points[2], points[3], tempo))
		tempo += step
	return positions

func QuadraticCurve(a : Vector2, b : Vector2, c : Vector2, t : float) -> Vector2:
	var p0 : Vector2 = lerp(a, b, t)
	var p1 : Vector2 = lerp(b, c, t)
	return lerp(p0, p1, t)

func CubicCurve(a : Vector2, b : Vector2, c : Vector2, d : Vector2, t : float) -> Vector2:
	var p0 : Vector2 = QuadraticCurve(a, b, c, t)
	var p1 : Vector2 = QuadraticCurve(b, c, d, t)
	return lerp(p0, p1, t)
