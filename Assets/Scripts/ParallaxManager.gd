extends Node

export(NodePath) var cameraPath : NodePath
onready var camera : MyCamera = get_node(cameraPath)

var Cores : Array = [Color(0, 0.72549, 0.95294, 1), Color(0.97647, 0.34510, 0.62745, 1), Color(1.00000, 0.95686, 0.29020, 1), Color(0.34510, 0.34902, 0.35686, 1)]

var CasasGerais : String = "res://Assets/Images/CasasGerais/"

var Ceara : Array = [["res://Assets/Images/Ceara/Fortaleza/Catedral.png", "res://Assets/Images/Ceara/Fortaleza/Iracema.png", "res://Assets/Images/Ceara/Fortaleza/TeatroJoseAlencar.png"],
	["res://Assets/Images/Ceara/Juazeiro/LuzeiroDaFe.png", "res://Assets/Images/Ceara/Juazeiro/PadreCicero.png", "res://Assets/Images/Ceara/Juazeiro/PracaCicero.png"],
	["res://Assets/Images/Ceara/Quixada/GalinhaChoca.png", "0", "0"],
	["res://Assets/Images/Ceara/Sobral/Arco.png", "res://Assets/Images/Ceara/Sobral/LuziaHomem.png", "res://Assets/Images/Ceara/Sobral/MuseuDoEclipse.png"]]

var Paraiba : Array = [["0"],["0"]]

var Pernambuco : Array = [["res://Assets/Images/Pernambuco/Olinda/Bonecos.png", "res://Assets/Images/Pernambuco/Olinda/FarolDeOlinda.png", "res://Assets/Images/Pernambuco/Olinda/RuinasDoSenado.png"],
	["res://Assets/Images/Pernambuco/Recife/CircuitoDePoesia.png", "res://Assets/Images/Pernambuco/Recife/MercadoSaoJose.png", "res://Assets/Images/Pernambuco/Recife/TorturaNuncaMais.png"]]

var Bahia : Array = [["res://Assets/Images/Bahia/FeiraDeSantana/Caminhoneiro.png", "res://Assets/Images/Bahia/FeiraDeSantana/Tropeiro.png", "0"],
	["res://Assets/Images/Bahia/Salvador/ElevadorLacerda.png","res://Assets/Images/Bahia/Salvador/Pelourinho1.png", "res://Assets/Images/Bahia/Salvador/Pelourinho2.png"],
	["res://Assets/Images/Bahia/VitoriaDaConquista/MonumentoIndio.png", "0", "0"]]

var shader = "res://Assets/Shaders/ColorReplacement.shader"

onready var midLayerCoeficient = $"../Parallax/ParallaxBackground/MidLayer".motion_scale.x

onready var distanceBuildings : float

func _ready() -> void:
	DeployCities()
	
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

func DeployCities() -> void:
	if $"..".currentLocation == $"..".Locations.Ceara:
		UpdateDistanceBuilding(Ceara)
		ShuffleMatrix(Ceara)
		var cont = 1
		for i in range(Ceara.size()):
			for j in range(Ceara[i].size()):
				if Ceara[i][j] != "0":
					PlaceBuilding(Ceara[i][j], distanceBuildings * cont)
					cont += 1
	
	elif $"..".currentLocation == $"..".Locations.Paraiba:
		UpdateDistanceBuilding(Paraiba)
		ShuffleMatrix(Paraiba)
		var cont = 1
		for i in range(Paraiba.size()):
			for j in range(Paraiba[i].size()):
				if Paraiba[i][j] != "0":
					PlaceBuilding(Paraiba[i][j], distanceBuildings * cont)
					cont += 1


func VerifyPassPoint(target) -> void:
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

func ClearBuildings() -> void:
	var buildings : Array = $"../Parallax/ParallaxBackground/MidLayer".get_children()
	for i in buildings:
		i.queue_free()

func ShuffleMatrix(matrix : Array) -> void:
	randomize()
	for i in matrix:
		i.shuffle()
	matrix.shuffle()
