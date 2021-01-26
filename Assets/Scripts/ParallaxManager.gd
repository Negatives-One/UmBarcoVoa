extends CanvasLayer

export(NodePath) var cameraPath : NodePath
onready var camera : MyCamera = get_node(cameraPath)

var Cores : Array = [Color(0.32, 0.63, 0.80, 1), Color(0.80, 0.73, 0.40, 1), Color(0.70, 0.41, 0.70, 1), Color(0.80, 0.80, 0.80, 1)]

var CasasGerais : String = "res://Assets/Images/CasasGerais/"


var distanceHouses : int = 280
export(float) var maxDistanceHouses : float = 800
var start = 0


var Ceara : Array = [["res://Assets/Images/Ceara/Fortaleza/catedral.png", "res://Assets/Images/Ceara/Fortaleza/Iracema.png", "res://Assets/Images/Ceara/Fortaleza/TeatroJoseAlencar.png"],
	["res://Assets/Images/Ceara/Juazeiro/LuzeiroDaFe.png", "res://Assets/Images/Ceara/Juazeiro/PadreCicero.png", "res://Assets/Images/Ceara/Juazeiro/PracaCicero.png"],
	["res://Assets/Images/Ceara/Quixada/GalinhaChoca.png", "0", "0"],
	["res://Assets/Images/Ceara/Sobral/Arco.png", "res://Assets/Images/Ceara/Sobral/LuziaHomem.png", "res://Assets/Images/Ceara/Sobral/MuseuDoEclipse.png"]]

var Pernambuco : Array = [["res://Assets/Images/Pernambuco/Olinda/bonecos.png", "res://Assets/Images/Pernambuco/Olinda/FarolDeOlinda.png", "res://Assets/Images/Pernambuco/Olinda/RuinasDoSenado.png"],
	["res://Assets/Images/Pernambuco/Recife/CircuitoDePoesia.png", "res://Assets/Images/Pernambuco/Recife/MercadoSaoJose.png", "res://Assets/Images/Pernambuco/Recife/TorturaNuncaMais.png"]]

var Bahia : Array = [["res://Assets/Images/Bahia/FeiraDeSantana/caminhoneiro.png", "res://Assets/Images/Bahia/FeiraDeSantana/Tropeiro.png", "0"],
	["res://Assets/Images/Bahia/Salvador/ElevadorLacerda.png","res://Assets/Images/Bahia/Salvador/pelourinho1.png", "res://Assets/Images/Bahia/Salvador/pelourinho2.png"],
	["res://Assets/Images/Bahia/VitoriaDaConquista/MonumentoIndio.png", "0", "0"]]

var DontShader : Array = ["res://Assets/Images/Bahia/Salvador/pelourinho1.png", "res://Assets/Images/Bahia/Salvador/pelourinho2.png", "res://Assets/Images/Pernambuco/Olinda/bonecos.png", "res://Assets/Images/Pernambuco/Recife/CircuitoDePoesia.png"] 

var shader = "res://Assets/Shaders/ColorReplacement.shader"

onready var midLayerCoeficient = $ParallaxBackground/MidLayer.motion_scale.x

onready var distanceBuildings : float

func _ready() -> void:
	DeployCities()
	while camera.global_position.x + $"../StageSpawner".screenSize.x/2 > start:
		DeployHouses(camera)

func _process(_delta: float) -> void:
	DeployHouses(camera)
	for i in $ParallaxBackground/FrontLayer.get_children():
		if i.position.x / $ParallaxBackground/FrontLayer.motion_scale.x + 500 < camera.global_position.x - $"../StageSpawner".screenSize.x /2:
			i.queue_free()

func SetShader(sprite : Sprite) -> void:
	var shaderMaterial : ShaderMaterial = ShaderMaterial.new()
	shaderMaterial.shader = load(shader)
	shaderMaterial.set_shader_param("color", Color(0.5, 0.5, 0.5, 1))
	randomize()
	shaderMaterial.set_shader_param("replace", Cores[randi() % Cores.size()])
	shaderMaterial.set_shader_param("tolerance", 0.45)
	sprite.material = shaderMaterial

