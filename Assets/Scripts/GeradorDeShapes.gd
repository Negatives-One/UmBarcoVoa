extends Node2D

var c3 : Array = [0.05, 0.1, 0.2, 0.05, 0.2, 0.05, 0.2, 0.05, 0.05, 0.05]

var C3_Chances : Dictionary = {"C3": 0.05, "D3": 0.15, "E3": 0.35, "F3": 0.4, "G3": 0.6, "A3": 0.65, "Bb3": 0.85, "C4": 0.9, "D4": 0.95, "E4": 1}
var D3_Chances : Dictionary = {"C3": 0.2, "D3": 0.25, "E3": 0.3, "F3": 0.5, "G3": 0.55, "A3": 0.75, "Bb3": 0.8, "C4": 0.9, "D4": 0.95, "E4": 1}
var E3_Chances : Dictionary = {"C3": 0.2, "D3": 0.25, "E3": 0.30, "F3": 0.35, "G3": 0.50, "A3": 0.55, "Bb3": 0.70, "C4": 0.80, "D4": 0.9, "E4": 1}
var F3_Chances : Dictionary = {"C3": 0.05, "D3": 0.1, "E3": 0.2, "F3": 0.25, "G3": 0.35, "A3": 0.55, "Bb3": 0.65, "C4": 0.85, "D4": 0.9, "E4": 1}
var G3_Chances : Dictionary = {"C3": 0.2, "D3": 0.25, "E3": 0.45, "F3": 0.55, "G3": 0.60, "A3": 0.65, "Bb3": 0.85, "C4": 0.95, "D4": 0.975, "E4": 1}
var A3_Chances : Dictionary = {"C3": 0.05, "D3": 0.1, "E3": 0.15, "F3": 0.35, "G3": 0.45, "A3": 0.5, "Bb3": 0.6, "C4": 0.8, "D4": 0.9, "E4": 1}
var Bb3_Chances : Dictionary = {"C3": 0.05, "D3": 0.1, "E3": 0.2, "F3": 0.3, "G3": 0.5, "A3": 0.6, "Bb3": 0.65, "C4": 0.85, "D4": 0.95, "E4": 1}
var C4_Chances : Dictionary = {"C3": 0.05, "D3": 0.1, "E3": 0.15, "F3": 0.2, "G3": 0.4, "A3": 0.45, "Bb3": 0.65, "C4": 0.70, "D4": 0.8, "E4": 1}
var D4_Chances : Dictionary = {"C3": 0.05, "D3": 0.1, "E3": 0.15, "F3": 0.25, "G3": 0.45, "A3": 0.55, "Bb3": 0.75, "C4": 0.85, "D4": 0.9, "E4": 1}
var E4_Chances : Dictionary = {"C3": 0.05, "D3": 0.1, "E3": 0.15, "F3": 0.2, "G3": 0.4, "A3": 0.5, "Bb3": 0.55, "C4": 0.75, "D4": 0.95, "E4": 1}

export(PackedScene) var coletavel : PackedScene = preload("res://Assets/Scenes/Coletavel.tscn")

export(NodePath) var rapaduraHolder : NodePath

const MaxHeight : int = -760
const MinHeight : int = -40

export(float) var mediumXVelocity : float = 2000

var noteSpacing : float

var coletavelSize := Vector2(85, 85)

func _ready() -> void:
	noteSpacing = mediumXVelocity / 2 / 4
	print("Deveria ser: ", noteSpacing * 16 * 4)

func GenerateRect(pos : Vector2, width : int, height : int, filled : bool = false, spacing : float = 7.0) -> Array:
	var positions : Array = []
	var truePositions : Array = []
	
	for i in range(height):
		positions.append([])
		for j in range(width):
			if filled:
				positions[i].append(true)
			else:
				if i == 0 or i == height-1 or j == 0 or j == width-1:
					positions[i].append(true)
				else:
					positions[i].append(false)
			
	
	for i in range(height):
		for j in range(width):
			var desiredPosition : Vector2 = Vector2(pos.x + (j) * (coletavelSize.x + spacing), pos.y + (i) * (coletavelSize.y + spacing))
			if desiredPosition.y < MinHeight and desiredPosition.y > MaxHeight:
				if positions[i][j]:
					truePositions.append(desiredPosition)
	
	return truePositions

func GenerateCircle(pos : Vector2, radius : float):
# warning-ignore:narrowing_conversion
	var quantity : int = radius / 25
	var positions : Array = []
	
	var angle : float = 0
	var angleStep : float = TAU/quantity
	for _i in range(quantity):
		var desiredPosition : Vector2 = Vector2((sin(angle) * radius) + pos.x, (cos(angle) * -radius) + pos.y)
		#if desiredPosition.y < MinHeight and desiredPosition.y > MaxHeight:
		positions.append(desiredPosition)
		angle += angleStep
	
	return positions

func SineCurve(pos : Vector2, width : float, height : float, t : float, endAngle : float = PI*6) -> Vector2:
	return Vector2(pos.x + width * t, sin(endAngle * t) * height/2 + pos.y)

func GenerateSineWave(pos : Vector2, height : float = 500) -> Array:
	var notas : Array = CreateComposition()
	
	var positions : Array = []
	
	var tempo : float = 0
	
	var width : float = noteSpacing * notas.size()
	var notePercent : float = noteSpacing / width
	
	for i in range(notas.size()):
		if notas[i]:
			positions.append(SineCurve(pos, width, height, tempo))
		tempo += notePercent
	
	return positions

