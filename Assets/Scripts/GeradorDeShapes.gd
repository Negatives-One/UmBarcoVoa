extends Node2D

export(PackedScene) var coletavel : PackedScene = preload("res://Assets/Scenes/Coletavel.tscn")

export(NodePath) var rapaduraHolder : NodePath

const MaxHeight : int = -760
const MinHeight : int = -40

export(float) var mediumXVelocity : float = 1000 

var noteSpacing : float = mediumXVelocity / 2 / 4

var coletavelSize := Vector2(85, 85)

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

func GenerateSineWave(pos : Vector2, angleSpeed : float = 0.05, height : float = 500) -> Array:
	var notas : Array = CreateComposition(20, 10)
	var quantity : int = notas.size()
	
	var positions : Array = []
	
	var placementStep = noteSpacing
	var currentPos : Vector2 = pos
	var angle = 0
	
	for i in range(quantity):
		if notas[i]:
			positions.append(currentPos)
		angle += angleSpeed
		currentPos.x += placementStep
		currentPos.y = sin(angle) * height/2 + pos.y
	
	return positions

func GenerateCubicCurve(pos : Vector2, width : float, quantity : int) -> Array:
	randomize()
	var positions : Array = []
	
	var spacing : float = noteSpacing
	var tempo : float = 0
	var points : Array = []
	
	var distanceBetween : float = width / 4
	
	for j in range(4):
		var pointPos : Vector2 = Vector2(pos.x + distanceBetween*(j + 1), rand_range(-50, -750))
		points.append(pointPos)
	
	for i in range(quantity):
		var step : float = .05
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

func Enable() -> void:
	pass

func Disable() -> void:
	set_process(false)

func GenerateAllBonus() -> void:
	randomize()
	var maxDistance : float = 123000
	var minDistance : float = 105000
	var actualDistance : float = minDistance
	
	var spawnQuantity : int = 1#randi() % 3 + 2
	var step : float = (maxDistance - minDistance) / (spawnQuantity)
	
	for _i in range(spawnQuantity):
		var spawnShape : int = 1#randi() % 3
		match spawnShape:
			0:
				#var radius : float = rand_range(100, 350)
				var teste : Array = GenerateCubicCurve(Vector2(actualDistance, 0), step-2000, 20)
				SpawnColetavel(teste)#GenerateCircle(Vector2(actualDistance - radius/2 + step/2, -400), radius))
				actualDistance += step
			1:
				SpawnColetavel(GenerateSineWave(Vector2(actualDistance, -400)))
				actualDistance += step

func SpawnColetavel(points : Array) -> void:
	for i in points:
		var newPeixe : Area2D = coletavel.instance()
		newPeixe.global_position = i
		call_deferred('add_child', newPeixe)


func _on_StageController_bonusEntered(value) -> void:
	$"../HUD/Panel/Panel2".visible = value
	if value:
		GenerateAllBonus()


func CreateComposition(notes : int = 10, cells : int = 16) -> Array:
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
