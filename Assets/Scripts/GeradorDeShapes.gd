extends Node2D

export(PackedScene) var coletavel : PackedScene = preload("res://Assets/Scenes/Coletavel.tscn")

export(NodePath) var rapaduraHolder : NodePath

const MaxHeight : int = -1080
const MinHeight : int = 0

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
			#if desiredPosition.y < MinHeight and desiredPosition.y > MaxHeight:
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

func GenerateSineWave(pos : Vector2, width : float, angleSpeed : float = 0.05, xSpeed : float = 20, height : float = 500) -> Array:
	var quantity : int = int(width / 150)
	var positions : Array = []
	var placementStep = width/quantity
	var placementCap = pos.x
	var startPos : Vector2 = Vector2(pos.x, pos.y)
	var currentPos : Vector2 = pos
	var angle = 0
	
#	positions.append(pos)
#	placementCap += placementStep
	
	while(currentPos.x < (width + startPos.x)):
		angle += angleSpeed
		currentPos.x += xSpeed
		currentPos.y = sin(angle) * height/2 + pos.y
		if currentPos.x > placementCap:
			positions.append(currentPos)
			placementCap += placementStep
	
	return positions

func Enable() -> void:
	pass

func Disable() -> void:
	set_process(false)

func GenerateAllBonus() -> void:
	randomize()
	var maxDistance : float = 125000
	var minDistance : float = 105000
	var actualDistance : float = 105000
	
	var spawnQuantity : int = 3#randi() % 3 + 1
	var step : float = (maxDistance - minDistance) / (spawnQuantity + 1)
	
	for _i in range(spawnQuantity):
		var spawnShape : int = randi() % 3
		match spawnShape:
			0:
				var widthQuantity : int = randi() % 8 + 5
				var heightQuantity : int = randi() % 6 + 4
				var heightNumber : float = heightQuantity * coletavelSize.y
				var filled = true
				if randi() % 2:
					filled = false  
				var yPos : float = -400 - heightNumber/2
				SpawnColetavel(GenerateRect(Vector2(actualDistance + step/2, yPos), widthQuantity, heightQuantity, filled))
				actualDistance += step
			1:
				var radius : float = rand_range(100, 350)
				SpawnColetavel(GenerateCircle(Vector2(actualDistance - radius/2 + step/2, -400), radius))
				actualDistance += step
			2:
				SpawnColetavel(GenerateSineWave(Vector2(actualDistance, -400), rand_range(1920, step)))
				actualDistance += step

func SpawnColetavel(points : Array) -> void:
	for i in points:
		var newRapadura : Area2D = coletavel.instance()
		newRapadura.global_position = i
		call_deferred('add_child', newRapadura)


func _on_StageController_bonusEntered(value) -> void:
	$"../HUD/Panel/Panel2".visible = value
	if value:
		GenerateAllBonus()
