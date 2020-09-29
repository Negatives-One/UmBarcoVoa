extends Node2D

func _ready():
	$AnimationPlayer.play("AnimacaoSol")

func _process(delta):
	$CanvasLayer/Label.text = str($RigidBody2D.currentState)
	$CanvasLayer/Label2.text = str($RigidBody2D.linear_velocity.length())
	$CanvasLayer/Label3.text = str($RigidBody2D.boostState)
	$Sol.global_position = Vector2($RigidBody2D.global_position.x + 720, -700)
