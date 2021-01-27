extends Control


func _ready() -> void:
	$AnimationPlayer.play("FadeInOutApoio")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
			if event.pressed and event.button_index == BUTTON_LEFT:
				if $AnimationPlayer.current_animation == "FadeInOutSplash":
					get_tree().change_scene("res://Assets/Scenes/Menu.tscn")

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "FadeInOutApoio":
		$AnimationPlayer.play("FadeInOutSplash")
	if anim_name == "FadeInOutSplash":
		get_tree().change_scene("res://Assets/Scenes/Menu.tscn")
