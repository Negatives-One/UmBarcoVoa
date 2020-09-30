extends Node2D

var imgWidth : float
var velocity : float
var aux : float = 0
var player : Player
var first : bool = true
var BackImg : Sprite
var FrontImg : Sprite

func _ready () -> void:
	player = $"../RigidBody2D"
	BackImg = $Sprite
	FrontImg = $Sprite2
	imgWidth = $Sprite.texture.get_width ()


func _physics_process(delta):
	#UpdateIMG()
	velocity = player.linear_velocity.x


func UpdateIMG() -> void:
	if player.global_position.x >= BackImg.global_position.x:
		FrontImg.global_position.x = (BackImg.global_position.x + imgWidth)
	elif player.global_position.x >= FrontImg.global_position.x:
		BackImg.global_position.x = (FrontImg.global_position.x + imgWidth)
