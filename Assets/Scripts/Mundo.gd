extends Node2D
#3350

func _ready() -> void:
	$AnimationPlayer.play("AnimacaoSol")

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		OS.window_fullscreen = !OS.window_fullscreen

func _process(delta : float) -> void:
	$CanvasLayer/Label.text = str($RigidBody2D.currentState)
	$CanvasLayer/Label2.text = str($RigidBody2D.linear_velocity.length())
	$CanvasLayer/Label3.text = str($RigidBody2D.boostState)
	$CanvasLayer/Label4.text = str(Performance.get_monitor(Performance.TIME_FPS))
	$Sol.global_position = Vector2($RigidBody2D.global_position.x + 720, -700)
