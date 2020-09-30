extends Node2D
#3350
onready var player : Player = $RigidBody2D
onready var FrontImg : Sprite = $Node2D/Sprite
onready var BackImg : Sprite = $Node2D/Sprite2
onready var HorizontalBG : Array = [ null, BackImg, FrontImg]

var auxImgPos : int = 2
onready var imgWidth : float= FrontImg.texture.get_width()

func _ready() -> void:
	$AnimationPlayer.play("AnimacaoSol")

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		OS.window_fullscreen = !OS.window_fullscreen

func _process(delta : float) -> void:
	$CanvasLayer/Label.text = str(HorizontalBG)#$RigidBody2D.currentState)
	$CanvasLayer/Label2.text = str($RigidBody2D.linear_velocity.length())
	$CanvasLayer/Label3.text = str($RigidBody2D.boostState)
	$Sol.global_position = Vector2($RigidBody2D.global_position.x + 720, -700)
	UpdateBG()
	UpdateArray()

func UpdateBG() -> void:
	if player.global_position.x > HorizontalBG[1].global_position.x:
		HorizontalBG[auxImgPos].global_position.x = (HorizontalBG[1].global_position.x + imgWidth)
	
	if player.global_position.x < HorizontalBG[1].global_position.x:
		HorizontalBG[auxImgPos].global_position.x = (HorizontalBG[1].global_position.x - imgWidth)

func UpdateArray() -> void:
	if player.global_position.x > HorizontalBG[1].global_position.x + imgWidth/2:
		var aux : Sprite = HorizontalBG[auxImgPos]
		auxImgPos = 2
		HorizontalBG[0] = null
		HorizontalBG[auxImgPos] = HorizontalBG[1]
		HorizontalBG[1] = aux
	
	elif player.global_position.x < HorizontalBG[1].global_position.x - imgWidth/2:
		var aux : Sprite = HorizontalBG[auxImgPos]
		auxImgPos = 0
		HorizontalBG[2] = null
		HorizontalBG[auxImgPos] = HorizontalBG[1]
		HorizontalBG[1] = aux
