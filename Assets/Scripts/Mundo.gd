extends Node2D

func _process(delta):
	$CanvasLayer/Label.text = str($KinematicBody2D.currentState)
	$CanvasLayer/Label2.text = str($KinematicBody2D._velocity.length())
