extends Area2D

func _ready() -> void:
	$AnimationPlayer.play("ColetavelAnim")


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_Area2D_body_entered(_body: Node) -> void:
	GameManager.StageControll.Collected()
	queue_free()
