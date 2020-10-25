extends Node2D

onready var img0 : Sprite = $Sprite0
onready var img1 : Sprite = $Sprite1
onready var img2 : Sprite = $Sprite2
onready var img3 : Sprite = $Sprite3

onready var jogador : Player = $"../RigidBody2D"

onready var images : Array = [[img0, img1], [img2, img3]]

onready var imgSize : Vector2 = Vector2(img0.texture.get_width(), img0.texture.get_height())


func _process(delta):
	ManageBG()
	ManageArray()

func InvertVertical() -> void:
	var second : Array = images[1];
	images[1] = images[0];
	images[0] = second;

func InvertHorizontal() -> void:
	var second : Array = [images[0][1], images[1][1]];
	images[0][1] = images[0][0];
	images[1][1] = images[1][0];
	images[0][0] = second[0];
	images[1][0] = second[1];

func ManageBG() -> void:
	if (jogador.global_position.x > images[0][0].global_position.x):
		images[0][1].global_position.x = images[0][0].global_position.x + imgSize.x;
		images[1][1].global_position.x = images[1][0].global_position.x + imgSize.x;
	elif (jogador.global_position.x < images[0][0].global_position.x):
		images[0][1].global_position.x = images[0][0].global_position.x - imgSize.x;
		images[1][1].global_position.x = images[1][0].global_position.x - imgSize.x;

	if (jogador.global_position.y > images[0][0].global_position.y):
		images[1][0].global_position.y = images[0][0].global_position.y + imgSize.y;
		images[1][1].global_position.y = images[0][1].global_position.y + imgSize.y;
	elif (jogador.global_position.y < images[0][0].global_position.y):
		images[1][0].global_position.y = images[0][0].global_position.y - imgSize.y;
		images[1][1].global_position.y = images[0][1].global_position.y - imgSize.y;

func ManageArray():
	if (jogador.global_position.x > images[0][0].global_position.x + imgSize.x/2):
		InvertHorizontal()
	elif (jogador.global_position.x < images[0][0].global_position.x - imgSize.x/2):
		InvertHorizontal()
	
	if (jogador.global_position.y > images[0][0].global_position.y + imgSize.y/2):
		InvertVertical()
	elif (jogador.global_position.y < images[0][0].global_position.y - imgSize.y/2):
		InvertVertical()
