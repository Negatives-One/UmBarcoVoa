extends Node

export(NodePath) var cameraPath : NodePath
onready var camera : MyCamera = get_node(cameraPath)

var Cores : Array = [Color(0, 0.72549, 0.95294, 1), Color(0.97647, 0.34510, 0.62745, 1), Color(1.00000, 0.95686, 0.29020, 1), Color(0.34510, 0.34902, 0.35686, 1)]
var Ceara : Array = [["res://Assets/Images/Ceara/Fortaleza/catedral.png", "res://Assets/Images/Ceara/Fortaleza/estatua de iracema.png", "res://Assets/Images/Ceara/Fortaleza/teatro jose de alencar.png"],
	["res://Assets/Images/Ceara/Juazeiro/luzeiro da fé.png", "res://Assets/Images/Ceara/Juazeiro/padre cicero.png", "res://Assets/Images/Ceara/Juazeiro/praça padre cicero.png"],
	["res://Assets/Images/Ceara/Quixada/pedra da galinha choca.png", "0", "0"]]

var Paraiba : Array = ["0"]

var Pernambuco : Array = [["res://Assets/Images/Pernambuco/Olinda/bonecos.png", "res://Assets/Images/Pernambuco/Olinda/Farol de Olinda.png", "res://Assets/Images/Pernambuco/Olinda/ruinas do senado.png"],
	["res://Assets/Images/Pernambuco/Recife/circuito de poesia.png", "res://Assets/Images/Pernambuco/Recife/mercado sao jose.png", "res://Assets/Images/Pernambuco/Recife/Tortura Nunca Mais.png"]]

var Bahia : Array = [["res://Assets/Images/Bahia/FeiraDeSantana/caminhoneiro.png", "res://Assets/Images/Bahia/FeiraDeSantana/Tropeiro.png", "0"],
	["res://Assets/Images/Bahia/Salvador/Elevador Lacerda.png","res://Assets/Images/Bahia/Salvador/pelourinho1.png", "res://Assets/Images/Bahia/Salvador/pelourinho2.png"],
	["res://Assets/Images/Bahia/VitoriaDaConquista/monumento ao indio.png", "0", "0"]]

var shader = "res://Assets/Shaders/ColorReplacement.shader"

onready var midLayerCoeficient = $"../Parallax/ParallaxBackground/MidLayer".motion_scale.x

onready var distanceBuildings : float

func _ready() -> void:
	UpdateDistanceBuilding(Ceara)
	var cont = 1
	for i in range(Ceara.size()):
		for j in range(Ceara[i].size()):
			if Ceara[i][j] != "0":
				PlaceBuilding(Ceara[i][j], distanceBuildings * cont)
				cont += 1
	#PlaceBuilding(Ceara[0][0], distanceBuildings)
	
	
	$"../Parallax/ParallaxBackground/BackgroundLayer".motion_mirroring.x = $"../StageSpawner".screenSize.x
	$"../Parallax/ParallaxBackground/BackgroundLayer/BG".scale.x = $"../StageSpawner".screenSize.x / $"../Parallax/ParallaxBackground/BackgroundLayer/BG".texture.get_size().x

func setShader(sprite : Sprite) -> void:
	var shaderMaterial : ShaderMaterial = ShaderMaterial.new()
	shaderMaterial.shader = load(shader)
	shaderMaterial.set_shader_param("color", Color(0.45, 0.45, 0.45, 1))
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

func PlaceMainPlaces() -> void:
	if $"..".currentLocation == $"..".Locations.Ceara:
		pass

func VerifyPassPoint(camera) -> void:
	pass

func PlaceBuilding(texture : String, positionX : float) -> void:
	var sprite : Sprite = Sprite.new()
	sprite.texture = load(texture)
	setShader(sprite)
	$"../Parallax/ParallaxBackground/MidLayer".add_child(sprite)
	sprite.position = Vector2(positionX * midLayerCoeficient, GetCorrectYPosition(sprite))

func GetCorrectYPosition(sprite : Sprite) -> float:
	var sizeY : float = -(sprite.texture.get_size().y / 2) + 20
	return sizeY
