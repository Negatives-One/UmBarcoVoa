extends Area2D

class_name Peixe


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_Area2D_body_entered(_body: Node) -> void:
	GameManager.StageControll.Collected()
	$AnimatedSprite.visible = false
	$AudioStreamPlayer.play()


func SetNote(note : String) -> void:
	var path : String = "res://Assets/NotasPeixes/" + note + ".wav"
	$AudioStreamPlayer.stream = load(path)


func _on_AudioStreamPlayer_finished() -> void:
	queue_free()