func UpdateDistanceBuilding(array : Array) -> void:
	var cont : int = 0
	for i in range(array.size()):
		for j in range(array[i].size()):
			if array[i][j] != "0":
				cont += 1
	distanceBuildings = ($"..".distancePerRegion - 3700) / cont

func DeployCities() -> void:
	start = 0
	ClearBuildings()
	if $"..".currentLocation == $"..".Locations.Ceara:
		UpdateDistanceBuilding(Ceara)
		ShuffleMatrix(Ceara)
		var cont = 1
		for i in range(Ceara.size()):
			for j in range(Ceara[i].size()):
				if Ceara[i][j] != "0":
					PlaceBuilding(Ceara[i][j], distanceBuildings * cont)
					cont += 1
	elif $"..".currentLocation == $"..".Locations.Pernambuco:
		UpdateDistanceBuilding(Pernambuco)
		ShuffleMatrix(Pernambuco)
		var cont = 1
		for i in range(Pernambuco.size()):
			for j in range(Pernambuco[i].size()):
				if Pernambuco[i][j] != "0":
					PlaceBuilding(Pernambuco[i][j], distanceBuildings * cont)
					cont += 1
	elif $"..".currentLocation == $"..".Locations.Bahia:
		UpdateDistanceBuilding(Bahia)
		ShuffleMatrix(Bahia)
		var cont = 1
		for i in range(Bahia.size()):
			for j in range(Bahia[i].size()):
				if Bahia[i][j] != "0":
					PlaceBuilding(Bahia[i][j], distanceBuildings * cont)
					cont += 1


func DeployHouses(target) -> void:
	if target.global_position.x + $"../StageSpawner".screenSize.x/2 > start:
		var sprite : Sprite = Sprite.new()
		sprite.texture = load(CasasGerais + str(randi() % 6 +1) + ".png")
		$ParallaxBackground/FrontLayer.add_child(sprite)
		SetShader(sprite)
		sprite.position = Vector2((start + distanceHouses) * $ParallaxBackground/FrontLayer.motion_scale.x, GetCorrectYPosition(sprite) + 25)
		start += int(UpdateHouseDistance($ParallaxBackground/FrontLayer.get_children()[$ParallaxBackground/FrontLayer.get_child_count() - 1], sprite))

func UpdateHouseDistance(oldSprite : Sprite, newSprite : Sprite) -> float:
	if !is_instance_valid(oldSprite):
		return maxDistanceHouses
	var percentage : float = abs(($"../RigidBody2D".global_position.x - $"..".distancePerRegion/2) / ($"..".distancePerRegion/2))
	var minDistance = (newSprite.texture.get_size().x/2 + oldSprite.texture.get_size().x/2) + 40
	if(maxDistanceHouses * percentage > minDistance):
		return maxDistanceHouses * percentage
	else:
		return minDistance

func PlaceBuilding(texture : String, positionX : float) -> void:
	var isGray : bool = true
	var sprite : Sprite = Sprite.new()
	sprite.texture = load(texture)
	for i in DontShader:
		if texture == i:
			isGray = false
	if isGray:
		SetShader(sprite)
	$ParallaxBackground/MidLayer.add_child(sprite)
	sprite.position = Vector2(positionX * midLayerCoeficient, GetCorrectYPosition(sprite))

func GetCorrectYPosition(sprite : Sprite) -> float:
	var sizeY : float = -(sprite.texture.get_size().y / 2)
	return sizeY

func ClearBuildings() -> void:
	var buildings : Array = $ParallaxBackground/MidLayer.get_children()
	if buildings.size() > 0:
		for i in buildings:
			i.queue_free()
	var casinhas : Array = $ParallaxBackground/FrontLayer.get_children()
	for j in casinhas:
		j.queue_free()

func ShuffleMatrix(matrix : Array) -> void:
	randomize()
	for i in matrix:
		i.shuffle()
	matrix.shuffle()
