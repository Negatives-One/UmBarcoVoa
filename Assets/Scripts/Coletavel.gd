extends Area2D

func _ready() -> void:
	$AudioStreamPlayer.stream = load("res://Assets/NotasPeixes/C3.wav")


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_Area2D_body_entered(_body: Node) -> void:
	GameManager.StageControll.Collected()
	$AnimatedSprite.visible = false
	$AudioStreamPlayer.play()


func SetNote(path : String) -> void:
	$AudioStreamPlayer.stream = load(path)


func _on_AudioStreamPlayer_finished() -> void:
	queue_free()