func GenerateCubicCurve(pos : Vector2) -> Array:
	randomize()
	var notas : Array = CreateComposition()
	var positions : Array = []
	
	var tempo : float = 0
	var points : Array = []
	
	var width : float = noteSpacing * notas.size()
	print("Size Curve: ", width)
	
	var notePercent = noteSpacing / width
	
	
	var distanceBetween : float = width / 3
	var alturas : Array = [-800, -600, -400, -200]
	randomize()
	alturas.shuffle()
	for j in range(4):
		var altura : float
		altura = alturas.pop_front()
		print(altura)
		
		var pointPos : Vector2 = Vector2(pos.x + distanceBetween*(j), altura)
		points.append(pointPos)
	
	for i in range(notas.size()):
		if notas[i]:
			positions.append(CubicCurve(points[0], points[1], points[2], points[3], tempo))
		tempo += notePercent
	return positions

func QuadraticCurve(a : Vector2, b : Vector2, c : Vector2, t : float) -> Vector2:
	var p0 : Vector2 = lerp(a, b, t)
	var p1 : Vector2 = lerp(b, c, t)
	return lerp(p0, p1, t)

func CubicCurve(a : Vector2, b : Vector2, c : Vector2, d : Vector2, t : float) -> Vector2:
	var p0 : Vector2 = QuadraticCurve(a, b, c, t)
	var p1 : Vector2 = QuadraticCurve(b, c, d, t)
	return lerp(p0, p1, t)

func Enable() -> void:
	pass

func Disable() -> void:
	set_process(false)

func GenerateAllBonus() -> void:
	randomize()
	var maxDistance : float = 100000 + $"..".bonusLength - 2000
	var minDistance : float = 105000
	var actualDistance : float = minDistance
	
	var melodyLength : float = noteSpacing * 4 * 16
	print(melodyLength)
	
	var spawnQuantity : int = floor((maxDistance - minDistance) / melodyLength)#2#randi() % 2 + 1
	var step : float = (maxDistance - minDistance) / float(spawnQuantity)
	
	for _i in range(spawnQuantity):
		var spawnShape : int = randi() % 2
		match spawnShape:
			0:
				#var radius : float = rand_range(100, 350)
				var teste : Array = GenerateCubicCurve(Vector2(actualDistance, 0))
				SpawnColetavel(teste)#GenerateCircle(Vector2(actualDistance - radius/2 + step/2, -400), radius))
				actualDistance += step
			1:
				SpawnColetavel(GenerateSineWave(Vector2(actualDistance, -450)))
				actualDistance += step

func SpawnColetavel(points : Array) -> void:
	var nota : String = "C3"
	for i in points:
		var newPeixe : Peixe = coletavel.instance()
		newPeixe.global_position = i
		call_deferred('add_child', newPeixe)
		newPeixe.SetNote(nota)
		nota = RandomizeNotes(nota)
		#print(nota)


func _on_StageController_bonusEntered(value) -> void:
	$"../HUD/Panel/Panel2".visible = value
	if value:
		GenerateAllBonus()


func CreateComposition(cells : int = 16) -> Array:
	randomize()
	var composition : Array = []
	var cell1 : Array = [true, false, false, false]
	var cell2 : Array = [true, false, false, true]
	var cell3 : Array = [true, true, false, true]
	var cell4 : Array = [false, true, false, false]
	var cell5 : Array = [true, false, true, false]
	
	for _i in range(cells):
		var num : float = randf()
		if num > 0.8:
			for j in cell1:
				composition.append(j)
		elif num > 0.6:
			for j in cell2:
				composition.append(j)
		elif num > 0.4:
			for j in cell3:
				composition.append(j)
		elif num > 0.2:
			for j in cell4:
				composition.append(j)
		else:
			for j in cell5:
				composition.append(j)
	
	return composition

func RandomizeNotes(actualNote : String) -> String:
	if actualNote == "C3":
		randomize()
		var randNumber : float = randf()
		for i in C3_Chances:
			if randNumber <= C3_Chances.get(i):
				return i
	elif actualNote == "D3":
		randomize()
		var randNumber : float = randf()
		for i in D3_Chances:
			if randNumber <= D3_Chances.get(i):
				return i
	elif actualNote == "E3":
		randomize()
		var randNumber : float = randf()
		for i in E3_Chances:
			if randNumber <= E3_Chances.get(i):
				return i
	elif actualNote == "F3":
		randomize()
		var randNumber : float = randf()
		for i in F3_Chances:
			if randNumber <= F3_Chances.get(i):
				return i
	elif actualNote == "G3":
		randomize()
		var randNumber : float = randf()
		for i in G3_Chances:
			if randNumber <= G3_Chances.get(i):
				return i
	elif actualNote == "A3":
		randomize()
		var randNumber : float = randf()
		for i in A3_Chances:
			if randNumber <= A3_Chances.get(i):
				return i
	elif actualNote == "Bb3":
		randomize()
		var randNumber : float = randf()
		for i in Bb3_Chances:
			if randNumber <= Bb3_Chances.get(i):
				return i
	elif actualNote == "C4":
		randomize()
		var randNumber : float = randf()
		for i in C4_Chances:
			if randNumber <= C4_Chances.get(i):
				return i
	elif actualNote == "D4":
		randomize()
		var randNumber : float = randf()
		for i in D4_Chances:
			if randNumber <= D4_Chances.get(i):
				return i
	elif actualNote == "E4":
		randomize()
		var randNumber : float = randf()
		for i in E4_Chances:
			if randNumber <= E4_Chances.get(i):
				return i
	return "C3"
