extends Node

var Ceara : Array = [["res://Assets/Images/Ceara/Fortaleza/catedral.png", "res://Assets/Images/Ceara/Fortaleza/estatua de iracema.png", "res://Assets/Images/Ceara/Fortaleza/teatro jose de alencar.png"],
					["res://Assets/Images/Ceara/Juazeiro/luzeiro da fé.png", "res://Assets/Images/Ceara/Juazeiro/padre cicero.png", "res://Assets/Images/Ceara/Juazeiro/praça padre cicero.png"],
					["res://Assets/Images/Ceara/Quixada/pedra da galinha choca.png", 0, 0]]

var Paraiba : Array = [0]

var Pernambuco : Array = [["res://Assets/Images/Pernambuco/Olinda/bonecos.png", "res://Assets/Images/Pernambuco/Olinda/Farol de Olinda.png", "res://Assets/Images/Pernambuco/Olinda/ruinas do senado.png"],
						["res://Assets/Images/Pernambuco/Recife/circuito de poesia.png", "res://Assets/Images/Pernambuco/Recife/mercado sao jose.png", "res://Assets/Images/Pernambuco/Recife/Tortura Nunca Mais.png"]]

var Bahia : Array = [["res://Assets/Images/Bahia/FeiraDeSantana/caminhoneiro.png", "res://Assets/Images/Bahia/FeiraDeSantana/Tropeiro.png", 0],
					["res://Assets/Images/Bahia/Salvador/Elevador Lacerda.png","res://Assets/Images/Bahia/Salvador/pelourinho1.png", "res://Assets/Images/Bahia/Salvador/pelourinho2.png"],
					["res://Assets/Images/Bahia/VitoriaDaConquista/monumento ao indio.png", 0, 0]]

var shader = "res://Assets/Shaders/ColorReplacement.shader"

onready var midLayerCoeficient = $"../Parallax/ParallaxBackground/MidLayer".motion_scale.x

onready var workingRegion = $"..".distancePerRegion * midLayerCoeficient


func _ready() -> void:
	var shaderMaterial : ShaderMaterial = ShaderMaterial.new()
	shaderMaterial.shader = load(shader)
	shaderMaterial.set_shader_param("color", Color(0.45, 0.45, 0.45, 1))
	shaderMaterial.set_shader_param("replace", Color(0.96, 0.39, 0.39, 1))
	shaderMaterial.set_shader_param("tolerance", 0.45)
	$"../Parallax/ParallaxBackground/MidLayer/estatua de iracema".material = shaderMaterial
	$"../Parallax/ParallaxBackground/MidLayer/catedral".material = shaderMaterial
	$"../Parallax/ParallaxBackground/MidLayer/teatro jose de alencar".material = shaderMaterial
